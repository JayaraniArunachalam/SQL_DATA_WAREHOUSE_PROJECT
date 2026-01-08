SELECT * FROM bronze.bronze_erp_loc_a101;
SELECT cid, count(*)
from bronze.bronze_erp_loc_a101
group by cid;
select distinct cntry from bronze.bronze_erp_loc_a101;
select length(cntry) from bronze.bronze_erp_loc_a101
where cntry <> trim(cntry);
select count(distinct cntry) from bronze.bronze_erp_loc_a101;
select cntry, trim(cntry) , length(cntry), length(trim(cntry)) ,
count(cntry), count(trim(cntry))
from bronze.bronze_erp_loc_a101
group by cntry;