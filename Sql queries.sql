
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

AND cus_code = 'UABB' 

GROUP BY SKU 
ORDER BY SKU DESC

################ CUSTOMER REPORT BY ORDER 1.0 ###############
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

WHERE RSN IN (169755, 169757,169757)
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
	report_stock.Avilable_Stock > '0'
AND 
	cus_code = 'DRES4' 
    
WHERE report_stock.BrandName IN ('YUMI RETAIL','YUMI ORIGINAL', 'YUMI GIRLS RETAIL', 'YUMI GIRLS', 'Yumi Curves',
								'YUMI ACCESSORIES', 'YUMI' ,'Y by Yumi', 'UTTAM KIDS', 'ISKA', 'YUMI-RETAIL') AND 
report_stock.Season IN ('AW10', 'AW11', 'AW12', 'AW13', 'AW14', 'AW15', 
'AW16', 'AW17', 'AW18', 'IS10', 'IS11', 
'IS12', 'IS13', 'IS14', 'IS15', 'IW10', 'IW11', 
'IW12', 'IW13', 'IW14', 'IW15', 'PD19', 'SS01', 
'SS02', 'SS10', 'SS11', 'SS12', 'SS13', 'SS14', 
'SS15', 'SS16', 'SS17', 'SS18', 'SS19', 'Missing')

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

create view report_stock_Extended as (
  select
    report_stock.BrandName,
    case when Season = "SS19" then Avilable_Stock end as SS19,
    case when Season = "SS18" then Avilable_Stock end as SS18,
    case when Season = "SS17" then Avilable_Stock end as SS17
   
  from report_stock
);

create view report_stock_Extended_Pivot as (
  select
    BrandName,
    sum(SS19) as SS19,
    sum(SS18) as SS18,
    sum(SS17) as SS17 
  from report_stock_Extended
  group by BrandName
);

create view report_stock_Extended_Pivot_Pretty as (
  select 
    BrandName, 
    coalesce(SS19, 0) as SS19, 
    coalesce(SS18, 0) as SS18, 
    coalesce(SS17, 0) as SS17
  from report_stock_Extended_Pivot
);

//////////////////////////////// end   ///////////////






