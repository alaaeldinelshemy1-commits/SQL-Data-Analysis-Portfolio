# World Layoffs Data Cleaning Project (SQL)

## Project Overview
This project demonstrates an end-to-end **Data Cleaning pipeline in SQL Server** using the global tech layoffs dataset. Raw data often contains duplicate entries, inconsistent naming conventions, and missing values that can distort business intelligence reports.

## Data Cleaning Workflow
1. **Staging Environment:** Created a backup staging table (`layoffs_staging`) to perform transformations safely without altering the raw source data.
2. **Deduplication:** Identified and removed exact duplicate records using Common Table Expressions (`CTEs`) and `ROW_NUMBER()` partitioned across all key attributes.
3. **Data Standardization:**
   - Trimmed leading and trailing whitespaces from company names (`TRIM`).
   - Unified inconsistent country labels (e.g., standardizing `UAE` to `United Arab Emirates`).
   - Cleaned city names by removing redundant `, Non-U.S.` suffixes and normalizing special characters (`Düsseldorf`, `Malmö`).
4. **Handling Missing Data (`NULL`s):**
   - Verified missing industry records using a `Self Join` across company entries and standardized remaining unmapped records to `Other`.
   - Removed rows lacking both `total_laid_off` and `percentage_laid_off` values as they provide no analytical value.

## SQL Techniques Used
- **Window Functions:** `ROW_NUMBER() OVER (PARTITION BY ...)`
- **Data Manipulation:** `UPDATE`, `DELETE`, `SELECT INTO`
- **String & Conditional Functions:** `TRIM()`, `REPLACE()`, `LIKE`, `IS NULL`
- **Joins:** `Self Join` for cross-row validation
