require(data.table)
require(dplyr)
require(ggplot2)

#Read RDS Files
classification <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
#Convert to data.table for optimization
setDT(classification)
setDT(NEI)

#Select rows with Fuel Combustion Coal in EI.Sector
combustion.coal.sources <- classification[grepl("Fuel Comb.*Coal", classification$EI.Sector),]
#Filter NEI by SCC using sources from previous line
emissions <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]

#Sum Emissions by year
emissions <- aggregate(Emissions ~ year, data=emissions, FUN=sum)

#Plot
png("plot4.png")
ggplot(emissions, aes(x=factor(year), y=Emissions)) +
    xlab("Year") +
    ylab(expression("Total Emissions")) +
    ggtitle("Emissions from coal combustion-related sources") +
    geom_bar(stat="identity")
dev.off()
