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

# Convert and combine Date & Time column to Date/ Time class
hpc_data$Date <- as.Date(hpc_data$Date, format = "%d/%m/%Y")
hpc_data$DateTime <- strptime(paste(hpc_data$Date, hpc_data$Time), format = "%Y-%m-%d %H:%M:%S")

# or create a DateTime Variable
hpc_data$DateTime <- as.POSIXct(paste(hpc_data$Date, hpc_data$Time))

#Removing the irrelevant columns
hpc_data <- hpc_data[, !(names(hpc_data) %in% c("Date", "Time"))]


#Plotting the 4th graph
#saving the file as png with required width and height
png("plot4.png", width = 480, height = 480)

#set a 2x2 dimension plot
par(mfrow = c(2,2))

#The top left plot
plot(hpc_data$DateTime, hpc_data$Global_active_power, 
     type = "l", xlab = "", ylab = "Global Active Power",
xaxt = "n") #removing x axis to reset with labels

#setting tick positions of dates Feb 1, Feb 2 midnight
tick_positions <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))



#Top right
plot(hpc_data$DateTime, hpc_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage",
     xaxt = "n") #removing axis to replace with days
tick_positions <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))


#Bottom left plot
plot(hpc_data$DateTime, hpc_data$Sub_metering_1, type = "l", xlab = "",
     ylab = "Energy sub metering",
     xaxt = "n") #removing x axis to reset with weekdays labels

#setting tick positions of dates Feb 1, Feb 2 midnight
tick_positions <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))
lines(hpc_data$DateTime, hpc_data$Sub_metering_2, col = "red")
lines(hpc_data$DateTime, hpc_data$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       lty = 1, bty = "n")


#Bottom left plot
plot(hpc_data$DateTime, hpc_data$Global_reactive_power, 
     type = "l", xlab = "datetime", ylab = "Global_reactive_power", 
xaxt = "n") #removing x axis to rename to appropriate week days

#setting tick positions of dates Feb 1, Feb 2 midnight
tick_positions <- as.POSIXct(c("2007-02-01", "2007-02-02", "2007-02-03"))
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

dev.off()

