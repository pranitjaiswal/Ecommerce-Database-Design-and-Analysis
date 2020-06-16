USE info430_group1_project

--Computed Columns 
-- Compute days from last status- shipment_status
USE info430_group1_project

-- Computed Column
-- Extended Order Amount- If Customer is from Hawaii or Alaska, add 15% tax on ordertotal
go

ALTER FUNCTION Extended_price(@PK_ID INT)
returns NUMERIC(8, 2)
AS
  BEGIN
      DECLARE @RET NUMERIC(8, 2) = (SELECT ( CASE
                    WHEN C.custstate IN ( 'Hawaii', 'Alaska' ) THEN (
                    O.ordertotal +
        O.ordertotal * 0.15 )
        ELSE O.ordertotal
        END ) AS ExtendedOrderTotal
         FROM   tblorder O
                JOIN customer C
                  ON O.custid = C.custid
         WHERE  O.orderid = @PK_ID)

      RETURN @RET
  END

go

ALTER TABLE tblorder
  ADD extendedorderamount

AS (dbo.Extended_price(orderid))
-- Computed Column
-- Estimated Delivery Date is 3 days after Order Date
go

CREATE FUNCTION Estimated_delivery_date(@PK_ID INT)
returns DATE
AS
  BEGIN
      DECLARE @Ret DATE = (SELECT Dateadd(day, 3, O.orderdate)
         FROM   tblorder O
                JOIN lineitems LI
                  ON O.orderid = LI.orderid
                JOIN shipment S
                  ON LI.lineitemid = S.lineitemid
                JOIN shipment_status SS
                  ON SS.shipmentid = S.shipmentid
         WHERE  SS.shipmentstatusid = @PK_ID)

      RETURN @Ret
  END

go

ALTER TABLE shipment_status
  ADD estimateddeliverydate

AS (dbo.Estimated_delivery_date(shipmentstatusid))
go

-- Function to calculate DaysToChangeStatus computed column 
CREATE FUNCTION Fn_calcdaystochangestatus(@ShipStatusID INT)
returns INT
AS
  BEGIN
      DECLARE @ShipID INT
      DECLARE @LineItID INT
      DECLARE @CurrStateDate DATETIME

      SELECT @ShipID = ss.shipmentid,
             @LineItID = ss.lineitemid,
             @CurrStateDate = ss.createtimestamp
      FROM   shipment_status ss
      WHERE  ss.shipmentstatusid = @ShipStatusID

      DECLARE @LastStatusDate DATE = (SELECT TOP 1 shipStat.createtimestamp
         FROM   shipment_status shipStat
         WHERE  shipStat.shipmentid = @ShipID
                AND shipStat.lineitemid = @LineItID
                AND shipStat.shipmentstatusid <> @ShipStatusID
         ORDER  BY shipStat.createtimestamp DESC)

      IF @LastStatusDate IS NULL
        BEGIN
            RETURN 0
        END

      DECLARE @RET INT = (SELECT Datediff(day, @LastStatusDate, @CurrStateDate))

      RETURN @RET
  END

go

ALTER TABLE shipment_status
  ADD daystochangestatus

AS (dbo.Fn_calcdaystochangestatus(shipmentstatusid))
go

-- Function to Calculate the DiffFromLastPrice computed column
CREATE FUNCTION Fn_calcdifffromlastprice(@PriceHistID INT)
returns NUMERIC(8, 2)
AS
  BEGIN
      DECLARE @ProdID INT
      DECLARE @CurrPrice NUMERIC(8, 2)
      DECLARE @PrevPrice NUMERIC(8, 2)

      SELECT @ProdID = ph.productid,
             @CurrPrice = ph.price
      FROM   price_history ph
      WHERE  ph.pricehistoryid = @PriceHistID

      DECLARE @PrevPriceHistID INT = (SELECT TOP 1 prcHist.pricehistoryid
         FROM   price_history prcHist
         WHERE  prcHist.productid = @ProdID
                AND prcHist.pricehistoryid <> @PriceHistID
                AND prcHist.pricehistoryid < @PriceHistID
         ORDER  BY pricingtimestamp DESC)
      DECLARE @LastPrice NUMERIC(8, 2) = (SELECT PP.price
         FROM   price_history PP
         WHERE  pp.pricehistoryid = @PrevPriceHistID)

      IF @LastPrice IS NULL
        BEGIN
            RETURN 0.00
        END

      RETURN ( @CurrPrice - @LastPrice )
  END

go

ALTER TABLE price_history
  ADD difffromlastprice

AS (dbo.Fn_calcdifffromlastprice(pricehistoryid))
go

-- Customer Age while Joining
CREATE FUNCTION Fn_calc_customer_age_joining(@Cust_ID INT)
returns INT
AS
  BEGIN
      DECLARE @Ret INT = (SELECT Datediff(year, c.custdob, Getdate())
         FROM   customer c
         WHERE  c.custid = @Cust_ID)

      RETURN @Ret
  END

go

ALTER TABLE customer
  ADD custageatjoining

AS dbo.Fn_calc_customer_age_joining(custid)
go

-- Supplier Experience
ALTER FUNCTION Fn_calc_supplier_age_joining(@Sup_ID INT)
returns INT
AS
  BEGIN
      DECLARE @Ret INT = (SELECT Datediff(year, S.supplierestablishmentdate,
                                 S.onboardingdate)
         FROM   supplier S
         WHERE  S.supplierid = @Sup_ID)

      RETURN @Ret
  END

go

ALTER TABLE supplier
  ADD supexpatjoining

AS dbo.Fn_calc_supplier_age_joining(supplierid)
go

-- Delivery Partner Experience
ALTER FUNCTION Fn_calc_deliverypartner_age_joining(@Del_ID INT)
returns INT
AS
  BEGIN
      DECLARE @Ret INT = (SELECT Datediff(year, D.deliverypartnerestdate,
                                   D.deliverypartneronboardingdate)
         FROM   delivery_partner D
         WHERE  D.deliverypartnerid = @Del_ID)

      RETURN @Ret
  END

go

ALTER TABLE delivery_partner
  ADD deliverypartnerexpatjoining

AS dbo.Fn_calc_deliverypartner_age_joining(deliverypartnerid)
go

-- Fine for product supplier for delivery later than 3 days
CREATE FUNCTION Fn_calc_fine_product_supplied_after_3_days(@Product_Supplier_ID
INT)
returns NUMERIC(8, 2)
AS
  BEGIN
      DECLARE @Fine NUMERIC (8, 2)
      DECLARE @ProductPrice NUMERIC(8, 2)
      DECLARE @ProductQuant INT
      DECLARE @ProductID INT

      SET @Fine = 0.0

      DECLARE @DtDiff INT = (SELECT Datediff(day, ps.orderplaceddate,
                                    ps.orderdelivereddate)
         FROM   product_supplier ps
         WHERE  ps.productsupplierid = @Product_Supplier_ID)

      IF @DtDiff > 3
        BEGIN
            SET @ProductID = (SELECT productid
                              FROM   product_supplier ps
                              WHERE  ps.productsupplierid = @Product_Supplier_ID
                             )
            SET @ProductPrice = (SELECT p.price
                                 FROM   product p
                                 WHERE  p.productid = @ProductID)
            SET @ProductQuant = (SELECT ps.productquantity
                                 FROM   product_supplier ps
                                 WHERE
            ps.productsupplierid = @Product_Supplier_ID)
            SET @Fine = 0.15 * ( @ProductPrice * @ProductQuant )
        END

      RETURN @Fine
  END

go

ALTER TABLE product_supplier
  ADD fineappliedforlatedelivery

AS dbo.Fn_calc_fine_product_supplied_after_3_days(productsupplierid) 