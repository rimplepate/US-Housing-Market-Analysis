select * from `housing_macroeconomic_factors_us (2)`;


SELECT
    Date,
    house_price_index,
    ROUND(
        (house_price_index - LAG(house_price_index) OVER (ORDER BY Date))
        * 100.0 / LAG(house_price_index) OVER (ORDER BY Date),
        2
    ) AS yoy_house_price_change_pct
FROM `housing_macroeconomic_factors_us (2)`
ORDER BY Date;

SELECT
    Date,
    mortgage_rate,
    house_price_index
FROM `housing_macroeconomic_factors_us (2)`
ORDER BY mortgage_rate DESC
LIMIT 10;

SELECT 
    (COUNT(*) * SUM(employment_rate * house_price_index) - SUM(employment_rate) * SUM(house_price_index)) / 
    (SQRT((COUNT(*) * SUM(POW(employment_rate, 2)) - POW(SUM(employment_rate), 2)) * (COUNT(*) * SUM(POW(house_price_index, 2)) - POW(SUM(house_price_index), 2)))) 
    AS employment_vs_house_price_corr
FROM `housing_macroeconomic_factors_us (2)`
WHERE employment_rate IS NOT NULL 
  AND house_price_index IS NOT NULL;
  
  WITH YearlyData AS (
    -- Step 1: Aggregate monthly/quarterly data into annual averages
    SELECT 
        EXTRACT(YEAR FROM STR_TO_DATE(Date, '%Y-%m-%d')) AS Year,
        AVG(gdp) AS avg_gdp,
        AVG(house_price_index) AS avg_hpi
    FROM `housing_macroeconomic_factors_us (2)`
    GROUP BY Year
),
GrowthCalculations AS (
    -- Step 2: Use LAG to get the previous year's values and calculate % growth
    SELECT 
        Year,
        avg_gdp,
        avg_hpi,
        ((avg_gdp - LAG(avg_gdp) OVER (ORDER BY Year)) / LAG(avg_gdp) OVER (ORDER BY Year)) * 100 AS gdp_growth_pct,
        ((avg_hpi - LAG(avg_hpi) OVER (ORDER BY Year)) / LAG(avg_hpi) OVER (ORDER BY Year)) * 100 AS hpi_appreciation_pct
    FROM YearlyData
)
-- Step 3: Final ranking
SELECT 
    Year,
    ROUND(gdp_growth_pct, 2) AS gdp_growth_pct,
    ROUND(hpi_appreciation_pct, 2) AS hpi_appreciation_pct
FROM GrowthCalculations
WHERE gdp_growth_pct IS NOT NULL -- Exclude the first year (no prior year to compare)
ORDER BY hpi_appreciation_pct DESC, gdp_growth_pct DESC;

SELECT 
    CASE 
        WHEN ppi_res > (SELECT AVG(ppi_res) FROM `housing_macroeconomic_factors_us (2)`) THEN 'High Inflation (Above Avg PPI)'
        ELSE 'Low Inflation (Below Avg PPI)'
    END AS inflation_period,
    ROUND(AVG(house_price_index), 2) AS avg_house_price_index,
    ROUND(AVG(ppi_res), 2) AS avg_ppi_in_period,
    COUNT(*) AS total_months
FROM `housing_macroeconomic_factors_us (2)`
WHERE ppi_res IS NOT NULL AND house_price_index IS NOT NULL
GROUP BY inflation_period;

WITH PeriodicChanges AS (
    -- Step 1: Get current and previous values to identify growth/contraction
    SELECT 
        STR_TO_DATE(Date, '%Y-%m-%d') AS Report_Date,
        gdp,
        house_price_index,
        LAG(gdp) OVER (ORDER BY STR_TO_DATE(Date, '%Y-%m-%d')) AS prev_gdp,
        LAG(house_price_index) OVER (ORDER BY STR_TO_DATE(Date, '%Y-%m-%d')) AS prev_hpi
    FROM `housing_macroeconomic_factors_us (2)`
),
EconomicStatus AS (
    -- Step 2: Define "Recession" as any period where GDP is lower than the previous period
    SELECT 
        Report_Date,
        house_price_index,
        ((house_price_index - prev_hpi) / prev_hpi) * 100 AS hpi_growth_pct,
        CASE 
            WHEN gdp < prev_gdp THEN 'Recession (GDP Contraction)'
            ELSE 'Expansion (GDP Growth)'
        END AS economy_phase
    FROM PeriodicChanges
    WHERE prev_gdp IS NOT NULL -- Exclude the very first record
)
-- Step 3: Compare HPI behavior between the two phases
SELECT 
    economy_phase,
    COUNT(*) AS total_periods,
    ROUND(AVG(hpi_growth_pct), 4) AS avg_hpi_growth_pct,
    ROUND(MIN(hpi_growth_pct), 4) AS steepest_hpi_drop,
    ROUND(MAX(hpi_growth_pct), 4) AS highest_hpi_gain
FROM EconomicStatus
GROUP BY economy_phase;

SELECT 
    Date,
    house_price_index,
    -- 3-Year Moving Average (36 trailing months)
    AVG(house_price_index) OVER (
        ORDER BY STR_TO_DATE(Date, '%Y-%m-%d') 
        ROWS BETWEEN 35 PRECEDING AND CURRENT ROW
    ) AS hpi_3yr_moving_avg,
    -- 5-Year Moving Average (60 trailing months)
    AVG(house_price_index) OVER (
        ORDER BY STR_TO_DATE(Date, '%Y-%m-%d') 
        ROWS BETWEEN 59 PRECEDING AND CURRENT ROW
    ) AS hpi_5yr_moving_avg
FROM `housing_macroeconomic_factors_us (2)`
ORDER BY STR_TO_DATE(Date, '%Y-%m-%d');

