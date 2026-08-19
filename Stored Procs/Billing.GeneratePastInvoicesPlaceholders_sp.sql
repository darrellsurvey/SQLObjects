DROP PROCEDURE IF EXISTS [Billing].[GeneratePastInvoicesPlaceholders_sp];
GO

CREATE PROCEDURE [Billing].[GeneratePastInvoicesPlaceholders_sp]

AS
BEGIN

  SET NOCOUNT ON;

  DELETE FROM Billing.InvoiceOrder
  DELETE FROM Billing.Invoice 

  -- Reseed identity on [Billing].[Invoice]
  DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED)
  -- Reseed identity on [Billing].[InvoiceOrder]
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED)
  -- Reseed identity on [Billing].[InvoiceOrderSpecial]
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED, 1)
  DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED)

  --find all customers that need to be be billed --montlhy
  DECLARE @CustomerId int
  DECLARE @CustomerName varchar(50)
  
  DECLARE curCustomerToBeBilled CURSOR 
  FOR
  SELECT DISTINCT Billing.OrderCompleted.CustomerId, Billing.Customer.CompanyName
  FROM Billing.OrderCompleted 
  INNER JOIN Billing.Customer
    ON Billing.OrderCompleted.CustomerId = Billing.Customer.CustomerId
  INNER JOIN Player_Master.TOURNAMENTS_TABLE Tournament
    ON Billing.OrderCompleted.TournamentId = Tournament.TournamentId
  LEFT JOIN Billing.InvoiceOrder 
    ON Billing.OrderCompleted.OrderId = Billing.InvoiceOrder.OrderId 
  WHERE Billing.InvoiceOrder.OrderId IS NULL
   AND Tournament.[FIRST DAY] <= '12/31/2012'
   --AND Billing.Customer.BillingFrequency = 'M'
   AND Billing.Customer.CustomerId > 0 
  
  ORDER BY Billing.OrderCompleted.CustomerId

  OPEN curCustomerToBeBilled 

  FETCH NEXT FROM curCustomerToBeBilled  
  INTO @CustomerId, @CustomerName
  WHILE @@FETCH_STATUS = 0
  BEGIN

     PRINT 'Billing ' + CAST(@CustomerId as varchar(10)) + ' ' + @CustomerName

    --for each customer find orders to be invoiced

    --insert invoice
    INSERT Billing.Invoice (CustomerId, InvoiceDate, IsPaid, Notes) 
    VALUES (@CustomerId, Getdate(), 0, NULL)

    DECLARE @NewInvoiceId int  
    SELECT @NewInvoiceId = SCOPE_IDENTITY()
    PRINT 'NewInvoiceId = ' + CAST(@NewInvoiceId as varchar(10)) 
    
    --insert InvoiceOrder
    INSERT Billing.InvoiceOrder (InvoiceId, OrderId) 
    SELECT @NewInvoiceId, Billing.OrderCompleted.OrderId 
	--, 
    --AmountInvoicedPerReport =
    --    COALESCE(Billing.OrderCompleted.Price, 0)
    --  + COALESCE(Billing.OrderCompleted.Fee1Amount, 0)
    --  + COALESCE(Billing.OrderCompleted.Fee2Amount, 0)
    --  + COALESCE(Billing.OrderCompleted.Fee3Amount, 0)
    FROM Billing.OrderCompleted 
    INNER JOIN Player_Master.TOURNAMENTS_TABLE Tournament
      ON Billing.OrderCompleted.TournamentId = Tournament.TournamentId
    LEFT JOIN Billing.InvoiceOrder 
      ON Billing.OrderCompleted.OrderId = Billing.InvoiceOrder.OrderId 
    WHERE Billing.InvoiceOrder.OrderId IS NULL
     AND Tournament.[FIRST DAY] <= '12/31/2012'
     AND Billing.OrderCompleted.CustomerId = @CustomerId
    ORDER BY Billing.OrderCompleted.OrderId


    FETCH NEXT FROM curCustomerToBeBilled  
    INTO @CustomerId, @CustomerName

  END 
  CLOSE curCustomerToBeBilled;
  DEALLOCATE curCustomerToBeBilled;

-- Reseed identity on [Billing].[InvoiceOrder]
DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED, 10000)
--DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED)
-- Reseed identity on [Billing].[InvoiceOrder]
DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED, 200000)
--DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED)

END
GO
