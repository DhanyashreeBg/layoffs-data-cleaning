-- Data Cleaning


SELECT * 
FROM layoffs;


CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT  layoffs_staging
SELECT * 
FROM layoffs;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- 1. Remove Duplicates

# First let's check for duplicates

SELECT * 
FROM layoffs_staging;

SELECT company, industry, total_laid_off,`date`,
   ROW_NUMBER() OVER(
	 PARTITION BY company, industry, total_laid_off, `date`)AS row_num
   FROM 
   layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`
, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`
, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging3
WHERE row_num > 1;

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`
, stage, country, funds_raised_millions)AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging3
WHERE row_num > 1;

SELECT *
FROM layoffs_staging3;


-- 2. Standardise the data

SELECT company, TRIM(company)
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging3
ORDER BY 1;

UPDATE layoffs_staging3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET date = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;




-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values




-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging3
SET industry = NULL 
WHERE industry = '';

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging3
WHERE company LIKE 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
  ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

UPDATE layoffs_staging3 t1
JOIN layoffs_staging3 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL ;

SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

-- Delete Useless data we can't really use

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

SELECT *
FROM layoffs_staging3;

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging3;