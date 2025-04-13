library(tseries)
library(TSA)
library(forecast)
library(rugarch)


file_path <- "/Users/nayanikaranjan/Stevens/Fall_Semester_2023/MA641 Time Series/Sem Project/sp500.csv"

# Read the CSV file into a data frame 
sp500 <- read.csv(file_path, header = TRUE)

# Convert 'Date' column to Date format
sp500$Date <- as.Date(sp500$Date, format = "%Y-%m-%d")

# Check the structure and summary of the data
str(sp500)
summary(sp500)

# Checking the "Date" column is in Date format
sp500Date <- as.Date(sp500$Date)
sp500Close <-  sp500$Close

# Plot the "Close" feature over time 
plot(sp500Date, sp500Close, type = "l", col = "lightblue", lwd = 2,
     xlab = "Date", ylab = "Close Price", main = "S&P500 Close Price Over Time",
     sub = "From 1/1/10 to 11/30/23", cex.main = 1.2, cex.sub = 0.8)
grid()
legend("topleft", legend = "Close Price", col = "lightblue", lwd = 2, cex = 0.8)


# ACF and PACF plots for sp500Close
par(mfrow = c(2, 1)) 
acf(sp500Close, main = "ACF for S&P500Close", cex.main = 1.2, lag.max = 100)
pacf(sp500Close, main = "PACF for S&P500Close", cex.main = 1.2, lag.max =100)

# ADF test to check for stationary 
adf_result <- adf.test(sp500Close)
print(adf_result)

# ADF test on the first difference
sp500_close_diff <- diff(sp500Close)
adf_diff <- adf.test(sp500_close_diff)
print(adf_diff)

# Plot differenced series 
par(mfrow = c(1, 1)) 
plot(sp500Date[-1], sp500_close_diff, type = "o", col = "lightblue", lwd = 2,
     xlab = "Date", ylab = "y", main = "S&P500 Close After First Differencing", cex.main = 1.2)
grid()

# ACF and PACF on the differenced series
par(mfrow = c(2, 1)) 
acf(sp500_close_diff, main = "ACF for S&P500Close", cex.main = 1.2, lag.max = 100)
pacf(sp500_close_diff, main = "PACF for S&P500Close", cex.main = 1.2, lag.max =100)
eacf(sp500_close_diff)

# Implementing ARIMA GARCH model
# Auto ARIMA
arima_model <- auto.arima(sp500Close)
arima_model

# Summary of the ARIMA model
summary(arima_model)

# Print optimization output
print(arima_model$optim.output)

# Manual ARIMA with specified order (2,1,4)
ns_model1 = arima(sp500Close, order=c(2,1,4))
print(ns_model1)

# Extract nonseasonal residuals
nonseasonal_residuals_model1 = ns_model1$residuals

# Plotting residuals
par(mfrow = c(1, 1)) 
plot(nonseasonal_residuals_model1, type='o')

# ACF and PACF of residuals
par(mfrow = c(2, 1)) 
acf(nonseasonal_residuals_model1)
pacf(as.vector(nonseasonal_residuals_model1))

# QQ plot of residuals
par(mfrow = c(1, 1)) 
qqnorm(nonseasonal_residuals_model1)
qqline(nonseasonal_residuals_model1)

# Histogram of residuals
hist(nonseasonal_residuals_model1)

# Shapiro-Wilk normality test
print(shapiro.test(nonseasonal_residuals_model1))

# Check residuals using checkresiduals function
checkresiduals(nonseasonal_residuals_model1)

# Reset plotting layout
par(mfrow = c(1, 1))

# Forecast using ARIMA model
model1 <- arima(ts(sp500Close, frequency = 12, start = c(2010, 1)), order = c(2, 1, 4))
model1$x <- ts(sp500Close, frequency = 12, start = c(2010))
f = forecast(model1, level = c(95), h = 24)
plot(f)

# Fit GARCH model
temp_data_garch <- as.numeric(sp500Close)
spec <- ugarchspec(
  variance.model = list(
    model = "sGARCH",
    garchOrder = c(1, 1),
    submodel = NULL,
    external.regressors = NULL,
    variance.targeting = FALSE
  ),
  mean.model = list(
    armaOrder = c(2, 1, 4),  # ARIMA(2,1,4)
    external.regressors = NULL
  ),
  distribution.model = "norm"
)
garch2 <- ugarchfit(spec = spec, data = temp_data_garch, solver.control = list(trace = 0))

# Display GARCH model results
print(garch2)
plot(garch2, which='all')

# Forecast the next 20 periods using GARCH
forecast1 <- ugarchforecast(fitORspec = garch2, n.ahead = 20)

# Plot the fitted values and forecasted values
plot(fitted(forecast1), type = 'l', col = 'blue', main = 'Fitted Values', ylab = 'Value')

# Plot conditional volatility (sigma)
plot(sigma(forecast1), type = 'l', col = 'blue', main = 'Conditional Volatility (sigma)', ylab = 'Volatility')

# Concatenate the original series and forecasted series
series <- c(temp_data_garch, rep(NA, length(fitted(forecast1))))
forecastseries <- c(rep(NA, length(temp_data_garch)), fitted(forecast1))

# Plot the original and forecasted series
par(mfrow = c(1, 1))
plot(series, type = "l", col = "blue", main = "Original and Forecasted Series", ylab = "Value")
lines(forecastseries, col = "red")
legend("topleft", legend = c("Original Series", "Forecasted Series"), col = c("blue", "red"), lty = 1)
# Add grid
grid()


