USE info430_group1_project

-- Get Order Status ID
go

CREATE PROCEDURE Getorderstatusid @OrdStatusName VARCHAR(50),
                                  @OrdStatusID   INT output
AS
    SET @OrdStatusID = (SELECT orderstatusid
                        FROM   order_status
                        WHERE  orderstatusname = @OrdStatusName)

-- Get Customer ID
go

CREATE PROCEDURE Getcustid @CFname VARCHAR(75),
                           @CLname VARCHAR(75),
                           @DOB    DATE,
                           @CID    INT output
AS
    SET @CID = (SELECT custid
                FROM   customer
                WHERE  custfname = @CFname
                       AND custlname = @CLname
                       AND custdob = @DOB)

-- Get Product ID
go

CREATE PROCEDURE Getpdtid @ProdName VARCHAR(50),
                          @ProdID   INT output
AS
    SET @ProdID = (SELECT productid
                   FROM   product
                   WHERE  productname = @ProdName)

-- Get Product Type ID
go

CREATE PROCEDURE Getpdttypeid @ProdTypeName VARCHAR(50),
                              @ProdTypeID   INT output
AS
    SET @ProdTypeID = (SELECT producttypeid
                       FROM   product_type
                       WHERE  producttypename = @ProdTypeName)

-- Get Payment Status ID
go

CREATE PROCEDURE Getpaystatid @PayStatName VARCHAR(50),
                              @PayStatID   INT output
AS
    SET @PayStatID = (SELECT paymentstatusid
                      FROM   payment_status
                      WHERE  paymentstatusname = @PayStatName)

-- Get Payment Type ID
go

CREATE PROCEDURE Getpaytypeid @PayTypeName VARCHAR(50),
                              @PayTypeID   INT output
AS
    SET @PayTypeID = (SELECT paymenttypeid
                      FROM   payment_type
                      WHERE  paymenttypename = @PayTypeName)

-- Get Rating ID
go

CREATE PROCEDURE Getratingid @RateName INT,
                             @RateID   INT output
AS
    SET @RateID = (SELECT ratingid
                   FROM   ratings
                   WHERE  ratingname = @RateName)

-- Get Supplier ID
go

CREATE PROCEDURE Getsupid @SupName  VARCHAR(75),
                          @SupEmail VARCHAR(50),
                          @SupID    INT output
AS
    SET @SupID = (SELECT supplierid
                  FROM   supplier
                  WHERE  suppliername = @SupName
                         AND supplieremail = @SupEmail)

-- Get Line Item ID
go

CREATE PROCEDURE Getlineid @OrdID       INT,
                           @OrdProdName VARCHAR(50),
                           @LineID      INT output
AS
    DECLARE @OrdProdId INT

    EXEC Getpdtid
      @ProdName = @OrdProdName,
      @ProdID = @OrdProdID output

    IF @OrdProdID IS NULL
      BEGIN
          PRINT 'Product ID cannot be null'

          RAISERROR('Product ID is null',11,1)

          RETURN
      END

    SET @LineID = (SELECT lineitemid
                   FROM   lineitems
                   WHERE  orderid = @OrdID
                          AND productid = @OrdProdID)

-- Get Shipment ID
go

CREATE PROCEDURE Getshipid @ShipOrdID    INT,
                           @ShipProdName VARCHAR(50),
                           @ShipID       INT output
AS
    DECLARE @ShipProdID INT

    EXEC Getpdtid
      @ProdName = @ShipProdName,
      @ProdID = @ShipProdID output

    IF @ShipProdID IS NULL
      BEGIN
          PRINT 'Product ID cannot be null'

          RAISERROR('Product ID is null',11,1)

          RETURN
      END

    DECLARE @Line_ID INT

    EXEC Getlineid
      @OrdID = @ShipOrdID,
      @OrdProdName = @ShipProdName,
      @LineID = @Line_ID output

    IF @Line_ID IS NULL
      BEGIN
          PRINT 'Line Item ID cannot be null'

          RAISERROR('Line Item ID is null',11,1)

          RETURN
      END

    SET @ShipID = (SELECT shipmentid
                   FROM   shipment
                   WHERE  lineitemid = @Line_ID)

-- Get Delivery Partner ID
go

CREATE PROCEDURE Getdelpartid @DelPartName  VARCHAR(75),
                              @DelPartEmail VARCHAR(50),
                              @DelPartID    INT output
AS
    SET @DelPartID = (SELECT deliverypartnerid
                      FROM   delivery_partner
                      WHERE  deliverypartnername = @DelPartName
                             AND deliverypartneremail = @DelPartEmail) 