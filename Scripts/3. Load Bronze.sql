-- ======================================================
-- Optimized Bulk Load for Bronze Layer (6 tables)
-- ======================================================
USE bronze;
-- Disable strict mode once
SET @OLD_SQL_MODE = @@sql_mode;
SET SESSION sql_mode = REPLACE(@@sql_mode, 'STRICT_TRANS_TABLES', '');

-- ========================================
SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
-- ========================================

-- ========================================
-- 1. CRM_CUST_INFO
-- ========================================
-- ========================================
ALTER TABLE bronze_crm_cust_info DISABLE KEYS;
TRUNCATE TABLE bronze_crm_cust_info;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA INFILE 'E:/Code/SQL/SQL Practice sessions/Portfolio Project Datasets_Date Ware Housing/Source CRM/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE bronze_crm_cust_info ENABLE KEYS;

-- ========================================
-- 2. CRM_PRD_INFO
-- ========================================

ALTER TABLE bronze_crm_prd_info DISABLE KEYS;
TRUNCATE TABLE bronze_crm_prd_info;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- ========================================
-- 3. CRM_SALES_DETAILS
-- ========================================

ALTER TABLE bronze_crm_sales_details DISABLE KEYS;
TRUNCATE TABLE bronze_crm_sales_details;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
ALTER TABLE bronze_crm_sales_details ENABLE KEYS;

-- ========================================
-- 4. ERP_CUST_AZ12
-- ========================================
ALTER TABLE bronze_erp_cust_az12 DISABLE KEYS;
TRUNCATE TABLE bronze_erp_cust_az12;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE bronze_erp_cust_az12 ENABLE KEYS;

-- ========================================
-- 5. ERP_LOC_A101
-- ========================================
ALTER TABLE bronze_erp_loc_a101 DISABLE KEYS;
TRUNCATE TABLE bronze_erp_loc_a101;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE bronze_erp_loc_a101 ENABLE KEYS;

-- ========================================
-- 6. ERP_PX_CAT_G1V2
-- ========================================
ALTER TABLE bronze_erp_px_cat_g1v2 DISABLE KEYS;
TRUNCATE TABLE bronze_erp_px_cat_g1v2;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

ALTER TABLE bronze_erp_px_cat_g1v21 ENABLE KEYS;
