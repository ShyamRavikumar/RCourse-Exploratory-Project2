require(data.table)
require(dplyr)
require(ggplot2)

#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)


#Filter by type and fips(Baltimore and on road)
emissions <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
emissions <- aggregate(Emissions ~ year, data=bmore.emissions, FUN=sum)

#Plot
png("plot5.png")
ggplot(emissions, aes(x=factor(year), y=Emissions)) +
    xlab("Year") +
    ylab(expression("Total Emissions")) +
    geom_bar(stat="identity") +
    ggtitle("Emissions from motor vehicle sources in Baltimore")
dev.off()