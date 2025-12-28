# SQL Sanitation: Cleaning Real-World Messy Data

## Project Overview
This project demonstrates **real-world data cleaning** using SQL on a synthetically generated messy student dataset. The dataset mimics common data quality issues like inconsistent formatting, missing values, mixed quotes, and irregular numeric and date formats.

The goal is to transform raw, unstructured data into a **clean, analytics-ready dataset** suitable for reporting, dashboards, or ML pipelines.

---

## Dataset
- **Size:** 500 records  
- **Columns:**
  - `student_name` → first + last names with single/double quotes
  - `date_of_birth` → mixed formats (`MMDDYYYY`, `MM/DD/YYYY`, `MM-DD-YYYY HH:MM:SS`, `MMDDYY`)
  - `state` → mix of codes, full names, uppercase/lowercase, and NULLs
  - `mobile_number` → formats like `XXX-XXX-XXXX`, `+1XXXXXXXXXX`, `1XXXXXXXXXX`, `XXXXXXXXXX`
  - `email` → valid emails with some NULLs
  - `gpa` → numeric as string or NULL

---

## Cleaning Steps (SQL)
1. **Create Raw Table:** All columns as `VARCHAR` to preserve original messy data.
2. **Generate Clean Table:** Standardized schema with proper data types.
3. **Column-wise Cleaning:**
   - `student_name`: removed quotes, split into `first_name` and `last_name`
   - `date_of_birth`: parsed all formats into `DATE`
   - `state`: standardized to 2-letter uppercase codes; missing states set as `'UN'`
   - `mobile_number`: stripped non-numeric characters and kept last 10 digits
   - `email`: lowercased; NULLs preserved
   - `gpa`: numeric values preserved; NULLs left intact
4. **Optional Imputation:** Missing GPA values can be imputed with mean/median for analytics (not applied here to preserve data integrity)

---

## SQL Best Practices
- Used `REPLACE`, `SUBSTRING_INDEX`, `REGEXP_REPLACE`, `CASE WHEN` for string and numeric normalization
- Joined raw → clean tables using a **row_id** to ensure safe updates
- Disabled **Safe Update Mode** in MySQL Workbench when performing bulk updates
- Preserved original data for auditability

---

## Project Outcome
- A fully **cleaned `clean_students` table** suitable for:
  - Analytics & reporting
  - Data visualization
  - Downstream ML pipelines
- Demonstrated advanced SQL cleaning techniques

---

## How to Run
1. Import `unclean_student_dataset_no_enrollment.csv` into MySQL (`raw_students`)  
2. Execute the provided SQL scripts to transform and populate `clean_students`  
3. Export the cleaned table to CSV:
   - Workbench: Right-click → Table Data Export Wizard  
   - OR Python: `pandas.to_csv()`

---

## Skills Demonstrated
- SQL string manipulation and regex
- Data type conversion and standardization
- Handling missing and inconsistent data
- Database best practices (row_id, primary keys, auditability)
- Reproducible data cleaning pipeline

---

## Interview Talking Points
- How to handle **dirty, real-world datasets**
- Why we keep NULLs vs. imputation
- Use of **CASE WHEN, REGEXP_REPLACE, STR_TO_DATE**
- Safe bulk updates and primary-key-based joins
- Balancing **data integrity vs analytics readiness**

