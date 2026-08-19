IF OBJECT_ID('Billing.GenerateInvoices_sp') IS NOT NULL
    DROP PROCEDURE [Billing].[GenerateInvoices_sp];
GO

CREATE PROCEDURE [Billing].[GenerateInvoices_sp]
(
  @ToDate datetime,
  @BillingCycleId int,
  @Notes varchar(200) = NULL
)
AS
BEGIN

  SET NOCOUNT ON;

  -- Reseed identity on [Billing].[Invoice]
  DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED)
  -- Reseed identity on [Billing].[InvoiceOrder]
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED)
  -- Reseed identity on [Billing].[InvoiceOrderSpecial]
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED)

  PRINT 'BillingCycleId= ' + CAST(@BillingCycleId as varchar(10))

  --find all customers that need to be be billed this pay period
  DECLARE @CustomerId int
  DECLARE @CustomerName varchar(50)
  
  DECLARE curCustomerToBeBilled CURSOR 
  FOR

SELECT DISTINCT CompanyBilled.CustomerId, CompanyBilled.CompanyName
FROM
  (
  SELECT DISTINCT Billing.OrderCompleted.CustomerId, Billing.Customer.CompanyName
  FROM Billing.OrderCompleted with (nolock)
  INNER JOIN Billing.Customer with (nolock)
    ON Billing.OrderCompleted.CustomerId = Billing.Customer.CustomerId
  INNER JOIN Player_Master.TOURNAMENTS_TABLE Tournament with (nolock)
    ON Billing.OrderCompleted.TournamentId = Tournament.TournamentId
  LEFT JOIN Billing.InvoiceOrder with (nolock)
    ON Billing.OrderCompleted.OrderId = Billing.InvoiceOrder.OrderId 
  WHERE Billing.InvoiceOrder.OrderId IS NULL
   AND Tournament.[FIRST DAY] <= @ToDate 
   --AND Billing.Customer.BillingFrequency = 'M'
   AND Billing.Customer.CustomerId > 0
 UNION 
 SELECT DISTINCT Billing.OrderSpecial.CustomerId, Billing.Customer.CompanyName
  FROM Billing.OrderSpecial with (nolock)
  INNER JOIN Billing.Customer with (nolock)
    ON Billing.OrderSpecial.CustomerId = Billing.Customer.CustomerId
  --INNER JOIN Player_Master.TOURNAMENTS_TABLE Tournament with (nolock)
  --  ON Billing.OrderSpecial.TournamentId = Tournament.TournamentId
  LEFT JOIN Billing.InvoiceOrder with (nolock)
    ON Billing.OrderSpecial.OrderId = Billing.InvoiceOrder.OrderId 
  WHERE Billing.InvoiceOrder.OrderId IS NULL
   --AND Tournament.[FIRST DAY] <= '1/31/2013' -- @ToDate 
   --AND Billing.Customer.BillingFrequency = 'Q'
   AND Billing.Customer.CustomerId > 0 
  ) CompanyBilled
  ORDER BY CompanyBilled.CompanyName

  OPEN curCustomerToBeBilled 

  FETCH NEXT FROM curCustomerToBeBilled  
  INTO @CustomerId, @CustomerName
  WHILE @@FETCH_STATUS = 0
  BEGIN

     PRINT 'Billing ' + CAST(@CustomerId as varchar(10)) + ' ' + @CustomerName

    --for each customer find orders to be invoiced

    --check if invoice exists for same payperiod for customer
    DECLARE @InvoiceId int = 0
    --if exists use existing invoice to add orders
    SELECT @InvoiceId = COALESCE(InvoiceId, 0) 
    FROM Billing.Invoice with (nolock)
    WHERE 
         CustomerId = @CustomerId 
     AND BillingCycleId = @BillingCycleId 
     AND Billing.Invoice.IsSubmitted = 0
     
    PRINT 'Existing InvoiceId = ' + CAST(@InvoiceId as varchar(10)) 

    IF (@InvoiceId=0) 
    BEGIN
    --if does not exist, then insert new invoice
    INSERT Billing.Invoice (CustomerId, InvoiceDate, BillingCycleId, IsPaid, Notes) 
    VALUES (@CustomerId, Getdate(), @BillingCycleId, 0, @Notes)
    SELECT @InvoiceId = SCOPE_IDENTITY()
    PRINT 'New InvoiceId = ' + CAST(@InvoiceId as varchar(10)) 
    END
    
    --insert InvoiceOrder
    INSERT Billing.InvoiceOrder (InvoiceId, OrderId)
    SELECT @InvoiceId, Billing.OrderCompleted.OrderId
    FROM Billing.OrderCompleted with (nolock)
    INNER JOIN Player_Master.TOURNAMENTS_TABLE Tournament with (nolock)
      ON Billing.OrderCompleted.TournamentId = Tournament.TournamentId
    LEFT JOIN Billing.InvoiceOrder with (nolock)
      ON Billing.OrderCompleted.OrderId = Billing.InvoiceOrder.OrderId 
    WHERE Billing.InvoiceOrder.OrderId IS NULL
     AND Tournament.[FIRST DAY] <= @ToDate 
     AND Billing.OrderCompleted.CustomerId = @CustomerId
    ORDER BY Billing.OrderCompleted.OrderId

    --insert InvoiceOrderSpecial
    INSERT Billing.InvoiceOrderSpecial (InvoiceId, OrderId)
    SELECT @InvoiceId, Billing.OrderSpecial.OrderId
    FROM Billing.OrderSpecial with (nolock)
    LEFT JOIN Billing.InvoiceOrderSpecial with (nolock)
      ON Billing.OrderSpecial.OrderId = Billing.InvoiceOrderSpecial.OrderId 
    WHERE Billing.InvoiceOrderSpecial.OrderId IS NULL
     AND Billing.OrderSpecial.CustomerId = @CustomerId
     AND Billing.OrderSpecial.BillingCycleId = @BillingCycleId
    ORDER BY Billing.OrderSpecial.OrderId

    --get prices for completed reports
    DECLARE @AmountInvoicedCompleted money
    SET @AmountInvoicedCompleted = 0
    SELECT @AmountInvoicedCompleted = 
    COALESCE(SUM(
        COALESCE(Billing.OrderCompleted.Price, 0)
      + COALESCE(Billing.OrderCompleted.Fee1Amount, 0)
      + COALESCE(Billing.OrderCompleted.Fee2Amount, 0)
      + COALESCE(Billing.OrderCompleted.Fee3Amount, 0)
      - COALESCE(Billing.OrderCompleted.Discount, 0)
                 ),0)
    FROM Billing.OrderCompleted with (nolock)
    INNER JOIN Billing.InvoiceOrder with (nolock)
    ON Billing.OrderCompleted.OrderId = Billing.InvoiceOrder.OrderId  
    WHERE Billing.InvoiceOrder.InvoiceId = @InvoiceId
    
    PRINT 'AmountInvoicedCompleted=' + CAST(@AmountInvoicedCompleted as varchar(20))

    --get prices for special reports
    DECLARE @AmountInvoicedSpecial money
    SET @AmountInvoicedSpecial = 0
    SELECT @AmountInvoicedSpecial = 
    COALESCE(SUM(
        COALESCE(Billing.OrderSpecial.Price, 0)
      - COALESCE(Billing.OrderSpecial.Discount, 0)
                 ),0)
    FROM Billing.OrderSpecial with (nolock)
    INNER JOIN Billing.InvoiceOrderSpecial  with (nolock)
    ON Billing.OrderSpecial.OrderId = Billing.InvoiceOrderSpecial.OrderId  
    WHERE Billing.InvoiceOrderSpecial.InvoiceId = @InvoiceId
    
    PRINT 'AmountInvoicedSpecial=' + CAST(@AmountInvoicedSpecial as varchar(20))

    --calculate Invoice.AmountInvoiced
    DECLARE @AmountInvoiced money
    SET @AmountInvoiced = @AmountInvoicedCompleted + @AmountInvoicedSpecial

    PRINT 'AmountInvoiced=' + CAST(@AmountInvoiced as varchar(20))

    --update Invoice.AmountInvoiced
    UPDATE Billing.Invoice 
    SET AmountInvoiced = @AmountInvoiced
    WHERE Billing.Invoice.InvoiceId = @InvoiceId

    PRINT '- - - - - - - - - - - - - - - - - - - - '

    FETCH NEXT FROM curCustomerToBeBilled  
    INTO @CustomerId, @CustomerName

  END 
  CLOSE curCustomerToBeBilled;
  DEALLOCATE curCustomerToBeBilled;

END
GO
