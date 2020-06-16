CREATE DATABASE info430_group1_project

USE info430_group1_project

--Creation of Tables
-- Customer: Table to hold details about registered customers
go

CREATE TABLE customer
  (
     custid              INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     custfname           VARCHAR(75) NOT NULL,
     custlname           VARCHAR(75) NOT NULL,
     custdob             DATE NOT NULL,
     customeremail       VARCHAR(75) NOT NULL,
     customerphonenumber CHAR(20) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL,
     custaddress         VARCHAR(500) NOT NULL,
     custcity            VARCHAR(75) NOT NULL,
     custstate           VARCHAR(75) NOT NULL,
     custcountry         VARCHAR(75) NOT NULL,
     custzipcode         VARCHAR(75) NOT NULL
  )

-- Product-Type: Table to hold all different product categories
go

CREATE TABLE product_type
  (
     producttypeid          INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     producttypename        VARCHAR(50) NOT NULL,
     producttypedescription VARCHAR(500) NOT NULL,
     createtimestamp        DATETIME NOT NULL,
     createui               VARCHAR(50) NOT NULL,
     lastupdatetimestamp    DATETIME NOT NULL,
     lastupdateui           VARCHAR(50) NOT NULL
  )

-- Order_Status: Lookup table to hold values of all different statuses that an order shipment can take
go

CREATE TABLE order_status
  (
     orderstatusid       INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     orderstatusname     VARCHAR(50) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Product: Table to hold details about all products available
go

CREATE TABLE product
  (
     productid           INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     producttypeid       INT FOREIGN KEY REFERENCES product_type(producttypeid)
     NOT NULL,
     productname         VARCHAR(50) NOT NULL,
     productdescription  VARCHAR(500) NOT NULL,
     price               NUMERIC(8, 2) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Payment_Status: Lookup table to hold values of all different Payment Statuses
go

CREATE TABLE payment_status
  (
     paymentstatusid     INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     paymentstatusname   VARCHAR(50) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Payment_Type: Table to hold all different types of payment available
go

CREATE TABLE payment_type
  (
     paymenttypeid       INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     paymenttypename     VARCHAR(50) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Ratings: Lookup table to hold different values of rating available (1 to 5)
go

CREATE TABLE ratings
  (
     ratingid            INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     ratingname          INT NOT NULL,
     ratingdescription   VARCHAR(500) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Supplier: Table to hold details of all on-boarded Suppliers
go

CREATE TABLE supplier
  (
     supplierid                INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     suppliername              VARCHAR(75) NOT NULL,
     onboardingdate            DATE NOT NULL,
     supplierestablishmentdate DATE NULL,
     supplierprimarycontact    CHAR(20) NOT NULL,
     suppliersecondarycontact  CHAR(20) NULL,
     supplieremail             VARCHAR(50) NULL,
     supplieraddress           VARCHAR(500) NOT NULL,
     suppliercity              VARCHAR(75) NOT NULL,
     supplierstate             VARCHAR(75) NOT NULL,
     suppliercountry           VARCHAR(75) NOT NULL,
     supplierzipcode           VARCHAR(75) NOT NULL,
     createtimestamp           DATETIME NOT NULL,
     createui                  VARCHAR(50) NOT NULL,
     lastupdatetimestamp       DATETIME NOT NULL,
     lastupdateui              VARCHAR(50) NOT NULL
  )

-- Delivery_Partner: Table to hold details of all on-boarded Delivery Partners
go

CREATE TABLE delivery_partner
  (
     deliverypartnerid               INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     deliverypartnername             VARCHAR(75) NOT NULL,
     deliverypartneronboardingdate   DATE NOT NULL,
     deliverypartnerestdate          DATE NULL,
     deliverypartnerprimarycontact   CHAR(20) NOT NULL,
     deliverypartnersecondarycontact CHAR(20) NULL,
     deliverypartneremail            VARCHAR(50) NOT NULL,
     deliverypartneraddress          VARCHAR(500) NOT NULL,
     deliverypartnercity             VARCHAR(75) NOT NULL,
     deliverypartnerstate            VARCHAR(75) NOT NULL,
     deliverypartnercountry          VARCHAR(75) NOT NULL,
     deliverypartnerzipcode          VARCHAR(75) NOT NULL,
     createtimestamp                 DATETIME NOT NULL,
     createui                        VARCHAR(50) NOT NULL,
     lastupdatetimestamp             DATETIME NOT NULL,
     lastupdateui                    VARCHAR(50) NOT NULL
  )

-- tblOrder: Table to hold values for all orders placed
go

CREATE TABLE tblorder
  (
     orderid             INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     custid              INT FOREIGN KEY REFERENCES customer(custid) NOT NULL,
     orderdate           DATETIME NOT NULL,
     ordertotal          NUMERIC(8, 2) NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- LineItems: Table containing information about individual items in an order
go

CREATE TABLE lineitems
  (
     lineitemid          INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     orderid             INT FOREIGN KEY REFERENCES tblorder(orderid) NOT NULL,
     productid           INT FOREIGN KEY REFERENCES product(productid) NOT NULL,
     quantity            INT NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Reviews: Table to hold reviews and ratings submitted by a user for a product
go

CREATE TABLE reviews
  (
     reviewid            INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     custid              INT FOREIGN KEY REFERENCES customer(custid) NOT NULL,
     lineitemid          INT FOREIGN KEY REFERENCES lineitems(lineitemid) NOT
     NULL,
     ratingid            INT FOREIGN KEY REFERENCES ratings(ratingid) NOT NULL,
     reviewtext          VARCHAR(500) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Product_Supplier: Table to track all purchases made from suppliers
go

CREATE TABLE product_supplier
  (
     productsupplierid   INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     productid           INT FOREIGN KEY REFERENCES product(productid) NOT NULL,
     supplierid          INT FOREIGN KEY REFERENCES supplier(supplierid) NOT
     NULL,
     productquantity     INT NOT NULL,
     orderplaceddate     DATE NULL,
     orderdelivereddate  DATE NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Price_History: Table to track price changes for products over a period of time
go

CREATE TABLE price_history
  (
     pricehistoryid      INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     productid           INT FOREIGN KEY REFERENCES product(productid) NOT NULL,
     price               NUMERIC(8, 2) NOT NULL,
     pricingtimestamp    DATETIME NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Payment: Table to hold Payment entry for each order
go

CREATE TABLE payment
  (
     paymentid           INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     orderid             INT FOREIGN KEY REFERENCES tblorder(orderid) NOT NULL,
     paymenttypeid       INT FOREIGN KEY REFERENCES payment_type(paymenttypeid)
     NOT NULL,
     paymentamount       NUMERIC(8, 2) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Payment_Processing: Table to track all changing statuses for a particular payment
go

CREATE TABLE payment_processing
  (
     paymentprocessingid INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
     paymentid           INT FOREIGN KEY REFERENCES payment(paymentid) NOT NULL,
     paymentstatusid     INT FOREIGN KEY REFERENCES payment_status(
     paymentstatusid) NOT
     NULL,
     iscurrentstate      VARCHAR(50) NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL
  )

-- Shipment: Table to track the shipments of various items
go

CREATE TABLE shipment
  (
     shipmentid          INT IDENTITY(1, 1) NOT NULL,
     lineitemid          INT FOREIGN KEY REFERENCES lineitems(lineitemid) NOT
     NULL,
     deliverypartnerid   INT FOREIGN KEY REFERENCES delivery_partner(
     deliverypartnerid)
     NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL,
     PRIMARY KEY (shipmentid, lineitemid)
  )

-- Shipment_Status: Table to track the lifecycle of a product and shipment combination
go

CREATE TABLE shipment_status
  (
     shipmentstatusid    INT IDENTITY(1, 1) NOT NULL,
     shipmentid          INT NOT NULL,
     lineitemid          INT NOT NULL,
     orderstatusid       INT FOREIGN KEY REFERENCES order_status(orderstatusid)
     NOT NULL,
     createtimestamp     DATETIME NOT NULL,
     createui            VARCHAR(50) NOT NULL,
     lastupdatetimestamp DATETIME NOT NULL,
     lastupdateui        VARCHAR(50) NOT NULL,
     FOREIGN KEY (shipmentid, lineitemid) REFERENCES shipment,
     PRIMARY KEY (shipmentstatusid, shipmentid, lineitemid)
  ) 