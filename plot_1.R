#Install necessary packages 
install.packages("data.table")
install.packages("dplyr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("readr")
install.packages("tidyr")
install.packages("stringr")

#Load packages
library(readr)
library(data.table)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)


#Read only the relevant rows (1st and 2nd Feb 2007)
getwd()
list.files()
hpc_data <- read.table(pipe('findstr /B /R ^[1-2]/2/2007 household_power_consumption.txt'),
                       header=FALSE, sep=';', na.strings='?', stringsAsFactors=FALSE)

#Rename the columns with the appropriate names from the orignal data set

colnames(hpc_data) <- c("Date", "Time", 
                        "Global_active_power",
                        "Global_reactive_power", 
                        "Voltage",
                        "Global_intensity",
                        "Sub_metering_1",
                        "Sub_metering_2",
                        "Sub_metering_3")

#see the first head rows
head(hpc_data)

# Convert and combine Date & Time column to Date/ Time class
hpc_data$Date <- as.Date(hpc_data$Date, format = "%d/%m/%Y")
hpc_data$DateTime <- strptime(paste(hpc_data$Date, hpc_data$Time), format = "%Y-%m-%d %H:%M:%S")

# or create a DateTime Variable
hpc_data$DateTime <- as.POSIXct(paste(hpc_data$Date, hpc_data$Time))

#Removing the irrelevant columns
hpc_data <- hpc_data[, !(names(hpc_data) %in% c("Date", "Time"))]

#Create a png file with width 480 pixel and height 480 with Plot 1- Global active Power and frequency
png("plot1.png", width = 480, height = 480)
hist(hpc_data$Global_active_power, col = "red", main = "Global Active Power",
     xlab = "Gloabl Active Power (Kilowatts")

dev.off()


