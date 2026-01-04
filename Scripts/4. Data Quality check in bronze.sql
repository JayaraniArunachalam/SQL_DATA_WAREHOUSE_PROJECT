-- =============================
-- Table 1: bronze_crm_cust_info
-- =============================
/* Quality Check 1 - PK is unique and not null
Expectation - no records */
SELECT cst_id, count(*)
FROM bronze_crm_cust_info
GROUP BY cst_id
HAVING count(*)>1 or cst_id is null;

SELECT * FROM(SELECT *, row_number() OVER(partition by cst_id order by cst_create_date DESC) AS FLAG
FROM bronze_crm_cust_info) AS tb1
WHERE FLAG = 1 AND cst_id IS NOT NULL;

/* Quality Check 2 Check white spaces in string values 
Expectation - no records */
SELECT cst_firstname FROM bronze_crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

SELECT cst_lastname FROM bronze_crm_cust_info
WHERE cst_lastname <> TRIM(cst_lastname);

SELECT cst_marital_status FROM bronze_crm_cust_info
WHERE cst_marital_status <> TRIM(cst_marital_status);

/* Quality check 3 Check for consistency in values of Low cardinal columns
Expectation - no records */
SELECT DISTINCT cst_marital_status
FROM bronze_crm_cust_info;

SELECT DISTINCT cst_gndr
FROM bronze_crm_cust_info;

-- =============================
-- Table 2: bronze_crm_prd_info
-- =============================
/* Quality Check 1 - PK is unique and not null
Expectation - no records */
SELECT prd_id, count(*)
FROM bronze.bronze_crm_prd_info
GROUP BY prd_id
HAVING count(*)>1 or prd_id is null;

# Quality Check 2- if the key use for building relations between tables are same?
#--------------------------------------------------------------------------------------
# Since prd_key has too much info and if you check in
# bronze_erp_px_cat_g1v2 we have an id which is same as prd_key 
# but has only the first five characters of prd_key.
# Similarly in bronze_crm_sales_details the last characters are available as prd_key
#---------------------------------------------------------------------------------------
SELECT * from bronze_crm_prd_info;
select * from bronze_crm_sales_details;
select * from bronze_erp_px_cat_g1v2;


/* Quality Check 3 Check white spaces in string values 
Expectation - no records */
SELECT prd_nm FROM bronze_crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

/* Quality check 4 Check for nulls or negative numbers
Expectation - no records */
SELECT * FROM bronze_crm_prd_info
WHERE prd_cost< 0 OR prd_cost IS NULL;

/* Quality Check 5 Data Standardizations*/
SELECT DISTINCT(prd_line)
FROM bronze_crm_prd_info;

#QC 6 Check for invalid dates - end dates should not be earlier than start date
select *
from bronze_crm_prd_info
where prd_end_dt< prd_start_dt;
# solution 1 - switch end date and start date 
# but issue here that rises is overlapping of dates for same product occurs
# this gives us another QC where end date of one product should be less than next record start date
# solution 2 End date = start date of next record-1
# cast dates to date

-- =============================
-- Table 3: bronze_crm_sales_details
-- =============================
/* Quality Check 1 - Unwanted spaces in PK sls_ord_num
Expectation - no records */
SELECT *
FROM bronze.bronze_crm_sales_details
WHERE sls_ord_num <> TRIM(sls_ord_num);

/* Quality Check 2 - Check for sls_prd_key which are not in prd_info
since the prd_key is the foreign key of prd_key of prd_info
Expectation - no records */
SELECT * from bronze.bronze_crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key from silver.silver_crm_prd_info);

/* Quality Check 3 - Check for sls_cust_id which are not in cust_info
since the cust_id in sales_details is the foreign key of cst_id in cust_info
Expectation - no records */
SELECT * from bronze.bronze_crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id from silver.silver_crm_cust_info);

/* Quality Check 4 - Check for sls_order_dt
Check where sales_date is 0 or less than 0 , Expectation - no records but 19 records where fetched */
SELECT sls_order_dt from bronze.bronze_crm_sales_details
WHERE sls_order_dt <=0;

/* check whether length sales date is not equal to 10 characters or not 
Expectation no records*/
SELECT sls_order_dt from bronze_crm_sales_details
WHERE length(sls_order_dt) <> 10;

/* check whether  sales date has abnormal dates
Expectation no records*/
select sls_order_dt from bronze_crm_sales_details
where YEAR(sls_order_dt) > YEAR(current_date());

/* cumulating every checks of sls_order_dt */
SELECT sls_order_dt from bronze.bronze_crm_sales_details
WHERE sls_order_dt <= 0 or length(sls_order_dt)<>10
or YEAR(sls_order_dt) > YEAR(current_date());

/* cumulating every checks of sls_ship_dt */
SELECT sls_ship_dt from bronze.bronze_crm_sales_details
WHERE sls_ship_dt <= 0 or length(sls_order_dt)<>10
or YEAR(sls_ship_dt) > YEAR(current_date());

/* cumulating every checks of sls_due_dt */
SELECT sls_due_dt from bronze.bronze_crm_sales_details
WHERE sls_due_dt <= 0 or length(sls_due_dt)<>10
or YEAR(sls_due_dt) > YEAR(current_date());

/* Quality Check 5 check sales, quantity and price columns 
we are using DISTINCT to get unique combination of bad data , thats it*/
SELECT DISTINCT sls_sales AS old_sls_sales ,sls_price AS old_sls_price,
  -- Refine SALES only when price is valid
CASE
	WHEN (sls_sales IS NULL or sls_sales <=0 OR sls_sales <> sls_quantity * ABS(sls_price)) AND 
    (abs(sls_price) >0 )
    THEN sls_quantity * ABS(sls_price) 
    ELSE sls_sales
END AS sls_sales,
 -- Refine PRICE only when sales is valid
  cast(CASE 
    WHEN (sls_price IS NULL OR sls_price <= 0) AND (abs(sls_sales) > 0 AND sls_price <> ABS(sls_sales) / NULLIF(sls_quantity, 0))
      THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
    ELSE sls_price
  END as signed)AS sls_price,
    sls_quantity
    FROM bronze.bronze_crm_sales_details
WHERE sls_sales <> sls_price*sls_quantity
OR sls_price IS NULL or sls_price <=0
OR sls_sales IS NULL or sls_sales <=0
OR sls_quantity IS NULL or sls_quantity <=0
ORDER BY sls_sales, sls_quantity, sls_price;


/* From the above query we can see that sls_quantity is good, no defects, 
zero or negative values are observed in sls_sales and sls_price */

SELECT  sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
	WHEN sls_order_dt <= 0 or length(sls_order_dt)<>10 or YEAR(sls_order_dt) > YEAR(current_date()) THEN NULL
    ELSE sls_order_dt
END AS sls_order_dt,
CASE
	WHEN sls_ship_dt <= 0 or length(sls_ship_dt)<>10 or YEAR(sls_ship_dt) > YEAR(current_date())THEN NULL
    ELSE sls_ship_dt
END AS sls_ship_dt,
CASE
	WHEN sls_due_dt <= 0 or length(sls_due_dt)<>10 or YEAR(sls_due_dt) > YEAR(current_date()) THEN NULL
    ELSE sls_due_dt
END AS sls_due_dt,
CASE
	WHEN (sls_sales IS NULL or sls_sales <=0 OR sls_sales <> sls_quantity * ABS(sls_price)) AND 
    (abs(sls_price) >0 )
    THEN sls_quantity * ABS(sls_price) 
    ELSE sls_sales
END AS sls_sales,
  cast(CASE 
    WHEN (sls_price IS NULL OR sls_price <= 0) AND (abs(sls_sales) > 0 AND sls_price <> ABS(sls_sales) / NULLIF(sls_quantity, 0))
      THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
    ELSE sls_price
  END as signed)AS sls_price,
    sls_quantity
    FROM bronze_crm_sales_details;
    
    -- =============================
-- 4. Table: bronze_erp_cust_az12
-- =================================
/* QC 1 checking whether the column cid is mathching with cst_key in crm_cust_info table,
since cid in bronze_erp_cust_az12 is the FK to the PK cst_key of bronze_crm_cust_info table  */
select CID, BDATE, gen from bronze_erp_cust_az12;
select * from bronze_crm_cust_info;
SELECT 
CASE
	WHEN CID LIKE 'NAS%' THEN SUBSTRING(cid,4,length(cid))
    ELSE cid
END AS cid, BDATE, gen from bronze_erp_cust_az12
where CASE
	WHEN CID LIKE 'NAS%' THEN SUBSTRING(cid,4,length(cid))
    ELSE cid
    END
    NOT IN (select distinct cst_key from silver.silver_crm_cust_info);
    
/* QC 2 checking bdate of the customer , not greater than current date */
SELECT bdate from bronze_erp_cust_az12 where bdate > curdate();

SELECT CASE
WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
ELSE cid
END AS cid,
CASE
WHEN bdate > curdate() THEN NULL
ELSE bdate
END AS bdate,
gen from bronze_erp_cust_az12;
/* QC 3 checking white spaces and in text data and invisible spaces */
-- Creating a two-line string
select distinct(gen), hex(gen), trim(gen), hex(trim(gen)) from bronze_erp_cust_az12;
select  distinct gen,
case
	when UPPER(TRIM( REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''),  
                CHAR(10), ''),                   
            CHAR(9), ''),                        
        CHAR(32), '') )) IN ( 'F','FEMALE') THEN 'Female'
	when UPPER(TRIM( REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''),  
                CHAR(10), ''),                   
            CHAR(9), ''),                        
        CHAR(32), '') )) IN ('M' ,'MALE') THEN 'Male'
    ELSE 'n/a'
END AS gender
from bronze_erp_cust_az12;

SELECT distinct (gen), case
UPPER(TRIM( REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''),  
                CHAR(10), ''),                   
            CHAR(9), ''),                        
        CHAR(32), '') ))
        when 'F'THEN 'Female'
        when 'FEMALE'THEN 'Female'
        when 'M' THEN 'Male'
        when 'MALE' THEN 'Male'
        ELSE 'n/a'
	END AS gender
    from bronze_erp_cust_az12;

/* writing select statement with all QCs for erp_cust_az12 */
SELECT 
CASE
	WHEN cid LIKE "NAS%" THEN SUBSTRING(cid, 4, LENGTH(cid))
	ELSE cid
END AS cid,
CASE
	WHEN bdate > curdate() THEN null
    ELSE bdate
END AS bdate,
CASE
	UPPER(TRIM( REPLACE(REPLACE(REPLACE(REPLACE(gen, CHAR(13), ''),  
                CHAR(10), ''),                   
            CHAR(9), ''),                        
        CHAR(32), '') ))
	WHEN 'F' THEN 'Female'
    WHEN 'FEMALE' THEN 'Female'
    WHEN 'M' THEN 'Male'
    WHEN 'MALE' THEN 'Male'
    ELSE 'n/a'
END AS gen
FROM bronze_erp_cust_az12;

/* Additional step of checking whether silver layer is loaded correctly */
SELECT cid from silver.silver_erp_cust_az12
where cid NOT IN (SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
ELSE cid
END AS cid from bronze_erp_cust_az12);

SELECT bdate from silver.silver_erp_cust_az12
where bdate > curdate();

SELECT distinct gen from silver.silver_erp_cust_az12;

-- ==============================
-- Table 5: bronze_erp_loc_a101
-- ==============================
/* QC 1 cid in bronze_erp_loc_a101 is the FK to cst_key in bronze_crm_cust_info .
so we have to check whether all cid in bronze_erp_loc_a101 is vailable in bronze_crm_cust_info*/
SELECT cid FROM bronze_erp_loc_a101
where cid NOT IN (SELECT cst_key from silver.silver_crm_cust_info);

SELECT cst_key from silver.silver_crm_cust_info where cst_key LIKE '%00011048%';

SELECT CONCAT(SUBSTRING(cid, 1,2), SUBSTRING(cid, 4, LENGTH(cid))) AS cid from bronze_erp_loc_a101;
SELECT REPLACE(cid, "-","") AS cid from bronze_erp_loc_a101;

/*QC 2 checking cntry */
SELECT distinct cntry from bronze_erp_loc_a101;

SELECT DISTINCT case UPPER(TRIM(
        REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''),   -- CR
                CHAR(10), ''),                   -- LF
            CHAR(9), ''),                        -- TAB
        CHAR(32), '')                            -- SPACE
    ))
when "US" then "United States"
when "USA" then "United States" 
when "DE" then "Germany"
when "" then "N/A"
when NULL then "N/A"
 else TRIM(
        REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''),   -- CR
                CHAR(10), ''),                   -- LF
            CHAR(9), '') -- tab
    ) end as cntry from bronze.bronze_erp_loc_a101;
/* Additional step of checking whether silver layer of erp_loc_a101 is loaded correctly */
SELECT cid from silver.silver_erp_loc_a101
where cid NOT IN (SELECT cst_key FROM silver.silver_crm_cust_info);

SELECT DISTINCT cntry from silver.silver_erp_loc_a101;

-- ================================
-- Table 6: bronze_erp_px_cat_g1v2
-- ================================
#QC1 to check whether all id in bronze_erp_px_cat_g1v2 is there in silver_crm_prd_info
SELECT * from bronze_erp_px_cat_g1v2;
SELECT * FROM silver.silver_crm_prd_info;
SELECT * FROM bronze_erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id from silver.silver_crm_prd_info);
SELECT * from silver.silver_crm_prd_info
where cat_id like '%co_p%';
SELECT * from bronze_erp_px_cat_g1v2
where id like '%co_p%';

SELECT CASE
WHEN id = 'CO_PD' THEN 'CO_PE'
ELSE id
END AS id,
cat, subcat, maintenance from bronze_erp_px_cat_g1v2;

#QC2 to check for unwanted spaces
select * from bronze.bronze_erp_px_cat_g1v2  
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance);

#QC 3 to check for data standardisations & normalisation
select distinct cat from bronze.bronze_erp_px_cat_g1v2;
select distinct subcat from bronze.bronze_erp_px_cat_g1v2;
select distinct MAINTENANCE, hex(maintenance),hex(trim(replace (MAINTENANCE,CHAR(13),""))) from bronze.bronze_erp_px_cat_g1v2;
select distinct REPLACE(maintenance, CHAR(13), '')
 from bronze.bronze_erp_px_cat_g1v2; -- remove the newline space here
 
 SELECT * from silver.silver_erp_px_cat_g1v2
 where id not in (select cat_id from silver.silver_crm_prd_info);
 
 select distinct cat from silver.silver_erp_px_cat_g1v2;
 select distinct subcat from silver.silver_erp_px_cat_g1v2;
 select distinct maintenance from silver.silver_erp_px_cat_g1v2;
 select * from silver.silver_erp_px_cat_g1v2
 where trim(cat) != cat or trim(subcat) != subcat or maintenance != trim(maintenance);
