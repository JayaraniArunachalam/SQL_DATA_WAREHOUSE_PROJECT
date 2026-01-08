# SQL_DATA_WAREHOUSE_PROJECT (Medallion Architecture)
Data warehouse is a type of data architecture, a distinct and common model that organizes and stores data in a structured, centralized way, used for business intelligence and analytics. It is the blueprint for how data from various sources is integrated, cleaned, and stored in a central location to support decision-making. 

The project is inspired by **Baraa Khatib Salkini’s**[![](https://img.shields.io/badge/“Data_with_Baraa”-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@DataWithBaraa)
and guided by **Mrs. Sneha Srinath (Founder – Mom Analyst Hub)**.


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
The warehouse follows the **Medallion Architecture**:

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
- SQL Server
- SQL (DDL, DML, Window Functions, CASE logic)
- CSV files
- draw.io
- GitHub

---

## 🔹 Acknowledgements
- **Baraa Khatib Salkini** – Data with Baraa (YouTube)
- **Mrs. Sneha Srinath** – Founder, Mom Analyst Hub

---

⭐ If you find this project useful, feel free to star the repository!
