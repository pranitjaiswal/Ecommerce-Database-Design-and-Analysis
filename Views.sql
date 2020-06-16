USE info430_group1_project

-- Top Suppliers
go

CREATE VIEW top_suppliers
AS
  SELECT S.supplierid,
         S.suppliername,
         Count(DISTINCT O.orderid)                    AS OrderCount,
         Dense_rank()
           OVER (
             ORDER BY Count(DISTINCT O.orderid) DESC) AS SupplierRank
  FROM   supplier S
         JOIN product_supplier PS
           ON S.supplierid = PS.supplierid
         JOIN product P
           ON P.productid = PS.productid
         JOIN lineitems LI
           ON LI.productid = P.productid
         JOIN tblorder O
           ON O.orderid = LI.orderid
  GROUP  BY S.supplierid,
            S.suppliername

go

--	Top Customers
CREATE VIEW top_customer
AS
  SELECT C.custid,
         C.custfname,
         C.custlname,
         Count(DISTINCT PT.producttypename)                    AS Cnt,
         Dense_rank()
           OVER(
             ORDER BY Count(DISTINCT PT.producttypename) DESC) AS Rankk
  FROM   customer C
         JOIN tblorder O
           ON C.custid = O.custid
         JOIN lineitems LI
           ON LI.orderid = O.orderid
         JOIN product P
           ON P.productid = LI.productid
         JOIN product_type PT
           ON PT.producttypeid = P.producttypeid
  GROUP  BY C.custid,
            C.custfname,
            C.custlname

go

-- Cities having max orders in pending
CREATE VIEW cities_having_orders_in_processing
AS
  SELECT C.custstate,
         S.deliverypartnerid,
         C.custid,
         Count(OS.orderstatusname)                    AS Cnt,
         Dense_rank()
           OVER (
             ORDER BY Count(OS.orderstatusname) DESC) AS Rankk
  FROM   customer C
         JOIN tblorder O
           ON C.custid = O.custid
         JOIN lineitems LI
           ON LI.orderid = O.orderid
         JOIN shipment S
           ON LI.lineitemid = S.lineitemid
         JOIN shipment_status SS
           ON SS.shipmentid = S.shipmentid
         JOIN order_status OS
           ON OS.orderstatusid = SS.orderstatusid
  WHERE  OS.orderstatusname = 'Processing'
  GROUP  BY C.custstate,
            S.deliverypartnerid,
            C.custid

go

-- Top product types
CREATE VIEW top_pdt_types
AS
  SELECT TOP 10 pt.producttypename,
                p.productid,
                p.productname,
                Sum(p.price * quantity) AS Total_Sold
  FROM   product_type pt
         JOIN product p
           ON pt.producttypeid = p.producttypeid
         JOIN lineitems l
           ON l.productid = p.productid
  GROUP  BY pt.producttypename,
            p.productid,
            p.productname
  ORDER  BY total_sold DESC

go

-- Top rated product types
CREATE VIEW top_rated_pdt_types
AS
  SELECT TOP 10 pt.producttypename,
                p.productid,
                Avg(ra.ratingname) AS Avg_Rating
  FROM   product_type pt
         JOIN product p
           ON pt.producttypeid = p.producttypeid
         JOIN lineitems l
           ON l.productid = p.productid
         JOIN reviews r
           ON r.lineitemid = l.lineitemid
         JOIN ratings ra
           ON ra.ratingid = r.ratingid
  GROUP  BY pt.producttypename,
            p.productid
  ORDER  BY avg_rating DESC

-- Top Product Suppliers bu product quantity
CREATE VIEW top_pdt_sup
AS
  SELECT TOP 10 s.suppliername,
                pt.producttypeid,
                pt.producttypename,
                p.productid,
                p.productname,
                Sum(ps.productquantity) AS Total_Quantity_Ordered
  FROM   product_type pt
         JOIN product p
           ON pt.producttypeid = p.producttypeid
         JOIN lineitems l
           ON l.productid = p.productid
         JOIN product_supplier ps
           ON ps.productid = p.productid
         JOIN supplier s
           ON s.supplierid = ps.supplierid
  GROUP  BY s.suppliername,
            pt.producttypeid,
            pt.producttypename,
            p.productid,
            p.productname
  ORDER  BY total_quantity_ordered DESC

go

-- No. of orders as per status
CREATE VIEW orders_per_status
AS
  SELECT os.orderstatusname,
         Count(o.orderid) Num_of_Order
  FROM   tblorder o
         JOIN lineitems l
           ON o.orderid = l.orderid
         JOIN shipment s
           ON l.lineitemid = s.lineitemid
         JOIN shipment_status ss
           ON ss.shipmentid = s.shipmentid
         JOIN order_status os
           ON os.orderstatusid = ss.orderstatusid
  GROUP  BY os.orderstatusname

go

SELECT *
FROM   orders_per_status

-- Sales over region (state)
CREATE VIEW sales_over_region
AS
  SELECT c.custstate,
         Sum(o.ordertotal) AS Total_in_State
  FROM   customer c
         JOIN tblorder o
           ON c.custid = o.custid
  GROUP  BY c.custstate

go 