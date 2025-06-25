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


#Pending##convert the Date and Time variables to Date/Time classes
data$DateTime <- strptime(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
hpc_data$Date <- as.Date(hpc_data$Date, format = "%d/%m/%Y")
