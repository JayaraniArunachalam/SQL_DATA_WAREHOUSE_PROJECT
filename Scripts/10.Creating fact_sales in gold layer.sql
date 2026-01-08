# creating fact_sales (the sales table is quantitative and connecting multiple dimensions like prd_key, cust_id, 
# so it is clearly understandable the sales table is a fact table.
# USe the sim tables surrogate keys instead of prd_key and cust_id to easily connect facts with dimensions. 
#"Key LOOKUP"-  that is replacing sls_prd_key and sls_cust_id in fact_tables
# with product_key and customer_key respectively from dim_products and dim_customers

CREATE VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num AS sales_order_num,
dp.product_key,
dc.customer_key,
sd.sls_order_dt AS order_date ,
sd.sls_ship_dt AS ship_date,
sd.sls_due_dt AS due_date, 
sd.sls_sales AS sales_amount, 
sd.sls_quantity AS sales_quantity, 
sd.sls_price AS sales_price
FROM silver.silver_crm_sales_details sd
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id 
LEFT JOIN gold.dim_products dp
ON sd.sls_prd_key = dp.product_number;