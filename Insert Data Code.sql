USE info430_group1_project

-- Insert into Customer Table
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
SELECT TOP 1000000 C.customerfname,
                   C.customerlname,
                   C.dateofbirth,
                   C.email,
                   C.areacode + '-' + C.phonenum,
                   Sysdatetime(),
                   'insCustomer',
                   Sysdatetime(),
                   'insCustomer',
                   C.customeraddress,
                   C.customercity,
                   C.customerstate,
                   'USA',
                   C.customerzip
FROM   customer_build.dbo.tblcustomer AS C

-- Insert into Order_Status Table
DECLARE @tempOrderStatues TABLE
  (
     rowid      INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
     statusname VARCHAR(50)
  )

INSERT INTO @tempOrderStatues
VALUES      ('Created'),
            ('Processing'),
            ('Picked-Up'),
            ('In-Transit'),
            ('Late'),
            ('Delivered'),
            ('Delivery Failed')

SELECT *
FROM   @tempOrderStatues

DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tempOrderStatues)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @TEMPSTATUS VARCHAR(50)

      SET @TEMPSTATUS = (SELECT statusname
                         FROM   @tempOrderStatues
                         WHERE  rowid = @COUNT)

      EXEC Insorderstatus
        @OrdStatusName = @TEMPSTATUS

      SET @COUNT = @COUNT + 1
  END

go

-- Insert into Payment_Status Table
DECLARE @tempPaymentStatus TABLE
  (
     rowid      INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
     statusname VARCHAR(50)
  )

INSERT INTO @tempPaymentStatus
VALUES      ('Payment Initiated'),
            ('Payment Pending Approval'),
            ('Payment Approved'),
            ('Payment Completed'),
            ('Payment Declined')

SELECT *
FROM   @tempPaymentStatus

DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tempPaymentStatus)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @TEMPSTATUS VARCHAR(50)

      SET @TEMPSTATUS = (SELECT statusname
                         FROM   @tempPaymentStatus
                         WHERE  rowid = @COUNT)

      EXEC Inspaymentstatus
        @PayStatus = @TEMPSTATUS

      SET @COUNT = @COUNT + 1
  END

-- Insert into Payment_Type Table
go

DECLARE @tempPaymentTypetbl TABLE
  (
     rowid      INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
     statusname VARCHAR(50)
  )

INSERT INTO @tempPaymentTypetbl
VALUES      ('Cash-On-Delivery'),
            ('Credit Card'),
            ('Debit Card'),
            ('Online Banking'),
            ('PayPal')

SELECT *
FROM   @tempPaymentTypetbl

DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tempPaymentTypetbl)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @TEMPSTATUS VARCHAR(50)

      SET @TEMPSTATUS = (SELECT statusname
                         FROM   @tempPaymentTypetbl
                         WHERE  rowid = @COUNT)

      EXEC Inspaymenttype
        @PayType = @TEMPSTATUS

      SET @COUNT = @COUNT + 1
  END 

-- Insert into Product_Type Table

go

DECLARE @tempProductType TABLE
  (
     rowid       INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
     prdtypename VARCHAR(50),
     prdtypedesc VARCHAR(500)
  )

INSERT INTO @tempProductType
VALUES      ('Adult Movies',
             'Movies meant for viewers who are 18+.'),
            ('Movies',
             'Your source of entertainment'),
            ('Cannabis',
             'Time to get high ON LIFE'),
            ('Exclusive',
             'Products from our partners available only on our website'),
            ('Garments',
             'Your Fashion Central' ),
            ('Personal Care',
             'For your Wellness'),
            ('Breakfast',
             'Make the most of the first meal of the day'),
            ('Asian Food',
             'Spicy Food'),
            ('Beverages',
             'Drinks for all ages and moods'),
            ('Alcohol',
             'Spirits for your parties'),
            ('Dairy',
             'Diary Products'),
            ('Vegetables',
             'Fresh veggies'),
            ('Fruits',
             'Fresh fruits for healthy eating'),
            ('Meat',
             'All types of meat'),
            ('Cigarettes',
             'Smoke Away'),
            ('Chocolates',
             'For the Sweet Tooth'),
            ('Toys',
             'For children and adults who want to be children'),
            ('Curtlery',
             'Makeup for your kitchen'),
            ('Baby Products',
             'Because babies need good products just as much as adults'),
            ('Books',
             'For the days you want to ditch the internet'),
            ('Home and Garden',
             'The perfect products for the inside and outside of your house'),
            ('Music',
             'The one stop shop for music junkies'),
            ('Outdoors',
             'Exploration products'),
            ('Computer Games',
             'Play them all'),
            ('Beauty',
             'For the beautiful you'),
            ('Sports',
             'Work hard but Play harder'),
            ('Wearable Technology',
             'The latest technology products in the market'),
            ('Office Products',
             'Making your office desks and cabins more personal')

SELECT *
FROM   @tempProductType

DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tempProductType)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @tempPrdName VARCHAR(50)
      DECLARE @tempPrdDesc VARCHAR(500)

      SELECT @tempPrdName = tp.prdtypename,
             @tempPrdDesc = tp.prdtypedesc
      FROM   @tempProductType tp
      WHERE  rowid = @COUNT

      EXEC Insproducttype
        @ProductTypeName = @tempPrdName,
        @ProductTypeDescription = @tempPrdDesc

      SET @COUNT = @COUNT + 1
  END

go 

-- Insert into Product Table

goDECLARE @TEMPPRODUCT TABLE
                           (
                                                      rowid       INT NOT NULL PRIMARY KEY IDENTITY(1,1),
                                                      prdtypename VARCHAR(50),
                                                      prdname     VARCHAR(50),
                                                      prddesc     VARCHAR(500),
                                                      prdprice    NUMERIC(8,2)
                           )INSERT INTO @tempProduct VALUES

('Adult Movies','American Pie 1','American Pie 1 in category Adult Movies',101.1),
('Adult Movies','Horrible Bosses','Horrible Bosses in category Adult Movies',61.74),
('Adult Movies','American Pie 2','American Pie 2 in category Adult Movies',23.85),
('Adult Movies','American Pie 3','American Pie 3 in category Adult Movies',74.7),
('Adult Movies','American Pie 4','American Pie 4 in category Adult Movies',97.34),
('Alcohol','Old Monk Rum','Old Monk Rum in category Alcohol',85.76),
('Alcohol','Corona Beer','Corona Beer in category Alcohol',13.5),
('Alcohol','Merlot Red Wine','Merlot Red Wine in category Alcohol',177.35),
('Alcohol','Jack Daniels Whiskey','Jack Daniels Whiskey in category Alcohol',190.21),
('Alcohol','Chateau Ponet White Wine','Chateau Ponet White Wine in category Alcohol',69.76),
('Asian Food','Top Ramen Noodles','Top Ramen Noodles in category Asian Food',24.79),
('Asian Food','Basmati Rice','Basmati Rice in category Asian Food',196.66),
('Asian Food','Paneer','Paneer in category Asian Food',69.9),
('Asian Food','Hainanese Chicken Rice','Hainanese Chicken Rice in category Asian Food',4.75),
('Asian Food','Fish Balls','Fish Balls in category Asian Food',168.04),
('Baby Products','Two-in-one car seat','Two-in-one car seat in category Baby Products',133.59),
('Baby Products','Playtex Diaper','Playtex Diaper in category Baby Products',153.65),
('Baby Products','Solly Baby Wrap','Solly Baby Wrap in category Baby Products',61.24),
('Baby Products','BabyBorn Bouncer Bliss','BabyBorn Bouncer Bliss in category Baby Products',131.43),
('Baby Products','Nursing Pillow','Nursing Pillow in category Baby Products',72.09),
('Beauty','Nivea Men Cream','Nivea Men Cream in category Beauty',197.92),
('Beauty','Lynx Hair Cream','Lynx Hair Cream in category Beauty',86),
('Beauty','Ustra Beard Oil','Ustra Beard Oil in category Beauty',160.89),
('Beauty','Head and Shoulders Shampoo','Head and Shoulders Shampoo in category Beauty',146.06),
('Beauty','Tea Tree Oil','Tea Tree Oil in category Beauty',120.77),
('Beverages','Himalayans Fresh Water','Himalayan Fresh Water in category Beverages',156.85),
('Beverages','Glaceau Vitamin Water','Glaceau Vitamin Water in category Beverages',130.42),
('Beverages','Diet Coke','Diet Coke in category Beverages',22.75),
('Beverages','Dasani Fresh Water','Dasani Fresh Water in category Beverages',137.7),
('Beverages','Fanta','Fanta in category Beverages',188.03),
('Books','I am fine and neither are you','I am fine and neither are you in category Books',137.23),
('Books','The beautiful chaos of growing up','The beautiful chaos of growing up in category Books',134.84),
('Books','War and Peace','War and Peace in category Books',131.99),
('Books','The Adventures of Huckleberry','The Adventures of Huckleberry in category Books',120.79),
('Books','The stories of Anton Chekhov','The stories of Anton Chekhov in category Books',187.21),
('Breakfast','Kellogg Granola','Kellogg Granola in category Breakfast',162.09),
('Breakfast','Signature Cornflakes','Signature Cornflakes in category Breakfast',153.04),
('Breakfast','Nature Protein Bars','Nature Protein Bars in category Breakfast',27.7),
('Breakfast','Whole Wheat Bread','Whole Wheat Bread in category Breakfast',170.57),
('Breakfast','Gimmys Pasta','Gimmys Pasta in category Breakfast',54.71),
('Cannabis','Nulead Naturals','Nulead Naturals in category Cannabis',152.37),
('Cannabis','Medterra','Medterra in category Cannabis',166.32),
('Cannabis','Populum','Populum in category Cannabis',77.37),
('Cannabis','Marley Natural','Marley Natural in category Cannabis',145.83),
('Cannabis','Highsmean Natural','Highsmean Natural in category Cannabis',29.75),
('Chocolates','Hershey dark chocolate','Hershey dark chocolate in category Chocolates',27.38),
('Chocolates','Five Star','Five Star in category Chocolates',87.76),
('Chocolates','Cadbury Fruit and Nut','Cadbury Fruit and Nut in category Chocolates',165.05),
('Chocolates','Cadbury Smooth Silk','Cadbury Smooth Silk in category Chocolates',91.52),
('Chocolates','Reese Peanut Candy','Reese Peanut Candy in category Chocolates',32.15),
('Cigarettes','Goldflake Small','Goldflake Small in category Cigarettes',71.13),
('Cigarettes','Malboro Red','Malboro Red in category Cigarettes',145.51),
('Cigarettes','Classic Ice Burst','Classic Ice Burst in category Cigarettes',133.05),
('Cigarettes','Indian Kings','Indian Kings in category Cigarettes',71.04),
('Cigarettes','Dunhill Switch','Dunhill Switch in category Cigarettes',1.54),
('Computer Games','Call of Duty','Call of Duty in category Computer Games',40.06),
('Computer Games','PUBG PC','PUBG PC in category Computer Games',6.13),
('Computer Games','Mario','Mario in category Computer Games',187.2),
('Computer Games','Fifa 19','Fifa 19 in category Computer Games',94.21),
('Computer Games','Fortnite','Fortnite in category Computer Games',135.13),
('Curtlery','Steel Spoons','Steel Spoons in category Curtlery',195.91),
('Curtlery','Dinner Plates','Dinner Plates in category Curtlery',9.43),
('Curtlery','Plastic forks','Plastic forks in category Curtlery',166.61),
('Curtlery','Small Bowls','Small Bowls in category Curtlery',115.71),
('Curtlery','Nonstick Pan','Nonstick Pan in category Curtlery',77.76),
('Dairy','Whole Milk','Whole Milk in category Dairy',112.46),
('Dairy','Fat Free Milk','Fat Free Milk in category Dairy',66.96),
('Dairy','Mozzarella Cheese','Mozzarella Cheese in category Dairy',23.14),
('Dairy','Feta Cheese','Feta Cheese in category Dairy',106.33),
('Dairy','Ricotta','Ricotta in category Dairy',68.51),
('Exclusive','Gift Cards','Gift Cards in category Exclusive',176.43),
('Exclusive','One Plus 7','One Plus 7 in category Exclusive',62.7),
('Exclusive','Apple Stand','Apple Stand in category Exclusive',189.49),
('Exclusive','Prime membership','Prime membership in category Exclusive',158.02),
('Exclusive','Nintendo New Switch','Nintendo New Switch in category Exclusive',19.39),
('Fruits','Apple','Apple in category Fruits',58.39),
('Fruits','Orange','Orange in category Fruits',167.5),
('Fruits','Banana','Banana in category Fruits',105.02),
('Fruits','Pineapple','Pineapple in category Fruits',133.14),
('Fruits','Muskmellon','Muskmellon in category Fruits',131.41),
('Garments','Shirt XL','Shirt XL in category Garments',95.09),
('Garments','T Shirt L','T Shirt L in category Garments',160.69),
('Garments','White Chinos','White Chinos in category Garments',43.97),
('Garments','Black Hoodie','Black Hoodie in category Garments',86.43),
('Garments','White Vest','White Vest in category Garments',74.47),
('Home and Garden','Chia Seeds','Chia Seeds in category Home and Garden',75.38),
('Home and Garden','Garden Spade','Garden Spade in category Home and Garden',169.37),
('Home and Garden','Trowel','Trowel in category Home and Garden',92.91),
('Home and Garden','Rake','Rake in category Home and Garden',11.36),
('Home and Garden','Manure','Manure in category Home and Garden',156.69),
('Meat','Chicken Breast','Chicken Breast in category Meat',112.78),
('Meat','Beef Slice','Beef Slice in category Meat',108),
('Meat','Pork Slice','Pork Slice in category Meat',8.49),
('Meat','Tune Fish','Tune Fish in category Meat',168.47),
('Meat','Salmon','Salmon in category Meat',109.38),
('Movies','Fast and Furious','Fast and Furious in category Movies',170.43),
('Movies','Hum Aapke Hain Kaun','Hum Aapke Hain Kaun in category Movies',65.48),
('Movies','Gangs of Wasseypur','Gangs of Wasseypur in category Movies',12.8),
('Movies','Titanic','Titanic in category Movies',51.24),
('Movies','Wolf of Wall Street','Wolf of Wall Street in category Movies',23.73),
('Music','Rihanna Singles','Rihanna Singles in category Music',166.23),
('Music','Atif Aslam Collection','Atif Aslam Collection in category Music',138.9),
('Music','Top 10 Michael Jackson','Top 10 Michael Jackson in category Music',21),
('Music','Bollywood Hits','Bollywood Hits in category Music',155.2),
('Music','Pink Floyd','Pink Floyd in category Music',27.16),
('Office Products','Office Desk','Office Desk in category Office Products',52.13),
('Office Products','Office Clipper','Office Clipper in category Office Products',93.43),
('Office Products','Harman Chair','Harman Chair in category Office Products',0.36),
('Office Products','HP Print Paper','HP Print Paper in category Office Products',151.33),
('Office Products','Brother InkJet Printer','Brother InkJet Printer in category Office Products',135.08),
('Outdoors','Bicycle','Bicycle in category Outdoors',43.5),
('Outdoors','Skateboard','Skateboard in category Outdoors',26.29),
('Outdoors','Waist Pack','Waist Pack in category Outdoors',148.4),
('Outdoors','Utility Duffle','Utility Duffle in category Outdoors',133.68),
('Outdoors','Ditty Bag','Ditty Bag in category Outdoors',150.98),
('Personal Care','Shaving Gel','Shaving Gel in category Personal Care',119.47),
('Personal Care','Razor','Razor in category Personal Care',136.32),
('Personal Care','Axe Deo','Axe Deo in category Personal Care',194.24),
('Personal Care','Sunscreen SPF 50','Sunscreen SPF 50 in category Personal Care',59.01),
('Personal Care','Toothpaste','Toothpaste in category Personal Care',18.72),
('Sports','Football','Football in category Sports',4.1),
('Sports','Volleyball','Volleyball in category Sports',6.97),
('Sports','Basketball','Basketball in category Sports',22.49),
('Sports','Badminton','Badminton in category Sports',132.06),
('Sports','Jogging Shoes','Jogging Shoes in category Sports',165.62),
('Toys','Lego','Lego in category Toys',166.68),
('Toys','G.I. Joe','G.I. Joe in category Toys',194.23),
('Toys','Stickers','Stickers in category Toys',153.71),
('Toys','Small Battery Drone','Small Battery Drone in category Toys',65.23),
('Toys','Speed Car','Speed Car in category Toys',88.34),
('Vegetables','Spinach','Spinach in category Vegetables',6.99),
('Vegetables','Potato','Potato in category Vegetables',61.19),
('Vegetables','Kale','Kale in category Vegetables',71.78),
('Vegetables','Tomato','Tomato in category Vegetables',110.29),
('Vegetables','Onion','Onion in category Vegetables',62.5),
('Wearable Technology','Moto Smartwatch','Moto Smartwatch in category Wearable Technology',12.16),
('Wearable Technology','Fitbit','Fitbit in category Wearable Technology',131.38),
('Wearable Technology','Google Glass','Google Glass in category Wearable Technology',167.35),
('Wearable Technology','Snap Spectale','Snap Spectale in category Wearable Technology',86.38),
('Wearable Technology','Wave Bracelet','Wave Bracelet in category Wearable Technology',78.4)


DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tempProduct)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @tmpprdTypeName VARCHAR(50)
      DECLARE @tmpprdName VARCHAR(50)
      DECLARE @tmpprdDesc VARCHAR(500)
      DECLARE @tmpprdPrice NUMERIC(8, 2)

      SELECT @tmpprdTypeName = tp.prdtypename,
             @tmpprdName = tp.prdname,
             @tmpprdDesc = tp.prddesc,
             @tmpprdPrice = tp.prdprice
      FROM   @tempProduct tp
      WHERE  rowid = @COUNT

      EXEC Insproduct
        @ProductTypeName = @tmpprdTypeName,
        @ProductName = @tmpprdName,
        @ProductDescription = @tmpprdDesc,
        @Price = @tmpprdPrice

      SET @COUNT = @COUNT + 1
  END

go

-- Insert into Rating Table
DECLARE @tmpRating TABLE
  (
     rowid         INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
     tmprating     INT,
     tmpratingdesc VARCHAR(500)
  )

INSERT INTO @tmpRating
VALUES      (1,
             '1 Star Rating'),
            (2,
             '2 Star Rating'),
            (3,
             '3 Star Rating'),
            (4,
             '4 Star Rating'),
            (5,
             '5 Star Rating')

DECLARE @COUNT INT

SET @COUNT = 1

DECLARE @TOTAL INT = (SELECT Count(*)
   FROM   @tmpRating)

WHILE @COUNT <= @TOTAL
  BEGIN
      DECLARE @tmpRatingVal INT
      DECLARE @tmpRatingDesc VARCHAR(500)

      SELECT @tmpRatingVal = tp.tmprating,
             @tmpRatingDesc = tp.tmpratingdesc
      FROM   @tmpRating tp
      WHERE  rowid = @COUNT

      EXEC Insrating
        @RtName = @tmpRatingVal,
        @RtDesc = @tmpRatingDesc

      SET @COUNT = @COUNT + 1
  END

go

-- Insert into Supplier Table
go

WITH suppcte (statename, cityname, zip, rownum)
     AS (SELECT a.statename,
                a.cityname,
                a.zip,
                Row_number()
                  OVER (
                    ORDER BY statename, cityname) RowNum
         FROM   (SELECT cz.statename,
                        cz.cityname,
                        cz.zip,
                        Row_number()
                          OVER (
                            partition BY statename
                            ORDER BY cityname) AS RowNum
                 FROM   customer_build.dbo.tblcity_state_zip cz) a
         WHERE  a.rownum < 11)
INSERT INTO supplier
            (suppliername,
             onboardingdate,
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
             lastupdateui,
             supplierestablishmentdate)
SELECT TOP 1900 bn.businessname,
                '01-Jan-2010',
                C.customerphonenumber,
                C.customerphonenumber,
                bn.emailcom,
                C.custaddress,
                sc.cityname,
                sc.statename,
                C.custcountry,
                sc.zip,
                Sysdatetime(),
                'insSupplier',
                Sysdatetime(),
                'insSupplier',
                C.custdob
FROM   customer C
       JOIN suppcte sc
         ON C.custid = sc.rownum
       JOIN customer_build.dbo.businessname bn
         ON bn.businessnameid = C.custid 


-- Insert into Delivery_Partner Table
WITH delcte (statename, cityname, zip, rownum)
     AS (SELECT a.statename,
                a.cityname,
                a.zip,
                Row_number()
                  OVER (
                    ORDER BY statename, cityname) RowNum
         FROM   (SELECT cz.statename,
                        cz.cityname,
                        cz.zip,
                        Row_number()
                          OVER (
                            partition BY statename
                            ORDER BY cityname) AS RowNum
                 FROM   customer_build.dbo.tblcity_state_zip cz) a
         WHERE  a.rownum < 11)
INSERT INTO delivery_partner
            (deliverypartnername,
             deliverypartneronboardingdate,
             deliverypartnerprimarycontact,
             deliverypartnersecondarycontact,
             deliverypartneremail,
             deliverypartneraddress,
             deliverypartnercity,
             deliverypartnerstate,
             deliverypartnercountry,
             deliverypartnerzipcode,
             createtimestamp,
             createui,
             lastupdatetimestamp,
             lastupdateui,
             deliverypartnerestdate)
SELECT TOP 1900 bn.businessname,
                '01-Jan-2010',
                C.customerphonenumber,
                C.customerphonenumber,
                bn.emailcom,
                C.custaddress,
                sc.cityname,
                sc.statename,
                C.custcountry,
                sc.zip,
                Sysdatetime(),
                'insDeliveryPartner',
                Sysdatetime(),
                'insDeliveryPartner',
                C.custdob
FROM   customer C
       JOIN delcte sc
         ON C.custid = sc.rownum
       JOIN customer_build.dbo.businessname bn
         ON bn.businessnameid = C.custid 


-- Insert into Product Supplier Using Synthetic Transaction (Not including values that will fail the check constraint)
CREATE PROCEDURE Prdsuppwrapper @Run INT
AS
    DECLARE @SName VARCHAR(50)
    DECLARE @SEmail VARCHAR(50)
    DECLARE @ProdName VARCHAR(50)
    DECLARE @OPlcDate DATE
    DECLARE @ODelDate DATE
    DECLARE @PrdQuant INT
    DECLARE @ProdCnt INT = (SELECT Count(*)
       FROM   product)
    DECLARE @SupCnt INT = (SELECT Count(*)
       FROM   supplier)
    DECLARE @SuppPK INT
    DECLARE @PrdPK INT
    DECLARE @Rand INT

    WHILE @Run > 0
      BEGIN
          SET @SuppPK = (SELECT Ceiling(@SupCnt * Rand()))
          SET @PrdPK = (SELECT Ceiling(@ProdCnt * Rand()))

          IF @PrdPK < 1
            BEGIN
                SET @PrdPK = 2
            END

          IF @SuppPK < 1
            BEGIN
                SET @SuppPK = 2
            END

          SET @SName = (SELECT S.suppliername
                        FROM   supplier S
                        WHERE  S.supplierid = @SuppPK)
          SET @SEmail = (SELECT S.supplieremail
                         FROM   supplier S
                         WHERE  S.supplierid = @SuppPK)
          SET @ProdName = (SELECT P.productname
                           FROM   product P
                           WHERE  P.productid = @PrdPK)
          SET @OPlcDate = (SELECT Getdate() - 2)
          SET @ODelDate = (SELECT Getdate())
          SET @PrdQuant = (SELECT 45 * Rand())

          EXEC Insproductsupplier
            @SuppName = @SName,
            @SuppEmail = @SEmail,
            @PrdName = @ProdName,
            @OrdPlaceDt = @OPlcDate,
            @OrdDelDt = @ODelDate,
            @ProdQuantity = @PrdQuant

          SET @Run = @Run - 1
      END

go

EXEC Prdsuppwrapper
  @Run = 500

go

SELECT *
FROM   product_supplier
ORDER  BY productsupplierid DESC

go 

-- Insert for tblLineItems and tblOrder using synthetic transaction (Since we are randomising items for testing and check constraints are in place
-- there might be scenarios where the row is not inserted in the lineItem table. This can be ignored for testing purposes.)
go

CREATE PROCEDURE Prdordwrapper @Run INT
AS
    DECLARE @CFName VARCHAR(75)
    DECLARE @CLName VARCHAR(75)
    DECLARE @CDOB DATE
    DECLARE @OTotal NUMERIC(8, 2) = 0
    DECLARE @ODate DATETIME
    DECLARE @PName VARCHAR(50)
    DECLARE @PrdId INT
    DECLARE @Quant INT
    DECLARE @prdPrice NUMERIC(8, 2)
    DECLARE @prdList TABLE
      (
         lstid           INT IDENTITY(1, 1) NOT NULL,
         productname     VARCHAR(50),
         productquantity INT,
         productprice    NUMERIC(8, 2)
      )
    DECLARE @CustCnt INT = (SELECT Count(*)
       FROM   supplier)
    DECLARE @CustPK INT
    DECLARE @PrdCnt INT = (SELECT Count(*)
       FROM   product)
    DECLARE @PrdPK INT
    DECLARE @Rand INT

    WHILE @Run > 0
      BEGIN
          DECLARE @NumProdForCust INT = (SELECT Ceiling(Rand() * 10))

          SET @CustPK = (SELECT Ceiling(@CustCnt * Rand()))

          IF @CustPK < 1
            BEGIN
                SET @CustPK = 2
            END

          SELECT @CFName = C.custfname,
                 @CLName = C.custlname,
                 @CDOB = C.custdob
          FROM   customer C
          WHERE  C.custid = @CustPK

          WHILE @NumProdForCust > 0
            BEGIN
                SET @PrdPK = (SELECT Ceiling(@PrdCnt * Rand()))

                IF @PrdPK < 1
                  BEGIN
                      SET @PrdPK = 2
                  END

                SET @PName = (SELECT productname
                              FROM   product P
                              WHERE  P.productid = @PrdPK)
                SET @Quant = (SELECT Ceiling(Rand() * 5))
                SET @prdPrice = (SELECT pr.price
                                 FROM   product pr
                                 WHERE  pr.productid = @PrdPK)

                IF NOT EXISTS(SELECT *
                              FROM   @prdList pr
                              WHERE  pr.productname = @PName)
                  BEGIN
                      INSERT INTO @prdList
                      VALUES      (@PName,
                                   @Quant,
                                   @prdPrice)

                      SET @OTotal = @OTotal + ( @Quant * @prdPrice )
                  END

                SET @NumProdForCust = @NumProdForCust - 1
            END

          SET @ODate = (SELECT Getdate() - Cast(Rand() * 100 AS INT))

          EXEC Instblorder
            @CustFName = @CFName,
            @CustLName = @CLName,
            @CustBirthDate = @CDOB,
            @OrderDate = @ODate,
            @OrderTotal = @OTotal

          DECLARE @OID INT = (SELECT Max(O.orderid)
             FROM   tblorder O)
          DECLARE @prodForOrd INT = (SELECT Max(lstid)
             FROM   @prdList)
          DECLARE @Cnt INT = (SELECT Min(lstid)
             FROM   @prdList)

          WHILE @Cnt <= @prodForOrd
            BEGIN
                SELECT @PName = a.productname,
                       @Quant = a.productquantity
                FROM   @prdList a
                WHERE  a.lstid = @Cnt

                EXEC Inslineitem
                  @OrdID = @OID,
                  @PrdName = @PName,
                  @Qty = @Quant

                DELETE FROM @prdList
                WHERE  lstid = @Cnt

                SET @Cnt = @Cnt + 1
            END

          SET @Run = @Run - 1
      END

go

EXEC Prdordwrapper
  @RUN = 5

go 

-- Insert into Reviews Table

--196
EXEC Insreviews
  @CustFname = 'Lucile',
  @CustLname = 'Prester',
  @CustDOB = '1977-08-21',
  @Order_ID = 2,
  @ProdName = 'Bicycle',
  @RatingName = 3,
  @ReviewText = 'The seat could have been better' 

--317
EXEC Insreviews
  @CustFname = 'Chelsea',
  @CustLname = 'Bose',
  @CustDOB = '1976-01-19',
  @Order_ID = 1,
  @ProdName = 'Lego',
  @RatingName = 4,
  @ReviewText =
  'Great. I really liked it. I bought it for my children and they loved it.'

-- Insert into Shipment
EXEC Insshipment
  @OrdID = 1,
  @PrdName = 'Lego'

EXEC Insshipment
  @OrdID = 2,
  @PrdName = 'Bicycle' 

-- Insert into Payment Table
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


-- Insert into Payment_Processing
EXEC Inspaymentprocessing
  @PaymentStatusName = 'Payment Initiated',
  @OrderID = 1

EXEC Inspaymentprocessing
  @PaymentStatusName = 'Payment Pending Approval',
  @OrderID = 1

EXEC Inspaymentprocessing
  @PaymentStatusName = 'Payment Approved',
  @OrderID = 1 

-- Insert into Shipment_Status
EXEC Insshipmentstatus
  @OrdID = 1,
  @PrdName = 'Lego',
  @OrdStat = 'Created'

EXEC Insshipmentstatus
  @OrdID = 1,
  @PrdName = 'Lego',
  @OrdStat = 'Processing'

EXEC Insshipmentstatus
  @OrdID = 1,
  @PrdName = 'Lego',
  @OrdStat = 'Picked-Up' 

