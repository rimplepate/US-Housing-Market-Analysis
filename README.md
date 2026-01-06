# US Housing Market Analysis: Macroeconomic Drivers & Modeling
This project explores the relationship between various macroeconomic factors and the US House Price Index (HPI) from 1987 to 2021. It combines SQL-based data engineering with Python-driven Exploratory Data Analysis (EDA) and Machine Learning to identify key predictors of housing price fluctuations.

📊 Project Overview
The primary goal of this analysis is to understand how national-level economic indicators—such as GDP, mortgage rates, and employment—impact the residential housing market. The project utilizes a dataset containing 425 monthly observations.

Key Features Analyzed:

House Price Index (HPI): The target variable representing housing value trends.

Economic Indicators: GDP, Mortgage Rates, Employment Rate, and Producer Price Index (PPI) for Residential Construction.

Supply & Demand: Housing supply (months' supply), new permits, and population growth.

Monetary & Risk Factors: M3 Money Supply, Consumer Confidence Index (CCI), and Delinquency Rates.

🛠️ Tech Stack
Database: SQL (BigQuery/MySQL) for data cleaning, year-over-year (YoY) change calculations, and correlation analysis.

Programming: Python (Pandas, NumPy).

Visualization: Matplotlib, Seaborn.

Machine Learning: Scikit-learn (Linear Regression).

📁 File Structure
Housing_Market_EDA_&_Modeling.ipynb: A comprehensive Jupyter Notebook containing data preprocessing, feature engineering (percentage change calculations), data visualization, and a predictive model.

Housing_market_analysis.sql: A collection of SQL queries designed for:

Calculating YoY house price changes.

Analyzing the impact of mortgage rates on HPI.

Measuring correlations between employment and house prices.

Defining economic phases (Recession vs. Expansion) based on GDP trends.

📈 Key Insights & Modeling
Data Engineering

In both the SQL and Python workflows, raw values were converted into percentage changes to normalize the data and better capture growth trends rather than absolute values.

Predictive Modeling

A Linear Regression model was implemented to quantify the influence of various factors. Based on the coefficients, the following features showed significant impact:

PPI (Residential Construction): High positive correlation (0.121), indicating that rising construction costs are a primary driver of house prices.

Employment Rate: Strong positive impact (0.108), highlighting the link between job market health and housing demand.

GDP: Significant contributor (0.076) reflecting overall economic health.

🚀 How to Use
SQL Analysis: Run the queries in Housing_market_analysis.sql on your SQL environment (ensure the table name matches your database) to see high-level trends and recession impacts.

Python Analysis:  Install requirements: pip install pandas numpy matplotlib seaborn scikit-learn

Open Housing_Market_EDA_&_Modeling.ipynb to view the full data science pipeline, from missing value handling to model evaluation.
