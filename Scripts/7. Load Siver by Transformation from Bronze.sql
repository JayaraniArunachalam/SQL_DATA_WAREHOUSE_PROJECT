-- =============================
-- Table 1: silver_crm_cust_info
-- =============================
INSERT INTO silver.silver_crm_cust_info(
cst_id, cst_key, cst_firstname, cst_lastname,cst_marital_status, cst_gndr, cst_create_date)
SELECT cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname, 
TRIM(cst_lastname) AS cst_lastname,
CASE
	WHEN UPPER(TRIM(cst_marital_status))= 'M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'NA'
END AS cst_marital_status,
CASE
	WHEN UPPER(TRIM(cst_gndr)) ='M' THEN 'Male'
    WHEN UPPER(TRIM(cst_gndr)) ='F' THEN 'Female'
    ELSE 'NA'
END AS cst_gndr,
cst_create_date
FROM(SELECT *, row_number() OVER(partition by cst_id order by cst_create_date DESC) AS FLAG
FROM bronze_crm_cust_info) AS tb1
WHERE FLAG = 1 AND cst_id IS NOT NULL;


-- =============================
-- Table 2: silver_crm_prd_info
-- =============================
INSERT INTO silver.silver_crm_prd_info(
prd_id, cat_id,prd_key, prd_nm, prd_cost,prd_line,prd_start_dt,prd_end_dt)
SELECT prd_id, replace(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
    WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'
    ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
    date_sub(cast(LEAD(prd_start_dt) OVER (PARTITION BY prd_key order by prd_start_dt) AS date),INTERVAL 1 DAY) as prd_end_date
FROM bronze_crm_prd_info;

-- =============================
-- Table 3: silver_crm_sales_details
-- =============================
INSERT INTO silver.silver_crm_sales_details
(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
SELECT  sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
	WHEN sls_order_dt <= 0 or length(sls_order_dt)<>10 or YEAR(sls_order_dt) > YEAR(current_date()) THEN NULL
    ELSE sls_order_dt
END AS sls_order_dt,
CASE
	WHEN sls_ship_dt <= 0 or length(sls_ship_dt)<>10 or YEAR(sls_ship_dt) > YEAR(current_date()) THEN NULL
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
sls_quantity,
  cast(CASE 
    WHEN (sls_price IS NULL OR sls_price <= 0) AND (abs(sls_sales) > 0 AND sls_price <> ABS(sls_sales) / NULLIF(sls_quantity, 0))
      THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
    ELSE sls_price
  END as signed)AS sls_price
    FROM bronze_crm_sales_details;
    
-- ==============================
-- Table 4: silver_erp_cust_az12
-- ==============================
INSERT INTO silver.silver_erp_cust_az12
(CID, BDATE, gen)
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

-- ==============================
-- Table 5: silver_erp_loc_a101
-- ==============================
INSERT INTO silver.silver_erp_loc_a101
(CID, cntry)
SELECT REPLACE(cid, "-", "") AS cid,
CASE UPPER(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(cntry, CHAR(13),""),CHAR(10),""),CHAR(9),""),CHAR(32),"")))
	WHEN "US" THEN "United States"
    WHEN "USA" THEN "United States"
    WHEN "DE" THEN "Germany"
    WHEN "" THEN 'n/a'
    WHEN NULL THEN 'n/a'
    ELSE TRIM(REPLACE(REPLACE(REPLACE(cntry, CHAR(13),""),CHAR(10),""),CHAR(9),""))
END AS cntry
FROM bronze_erp_loc_a101;

-- ===============================
-- Table 6: silver_erp_px_cat_g1v2
-- ===============================

INSERT INTO silver.silver_erp_px_cat_g1v2
(ID, CAT, SUBCAT, MAINTENANCE)
SELECT 
CASE
	WHEN id = 'CO_PD' THEN 'CO_PE'
	ELSE id
END AS id,
cat, subcat, trim(REPLACE(maintenance, char(13),"")) AS MAINTENANCE 
from bronze_erp_px_cat_g1v2;
