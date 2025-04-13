# Loading libraries
library(zoo)
library(ggplot2)
library(forecast)
library(TSA)
library(tseries)

file_path <- "/Users/nayanikaranjan/Stevens/Fall_Semester_2023/MA641 Time Series/Sem Project/scallops.csv"

# Read the CSV file into a data frame 
scallop <- read.csv(file_path, header = TRUE)
scallop

# Convert the Date column to Date format
scallop$Date <- as.Date(scallop$Date, format = "%m/%d/%y")
scallop$Date

# Create a time series object with frequency 12
scallop_ts <- ts(scallop$Sales, frequency = 12, start = c(1986, 1))

# Plot the time series
plot(scallop_ts, ylab = 'Scallop Sales', main = 'Scallop Sales Over Time')
plot(scallop_ts, ylab = 'Scallop Sales',main = 'Scallop Sales Over Time', type = "o",col = 'maroon', lwd = 2)
grid(col = 'gray', lty = 2)
legend("topright", legend = "Time Series Plot of Scallop Sales", col = "maroon", lwd = 2, cex = 0.8)

# ACF and PACF plots for Scallops Sales
par(mfrow = c(2, 1))
acf(as.vector(scallop_ts), main = "ACF for Scallop Sales", lag.max =100)
pacf(as.vector(scallop_ts), main = "PACF for Scallop Sales", lag.max =100)

# ADF test to check for stationary
adf_result <- adf.test(scallop_ts)
print(adf_result)

# Calculate the first difference of the time series
scallop_diff <- diff(scallop_ts)

# ADF test to check for stationary
adf_result <- adf.test(scallop_diff)
print(adf_result)

par(mfrow = c(1, 1))
plot(scallop_diff, ylab = 'First Difference of Scallop Sales', 
     main = 'First Difference of Scallop Sales Over Time', type = "o",col = 'maroon', lwd = 2)
grid(col = 'gray', lty = 2)
legend("topright", legend = "First Difference of Scallop Sales", col = "maroon", lwd = 2, cex = 0.8)

# ACF and PACF plots for Scallops Sales
par(mfrow = c(2, 1))
acf(as.vector(scallop_diff), main = "ACF for First Difference Scallop Sales", lag.max =100)
pacf(as.vector(scallop_diff), main = "PACF for First Difference Scallop Sales", lag.max =100)

# Fit different SARIMA(p,d,q)(P,D,Q)S models
orders <- c(0, 1, 2, 3, 4, 6, 7)
seasonal_orders <- c(1, 2, 3, 4, 5)

best_model_aic <- NULL
best_model_bic <- NULL
best_aic_value <- Inf
best_bic_value <- Inf

for (p in orders) {
  for (P in seasonal_orders) {
    order <- c(p, 1, 0)
    seasonal_order <- c(P, 0, 0)
    sarima_model <- Arima(scallop_diff, order = order, seasonal = list(order = seasonal_order, period = 12))

    aic_value <- AIC(sarima_model)
    bic_value <- BIC(sarima_model)

    # Check if the current model has lower AIC value
    if (aic_value < best_aic_value) {
      best_aic_value <- aic_value
      best_model_aic <- list(order = order, seasonal_order = seasonal_order, AIC = aic_value)
    }

    # Check if the current model has lower BIC value
    if (bic_value < best_bic_value) {
      best_bic_value <- bic_value
      best_model_bic <- list(order = order, seasonal_order = seasonal_order, BIC = bic_value)
    }
  }
}


if (identical(best_model_aic, best_model_bic)) {
  cat("Best Model (AIC/BIC):\n")
  print(best_model_aic)
  cat("\n")
} else {
  cat("Best Model (AIC):\n")
  print(best_model_aic)
  cat("\n")

  cat("Best Model (BIC):\n")
  print(best_model_bic)
  cat("\n")
}


# # Assuming best_model_aic is the best SARIMA model based on AIC
best_model_aic <- Arima(scallop_diff, order = c(7,1,0), seasonal = list(order = c(5,0,0), period = 12))
# par(mfrow = c(1, 1))
# plot(best_model_aic)

set.seed(123)
par(mfrow = c(1, 1))
# Residual diagnostics
checkresiduals(best_model_aic)

# Create a QQ plot for SARIMA(7,1,0)x12(5,0,0)
set.seed(123)
par(mfrow = c(1, 1))
residuals <- residuals(best_model_aic)

#Shapiro Test to check normality
print(shapiro.test(residuals))

# Assuming 'residuals' is your vector of residuals
plot(residuals, type='o', col='darkblue', pch=16, xlab='Date', ylab='Residuals', main='Residuals Plot')
grid(col = 'darkblue', lty = 2)

qqnorm(residuals)
qqline(residuals, col = 2)

# Reset the plotting layout
par(mfrow = c(1, 1))

# Ensure the time index is in order
scallop_diff <- ts(scallop_diff, start = c(1986, 1), frequency = 12)

# Define training set and test set
train_set <- window(scallop_diff, end = c(2009, 12))
test_set <- window(scallop_diff, start = c(2010, 1))

# ADF test to check for stationary
adf_result <- adf.test(test_set)
adf_result

# Fit SARIMA model on the training set
forecast_model <- Arima(train_set, order = c(7, 1, 0), seasonal = list(order = c(5, 1, 0), period = 12))

# Forecast future values from 2009 to 2025
forecast_values <- forecast(forecast_model, h = 192)  


# Plotting original and forecasted scallop sales
plot(scallop_diff, col = 'darkblue', type = 'o', lwd = 2, main = 'Original and Forecasted Scallop Sales')

# Adding color labels
legend('topright', legend = c('Original', 'Test Set', 'Forecasted'),
       col = c('darkblue', 'red', 'green'), lty = c(1, 2, 1), lwd = 2, bg = 'white')

# Plotting test set as a dotted line
lines(test_set, col = 'red', type = 'l', lwd = 2, lty = 2)

# Plotting forecasted values
lines(forecast_values$mean, col = 'green', type = 'o', lwd = 2)

# Adding grid lines
grid()



