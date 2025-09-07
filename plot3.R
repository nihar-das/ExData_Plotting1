library("dplyr")
library("readr")

dataset_name <- "household_power_consumption.txt"

# read only required data and parse the columns with appropriate datatypes
data <- read_delim(dataset_name,  col_names = TRUE, 
                   delim = ";", col_select = -c(3:6), na = c("?"),
                   col_types = cols(Date = col_date("%d/%m/%Y"), Time = col_time("%H:%M:%S"), Sub_metering_1 = "n", Sub_metering_2 = "n", Sub_metering_3 = "n")
                   ) %>%
  filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")) %>%
  mutate(DateTimeString = paste(Date, Time), DateTimeString = strptime(DateTimeString, format = "%Y-%m-%d %H:%M:%S"),
         weekday = weekdays(DateTimeString)) %>%
  select(-c(1:2))

# generate line plot
plot(data$DateTimeString, data$Sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering", xlab = "", xaxt = "n")
lines(data$DateTimeString, data$Sub_metering_2, col = "red")
lines(data$DateTimeString, data$Sub_metering_3, col = "blue")

#add legends to plot
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# add custom x-axis label at start of day 1, day2 and day3
base_time = as.POSIXct(data$DateTimeString[1])
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thursday", "Friday", "Saturday"))

#copy the histogram to a png device
dev.copy(png, file = "plot3.png")
dev.off()