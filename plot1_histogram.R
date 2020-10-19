#read libraries
library(RCurl)
library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)

#download and read file
URL <-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
destfile <- paste0(getwd(),"/","exdata_data_household_power_consumption.zip")
download.file(URL,destfile,method = "curl")
dataset <- read_delim("exdata_data_household_power_consumption.zip",delim = ";",
                      na = c("", "NA", "?"))

#extracting dates 2007-02-01 and 2007-02-02
dataset <- filter(dataset, dataset$Date == "1/2/2007" | dataset$Date == "2/2/2007")

#changing column Date type, adding column "Date-Time"
dataset$Date <- as.Date(dataset$Date, "%d/%m/%Y")
temp <- as.POSIXct(paste0(dataset$Date, dataset$Time), format = "%Y-%m-%d %H:%M:%S")
dataset <- mutate(dataset, Date_Time = temp)
remove(temp, destfile, URL)

#create and save plot1
png(file = "plot1.png")
ggplot(dataset, aes(x=Global_active_power)) +
  geom_histogram(color="black", fill="red", position="identity", alpha=0.5)+
  geom_density(alpha=0.6)+
  labs(title="Global active power", x="Global active power (kilowatts)", y = "Frequency")+
  theme_classic()
dev.off()