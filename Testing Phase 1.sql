USE INFO430_Group1_Project

-- inserting data into payment table
EXEC Inspayment
  @OrderID = 1,
  @PaymentTypeName = 'COD' 

EXEC Inspayment
  @OrderID = 2,
  @PaymentTypeName = 'Credit Card'

EXEC Inspayment
  @OrderID = 3,
  @PaymentTypeName = 'Debit Card'

EXEC Inspayment
  @OrderID = 4,
  @PaymentTypeName = 'Online Banking'

EXEC Inspayment
  @OrderID = 5,
  @PaymentTypeName = 'PayPal'

EXEC Inspayment
  @OrderID = 6,
  @PaymentTypeName = 'COD' 


-- validating business rule 
EXEC insPayment
@OrderID = 7,
@PaymentTypeName = 'COD'


-- inserting into shipment
EXEC Insshipment
  @OrdID = 1,
  @PrdName = 'Lego' 

SELECT *
FROM   shipment

SELECT *
FROM   delivery_partner
WHERE  deliverypartnerid = 289 

EXEC insshipment
@ordid = 2,
@prdname = 'Bicycle'

EXEC insshipment
@ordid =
@prdname = ''

EXEC insshipment
@ordid =
@prdname = ''

EXEC insshipment
@ordid =
@prdname = ''

EXEC insshipment
@ordid =
@prdname = '' 

SELECT *
FROM   tblorder

SELECT P.productname
FROM   product P
WHERE  P.productid = 111

SELECT *
FROM   lineitems

SELECT custid
FROM   tblorder
WHERE  orderid = 1

SELECT custstate
FROM   customer
WHERE  custid = 196

SELECT *
FROM   delivery_partner
WHERE  deliverypartnerstate = 'California'

DELETE FROM shipment

DBCC checkident('Shipment', reseed, 0) 