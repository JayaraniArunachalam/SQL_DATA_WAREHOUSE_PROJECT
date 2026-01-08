# creating dim_products
# Joining child table with master table
SELECT pi.prd_id, pi.cat_id,
pi.prd_key, pi.prd_nm, pc.cat, pc.SUBCAT,pc.MAINTENANCE,
pi.prd_cost, pi.prd_line, pi.prd_start_dt, pi.prd_end_dt 
from silver_crm_prd_info pi
left join silver_erp_px_cat_g1v2 pc
on pi.cat_id = pc.id
where prd_end_dt IS NULL; -- selecting only the current products and historical products are filtered out

# checking the quality of the results of above query, particularly the uniqueness of prd_key (no duplicates)
SELECT prd_key, count(*) FROM(SELECT pi.prd_id, pi.cat_id,
pi.prd_key, pi.prd_nm, pc.cat, pc.SUBCAT,pc.MAINTENANCE,
pi.prd_cost, pi.prd_line, pi.prd_start_dt, pi.prd_end_dt 
from silver_crm_prd_info pi
left join silver_erp_px_cat_g1v2 pc
on pi.cat_id = pc.id
where prd_end_dt IS NULL) t
GROUP BY prd_key
HAVING count(*)>1;

# use the above case in the transformation query in place of gen
# use naming conventions and give proper names for all columns
# organise the columns in logical manner 
# decide if it is dimension or fact
# create surrogate key for dimension table (unique system generated identifier assigned to each record in table
# this can be done as ddl based generation or query based(using windows function like row number)
# we use window functions row_number ordered by start date and product_number
# create view with the whole query in gold table
CREATE VIEW gold.dim_products AS 
SELECT ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,pi.prd_id AS product_id, 
pi.prd_key AS product_number, pi.prd_nm AS product_name, 
pi.cat_id AS category_id,pc.cat AS category, pc.SUBCAT AS sub_category,pc.MAINTENANCE AS maintenance,
pi.prd_cost AS product_cost, pi.prd_line AS product_line, pi.prd_start_dt
from silver_crm_prd_info pi
left join silver_erp_px_cat_g1v2 pc
on pi.cat_id = pc.id
where prd_end_dt IS NULL