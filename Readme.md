# High-Frequency Forecasting: S&P 500 and Fisheries

## Project Overview
This project involves the application of advanced time series analysis and forecasting techniques to two distinct datasets: monthly Scallop sales over a 26-year period and the S&P 500 index from Yahoo Finance. The goal is to predict future trends and extract actionable insights from both the fisheries and financial markets, leveraging models like ARIMA, SARIMA, and GARCH.

## Key Objectives
- Perform time series analysis on historical sales data of Scallops and the S&P 500 index.
- Apply statistical models (ARIMA, SARIMA, GARCH) for forecasting and trend prediction.
- Provide insights that could support strategic decision-making in both fisheries and finance.
  
## Models Used
1. **ARIMA (AutoRegressive Integrated Moving Average)**: For modeling non-seasonal time series data.
2. **SARIMA (Seasonal ARIMA)**: For modeling data with seasonal patterns.
3. **GARCH (Generalized Autoregressive Conditional Heteroskedasticity)**: For modeling and forecasting volatility in financial data.

## Tools and Technologies
- **R Programming**: The primary programming language for performing time series analysis.
- **Libraries**:
  - `forecast`: For ARIMA and SARIMA modeling.
  - `rugarch`: For GARCH model implementation.
  - `tseries`, `TSA`: For statistical tests and time series analysis.
  - `ggplot2`: For visualizations.

## Datasets
1. **Scallop Sales Data**: A 26-year dataset containing monthly sales data for Scallops sourced from NOAA Fisheries Economics.
2. **S&P 500 Data**: Historical S&P 500 index data, sourced from Yahoo Finance, capturing the close prices over a significant time period.

## Methodology
### Data Preprocessing:
- **Stationarity Testing**: Applied the Augmented Dickey-Fuller (ADF) test to check the stationarity of the data and performed necessary transformations (e.g., differencing) for non-stationary series.
  
### Model Selection:
- **ARIMA & SARIMA**: Identified optimal parameters using ACF/PACF plots and model selection criteria (AIC, BIC).
- **GARCH**: Applied to model and forecast volatility patterns in the financial time series (S&P 500).
  
### Model Evaluation:
- **Residual Diagnostics**: Ensured model adequacy by analyzing residuals with statistical tests (e.g., Ljung-Box, Shapiro-Wilk).
- **Forecasting**: Utilized the selected models to predict future values and visualize the forecasted trends.

## Results
- The SARIMA model for Scallop sales successfully predicted future trends based on historical data.
- The ARIMA model for the S&P 500 showed strong fit, with forecasts indicating future index movements.
- The GARCH model effectively captured the volatility patterns in the S&P 500, providing forecasts of conditional variance.

## How to Run the Code
1. Clone the repository to your local machine.

`git clone https://github.com/your-username/Time-Series-Analysis.git`

2. Install the required R libraries (if not already installed)

`install.packages(c("forecast", "rugarch", "ggplot2", "tseries", "TSA"))`

3. Load the datasets and run the analysis in RStudio or any R environment.

4. Modify the input files if you wish to run with different datasets.

## Conclusion
This project showcases the practical application of time series analysis and forecasting using ARIMA, SARIMA, and GARCH models. The predictive insights derived from this analysis can be valuable for industries dealing with both seasonal sales data (fisheries) and financial market trends (stock indices).# high-freq-forecasting
