#################################
# LOAD RELEVANT DATA & SHAPE IT #
#################################

#read 1st & 2nd Fed 2007 data only

#initialize required dataset to NULL
matchedLines <- c()

#open file to stream from
dataFileConnection <- file("./exdata-data-household_power_consumption/household_power_consumption.txt", open="r")

#line counter counters
ctr.line=0
ctr.validline=0
while(length(oneLine <- readLines(dataFileConnection, n = 1, warn = FALSE)) > 0) {
  ctr.line<-ctr.line+1
  if(ctr.line==1) {
    #exception to capture the header
    boolMatched <- TRUE
  } else {
    boolMatched <- grepl("^[12]/2/2007", oneLine) #get index vector for 1st & 2nd Fed 2007 data only  
  }
  if(boolMatched) {
    ctr.validline<-ctr.validline+1
    matchedLines<-c(matchedLines, oneLine) #append all criteria matched lines
  }
}

close(dataFileConnection)

print(paste("Total Lines= ", ctr.line))
print(paste("Total ValidLines= ", ctr.validline))

#We now have the relevant data in text line format in the object matchedLines
#convert this to Data frame for processing
txtCon <- textConnection(matchedLines, "r")
DF <- read.table(txtCon,
                 header=TRUE, 
                 na.strings = "?", 
                 sep=";", 
                 colClasses=c(rep('character', 2), rep('numeric', 7)))
close(txtCon)

# convert Date and Time variables to Date/Time classes, and append them to form one column
DF$Date <- as.Date(DF$Date , "%d/%m/%Y")
DF$Time <- paste(DF$Date, DF$Time, sep=" ")
DF$Time <- strptime(DF$Time, "%Y-%m-%d %H:%M:%S")

#################################
# PLOT TO PNG DEVICE            #
#################################

# Open png device
png(filename='./plot2.png', width = 480, height = 480)

# Make plot
plot(DF$Time, DF$Global_active_power, ylab='Global Active Power (kilowatts)', xlab='', type='l')

# Turn off device
dev.off()
