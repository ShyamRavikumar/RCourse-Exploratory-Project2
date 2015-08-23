require(data.table)
require(dplyr)
require(ggplot2)
#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)
#Filter Baltimore data
NEIBaltimore<- filter(NEI,fips == "24510")
#Get sum of emissions by year and type
vals <- aggregate(NEIBaltimore$Emissions,FUN=sum,
                  by = list(type = NEIBaltimore$type,year = NEIBaltimore$year))


#Plot
png(filename = "./Plot3.png",width = 1024,height=980)
Plot <- ggplot(vals, aes(year,x,group=type,col=type)) + 
    geom_line() + 
    geom_text(aes(label=round(x,1)),hjust=1, vjust=0,size=4)
#Annotations
Plot<- Plot + xlab("Year") + ylab("Emissions") + 
    ggtitle("Emissions for various Types of pollutants from 1999 to 2008")
#Mean Line & X-Axis limits
Plot <- Plot + geom_line(stat = "hline", yintercept = "mean",lty =2) + 
    xlim(c(min(vals$year)-1,max(vals$year)+1))
Plot
dev.off()
