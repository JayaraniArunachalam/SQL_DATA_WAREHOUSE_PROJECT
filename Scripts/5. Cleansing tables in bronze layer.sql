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

/* Quality Check 2 Check white spaces in string values */
SELECT cst_firstname FROM bronze_crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

SELECT cst_lastname FROM bronze_crm_cust_info
WHERE cst_lastname <> TRIM(cst_lastname);

SELECT cst_marital_status FROM bronze_crm_cust_info
WHERE cst_marital_status <> TRIM(cst_marital_status);

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
-- Table 2: bronze_crm_prd_info
-- =============================
SELECT * from bronze_crm_prd_info;
SELECT prd_id, replace(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
replace(SUBSTRING(prd_key, 7, LENGTH(prd_key)),'-','_') AS prd_key,
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

