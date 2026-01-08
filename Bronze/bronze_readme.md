# Bronze Layer – Raw Data

## Overview
The Bronze layer stores raw data ingested from source systems **as-is**, without applying any transformations.  
It acts as the landing zone for traceability, auditability, and debugging.

## Source Systems
Data is ingested from CSV files representing:
- CRM system
- ERP system

## Tables in Bronze Layer
- `bronze_crm_cust_info`
- `bronze_crm_prd_info`
- `bronze_crm_sales_details`
- `bronze_erp_cust_az12`
- `bronze_erp_loc_a101`
- `bronze_erp_px_cat_g1v2`

## Load Strategy
- Full load
- `TRUNCATE & INSERT`
- Batch processing

## Transformations
❌ No transformations are applied in the Bronze layer  
❌ No data cleansing  
❌ No standardization  

Data is stored **exactly as received from the source systems**.

## Purpose
- Preserve raw source data
- Enable audit and reconciliation
- Serve as the base for data quality checks in the Silver layer
