require(data.table)
#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)
#Calculate Sum of Emissions, by Year
vals <- tapply(NEI$Emissions, NEI$year, sum)
#Scale emissions to thousands
vals <- vals/10^3
vals <- data.frame(x=as.integer(rownames(vals)),y=vals)

#Plot Info
Mean<-round(mean(vals$y),2) #For drawing Mean Line
xlim <- c(min(vals$x)-2,max(vals$x)+2)
ylim <- c(min(vals$y)-1000,max(vals$y)+1000)

#Plot
png(filename = "./Plot1.png")
plot(vals$y~vals$x,
     col="red",
     pch=16,
     ylim=ylim,
     xlim=xlim,
     ylab = "Emissions (In Thousands)",
     xlab = "Year",
     xaxt='n',
     main = "Total Emissions from 1999 to 2008"
     )
axis(side=1,at=c(xlim,vals$x))
#Use lines to connect points
lines(vals$x,vals$y,col="blue")
#Label points
text(x=vals$x,y=vals$y,labels=round(vals$y,2),pos=3,cex = 0.8)
#Mean Line
abline(h = Mean, untf = FALSE, col=3,lty=2)
#Add Mean Line Label
text(x=max(vals$x),y=Mean, labels =paste("Mean: ",Mean), pos=3,cex=0.6,col=3)

dev.off()
