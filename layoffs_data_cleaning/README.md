# Layoffs Data Cleaning Project

## Overview
This project demonstrates a complete **data cleaning workflow** using SQL on a layoffs dataset.  
The cleaned dataset can be used for analysis, visualization, and reporting.

## Steps Performed

1. **Duplicate Handling**  
   - Identified duplicates using `ROW_NUMBER()`  
   - Removed duplicates safely using staging tables

2. **Data Standardization**  
   - Trimmed spaces in text fields  
   - Standardized categorical values (`industry`, `country`)  
   - Converted `date` column to proper DATE format

3. **Null Values Handling**  
   - Kept nulls where appropriate  
   - Filled missing `industry` values using other rows of the same company

4. **Removing Unnecessary Data**  
   - Deleted rows missing key metrics (`total_laid_off`, `percentage_laid_off`)  
   - Dropped unneeded columns (`row_num`)

## Tools
- MySQL / MariaDB  
- SQL queries  


## Outcome
- Cleaned dataset ready for analysis  
- Dataset can be used for dashboards, visualizations, or further analysis

