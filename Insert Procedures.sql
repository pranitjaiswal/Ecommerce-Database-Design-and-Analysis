USE info430_group1_project

go

-- insert procedure for Customer
CREATE PROCEDURE Inscustomer @CustFname           VARCHAR(75),
                             @CustLname           VARCHAR(75),
                             @CustDOB             DATE,
                             @CustomerEmail       VARCHAR(75),
                             @CustomerPhoneNumber CHAR(12),
                             @CustAddress         VARCHAR(500),
                             @CustCity            VARCHAR(75),
                             @CustState           VARCHAR(75),
                             @CustCountry         VARCHAR(75),
                             @CustZipCode         VARCHAR(75)
AS
    IF @CustFName IS NULL
        OR @CustLName IS NULL
        OR @CustDOB IS NULL
        OR @CustomerEmail IS NULL
        OR @CustomerPhoneNumber IS NULL
        OR @CustAddress IS NULL
        OR @CustCity IS NULL
        OR @CustState IS NULL
        OR @CustCountry IS NULL
        OR @CustZipCode IS NULL
      BEGIN
          PRINT( 'null arguments passed to the procedure' )

          RAISERROR('cannot pass null arguments to the procedure',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO customer
                (custfname,
                 custlname,
                 custdob,
                 customeremail,
                 customerphonenumber,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui,
                 custaddress,
                 custcity,
                 custstate,
                 custcountry,
                 custzipcode)
    VALUES      (@CustFName,
                 @CustLName,
                 @CustDOB,
                 @CustomerEmail,
                 @CustomerPhoneNumber,
                 Sysdatetime(),
                 'insCustomer',
                 Sysdatetime(),
                 'insCustomer',
                 @CustAddress,
                 @CustCity,
                 @CustState,
                 @CustCountry,
                 @CustZipCode)

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

go

-- insert procedure for Product
CREATE PROCEDURE Insproduct @ProductTypeName    VARCHAR(50),
                            @ProductName        VARCHAR(50),
                            @ProductDescription VARCHAR(500),
                            @Price              NUMERIC(8, 2)
AS
    IF @ProductTypeName IS NULL
        OR @ProductName IS NULL
        OR @ProductDescription IS NULL
        OR @Price IS NULL
      BEGIN
          PRINT( 'null arguments passed to the procedure' )

          RAISERROR('cannot pass null arguments to the procedure',11,1)

          RETURN
      END

    DECLARE @ProductTypeID INT

    EXEC Getpdttypeid
      @ProdTypeName = @ProductTypeName,
      @ProdTypeID = @ProductTypeID output

    IF @ProductTypeID IS NULL
      BEGIN
          PRINT( 'No Product Type exists for the given Product Type Name' )

          RAISERROR(
          'Given Product Type Name does not exist in the table Product_Type'
          ,11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO product
                (producttypeid,
                 productname,
                 productdescription,
                 price,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@ProductTypeID,
                 @ProductName,
                 @ProductDescription,
                 @Price,
                 Sysdatetime(),
                 'insProduct',
                 Sysdatetime(),
                 'insProduct')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

go

-- insert procedure for Product_Type
CREATE PROCEDURE Insproducttype @ProductTypeName        VARCHAR(50),
                                @ProductTypeDescription VARCHAR(500)
AS
    IF @ProductTypeName IS NULL
        OR @ProductTypeDescription IS NULL
      BEGIN
          PRINT( 'null arguments passed to the procedure' )

          RAISERROR('cannot pass null arguments to the procedure',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO product_type
                (producttypename,
                 producttypedescription,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@ProductTypeName,
                 @ProductTypeDescription,
                 Sysdatetime(),
                 'insProductType',
                 Sysdatetime(),
                 'insProductType')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

go

-- Insert Procedure for Ratings Table
go

CREATE PROCEDURE Insrating @RtName INT,
                           @RtDesc VARCHAR(500)
AS
    IF @RtName IS NULL
      BEGIN
          RAISERROR('Rating Name cannot be Null',11,1)

          RETURN
      END

    IF @RtDesc IS NULL
      BEGIN
          RAISERROR('Rating Description cannot be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO ratings
                (ratingname,
                 ratingdescription,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @RtName,
                  @RtDesc,
                  'insRating',
                  Sysdatetime(),
                  'insRating',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

go

-- Insert Procedure for OrderStatus Table
CREATE PROCEDURE Insorderstatus @OrdStatusName VARCHAR(50)
AS
    IF @OrdStatusName IS NULL
      BEGIN
          RAISERROR('Rating Description cannot be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO order_status
                (orderstatusname,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @OrdStatusName,
                  'insOrderStatus',
                  Sysdatetime(),
                  'insOrderStatus',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

go

-- Insert Procedure for PaymentType Table
CREATE PROCEDURE Inspaymenttype @PayType VARCHAR(50)
AS
    IF @PayType IS NULL
      BEGIN
          RAISERROR('Rating Description cannot be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO payment_type
                (paymenttypename,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @PayType,
                  'insPaymentType',
                  Sysdatetime(),
                  'insPaymentType',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

go

-- Insert Procedure for PaymentStatus Table
CREATE PROCEDURE Inspaymentstatus @PayStatus VARCHAR(50)
AS
    IF @PayStatus IS NULL
      BEGIN
          RAISERROR('Rating Description cannot be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO payment_status
                (paymentstatusname,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @PayStatus,
                  'insPaymentStatus',
                  Sysdatetime(),
                  'insPaymentStatus',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

go

-- Insert Procedure for DeliveryPartner Table
CREATE PROCEDURE Insdeliverypartner @DelPartName       VARCHAR(75),
                                    @DelPartOnboardDt  DATE,
                                    @DelPartEstDt      DATE,
                                    @DelPartPrimaryCnt CHAR(20),
                                    @DelPartSecondCnt  CHAR(20),
                                    @DelPartEmail      VARCHAR(50),
                                    @DelPartAddress    VARCHAR(500),
                                    @DelPartCity       VARCHAR(75),
                                    @DelPartState      VARCHAR(75),
                                    @DelPartCountry    VARCHAR(75),
                                    @DelPartZip        VARCHAR(75)
AS
    IF @DelPartName IS NULL
      BEGIN
          RAISERROR('Partner Name cannot be Null',11,1)

          RETURN
      END

    IF @DelPartOnboardDt IS NULL
      BEGIN
          RAISERROR('Partner Onboarding Date cannot be Null',11,1)

          RETURN
      END

    IF @DelPartEstDt IS NULL
      BEGIN
          RAISERROR('Partner Establishment Date cannot be Null',11,1)

          RETURN
      END

    IF @DelPartPrimaryCnt IS NULL
      BEGIN
          RAISERROR('Partner Priamry Contact cannot be Null',11,1)

          RETURN
      END

    IF @DelPartSecondCnt IS NULL
      BEGIN
          RAISERROR('Partner Secondary Contact cannot be Null',11,1)

          RETURN
      END

    IF @DelPartEmail IS NULL
      BEGIN
          RAISERROR('Partner Email cannot be Null',11,1)

          RETURN
      END

    IF @DelPartAddress IS NULL
      BEGIN
          RAISERROR('Partner Address cannot be Null',11,1)

          RETURN
      END

    IF @DelPartCity IS NULL
      BEGIN
          RAISERROR('Partner City cannot be Null',11,1)

          RETURN
      END

    IF @DelPartState IS NULL
      BEGIN
          RAISERROR('Partner State cannot be Null',11,1)

          RETURN
      END

    IF @DelPartCountry IS NULL
      BEGIN
          RAISERROR('Partner Country cannot be Null',11,1)

          RETURN
      END

    IF @DelPartZip IS NULL
      BEGIN
          RAISERROR('Partner ZipCode cannot be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO delivery_partner
                (deliverypartnername,
                 deliverypartneronboardingdate,
                 deliverypartnerestdate,
                 deliverypartnerprimarycontact,
                 deliverypartnersecondarycontact,
                 deliverypartneremail,
                 deliverypartneraddress,
                 deliverypartnercity,
                 deliverypartnerstate,
                 deliverypartnercountry,
                 deliverypartnerzipcode,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @DelPartName,
                  @DelPartOnboardDt,
                  @DelPartEstDt,
                  @DelPartPrimaryCnt,
                  @DelPartSecondCnt,
                  @DelPartEmail,
                  @DelPartAddress,
                  @DelPartCity,
                  @DelPartState,
                  @DelPartCountry,
                  @DelPartZip,
                  'insDeliveryPartner',
                  Sysdatetime(),
                  'insDeliveryPartner',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

go

-- Insert Procedure for ProductSupplier Table
CREATE PROCEDURE Insproductsupplier @SuppName     VARCHAR(75),
                                    @SuppEmail    VARCHAR(50),
                                    @PrdName      VARCHAR(50),
                                    @OrdPlaceDt   DATE,
                                    @OrdDelDt     DATE,
                                    @ProdQuantity INT
AS
    IF @SuppName IS NULL
      BEGIN
          RAISERROR('Supplier Name cannot be Null',11,1)

          RETURN
      END

    IF @SuppEmail IS NULL
      BEGIN
          RAISERROR('Supplier Email cannot be Null',11,1)

          RETURN
      END

    IF @PrdName IS NULL
      BEGIN
          RAISERROR('Product Name cannot be Null',11,1)

          RETURN
      END

    IF @OrdPlaceDt IS NULL
      BEGIN
          RAISERROR('Order Placement Date cannot be Null',11,1)

          RETURN
      END

    IF @OrdDelDt IS NULL
      BEGIN
          RAISERROR('Order Delivery Date cannot be Null',11,1)

          RETURN
      END

    IF @ProdQuantity IS NULL
      BEGIN
          RAISERROR('Product Quantity cannot be Null',11,1)

          RETURN
      END

    DECLARE @P_ID INT
    DECLARE @S_ID INT

    EXEC Getpdtid
      @ProdName = @PrdName,
      @ProdID = @P_ID output

    IF @P_ID IS NULL
      BEGIN
          RAISERROR('Product ID was found to be Null',11,1)

          RETURN
      END

    EXEC Getsupid
      @SupName = @SuppName,
      @SupEmail = @SuppEmail,
      @SupID = @S_ID output

    IF @S_ID IS NULL
      BEGIN
          RAISERROR('Supplier ID was found to be Null',11,1)

          RETURN
      END

    BEGIN TRANSACTION t1

    INSERT INTO product_supplier
                (productid,
                 supplierid,
                 productquantity,
                 orderplaceddate,
                 orderdelivereddate,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      ( @P_ID,
                  @S_ID,
                  @ProdQuantity,
                  @OrdPlaceDt,
                  @OrdDelDt,
                  'insProductSupplier',
                  Sysdatetime(),
                  'insProductSupplier',
                  Sysdatetime() )

    IF @@ERROR <> 0
      ROLLBACK TRANSACTION t1
    ELSE
      COMMIT TRANSACTION t1

-- Insert procedure for Shipment
go

CREATE PROCEDURE Insshipment @OrdID   INT,
                             @PrdName VARCHAR(50)
AS
    IF @OrdID IS NULL
      BEGIN
          RAISERROR('Order ID cannot be Null',11,1)

          RETURN
      END

    IF @PrdName IS NULL
      BEGIN
          RAISERROR('Product Name cannot be Null',11,1)

          RETURN
      END

    DECLARE @PROD_ID INT

    EXEC Getpdtid
      @ProdName = @PrdName,
      @ProdID = @PROD_ID output

    IF @PROD_ID IS NULL
      BEGIN
          RAISERROR('Product ID cannot be Null',11,1)

          RETURN
      END

    DECLARE @ProdState VARCHAR(50)
    DECLARE @LineItID INT

    SELECT @ProdState = C.custstate,
           @LineItID = lt.lineitemid
    FROM   customer C
           JOIN tblorder O
             ON O.custid = C.custid
           JOIN lineitems lt
             ON lt.orderid = O.orderid
    WHERE  O.orderid = @OrdID
           AND lt.productid = @PROD_ID

    DECLARE @DelPartInState INT = (SELECT Count(*)
       FROM   delivery_partner dp
       WHERE  dp.deliverypartnerstate = @ProdState)
    DECLARE @DelPartID INT = (SELECT TOP 1 dp.deliverypartnerid
       FROM   delivery_partner dp
       WHERE  dp.deliverypartnerstate = @ProdState
       ORDER  BY Newid())
    DECLARE @DelPartCurrShipment INT = (SELECT TOP 1 s.shipmentid
       FROM   shipment s
       WHERE  s.deliverypartnerid = @DelPartID
       ORDER  BY s.createtimestamp DESC)

    IF @DelPartCurrShipment IS NOT NULL
      BEGIN
          DECLARE @CurrShipCapacity INT = (SELECT Count(*)
             FROM   shipment ss
             WHERE  ss.shipmentid = @DelPartCurrShipment)

          IF @CurrShipCapacity < 10
            BEGIN
                BEGIN TRAN t1

                SET IDENTITY_INSERT dbo.shipment ON

                INSERT INTO shipment
                            (shipmentid,
                             lineitemid,
                             deliverypartnerid,
                             createui,
                             createtimestamp,
                             lastupdateui,
                             lastupdatetimestamp)
                VALUES      (@DelPartCurrShipment,
                             @LineItID,
                             @DelPartID,
                             'insShipment',
                             Sysdatetime(),
                             'insShipment',
                             Sysdatetime())

                SET IDENTITY_INSERT dbo.shipment OFF

                IF @@ERROR <> 0
                  ROLLBACK TRAN t1
                ELSE
                  COMMIT TRAN t1
            END
      END
    ELSE
      BEGIN
          BEGIN TRAN t2

          INSERT INTO shipment
                      (lineitemid,
                       deliverypartnerid,
                       createui,
                       createtimestamp,
                       lastupdateui,
                       lastupdatetimestamp)
          VALUES      (@LineItID,
                       @DelPartID,
                       'insShipment',
                       Sysdatetime(),
                       'insShipment',
                       Sysdatetime())

          IF @@ERROR <> 0
            ROLLBACK TRAN t2
          ELSE
            COMMIT TRAN t2
      END

go

-- Insert Procedure for Shipment Status
CREATE PROCEDURE Insshipmentstatus @OrdID   INT,
                                   @PrdName VARCHAR(50),
                                   @OrdStat VARCHAR(50)
AS
    IF @OrdID IS NULL
      BEGIN
          RAISERROR('Order ID cannot be Null',11,1)

          RETURN
      END

    IF @PrdName IS NULL
      BEGIN
          RAISERROR('Product Name cannot be Null',11,1)

          RETURN
      END

    IF @OrdStat IS NULL
      BEGIN
          RAISERROR('Order Status cannot be Null',11,1)

          RETURN
      END

    DECLARE @PROD_ID INT

    EXEC Getpdtid
      @ProdName = @PrdName,
      @ProdID = @PROD_ID output

    IF @PROD_ID IS NULL
      BEGIN
          RAISERROR('Product ID cannot be Null',11,1)

          RETURN
      END

    DECLARE @Stat_ID INT

    EXEC Getorderstatusid
      @OrdStatusName = @OrdStat,
      @OrdStatusID = @Stat_ID output

    IF @Stat_ID IS NULL
      BEGIN
          RAISERROR('Order ID cannot be Null',11,1)

          RETURN
      END

    DECLARE @LineItID INT
    DECLARE @ShipID INT

    SELECT @LineItID = lt.lineitemid,
           @ShipID = s.shipmentid
    FROM   tblorder O
           JOIN lineitems lt
             ON O.orderid = lt.orderid
           JOIN shipment s
             ON lt.lineitemid = s.lineitemid
    WHERE  O.orderid = @OrdID

    BEGIN TRAN t2

    INSERT INTO shipment_status
                (shipmentid,
                 lineitemid,
                 orderstatusid,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      (@ShipID,
                 @LineItID,
                 @Stat_ID,
                 'insShipmentStatus',
                 Sysdatetime(),
                 'insShipmentStatus',
                 Sysdatetime())

    IF @@ERROR <> 0
      ROLLBACK TRAN t2
    ELSE
      COMMIT TRAN t2

go

-- Insert Proedure for lineItem
CREATE PROCEDURE Inslineitem @OrdID   INT,
                             @PrdName VARCHAR(50),
                             @Qty     INT
AS
    IF @OrdID IS NULL
      BEGIN
          RAISERROR('Order ID cannot be Null',11,1)

          RETURN
      END

    IF @PrdName IS NULL
      BEGIN
          RAISERROR('Product Name cannot be Null',11,1)

          RETURN
      END

    IF @Qty IS NULL
      BEGIN
          RAISERROR('Order Status cannot be Null',11,1)

          RETURN
      END

    DECLARE @PROD_ID INT

    EXEC Getpdtid
      @ProdName = @PrdName,
      @ProdID = @PROD_ID output

    IF @PROD_ID IS NULL
      BEGIN
          RAISERROR('Product ID cannot be Null',11,1)

          RETURN
      END

    BEGIN TRAN t2

    INSERT INTO lineitems
                (orderid,
                 productid,
                 quantity,
                 createui,
                 createtimestamp,
                 lastupdateui,
                 lastupdatetimestamp)
    VALUES      (@OrdID,
                 @PROD_ID,
                 @Qty,
                 'insLineItems',
                 Sysdatetime(),
                 'insLineItems',
                 Sysdatetime())

    IF @@ERROR <> 0
      ROLLBACK TRAN t2
    ELSE
      COMMIT TRAN t2

-- insert procedure for Payment
go

CREATE PROCEDURE Inspayment @OrderID         INT,
                            @PaymentTypeName VARCHAR(50)
AS
    IF @OrderID IS NULL
        OR @PaymentTypeName IS NULL
      BEGIN
          PRINT( 'Null parameters passed to the procedure' )

          RAISERROR('Null parameters not allowed',11,1)

          RETURN
      END

    DECLARE @PaymentTypeId INT
    DECLARE @ExtendedOrder NUMERIC(8, 2)

    SET @ExtendedOrder = (SELECT extendedorderamount
                          FROM   tblorder
                          WHERE  orderid = @OrderID)

    EXEC Getpaytypeid
      @PayTypeName = @PaymentTypeName,
      @PayTypeID = @PaymentTypeId output

    IF @PaymentTypeId IS NULL
      BEGIN
          PRINT( 'No payment type id for the given payment type name' )

          RAISERROR('Pass a valid Payment type name',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO payment
                (orderid,
                 paymenttypeid,
                 paymentamount,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@OrderID,
                 @PaymentTypeId,
                 @ExtendedOrder,
                 Sysdatetime(),
                 'insPaymentProcessing',
                 Sysdatetime(),
                 'insPaymentProcessing')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

go

---- insert procedure for payment_processing
CREATE PROCEDURE Inspaymentprocessing @PaymentStatusName VARCHAR(50),
                                      @OrderID           INT
AS
    IF @PaymentStatusName IS NULL
        OR @OrderID IS NULL
      BEGIN
          PRINT( 'Null parameters passed to the procedure' )

          RAISERROR('Null parameters not allowed',11,1)

          RETURN
      END

    DECLARE @PaymentID INT
    DECLARE @PaymentStatsID INT
    DECLARE @ErrorCode INT

    SET @PaymentID = (SELECT paymentid
                      FROM   payment
                      WHERE  orderid = @OrderID)

    IF @PaymentID IS NULL
      BEGIN
          PRINT( 'No payment id for the given ORDER ID' )

          RAISERROR('Pass a valid Payment ID',11,1)

          RETURN
      END

    EXEC Getpaystatid
      @PayStatName = @PaymentStatusName,
      @PayStatID = @PaymentStatsID output

    IF @PaymentStatsID IS NULL
      BEGIN
          PRINT( 'No payment status id for the given payment status name' )

          RAISERROR('Pass a valid payment status name',11,1)

          RETURN
      END

    BEGIN TRAN t1

    UPDATE payment_processing
    SET    iscurrentstate = 'N'
    WHERE  paymentid = @PaymentID

    SELECT @ErrorCode = @@ERROR

    IF( @ErrorCode <> 0 )
      GOTO problem

    BEGIN TRAN

    INSERT INTO payment_processing
                (paymentid,
                 paymentstatusid,
                 iscurrentstate,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      ( @PaymentID,
                  @PaymentStatsID,
                  'Y',
                  Sysdatetime(),
                  'insPaymentProcessing',
                  Sysdatetime(),
                  'insPaymentProcessing' )

    SELECT @ErrorCode = @@ERROR

    IF ( @ErrorCode <> 0 )
      GOTO problem

    COMMIT TRAN

    PROBLEM:

    IF ( @ErrorCode <> 0 )
      BEGIN
          PRINT 'Unable to process requested transaction!'

          ROLLBACK TRAN
      END

go

-- insert procedure for tblOrder
CREATE PROCEDURE Instblorder @CustFName     VARCHAR(50),
                             @CustLName     VARCHAR(50),
                             @CustBirthDate DATE,
                             @OrderDate     DATETIME,
                             @OrderTotal    NUMERIC(8, 2)
AS
    IF @CustFName IS NULL
        OR @CustLName IS NULL
        OR @CustBirthDate IS NULL
        OR @OrderDate IS NULL
        OR @OrderTotal IS NULL
      BEGIN
          PRINT( 'Null parameters passed to the procedure' )

          RAISERROR('Null parameters not allowed',11,1)

          RETURN
      END

    DECLARE @CustID INT

    EXEC Getcustid
      @CFname = @CustFName,
      @CLname = @CustLName,
      @DOB = @CustBirthDate,
      @CID = @CustID output

    IF @CustID IS NULL
      BEGIN
          PRINT( 'No customer found' )

          RAISERROR('Customer ID not found',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO tblorder
                (custid,
                 orderdate,
                 ordertotal,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@CustID,
                 @OrderDate,
                 @OrderTotal,
                 Sysdatetime(),
                 'insTblOrder',
                 Sysdatetime(),
                 'insTblOrder')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

go

-- Insert procedure for Price_History
go

CREATE PROCEDURE Ins_price_history @ProductName       VARCHAR(50),
                                   @Price             NUMERIC(8, 2),
                                   @Pricing_TimeStamp DATETIME
AS
    DECLARE @P_ID INT

    EXEC Getpdtid
      @ProdName = @ProductName,
      @ProdID = @P_ID output

    IF @P_ID IS NULL
      BEGIN
          RAISERROR('Product ID is null',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO price_history
                (productid,
                 price,
                 pricingtimestamp,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@P_ID,
                 @Price,
                 @Pricing_TimeStamp,
                 Sysdatetime(),
                 'INS_Price_History',
                 Sysdatetime(),
                 'INS_Price_History')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

-- Insert Procedure for Supplier
go

CREATE PROCEDURE Inssupplier @SupplierName     VARCHAR(75),
                             @OnboardingDate   DATE,
                             @SupplierEstDate  DATE,
                             @SupplierPContact CHAR(12),
                             @SupplierSContact CHAR(12),
                             @SupplierEmail    VARCHAR(50),
                             @SupplierAdd      VARCHAR(500),
                             @SupplierCity     VARCHAR(75),
                             @SupplierState    VARCHAR(75),
                             @SupplierCountry  VARCHAR(75),
                             @SupplierZipCode  VARCHAR(75)
AS
    BEGIN TRAN t1

    INSERT INTO supplier
                (suppliername,
                 onboardingdate,
                 supplierestablishmentdate,
                 supplierprimarycontact,
                 suppliersecondarycontact,
                 supplieremail,
                 supplieraddress,
                 suppliercity,
                 supplierstate,
                 suppliercountry,
                 supplierzipcode,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES     (@SupplierName,
                @OnboardingDate,
                @SupplierEstDate,
                @SupplierPContact,
                @SupplierSContact,
                @SupplierEmail,
                @SupplierAdd,
                @SupplierCity,
                @SupplierState,
                @SupplierCountry,
                @SupplierZipCode,
                Sysdatetime(),
                'insSupplier',
                Sysdatetime(),
                'insSupplier')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1

-- Insert Procedure for Reviews
go

CREATE PROCEDURE Insreviews @CustFname  VARCHAR(75),
                            @CustLname  VARCHAR(75),
                            @CustDOB    DATE,
                            @Order_ID   INT,
                            @ProdName   VARCHAR(50),
                            @RatingName INT,
                            @ReviewText VARCHAR(500)
AS
    DECLARE @C_ID INT
    DECLARE @LI_ID INT
    DECLARE @R_ID INT

    EXEC Getcustid
      @CFname = @CustFname,
      @CLname = @CustLname,
      @DOB = @CustDOB,
      @CID = @C_ID output

    IF @C_ID IS NULL
      BEGIN
          RAISERROR('Customer ID is null',11,1)

          RETURN
      END

    EXEC Getlineid
      @OrdID = @Order_ID,
      @OrdProdName = @ProdName,
      @LineID = @LI_ID output

    IF @LI_ID IS NULL
      BEGIN
          RAISERROR('Line Item ID is Null',11,1)

          RETURN
      END

    EXEC Getratingid
      @RateName = @RatingName,
      @RateID = @R_ID output

    IF @R_ID IS NULL
      BEGIN
          RAISERROR('Rating ID is NULL',11,1)

          RETURN
      END

    BEGIN TRAN t1

    INSERT INTO reviews
                (custid,
                 lineitemid,
                 ratingid,
                 reviewtext,
                 createtimestamp,
                 createui,
                 lastupdatetimestamp,
                 lastupdateui)
    VALUES      (@C_ID,
                 @LI_ID,
                 @R_ID,
                 @ReviewText,
                 Sysdatetime(),
                 'insReviews',
                 Sysdatetime(),
                 'insReviews')

    IF @@ERROR <> 0
      ROLLBACK TRAN t1
    ELSE
      COMMIT TRAN t1 