
/*http://www.artfulsoftware.com/infotree/queries.php */
/*http://stratosprovatopoulos.com/web-development/mysql/pivot-a-table-in-mysql*/
########### Customer Order Sold Report ####################

SELECT
sku.LineCol, sku.Style, item.ColourCode, sku.Colour,
sku.BrandName, sku.Season,
item.SKU, item.Article,
sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Tiems_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 
avg(item.SellPrice) as Average_Sold_Price,
customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,
head.RSN, head.AcCode, head.Status, head.CreateDate

FROM item join head join customer join sku 

ON item.CustOrderRSN_ID = head.Id 
AND item.sku_id = sku.Id 
AND head.Customer_Id = customer.Id 

AND cus_code = 'BA004A' 

GROUP BY SKU 
ORDER BY SKU DESC

################ CUSTOMER REPORT BY ORDER BY RSN ###############
SELECT
	sku.LineCol, sku.Style, sku.Colour,
    sum(item.TotalQty),
	customer.cus_code, customer.Name,
	head.RSN, head.OrderNum, head.AcCode, head.Status, head.CreateDate,
	item.SKU, item.Article, item.ColourCode, item.SellPrice
FROM
	item join head join customer join sku
ON
	item.CustOrderRSN_ID = head.Id
AND
	head.customer_Id = customer.id
And
	item.sku_id = sku.Id

WHERE RSN IN (169751, 169752, 169801)
GROUP BY SKU
ORDER BY SKU DESC

################ CUSTOMER REPORT BY ORDER 1.1 ###############

SELECT
	sku.LineCol, sku.Style, item.ColourCode as Col_Code, sku.Colour,
	sku.BrandName as Brand, sku.Season,
	sum(item.TotalQty) as Total_Qty_Sold,
    max(item.SellPrice) as Last_Sold_Price, 
	item.BuyPrice as Landed_Cost_GBP,
    sku.Collection, item.Article, 
	customer.Cus_Code as Customer_Code, customer.Name as Customer_Name, 
	head.RSN, head.AcCode, head.Status, head.CreateDate as Order_Raised_Date,
    item.SKU

FROM
	item join head join customer join sku
ON
	item.CustOrderRSN_ID = head.Id
AND
	head.customer_Id = customer.id
And
	item.sku_id = sku.Id

WHERE RSN IN (169710)

GROUP BY SKU
ORDER BY SKU DESC

################## Stock_ List _By _Barcode #########################
SELECT
	mastersku.Barcode_13 as Barcode ,
    sku.LineCol, sku.Style,
    torque_stock.SKU_ID,
    /*colcode.Col_Code,*/
    torque_stock.COLOUR, torque_stock.SKU_SIZE as Size,
	torque_stock.AVAILABLE as Avilable_Stock, torque_stock.New_Season as Carry_Over_Season, 
    sku.BrandName, sku.Season,
    sku.Collection, sku.Article, sku.Origin,
    torque_stock.QTY_ON_HAND as Stock_IN_Hand
FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
    
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

###################### Stock_ List _By Line Col and Count 1.0  with out FAb com #####################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.BrandName, sku.Season,
    torque_stock.New_Season as Carry_Over_Season,
     /*colcode.Col_Code, */
	sum(torque_stock.AVAILABLE) as Avialable_Stock,
    count(mastersku.SKU_Id) as Sizes_Avilable,
	sku.RRPGBP, sku.RRPEuro, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
    mastersku.SKU_Id

FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
    
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

##################################################################################

###################### Stock_ List _By Line Col and Count 1.1  with FAB_Com FOR REPORT_STOCK #####################

SELECT
	sku.SKU, sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName,
    colcode.Col_Code,
	sum(torque_stock.AVAILABLE) as Avilable_Stock, 
    mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Count,
    sku.FabCom, sku.WashCare,sku.Collection,
	sku.Article, sku.Origin, sku.Brand,
    sum(torque_stock.QTY_ON_HAND) as Stock_In_Hand
FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
   
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

##################################################################################

################## Stock_ List _By _Single _Brand_Season  ############################

SELECT
	sku.LineCol, sku.Style, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
    sku.Colour,
    colcode.Col_Code,
	sum(torque_stock.AVAILABLE) as Avialable_Stock , sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
    mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
AND
	sku.Season = 'SS19'
AND
	sku.Brand = 'Yumi'

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

################## Stock_ List _By Single _Brand_Season Stock Size >10 ############################

SELECT
	sku.LineCol, sku.Style, sku.Season, sku.BrandName, sku.Collection,
	sku.Colour,
    colcode.Col_Code,
	sum(torque_stock.AVAILABLE) as Avialable_Stock, 
    mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable,
    sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
    sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock
FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
AND
	sku.Season = 'SS19'
AND
	sku.Brand = 'Yumi'
AND
	torque_stock.AVAILABLE > '0'

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC


##################Stock_ List _By _Brand_Season Stock Size < 3 yumi All ############################

SELECT
	sku.LineCol, sku.Style, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
    sku.Colour,
    colcode.Col_Code,
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
    mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id

AND
	sku.Brand = 'Yumi'
AND
	torque_stock.AVAILABLE > '3'

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

################### Stock List By Brand  Specific ###########################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Brand,
	sum(torque_stock.AVAILABLE) as Avialable_Stock, 
	count(mastersku.SKU_Id) as Sizes_Avilable,
    sku.Collection, sku.Article, sku.Origin, sku.FabCom, sku.WashCare,
    sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
    mastersku.SKU_Id
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id 

WHERE
	(BrandName = 'YUMI') OR
    (BrandName = 'YUMI RETAIL') OR
    (BrandName = 'YUMI-RETAIL') OR
    (BrandName = 'Y by Yumi') OR
    (BrandName = 'YUMI ORIGINAL')
    
    /* (BrandName = 'YUMI GIRLS') OR */
    /* (BrandName = 'YUMI Curves') OR */
    /* (BrandName = 'ISKA') */
    

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

##############################################

################### Stock List By Brand  and  by one Season Specific ###########################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE > '3'
AND
	sku.Season = 'SS19'
    
WHERE
	(BrandName = 'YUMI') OR
    (BrandName = 'YUMI RETAIL') OR
    (BrandName = 'YUMI-RETAIL')
    
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

################### Stock list by Season Specific  ###########################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE > '3'

WHERE
	(Season = 'SS19') OR
    (Season = 'SS18')
    
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

################### test 1.2  BRAND and SEASON Multiple   ###########################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE > '3'
    
WHERE sku.BrandName IN ('YUMI','YUMI RETAIL', 'YUMI-RETAIL' ) AND sku.Season IN ('SS19','SS18','SS17')

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

///////////////////////////////////////  Yumi All Season ////////////////////////////////

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE > '1'
    
WHERE sku.Brand IN ('Yumi') AND sku.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'AW19', 'IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19',' SS20', 'Missing')

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

///////////////////////////////////////   All Season YUMI, Yumi Curve, Girls, ACCESSORIES  <3 ////////////////////////////////

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, 
	sum(torque_stock.AVAILABLE) as Avialable_Stock, 
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable,
    sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
    sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock
	
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE > '0'

WHERE sku.Brand IN ('Yumi', 'Yumi Curves', 'Yumi Girls' , 'ISKA') AND 
sku.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'AW19', 'IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19', 'SS20', 
'Missing')

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC

///////////////////////////////////////   All Season all BRand <3 ////////////////////////////////

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.RRPGBP, sku.RRPEuro, sku.Season, sku.BrandName, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	
	sum(torque_stock.AVAILABLE) as Avialable_Stock, sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
	mastersku.SKU_Id,
	count(mastersku.SKU_Id) as Sizes_Avilable
FROM
	torque_stock join sku join mastersku
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.AVAILABLE < '3'

WHERE sku.Brand IN ('Yumi','Iska', 'Mela', 'Mela Curve', 'UTTAM BOUTIQUE', 'Yumi Curves') AND 
sku.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19', 'Missing')

GROUP BY SKU_ID 
ORDER BY SKU_ID DESC



/*/////////////////////////////// By Customer Report form stock list //////////////*/

SELECT

report_stock.LineCol, report_stock.SKU, report_stock.Colour, report_stock.Col_Code,
report_stock.BrandName, report_stock.Avilable_Stock,

sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Times_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 

customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,

head.RSN, head.AcCode, head.Status,

sku.Collection, sku.Article,
sku.FabCom, sku.WashCare, sku.Origin,

report_stock.Stock_In_Hand

FROM item join head join customer join report_stock Join sku

ON
	item.sku_id = sku.Id
And 
	report_stock.SKU_Id = item.sku_id 
And 
	item.CustOrderRSN_ID = head.Id 
AND 
	head.Customer_Id = customer.Id 
AND
	report_stock.Avilable_Stock > '0'
AND 
	cus_code = 'SE001A' 

GROUP BY SKU 
ORDER BY SKU DESC

//////////////////////////////// end   ///////////////


/*/////////////////////////////// By Customer Report form stock list //////////////*/

SELECT
report_stock.LineCol, report_stock.SKU, report_stock.Colour, report_stock.Col_Code,
report_stock.BrandName, report_stock.Avilable_Stock,

sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Times_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 

customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,

head.RSN, head.AcCode, head.Status,

sku.Collection, sku.Article,
sku.FabCom, sku.WashCare, sku.Origin,

report_stock.Stock_In_Hand

FROM item join head join customer join report_stock Join sku

ON
	item.sku_id = sku.Id
And 
	report_stock.SKU_Id = item.sku_id 
And 
	item.CustOrderRSN_ID = head.Id 
AND 
	head.Customer_Id = customer.Id 
AND
	report_stock.Avilable_Stock > '0'
AND 
	cus_code = 'DRES4' 
    
WHERE report_stock.BrandName IN ('YUMI RETAIL','YUMI ORIGINAL', 'YUMI GIRLS RETAIL', 'YUMI GIRLS', 'Yumi Curves',
								'YUMI ACCESSORIES', 'YUMI' ,'Y by Yumi', 'UTTAM KIDS', 'ISKA', 'YUMI-RETAIL')

GROUP BY SKU 
ORDER BY SKU DESC

/*/////////////////////////////// By Customer Report form stock list //////////////*/

SELECT
report_stock.LineCol, report_stock.SKU, report_stock.Colour, report_stock.Col_Code,
report_stock.BrandName, report_stock.Avilable_Stock,

sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Times_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 

customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,

head.RSN, head.AcCode, head.Status,

sku.Collection, sku.Article,
sku.FabCom, sku.WashCare, sku.Origin,

report_stock.Stock_In_Hand

FROM item join head join customer join report_stock Join sku

ON
	item.sku_id = sku.Id
And 
	report_stock.SKU_Id = item.sku_id 
And 
	item.CustOrderRSN_ID = head.Id 
AND 
	head.Customer_Id = customer.Id 
AND
	report_stock.Avilable_Stock > '2'
AND 
	cus_code = 'ZALANL 3'
/*
WHERE report_stock.BrandName IN ('YUMI RETAIL','YUMI ORIGINAL', 'YUMI GIRLS RETAIL', 'YUMI GIRLS', 'Yumi Curves',
								'YUMI ACCESSORIES', 'YUMI' ,'Y by Yumi', 'UTTAM KIDS', 'ISKA', 'YUMI-RETAIL') AND 
*/
WHERE report_stock.BrandName IN ('ISKA', 'MELA', 'MELA LONDON') AND 
                                
report_stock.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'AW19','IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19', 'SS20','Missing')

GROUP BY SKU 
ORDER BY SKU DESC

//////////////////////////////// end   ///////////////

//////////////////////////////// By Customer but Dont use ///////////////

SELECT
sku.LineCol, sku.Style, item.ColourCode, sku.Colour,
sku.BrandName, sku.Season,
item.SKU, item.Article,
sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Tiems_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 
customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,
head.RSN, head.AcCode, head.Status, head.CreateDate,
sum(torque_stock.AVAILABLE) as Avialable_Stock,
mastersku.SKU_Id,
count(mastersku.SKU_Id) as Sizes_Avilable,
sku.FabCom, sku.WashCare

FROM item join head join customer join sku join torque_stock join mastersku

ON
	torque_stock.SKUSize_Id = mastersku.Id
And 
	item.CustOrderRSN_ID = head.Id 
AND 
	item.sku_id = sku.Id 
AND 
	head.Customer_Id = customer.Id 
AND
	mastersku.SKU_Id = sku.id
AND
	torque_stock.QTY_ON_HAND > '1'
AND 
	cus_code = 'ZALANL 3' 

GROUP BY SKU 
ORDER BY SKU DESC

//////////////////////////////// end   ///////////////

###################### Stock_ List _By Line Col and Count 1.0  with out FAb com #####################

SELECT
	sku.LineCol, sku.Style, sku.Colour, sku.BrandName, sku.Season,
    torque_stock.New_Season as Carry_Over_Season,
     /*colcode.Col_Code, */
	 /*sum(torque_stock.AVAILABLE) as Avialable_Stock, */
     
    sum(torque_stock.NEW_SEASON),
    
	sku.RRPGBP, sku.RRPEuro, sku.Collection,
	sku.Article, sku.Origin, sku.Brand, sku.FabCom, sku.WashCare,
	sum(torque_stock.QTY_ON_HAND) as In_Hand_Stock,
    mastersku.SKU_Id

FROM
	torque_stock join sku join mastersku join colcode
ON
	torque_stock.SKUSize_Id = mastersku.Id
AND
	mastersku.SKU_Id = sku.id
AND
   colcode.SKU_Id = sku.id
    
GROUP BY SKU_ID 
ORDER BY SKU_ID DESC


//////////////////////////////// end   ///////////////

//////////////////////////////// Pivot  ///////////////

create view report_stock_Extended_AW17 as (
  select
    report_stock.BrandName,
    case when Season = "SS19" then Avilable_Stock end as SS19,
    case when Season = "SS18" then Avilable_Stock end as SS18,
    case when Season = "SS17" then Avilable_Stock end as SS17,
    case when Season = "AW19" then Avilable_Stock end as AW19,
    case when Season = "AW18" then Avilable_Stock end as AW18,
    case when Season = "AW17" then Avilable_Stock end as AW17
   
  from report_stock
);

create view report_stock_Extended_Pivot_AW17 as (
  select
    BrandName,
    sum(SS19) as SS19,
    sum(SS18) as SS18,
    sum(SS17) as SS17,
	sum(AW19) as AW19,
    sum(AW18) as AW18,
    sum(AW17) as AW17
  from report_stock_Extended_Aw17
  group by BrandName
);

create view report_stock_Extended_Pivot_Pretty_AW17 as (
  select 
    BrandName, 
    coalesce(SS19, 0) as SS19, 
    coalesce(SS18, 0) as SS18, 
    coalesce(SS17, 0) as SS17,
	coalesce(AW19, 0) as AW19, 
    coalesce(AW18, 0) as AW18, 
    coalesce(AW17, 0) as AW17
  from report_stock_Extended_Pivot_AW17
);

/*/////////////////////////////// end   //////////////*/

create view report_stock_Extended_SS19 as (
  select
    report_stock.BrandName,
    case when Season = "SS19" then Avilable_Stock end as SS19
    from report_stock
);

create view report_stock_Extended_Pivot_SS19 as (
  select
    BrandName,
    sum(SS19) as SS19
    from report_stock_Extended
  group by BrandName
);

create view report_stock_Extended_Pivot_Pretty_SS19 as (
  select 
    BrandName, 
    coalesce(SS19, 0) as SS19
    from report_stock_Extended_Pivot
);

/*/////////////////////////////// end   //////////////*/

########### Customer Order Sold Report_ for _Offer ####################

SELECT
sku.LineCol, sku.Style, item.ColourCode, sku.Colour,
sku.BrandName, sku.Season,
item.sku_id,
min(item.SellPrice) as Lowest_Sold_Price,
sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Tiems_Sold,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 
customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,
head.Status,
item.Article

FROM item join head join customer join sku 

ON item.CustOrderRSN_ID = head.Id 
AND item.sku_id = sku.Id 
AND head.Customer_Id = customer.Id 

AND cus_code = 'DRES4' 

GROUP BY sku_id 
ORDER BY sku_id DESC

/*/////////////////////////////// end   //////////////*/

########### Customer Order Sold Report by Customer ####################

SELECT
report_stock.LineCol, report_stock.Style, report_stock.Colour,
report_stock.BrandName, report_stock.Season, report_stock.RRPGBP,
report_stock.RRPEuro, report_stock.Avilable_Stock, report_stock.Count,
report_stock.Collection, report_stock.Article,

customer_report_stock.Lowest_Sold_Price, customer_report_stock.Total_Qty_Sold,
customer_report_stock.Tiems_Sold, customer_report_stock.Max_Sold_Price,
customer_report_stock.Customer_Code,

sku.Origin, sku.FabCom, sku.WashCare

FROM customer_report_stock join report_stock join sku

ON report_stock.SKU_Id = sku.Id

AND customer_report_stock.Report_Stock_Id = report_stock.Id

GROUP BY LineCol 
ORDER BY LineCol

/*/////////////////////////////// end   //////////////*/

########### Customer Order Sold Report by Customer _1.0 ####################

SELECT
report_stock.LineCol, report_stock.Style, report_stock.Colour,
report_stock.BrandName, report_stock.Season, report_stock.RRPGBP,
report_stock.RRPEuro, report_stock.Avilable_Stock, report_stock.Count,
report_stock.Collection, report_stock.Article,

customer_report_stock.Lowest_Sold_Price, customer_report_stock.Total_Qty_Sold,
customer_report_stock.Tiems_Sold, customer_report_stock.Max_Sold_Price,
customer_report_stock.Customer_Code,

sku.Origin, sku.FabCom, sku.WashCare

FROM 
	customer_report_stock join report_stock join sku

ON 
	customer_report_stock.Report_Stock_Id = report_stock.Id

AND 
	report_stock.SKU_Id = sku.Id

AND
	report_stock.Avilable_Stock > '10'

/*
WHERE report_stock.BrandName IN ('YUMI RETAIL','YUMI ORIGINAL', 'YUMI GIRLS RETAIL', 'YUMI GIRLS', 'Yumi Curves',
								'YUMI ACCESSORIES', 'YUMI' ,'Y by Yumi', 'UTTAM KIDS', 'ISKA', 'YUMI-RETAIL') AND 
*/
WHERE report_stock.BrandName IN ('ISKA', 'MELA', 'MELA LONDON', 'Yumi') AND 
                                
report_stock.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'AW19','IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19', 'SS20','Missing')

GROUP BY LineCol 
ORDER BY LineCol

/*/////////////////////////////// end   //////////////*/

//////////// OUTER jOIN ////////////////////////////

/* select t1.Product, t1.Quantity, t2.Cost */

SELECT

t1.SKU, t1.LineCol, t1.Style, t1.Colour,
t1.BrandName, t1.Season, t1.RRPGBP,
t1.RRPEuro, t1.Avilable_Stock, t1.Count,
t1.Collection, t1.Article,
t2.Total_Qty_Sold,
t2.Lowest_Sold_Price,
t2.Landed_Cost_GBP,
t2.Tiems_Sold,
t2.Customer_Code

/*
report_stock.SKU, report_stock.LineCol, report_stock.Style, report_stock.Colour,
report_stock.BrandName, report_stock.Season, report_stock.RRPGBP,
report_stock.RRPEuro, report_stock.Avilable_Stock, report_stock.Count,
report_stock.Collection, report_stock.Article,
customer_report_stock.Total_Qty_Sold

*/

/* from table1 as t1 */

FROM report_stock as t1

/* left join table2 as t2 */

LEFT OUTER JOIN customer_report_stock as t2

    /* on t1.Product = t2.Product */

ON t1.LineCol = t2.LineCol

GROUP BY LineCol 
ORDER BY LineCol

/*/////////////////////////////// end   //////////////*/

//////////// OUTER JOIN 1.1 ////////////////////////////

SELECT
t1.SKU, t1.LineCol, t1.Style, t1.Colour,
t1.BrandName, t1.Season, t1.RRPGBP,
t1.RRPEuro, t1.Avilable_Stock, t1.Count,
t1.Collection, t1.Article,
t2.Total_Qty_Sold,
t2.Lowest_Sold_Price,
t2.Landed_Cost_GBP,
t2.Tiems_Sold,
t2.Customer_Code,
t3.FabCom,
t3.WashCare,
t3.Origin

FROM report_stock as t1

LEFT OUTER JOIN customer_report_stock as t2

ON (t1.LineCol = t2.LineCol)
    
LEFT OUTER JOIN sku as t3

ON (t1.LineCol = t3.LineCol)

WHERE t1.Avilable_Stock > '2' AND

t1.BrandName IN ('Yumi', 'YUMI RETAIL', 'Y by Yumi', 'YUMI ORIGINAL', 'YUMI-RETAIL', 
				 'Yumi Curves', '
                 YUMI GIRLS RETAIL', 'YUMI GIRLS') 

AND

t1.Season IN ('AW11', 'AW12', 'AW13', 'AW14', 'AW15', 'AW16', 'AW17', 'AW18', 'AW19', 'IW15',
			  'PD15' 'PD16', 'PD17', 'PD18', 'PD19','SS13', 'SS14', 'SS15', 'SS16', 'SS17',
              'SS18', 'SS19','SS20')

GROUP BY LineCol 
ORDER BY LineCol

/*/////////////////////////////// end   //////////////*/

//////////////////////////////// Pivot_SIZE   ///////////////

create view torque_stock_size as (
  select
    torque_stock.SKU,
    case when COLOUR = "WHITE" then AVAILABLE end as WHITE,
	case when COLOUR = "BLACK" then AVAILABLE end as BLACK
    from torque_stock
);

/*/////////////////////////////// Pivot_SIZE   //////////////*/

create view torque_stock_by_size as (
  select
	torque_stock.SKU,
    case when SKU_SIZE = "6" then AVAILABLE end as SIX,
    case when SKU_SIZE = "8" then AVAILABLE end as EIGHT,
	case when SKU_SIZE = "10" then AVAILABLE end as TEN,
    case when SKU_SIZE = "12" then AVAILABLE end as TWELVEL,
    case when SKU_SIZE = "14" then AVAILABLE end as FOURTEEN,
    case when SKU_SIZE = "16" then AVAILABLE end as SIXTEEN,
    
    case when SKU_SIZE = "XXS" then AVAILABLE end as XXS,
    case when SKU_SIZE = "XS" then AVAILABLE end as XS,
    case when SKU_SIZE = "S" then AVAILABLE end as S,
    case when SKU_SIZE = "M" then AVAILABLE end as M,
    case when SKU_SIZE = "L" then AVAILABLE end as L,
    case when SKU_SIZE = "XL" then AVAILABLE end as XL,
    case when SKU_SIZE = "XXL" then AVAILABLE end as XXL,
    case when SKU_SIZE = "S/M" then AVAILABLE end as SM,
    case when SKU_SIZE = "M/L" then AVAILABLE end as ML,
    case when SKU_SIZE = "SM" then AVAILABLE end as SSM,
    case when SKU_SIZE = "ML" then AVAILABLE end as MML,
    
	case when SKU_SIZE = "FREE" then AVAILABLE end as Free,
    case when SKU_SIZE = "ONE" then AVAILABLE end as ONESIZE,
    
    case when SKU_SIZE = "18" then AVAILABLE end as EIG,
    case when SKU_SIZE = "20" then AVAILABLE end as TWE,
    case when SKU_SIZE = "22" then AVAILABLE end as TWET,
    case when SKU_SIZE = "24" then AVAILABLE end as TWEF,
    case when SKU_SIZE = "26" then AVAILABLE end as TWES,
    case when SKU_SIZE = "28" then AVAILABLE end as TWEE,
    
    case when SKU_SIZE = "40" then AVAILABLE end as FOURTY,
    case when SKU_SIZE = "42" then AVAILABLE end as FOURTYT,
    case when SKU_SIZE = "44" then AVAILABLE end as FOURTYF,
    case when SKU_SIZE = "46" then AVAILABLE end as FOURTS,
    case when SKU_SIZE = "48" then AVAILABLE end as FOURTE,
    
    case when SKU_SIZE = "3" then AVAILABLE end as THREE,
    case when SKU_SIZE = "4" then AVAILABLE end as FOUR,
    case when SKU_SIZE = "5" then AVAILABLE end as FIVE,
    case when SKU_SIZE = "7" then AVAILABLE end as SEVEN,
    
    case when SKU_SIZE = "3Y" then AVAILABLE end as 3Y,
    case when SKU_SIZE = "3/4Y" then AVAILABLE end as 4Y,
    case when SKU_SIZE = "4/5Y" then AVAILABLE end as 5Y,
    case when SKU_SIZE = "5/6Y" then AVAILABLE end as 6Y,
    case when SKU_SIZE = "7/8Y" then AVAILABLE end as 7Y,
    case when SKU_SIZE = "9/10Y" then AVAILABLE end as 10Y,
    case when SKU_SIZE = "11/12Y" then AVAILABLE end as 12Y,
    case when SKU_SIZE = "13/14Y" then AVAILABLE end as 14Y,
    case when SKU_SIZE = "13Y" then AVAILABLE end as 13Y,
    
    case when SKU_SIZE = "3-4Y" then AVAILABLE end as 4YY,
    case when SKU_SIZE = "4-5Y" then AVAILABLE end as 5YY,
    case when SKU_SIZE = "7-8Y" then AVAILABLE end as 8YY,
    case when SKU_SIZE = "9-10Y" then AVAILABLE end as 10YY,
    
    case when SKU_SIZE = "10/11F" then AVAILABLE end as 11F,
    case when SKU_SIZE = "11/12F" then AVAILABLE end as 12F,
    case when SKU_SIZE = "2/3F" then AVAILABLE end as 3F,
    
    case when SKU_SIZE = "05-Jun" then AVAILABLE end as 6S,
    case when SKU_SIZE = "07-Aug" then AVAILABLE end as 8S
    
    from torque_stock
);


create view torque_stock_by_size_Pivot as (
  select
    SKU,
		sum(SIX) as SIX,
        sum(EIGHT) as EIGHT,
        sum(TEN) as TEN,
        sum(TWELVEL) as TWELVEL,
        sum(FOURTEEN) as FOURTEEN,
        sum(SIXTEEN) as SIXTEEN,
        
        sum(XXS) as XXS,
        sum(XS) as XS,
        sum(S) as S,
        sum(M) as M,
        sum(L) as L,
        sum(XL) as XL,
        sum(XXL) as XXL,
        
        sum(SM) as SM,
        sum(ML) as ML,
        
        sum(SSM) as SSM,
        sum(MML) as MML,
        
        sum(FREE) as FREE,
        sum(ONESIZE) as ONESIZE,
        
        sum(EIG) as EIG,
        sum(TWE) as TWE,
        sum(TWET) as TWET,
        sum(TWEF) as TWEF,
        sum(TWES) as TWES,
        sum(TWEE) as TWEE,
        
        sum(FOURTY) as FOURTY,
        sum(FOURTYT) as FOURTYT,
        sum(FOURTYF) as FOURTYF,
        sum(FOURTS) as FOURTS,
        sum( FOURTE) as  FOURTE,
        
		sum(THREE) as THREE,
        sum(FOUR) as FOUR,
        sum(FIVE) as FIVE,
        sum(SEVEN) as SEVEN,
        
        sum(3Y) as 3Y,
        sum(4Y) as 4Y,
        sum(5Y) as 5Y,
        sum(6Y) as 6Y,
        sum(7Y) as 7Y,
        sum(10Y) as 10Y,
        sum(12Y) as 12Y,
        sum(14Y) as 14Y,
        sum(13Y) as 13Y,
        
        sum(4YY) as 4YY,
        sum(5YY) as 5YY,
        sum(8YY) as 8YY,
        sum(10YY) as 10YY,
        
        sum(11F) as 11F,
        sum(12F) as 12F,
        sum(3F) as 3F,
        
        sum(6S) as 6S,
        sum(8S) as 8S
       
From torque_stock_by_size
group by SKU
);

create view torque_stock_by_size_Pivot_Pretty as (
  select 
	SKU,
    coalesce(SIX,0) as "06",
	coalesce(EIGHT,0) as "08",
	coalesce(TEN,0) as "10",
	coalesce(TWELVEL,0) as "12",
	coalesce(FOURTEEN,0) as "14",
	coalesce(SIXTEEN,0) as "16",
    
	coalesce(XXS,0) as XXS,
	coalesce(XS,0) as XS,
	coalesce(S,0) as S,
	coalesce(M,0) as M,
	coalesce(L,0) as L,
	coalesce(XL,0) as XL,
	coalesce(XXL,0) as XXL,
    
	coalesce(SM,0) as "STM",
	coalesce(ML,0) as "MTM",
	coalesce(SSM,0) as "SM",
	coalesce(MML,0) as "ML",
    
	coalesce(FREE,0) as FREE,
	coalesce(ONESIZE,0) as "ONE",
    
	coalesce(EIG,0) as "18",
	coalesce(TWE,0) as "20",
	coalesce(TWET,0) as "22",
	coalesce(TWEF,0) as "24",
	coalesce(TWES,0) as "26",
	coalesce(TWEE,0) as "28",
    
	coalesce(FOURTY,0) as "40",
	coalesce(FOURTYT,0) as "42",
	coalesce(FOURTYF,0) as "44",
	coalesce(FOURTS,0) as "46",
	coalesce(FOURTE,0) as "48",
    
	coalesce(THREE,0) as "03",
	coalesce(FOUR,0) as "04",
	coalesce(FIVE,0) as "05",
	coalesce(SEVEN,0) as "07",
    
	coalesce(3Y,0) as "Y3",
	coalesce(4Y,0) as "Y3_4Y",
	coalesce(5Y,0) as "Y4_5Y",
	coalesce(6Y,0) as "Y5_6Y",
	coalesce(7Y,0) as "Y7_8Y",
	coalesce(10Y,0) as "Y9_10Y",
	coalesce(12Y,0) as "Y11_12Y",
	coalesce(14Y,0) as "Y13_14Y",
	coalesce(13Y,0) as "Y13",
    
    coalesce(4YY,0) as "Y3__4Y",
	coalesce(5YY,0) as "Y4__5Y",
	coalesce(8YY,0) as "Y7__8Y" ,
	coalesce(10YY,0) as "Y9__10Y",
    
    coalesce(11F,0) as "F10__11F",
	coalesce(12F,0) as "F11__12F",
	coalesce(3F,0) as "F2__3F",
    
	coalesce(6S,0) as "05_Jun",
	coalesce(8S,0) as "07_Aug"
        
    
from torque_stock_by_size_Pivot
);

/*/////////////////////////////// end   //////////////*/

/*/////////////////////////////// TABLE AND VIEWS JOIN   //////////////*/
SELECT
    t2.LineCol, t2.Style, t2.Colour, t2.BrandName, t2.Season,  
	t1.06, t1.08, t1.10, t1.12, t1.14, t1.16,
    t1.XS, t1.S, t1.M, t1.L, t1.XL, t1.XXL,
    t1.STM as "S/M", t1.MTM as "M/L",
    t1.SM, t1.ML,
    t1.FREE, t1.ONE,
    t1.18, t1.20, t1.22, t1.24, t1.26, t1.28,
    t1.Y3 as 3Y, t1.Y3_4Y as "3/4Y", t1.Y4_5Y as "4/5Y", t1.Y5_6Y as "5/6Y", t1.Y7_8Y as "7/8Y",
    t1.Y9_10Y as "9/10Y", t1.Y11_12Y as "11/12Y", t1.Y13_14Y as "13/14Y", t1.Y13 as "13Y",
    t1.03, t1.04, t1.05, t1.07,
    t1.Y3__4Y as "3-4Y", t1.Y4__5Y as "4-5Y", t1.Y7__8Y as "7-8Y", t1.Y9__10Y as "9-10Y",
    t1.F10__11F as "10/11F", t1.F11__12F as "11/12F", t1.F2__3F as "2/3F",
    t1.05_Jun as "6S",  t1.07_Aug as "8S",
    t2.Collection, t2.Article, t2.Origin, t2.SizeRange, t2.GarmentType, t2.Brand, t2.Brand, t2.FabCom, t2.WashCare
    
		FROM torque_stock_by_size_Pivot_Pretty as t1
		LEFT OUTER JOIN sku as t2
		ON t1.SKU = t2.SKU
		GROUP BY LineCol
		ORDER BY LineCol

/*/////////////////////////////// Customer    //////////////*/

SELECT
    t2.LineCol, t2.Style, t2.Colour, 
    t6.Col_Num, t6.Season,  
    
	t1.06, t1.08, t1.10, t1.12, t1.14, t1.16,
    t1.XS, t1.S, t1.M, t1.L, t1.XL, t1.XXL,
    t1.STM as "S/M", t1.MTM as "M/L",
    
    sum(t6.AVAILABLE) as Total,
    
    t6.Landed,  t6.Cost, t6.RRPGBP, t6.RRPEuro,
    
    t3.Total_Qty_Sold,
    
    t4.Total_Qty_Sold_In_Last_Order,
    
    t6.Collection, t6.Article, t6.Origin, 
    
    t2.Brand, 
    
    t5.URL_Ama_com_1, t5.URL_Big_com_1,
    
    t6.Fab_Com, t6.Wash_Care, t6.Brand_Name,
    
    t2.SizeRange, t2.GarmentType
    
	FROM torque_stock_by_size_Pivot_Pretty as t1
        
		LEFT OUTER JOIN sku as t2
		ON t1.SKU = t2.SKU
        
					LEFT OUTER JOIN Cutomer_Order_View_By_Customer_Code as t3
					ON t1.SKU = t3.SKU
                    
						LEFT OUTER JOIN Cutomer_Order_View_By_Order_RSN as t4
						ON t1.SKU = t4.SKU
                        
							LEFT OUTER JOIN url_link as t5
							ON t1.SKU = t5.SKU
                            
								LEFT OUTER JOIN torque_stock as t6
								ON t1.SKU = t6.SKU
		
        WHERE t6.Brand_Name IN ('ISKA') AND 
                                
		t6.Season IN ( 'SS19', 'SS20') AND
        
		t6.AVAILABLE > '0'
                    
		GROUP BY LineCol
		ORDER BY LineCol

/*/////////////////////////////// end   //////////////*/
###################### Cutomer Order View by customer Code    ###############

create view Cutomer_Order_View_By_Customer_Code as (
SELECT
sku.LineCol, sku.Style, item.ColourCode, sku.Colour,
sku.BrandName, sku.Season,
item.SKU, item.Article,
sum(item.TotalQty) as Total_Qty_Sold, count(head.RSN) as Tiems_Sold,
min(item.SellPrice) as Lowest_Sold_Price,
item.BuyPrice as Landed_Cost_GBP,
max(item.SellPrice) as Max_Sold_Price, 
avg(item.SellPrice) as Average_Sold_Price,
customer.Cus_Code as Customer_Code, customer.Name as Customer_Name,
head.RSN, head.AcCode, head.Status, head.CreateDate

FROM item join head join customer join sku 

ON item.CustOrderRSN_ID = head.Id 
AND item.sku_id = sku.Id 
AND head.Customer_Id = customer.Id 

AND cus_code = 'BA004A' 

GROUP BY SKU 
ORDER BY SKU DESC
);

/*/////////////////////////////// end   //////////////*/

create view Cutomer_Order_View_By_Order_RSN as (

SELECT
	sku.LineCol, sku.Style, sku.Colour,
    sum(item.TotalQty) as Total_Qty_Sold_In_Last_Order,
	customer.cus_code, customer.Name,
	head.RSN, head.OrderNum, head.AcCode, head.Status, head.CreateDate,
	item.SKU, item.Article, item.ColourCode, item.SellPrice
FROM
	item join head join customer join sku
ON
	item.CustOrderRSN_ID = head.Id
AND
	head.customer_Id = customer.id
And
	item.sku_id = sku.Id

WHERE RSN IN (169751, 169752, 169801)
GROUP BY SKU
ORDER BY SKU DESC

);

/*/////////////////////////////// end   //////////////*/

create view torque_stock_by_size_test as (
  select
    torque_stock.SKU,
    case when SKU_SIZE = "6" then AVAILABLE end as SIX,
    case when SKU_SIZE = "S" then AVAILABLE end as S,
    case when SKU_SIZE = "M" then AVAILABLE end as M,
	case when SKU_SIZE = "VIII" then AVAILABLE end as VIII

	from torque_stock
    
);

/*/////////////////////////////// end   //////////////*/

create view torque_stock_by_size_test_Pivot as (
  select
  SKU,
		sum(S) as S,
        sum(M) as M,
        sum(SIX) as SIX,
        sum(VIII) as VIII
        
	From torque_stock_by_size_test
    group by SKU
);

/*/////////////////////////////// end   //////////////*/

create view torque_stock_by_size_test_Pivot_Pretty as (
  select 
	SKU,
    coalesce(S, 0) as S,
    coalesce(M, 0) as M,
    coalesce(SIX, 0) as "06",
    coalesce(VIII, 0) as "08"
from torque_stock_by_size_test_Pivot
);

/*/////////////////////////////// Join View with tables ex   //////////////*/

/* ?* https://stackoverflow.com/questions/12004603/mysql-pivot-row-into-dynamic-number-of-columns */
SELECT
	t1.SKU, t1.LineCol, t1.Style, t1.Colour,
	t1.BrandName, t1.Season, t1.RRPGBP
FROM sku as t1
LEFT OUTER JOIN torque_stock_by_size_Pivot_Pretty as t2
ON t1.SKU = t2.SKU
GROUP BY SKU
ORDER BY SKU

/*/////////////////////////////// end   //////////////*/





