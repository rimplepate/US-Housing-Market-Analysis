# Year-over-Year % Change in House Price Index
SELECT 
    Date,
    House_Price_Index,
    ROUND(
        (House_Price_Index - LAG(House_Price_Index) OVER (ORDER BY Date)) 
        * 100.0 / LAG(House_Price_Index) OVER (ORDER BY Date), 2
    ) AS YoY_HPI_Change
FROM `housing_macroeconomic_factors_us (2)`;

#Periods with Highest Mortgage Rates
SELECT 
    Date,
    Mortgage_Rate,
    House_Price_Index
FROM housing_macro
ORDER BY Mortgage_Rate DESC
LIMIT 10;

#GDP Growth vs House Prices
SELECT 
    Date,
    Real_GDP,
    House_Price_Index
FROM housing_macro
ORDER BY Real_GDP DESC;

#Average House Prices During High Inflation
SELECT 
    CASE 
        WHEN Inflation > 4 THEN 'High Inflation'
        ELSE 'Low Inflation'
    END AS Inflation_Category,
    ROUND(AVG(House_Price_Index),2) AS Avg_House_Price
FROM `housing_macroeconomic_factors_us (2)`
GROUP BY Inflation_Category;

#Moving Average of House Prices (3 Period)
SELECT
    Date,
    House_Price_Index,
    ROUND(AVG(House_Price_Index) OVER (
        ORDER BY Date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ),2) AS Moving_Avg_3
FROM `housing_macroeconomic_factors_us (2)`;


