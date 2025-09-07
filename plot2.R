library("dplyr")
library("readr")

dataset_name <- "household_power_consumption.txt"

# read only required data and parse the columns with appropriate datatypes
data <- read_delim(dataset_name,  col_names = TRUE, 
                   delim = ";", col_types = cols(Date = col_date("%d/%m/%Y"), Time = col_time("%H:%M:%S"), Global_active_power = "n"),
                   col_select = c(1:3), na = c("?")) %>%
        filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02")) %>%
        mutate(DateTimeString = paste(Date, Time), DateTimeString = strptime(DateTimeString, format = "%Y-%m-%d %H:%M:%S"),
               weekday = weekdays(DateTimeString)) %>%
        select(-c(1:2))

# generate histogram with proper label and title
plot(data$DateTimeString, data$Global_active_power, type = "l", ylab = "Global Active Power(kilowatts)", xlab = "", xaxt = "n")

# add custom x-axis label at start of day 1, day2 and day3
base_time = as.POSIXct(data$DateTimeString[1])
axis(1, at = c(base_time, base_time + (3600 * 24), base_time + (3600 * 24 * 2)), labels = c("Thursday", "Friday", "Saturday"))

#copy the histogram to a png device
dev.copy(png, file = "plot2.png")
dev.off()