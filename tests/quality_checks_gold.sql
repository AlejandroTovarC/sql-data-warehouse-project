/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Check for gender information
-- Expectation: 3 Results. n/a, Male, Female
SELECT DISTINCT gender 
FROM gold.dim_customers

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for duplicates
-- Expectation: none
SELECT prd_key, count(*) FROM(
    SELECT 
        pn.prd_id,
        pn.cat_id,
        pn.prd_key,
        pn.prd_nm,
        pn.prd_cost,
        pn.prd_line,
        pn.prd_start_dt,
        pn.prd_end_dt,
        pc.cat,
        pc.subcat,
        pc.maintenance
      FROM silver.crm_prd_info pn
      LEFT JOIN silver.erp_px_cat_g1v2 pc
      ON pn.cat_id = pc.id
      WHERE pn.prd_end_dt IS NULL -- Filter out all historical data
  )t
  GROUP BY prd_key
  HAVING COUNT(*) > 1

  -- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check: if all dimension tables can successfully join to the fact table


-- Checking dim_customers -> fact_sales
-- Expectation: No Results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

-- Checking dim_product -> fact_sales
-- Expectation: No Results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key = p.product_key
WHERE p.product_key IS NULL

