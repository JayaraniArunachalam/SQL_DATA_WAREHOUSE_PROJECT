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