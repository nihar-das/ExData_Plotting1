library("dplyr")
library("readr")

dataset_name <- "household_power_consumption.txt"

# read only required data and parse the columns with apropriate datatypes
data <- read_delim(dataset_name,  col_names = TRUE, 
                   delim = ";", col_types = cols(Date = col_date("%d/%m/%Y"), Global_active_power = "n"),
                   col_select = c(1, 3), na = c("?")) %>%
        filter(Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

#generate histogram with proper label and title
hist(data$Global_active_power, xlab = "Global Active Power(kilowatts)", ylab = "Frequency", col = "red")

#copy the histogram to a png device
dev.copy(png, file = "plot1.png")
dev.off()