library("dplyr")
library("readr")

dataset_name <- "household_power_consumption.txt"

# read only required data and parse the columns with appropriate datatypes
data <- read_delim(dataset_name,  col_names = TRUE, 
                   delim = ";", col_select = -c(6) , na = c("?"),
                   col_types = cols(Date = col_date("%d/%m/%Y"), Time = col_time("%H:%M:%S"))
) %>%
  filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")) %>%
  mutate(DateTimeString = paste(Date, Time), DateTimeString = strptime(DateTimeString, format = "%Y-%m-%d %H:%M:%S"),
         weekday = weekdays(DateTimeString)) %>%
  select(-c(1:2))

# base time for custom x-axis label calculation
base_time = as.POSIXct(data$DateTimeString[1])

#prepare graphics grid
par(mfrow = c(2, 2), mar = c(4, 4, 4, 2))

# plot 1 graph
plot(data$DateTimeString, data$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "", xaxt = "n", cex = 0.1)
# add custom x-axis label at start of day 1, day2 and day3
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thu", "Fri", "Sat"))

# plot 2 graph
plot(data$DateTimeString, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage", xaxt = "n", cex = 0.1)
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thu", "Fri", "Sat"))

# plot 3 graph
plot(data$DateTimeString, data$Sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering", xlab = "", xaxt = "n")
lines(data$DateTimeString, data$Sub_metering_2, col = "red")
lines(data$DateTimeString, data$Sub_metering_3, col = "blue")

legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thu", "Fri", "Sat"))

# plot 4 graph
plot(data$DateTimeString, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", xaxt = "n", cex = 0.1)
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thu", "Fri", "Sat"))

#copy the histogram to a png device
dev.copy(png, file = "plot4.png")
dev.off()