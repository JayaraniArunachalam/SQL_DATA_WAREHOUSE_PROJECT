/*
===============================================================================
DDL Script: Create Silver Tables (MySQL Compatible)
===============================================================================
Script Purpose:
    This script creates tables for the 'silver' layer, dropping existing tables 
    if they already exist.
===============================================================================
*/

-- =============================
-- 1.Table: silver_crm_cust_info
-- =============================
USE silver;
DROP TABLE IF EXISTS silver_crm_cust_info;

CREATE TABLE silver_crm_cust_info (
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date date,
dwh_create_date DATETIME default current_timestamp()
);

-- =============================
-- 2. Table: silver_crm_prd_info
-- =============================
USE silver;
DROP TABLE IF EXISTS silver_crm_prd_info;

CREATE TABLE silver_crm_prd_info(
prd_id INT,
cat_id VARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME default current_timestamp()
);

-- =============================
-- 3. Table: silver_crm_sales_details
-- =============================
USE silver;
DROP TABLE IF EXISTS silver_crm_sales_details;

CREATE TABLE silver_crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id	INT,
sls_order_dt DATE,
sls_ship_dt	DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME default current_timestamp()
);

-- =============================
-- 4. Table: silver_erp_cust_az12
-- =============================
USE silver;
DROP TABLE IF EXISTS silver_erp_cust_az12;

CREATE TABLE silver_erp_cust_az12(
CID VARCHAR(50),
BDATE DATE,
gen VARCHAR(50),
dwh_create_date DATETIME default current_timestamp()
);

-- =============================
-- 5. Table: silver_erp_loc_a101
-- =============================
USE silver;
DROP TABLE IF EXISTS silver_erp_loc_a101;

CREATE TABLE silver_erp_loc_a101(
CID VARCHAR(50),
cntry VARCHAR(50),
dwh_create_date DATETIME default current_timestamp()
);

-- =============================
-- 6. Table: silver_erp_px_cat_g1v2
-- =============================
DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2(
ID	VARCHAR(50),
CAT	VARCHAR(50),
SUBCAT	VARCHAR(50),
MAINTENANCE VARCHAR(50),
dwh_create_date DATETIME default current_timestamp()
);
