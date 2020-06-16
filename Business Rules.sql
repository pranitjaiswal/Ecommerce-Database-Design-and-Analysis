USE info430_group1_project

-- If Customer is Below 18 cannot order Adult Movies - LineItems Table
go

CREATE FUNCTION Customerageadultmovies()
returns INT
AS
  BEGIN
      DECLARE @Ret INT = 0

      IF EXISTS(SELECT *
                FROM   customer c
                       JOIN tblorder o
                         ON c.custid = o.custid
                       JOIN lineitems l
                         ON l.orderid = o.orderid
                       JOIN product p
                         ON p.productid = l.productid
                       JOIN product_type pt
                         ON pt.producttypeid = p.producttypeid
                WHERE  pt.producttypename IN ( 'Adult Movies', 'Cannabis' )
                       AND c.custdob >= ( Getdate() - ( 365.25 * 18 ) ))
        BEGIN
            SET @Ret = 1
        END

      RETURN @Ret
  END

go

ALTER TABLE lineitems
  ADD CONSTRAINT ck_customerageadultmovies CHECK(dbo.Customerageadultmovies() =
  0)

-- A customer cannot write more than one review for the same  product and order combination - Review Table
go

CREATE FUNCTION Reviewproductordercomb(@Cust_id INT,
                                       @LT_ID   INT)
returns INT
AS
  BEGIN
      DECLARE @Ret INT = 0
      DECLARE @RevCnt INT = (SELECT Count(*)
         FROM   customer c
                JOIN tblorder o
                  ON c.custid = o.custid
                JOIN lineitems l
                  ON l.orderid = o.orderid
                JOIN product p
                  ON p.productid = l.productid
                JOIN reviews r
                  ON r.lineitemid = l.lineitemid
         WHERE  c.custid = @Cust_id
                AND l.lineitemid = @LT_ID)

      IF @RevCnt > 1
        BEGIN
            SET @Ret = 1
        END

      RETURN @Ret
  END

go

ALTER TABLE reviews
  ADD CONSTRAINT ck_reviewproductordercomb
  CHECK(dbo.Reviewproductordercomb(custid, lineitemid) = 0)

-- Payment type cannot be COD if customer total order is less than 35$- Payment Table
go

CREATE FUNCTION Codordertotal()
returns INT
AS
  BEGIN
      DECLARE @Ret INT = 0

      IF EXISTS(SELECT *
                FROM   tblorder o
                       JOIN payment p
                         ON o.orderid = p.orderid
                       JOIN payment_type pt
                         ON pt.paymenttypeid = p.paymenttypeid
                WHERE  paymenttypename = 'COD'
                       AND ordertotal < 35)
        BEGIN
            SET @Ret = 1
        END

      RETURN @Ret
  END

go

ALTER TABLE payment
  ADD CONSTRAINT ck_codordertotal CHECK(dbo.Codordertotal() = 0)

-- Function to restrict price change to one per day
go

CREATE FUNCTION Onlyonepricechangeperday(@ProdID INT)
returns INT
AS
  BEGIN
      DECLARE @RET INT = 0
      DECLARE @RCnt INT = (SELECT Count(*)
         FROM   price_history ph
         WHERE  ph.productid = @ProdID
                AND Cast(ph.pricingtimestamp AS DATE) = Cast(Getdate() AS DATE))

      IF @RCnt > 1
        BEGIN
            SET @RET = 1
        END

      RETURN @RET
  END

go

ALTER TABLE price_history
  ADD CONSTRAINT ck_onlyonepricechangeperday CHECK
  (dbo.Onlyonepricechangeperday(productid) = 0)

go

-- Function to restrict purchase of quantity more than 50 to sellers from washington and texas
CREATE FUNCTION Bulkorderfromtaxfreestates()
returns INT
AS
  BEGIN
      DECLARE @RET INT = 0

      IF EXISTS(SELECT *
                FROM   product_supplier PS
                       JOIN supplier S
                         ON PS.supplierid = S.supplierid
                WHERE  PS.productquantity > 50
                       AND S.supplierstate NOT IN ( 'Washington', 'Texas' ))
        BEGIN
            SET @RET = 1
        END

      RETURN @RET
  END

go

ALTER TABLE product_supplier
  ADD CONSTRAINT ck_bulkorderfromtaxfreestates CHECK
  (dbo.Bulkorderfromtaxfreestates() = 0)

-- Customers from certain states cannot order products under product type such as cannabis and Exclusive- line item
go

CREATE FUNCTION Products_in_certain_states()
returns INT
AS
  BEGIN
      DECLARE @Ret INT = 0

      IF EXISTS (SELECT *
                 FROM   customer C
                        JOIN tblorder O
                          ON O.custid = C.custid
                        JOIN lineitems LI
                          ON LI.orderid = O.orderid
                        JOIN product P
                          ON P.productid = LI.productid
                        JOIN product_type PT
                          ON PT.producttypeid = P.producttypeid
                 WHERE  C.custstate NOT IN ( 'Washington', 'California' )
                        AND PT.producttypename IN ( 'Cannabis', 'Exclusive' ))
        BEGIN
            SET @Ret = 1
        END

      RETURN @Ret
  END

go

ALTER TABLE lineitems
  ADD CONSTRAINT only_certain_states_can_order_exclusive CHECK
  (dbo.Products_in_certain_states() = 0)

-- Cannot order more than 300 quantity for Product Type Cannabis from Supplier- line item
go

CREATE FUNCTION More_than_300 ()
returns INT
AS
  BEGIN
      DECLARE @Ret INT = 0

      IF EXISTS (SELECT *
                 FROM   product_type PT
                        JOIN product P
                          ON PT.producttypeid = P.producttypeid
                        JOIN product_supplier PS
                          ON PS.productid = P.productid
                 WHERE  PT.producttypename = 'Cannabis'
                        AND PS.productquantity > 300)
        BEGIN
            SET @Ret = 1
        END

      RETURN @Ret
  END

go

ALTER TABLE product_supplier
  ADD CONSTRAINT more_than_300_cannabis CHECK (dbo.More_than_300()=0)
-- As discussed in the Presentation, the last business rule 'Delivery partner can only be from the same state as the customer' is implemented
-- inside the insert procedure of Shipment to avoid frequent failures of insert statements into Shipment