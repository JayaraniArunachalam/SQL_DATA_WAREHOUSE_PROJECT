# Silver Layer – Cleansed & Standardized Data

## Overview
The Silver layer applies **data quality checks, cleansing, standardization, and business rules** to prepare data for analytics.

All transformations are driven by explicit **data quality validations** performed on Bronze tables.

---

## Data Quality & Cleansing Approach

### 1️⃣ CRM Customer Information (`silver_crm_cust_info`)
Applied checks and transformations:
- Primary key (`cst_id`) uniqueness and non-null validation
- Deduplication using `ROW_NUMBER()` (latest record retained)
- Removal of unwanted whitespaces
- Standardization of:
  - Marital status (`M` → Married, `S` → Single)
  - Gender (`M/F` → Male/Female)
- Invalid or unknown values mapped to `NA`

---

### 2️⃣ CRM Product Information (`silver_crm_prd_info`)
Applied checks and transformations:
- Primary key validation
- Standardization of product categories
- Harmonization of product keys between CRM and ERP
- Handling NULL or negative product cost
- Standardization of product line values
- Date corrections:
  - Ensured end date is derived as **next start date – 1**
  - Prevented overlapping date ranges (SCD logic)

---

### 3️⃣ CRM Sales Details (`silver_crm_sales_details`)
Applied checks and transformations:
- Validation of foreign keys (`customer`, `product`)
- Cleansing of invalid dates (order, ship, due dates)
- Handling invalid date formats and future dates
- Validation of sales, quantity, and price consistency
- Avoided division-by-zero using `NULLIF`
- Prevented circular dependency by conditionally refining:
  - Sales only when price is valid
  - Price only when sales is valid

---

### 4️⃣ ERP Customer Information (`silver_erp_cust_az12`)
Applied checks and transformations:
- Harmonized customer IDs (`NAS` prefix removal)
- Validation of birth dates (no future dates)
- Deep cleansing of gender column:
  - Removal of hidden characters (CHAR(9), CHAR(10), CHAR(13), CHAR(32)
  - Standardization to `Male` / `Female`
- Invalid values mapped to `n/a`

---

### 5️⃣ ERP Customer Location (`silver_erp_loc_a101`)
Applied checks and transformations:
- Harmonized customer IDs (removed special characters)
- Cleansed country values
- Standardized country codes (`US`, `USA` → United States)
- Removed hidden whitespace and control characters

---

### 6️⃣ ERP Product Category (`silver_erp_px_cat_g1v2`)
Applied checks and transformations:
- Ensured category IDs align with CRM product data
- Corrected inconsistent category codes
- Standardized text fields
- Removed hidden newline characters in maintenance field

---

## Load Strategy
- Full load
- `INSERT INTO … SELECT`
- Deterministic transformations

## Purpose
- Enforce data quality rules
- Standardize and normalize data
- Prepare clean, reliable data for dimensional modeling
