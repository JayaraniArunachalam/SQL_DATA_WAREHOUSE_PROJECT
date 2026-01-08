# SQL_DATA_WAREHOUSE_PROJECT (Medallion Architecture)
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. 

## 🔹 Project Objective
To design and implement a scalable SQL-based data warehouse by integrating data from multiple source systems (CRM & ERP), applying data quality checks, standardization, and business transformations, and delivering analytics-ready data models.

---

## 🔹 Data Sources
CSV files representing data from:
- **CRM System**
  - Customer details
  - Product details
  - Sales transactions
- **ERP System**
  - Customer additional attributes
  - Customer location
  - Product category information

---

## 🔹 Architecture Overview
The data architecture for this project follows **Medallion Architecture** containing **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](https://github.com/JayaraniArunachalam/SQL_DATA_WAREHOUSE_PROJECT/blob/main/diagrams/Data%20Architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into the MySQL database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

### 🥉 Bronze Layer (Raw Data)
- Stores raw data as-is from source CSV files
- No transformations applied
- Supports full load using truncate & insert
- Purpose: Traceability and audit

### 🥈 Silver Layer (Cleansed & Standardized Data)
- Data quality checks (NULLs, negative values, inconsistencies)
- Standardization of text fields
- Business rule validation
- Data enrichment across CRM and ERP sources

### 🥇 Gold Layer (Business-Ready Data)
- Analytical views created:
  - `dim_customers`
  - `dim_products`
  - `fact_sales`
- Star-schema based modeling
- Optimized for reporting and ad-hoc analysis

---

## 🔹 Diagrams
All diagrams were designed using **draw.io**:
- Data Architecture Diagram
- Data Flow Diagram
- Data Integration Diagram
- Data Model Diagram

(Refer to `/diagrams` folder)

---

## 🔹 Key Learnings
- Designing a SQL Data Warehouse using Medallion Architecture
- Implementing robust data quality checks
- Avoiding circular dependency in transformations
- Applying dimensional modeling concepts
- Writing production-ready SQL
- Documenting and structuring a real-world data project

---

## 🔹 Tools & Technologies
- MYSQL
- SQL (DDL, DML, Window Functions, CASE logic)
- CSV files
- draw.io
- GitHub

---

## 📂 Repository Structure

```
SQL_DATA_WAREHOUSE_PROJECT/
│
├── README.md
│
├── diagrams/
│   ├── data_architecture.png
│   ├── data_flow.png
│   ├── data_integration.png
│   └── data_model.png
│
├── datasets/
│   ├── crm_sales_details.csv
│   ├── crm_cust_info.csv
│   ├── crm_prd_info.csv
│   ├── erp_cust_az12.csv
│   ├── erp_loc_a101.csv
│   └── erp_px_cat_g1v2.csv
│
├── scripts/
│   ├── 01_create_databases.sql
│   ├── 02_ddl_bronze.sql
│   ├── 03_load_bronze.sql
│   ├── 04_bronze_data_quality_checks.sql
│   ├── 05_bronze_data_cleansing.sql
│   ├── 06_ddl_silver.sql
│   ├── 07_load_silver.sql
│   ├── 08_gold_views.sql
│
├── bronze/
│   └── README.md
│
├── silver/
│   └── README.md
│
└── gold/
    └── README.md
```

[Connect with me on LinkedIn](https://www.linkedin.com/in/jayarani-arunachalam-23jun1990/)
## 🔹 Acknowledgements
The project is inspired by **Baraa Khatib Salkini’s - Data with Baraa** and guided by **Mrs. Sneha Srinath (Founder – Mom Analysts Hub)**.
- [**Baraa Khatib Salkini**](https://www.linkedin.com/in/baraa-khatib-salkini/) –  
  [![Data with Baraa](https://img.shields.io/badge/Data_with_Baraa-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@DataWithBaraa)
- [**Mrs. Sneha Srinath**](https://www.linkedin.com/in/sneha-srinath/)– Founder, [Mom Analysts Hub](https://www.linkedin.com/company/mom-analysts-hub/posts/?feedView=all)

---

⭐ If you find this project useful, feel free to star the repository!
