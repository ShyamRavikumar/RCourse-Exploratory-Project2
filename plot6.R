require(data.table)
require(dplyr)
require(ggplot2)

#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)

#Filter ON-ROAD type emissions for cities Baltimore and LA(24510 and 06037)
emissions <- filter(NEI,(fips=="24510" | fips=="06037") & type=="ON-ROAD")
emissions$fips <- factor(emissions$fips) #Convert to factor for labelling fips as cities
levels(emissions$fips) <- c("Baltimore City, MD","Los Angeles County, CA")

#Sum Emissions by year and County
emissions <- aggregate(emissions$Emissions, 
                        by=list(County = emissions$fips,year = emissions$year), 
                        FUN = sum)
# plot
span<-0.3
png("plot6.png",width = 1024,height=980)
ggplot(emissions, aes(year,x, group=County,col=County)) +
    geom_text(aes(label=round(x,1)),hjust=0.5, vjust=-1,size=4) +
    geom_line() + 
    #geom_line(stat = "hline", yintercept = "mean",lty =2) +
    stat_smooth(method = lm,se=FALSE,lty=2) +
    ylab("Total emissions (tons)") + 
    xlab("Year") +
    ggtitle(expression("Vehicle Emissions in Baltimore and LA from 1999 to 2008 (with lm to show trend)"))

dev.off()
