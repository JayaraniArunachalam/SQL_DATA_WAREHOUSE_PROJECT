# Creating dim_customers
# GOLD LAYER First step is to left join child tables with master tables
# then check for duplicates after joining to veify join logic

SELECT cst_key, count(*)
from (SELECT ci.cst_id, ci.cst_key, 
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.BDATE,
ca.gen,
la.cntry
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
ON ci.cst_key = la.CID) t1
GROUP BY cst_key
HAVING count(*)>1;

# WE have to two gender columns, (from silver_crm_cust_info and from silver_erp_cust_az12,
# for this we have to data integration (integrating gender column from crm and erp into new column)
# running the below query shows some data integration issues like female in one table have male in others, vice versa
# also n/a in one table have gender details in other table

SELECT DISTINCT
ci.cst_gndr,
ca.gen,
CASE
	WHEN ci.cst_gndr != 'NA' THEN ci.cst_gndr -- CRM is the master for gender info
    ELSE coalesce(ca.gen, 'NA')
END AS new_gen
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
ON ci.cst_key = la.CID
ORDER BY 1,2;

# use the above case in the transformation query in place of gen
SELECT ci.cst_id, ci.cst_key, 
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
CASE
	WHEN ci.cst_gndr != 'NA' THEN ci.cst_gndr -- CRM is the master for gender info
    ELSE coalesce(ca.gen, 'NA')
END AS gen,
ci.cst_create_date,
ca.BDATE,
la.cntry
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
ON ci.cst_key = la.CID;

# use naming conventions and give proper names for all columns
# organise the columns in logical manner 
# decide if it is dimension or fact (it describes customers, not quatitates anything so it is a dim_customer table)
# create surrogate key for dimension table (unique system generated identifier assigned to each record in table
# this can be done as ddl based generation or query based(using windows function like row number)
# we use window functions row_number
# create view with the whole query in gold table
CREATE VIEW gold.dim_customers AS
SELECT 
row_number() OVER(ORDER BY cst_id) AS customer_key,
cst_id AS customer_id, ci.cst_key AS customer_number, 
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE
	WHEN ci.cst_gndr != 'NA' THEN ci.cst_gndr -- CRM is the master for gender info
    ELSE coalesce(ca.gen, 'NA')
END AS gender,
ca.BDATE AS birth_date,
ci.cst_create_date AS cust_cration_date
FROM silver_crm_cust_info ci
LEFT JOIN silver_erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver_erp_loc_a101 la
ON ci.cst_key = la.CID;