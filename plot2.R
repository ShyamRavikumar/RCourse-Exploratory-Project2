require(data.table)
require(dplyr)
#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)

#Obatain data for baltimore
NEIBaltimore<- filter(NEI,fips == "24510")
#Sum Emissions by year
vals <- tapply(NEIBaltimore$Emissions, NEIBaltimore$year, sum)
#Scale emissions to thousands
vals <- vals/10^3
vals <- data.frame(x=as.integer(rownames(vals)),y=vals)

#Plot info
Mean<-round(mean(vals$y),2)
xlim <- c(min(vals$x)-2,max(vals$x)+2)
ylim <- c(min(vals$y),max(vals$y)+1)
#Plot
png(filename = "./Plot2.png")
plot(vals$y~vals$x,
     col="red",
     pch=16,
     ylim=ylim,
     xlim=xlim,
     ylab = "Emissions (In Thousands)",
     xlab = "Year",
     xaxt='n',
     main = "Total Emissions in Baltimore City, Maryland, from 1999 to 2008"
)
axis(side=1,at=c(xlim,vals$x))
#Add lines to join points
lines(vals$x,vals$y,col="blue")
text(x=vals$x,y=vals$y,labels=round(vals$y,2),pos=3,cex = 0.8)
#Add mean line
abline(h = Mean, untf = FALSE, col=3,lty=2)
text(x=max(vals$x),y=Mean, labels =paste("Mean: ",Mean), pos=1,cex=0.7,col=3)

dev.off()
