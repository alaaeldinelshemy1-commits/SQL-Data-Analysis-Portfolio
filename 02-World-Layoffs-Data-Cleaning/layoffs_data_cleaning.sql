/* ============================================================================
   PROJECT 2: DATA CLEANING IN SQL (WORLD LAYOFFS DATASET)
   Tools: SQL Server (SSMS)
   Key Skills: Staging Tables, Deduplication (ROW_NUMBER), Standardization (TRIM, REPLACE),
               Self-Joins, Handling NULL Values
   ============================================================================ */

-- 1. Create a Staging Table to preserve raw data integrity
SELECT * 
INTO layoffs_staging 
FROM layoffs_raw;

-- 2. Identify & Remove Duplicate Records using CTE and ROW_NUMBER()
WITH CTE_Duplicates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, total_laid_off, [date], 
                         percentage_laid_off, industry, stage, funds_raised, country
            ORDER BY company
        ) AS RowNumber
    FROM layoffs_staging
)
DELETE 
FROM CTE_Duplicates
WHERE RowNumber > 1;

-- 3. Standardize Text Fields (Company Names, Country & Location)
UPDATE layoffs_staging
SET company = TRIM(company);

-- Unify duplicate country names
UPDATE layoffs_staging
SET country = 'United Arab Emirates'
WHERE country = 'UAE';

-- Clean location suffixes (', Non-U.S.') and special characters
UPDATE layoffs_staging
SET location = TRIM(REPLACE(location, ', Non-U.S.', ''))
WHERE location LIKE '%, Non-U.S.%';

UPDATE layoffs_staging
SET location = 'Dusseldorf'
WHERE location = N'Düsseldorf';

UPDATE layoffs_staging
SET location = 'Malmo'
WHERE location = N'Malmö';

-- 4. Handle NULL & Blank Values
-- Check if missing industries can be populated from other rows of the same company
SELECT t1.company, t1.industry AS Null_Industry, t2.industry AS Found_Industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
    ON t1.company = t2.company
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;

-- Standardize remaining unpopulated industries to 'Other'
UPDATE layoffs_staging
SET industry = 'Other'
WHERE industry IS NULL OR industry = '';

-- 5. Remove Unusable Rows (Where both layoff metrics are NULL)
DELETE 
FROM layoffs_staging
WHERE total_laid_off IS NULL 
  AND percentage_laid_off IS NULL;

-- Final Inspection of Clean Dataset
SELECT * 
FROM layoffs_staging;
