rm(list = ls())
### Climate Project

# Read in the csv data for global co2 levels, global temperature, and fossil fuel emmissions by nation.
atmos <- read.csv("/home/kenny/Downloads/data/co2-mm-mlo_csv.csv")
globaltemp <- read.csv("/home/kenny/Downloads/data/annual_csv.csv")
fossil <- read.csv("/home/kenny/Downloads/data/fossil-fuel-co2-emissions-by-nation_csv.csv")
fossilread = fossil
### Clean up the datasets so they can knit together neatly.

# Separate GCAG and GISTEMP in globaltemp
gistemp <- globaltemp[globaltemp$Source=="GISTEMP",]
gcagtemp <- globaltemp[globaltemp$Source=="GCAG",]

# Extract the year from atmos$Date and put it in a new column
atmos$Date <- as.Date(atmos$Date,"%Y-%m-%d")
atmos$Year <- as.numeric(format(atmos$Date,"%Y"))
atmos <- atmos[,c(1,7,3,4,5)]

# Find the yearly average of each variable in co2data
annualatmos <- data.frame("Year"=unique(atmos$Year),"Average"=aggregate(Average~Year,atmos,mean),
  "Interpolated"=aggregate(Interpolated~Year,atmos,mean),"Trend"=aggregate(Trend~Year,atmos,mean))
annualatmos <- annualatmos[,c(-2,-4,-6)]
colnames(annualatmos) <- c("Year","AvgC02","InterpolatedCO2","TrendCO2")

# Merge Global Temp and CO2 emmissions data
climatedata <- merge(annualatmos,gistemp,by="Year")
colnames(climatedata)[colnames(climatedata)=="Mean"] <- "Avg GISTEMP"
climatedata <- climatedata[,-5]

# Clean fossil fuel data by removing extraneous columns, limiting time frame to match climatedata
fossil <- fossil[,c(-4:-10)]
recentfossil <- fossil[fossil$Year>="1958",]
colnames(recentfossil) <- c("Year","Country","Total")

# Add global sums to climatedata
climatedata <- climatedata[-57:-58,]
a <- aggregate(Total~Year,recentfossil,sum)
climatedata$TotalGlobalCE <- a[,2]
#climatedata <- climatedata[,-6]
colnames(climatedata)[colnames(climatedata)==""]

### Analyze the data

# Install packages
# install.packages("gglot2")
library(ggplot2)

# Create a multiline visual an see if there are any trends
colnames(climatedata) <- c("Year","AvgCE","InterpolatedCE","TrendCE","AvgTemp","TotalCE")
# Carbon emissions trends multiline:
ggplot() + 
  geom_line(data = climatedata, aes(x = Year, y = AvgCE, group=1), color = "blue") +
  geom_line(data = climatedata, aes(x = Year, y = TrendCE, group=1), color = "green") +
  ylab("Carbon Emissions")
# Total carbon emissions line
ggplot() + geom_line(data=climatedata, aes(x = Year, y = TotalCE, group=1), color = "red") + 
  ylab("Carbon Emissions")
# Average GIS temp anomaly plotline
ggplot() + geom_line(data=climatedata, aes(x = Year, y = AvgTemp, group=1), color = "orange") + 
  ylab("Average Temperature Anomalies")


### K Means Cluster
#install.packages("tidyverse")
#install.packages("cluster")
#install.packages("factoextra")

library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization

# Create a fossil types dataframe
fossiltypes <- fossilread[,-9]
fossiltypes$CountryYear <- paste(fossiltypes$Country,fossiltypes$Year, sep=", ")
fossiltypes <- fossiltypes[,c(10,3:9)]
rownames(fossiltypes) <- fossiltypes[,1]
fossil2 = fossiltypes
fossiltypes <- fossiltypes[,-1]

# Standardize it
fossiltypes <- scale(fossiltypes)

k2 <- kmeans(fossiltypes, centers = 2, nstart = 25)
str(k2)
fviz_cluster(k2, data = fossiltypes)

# Scatter plot
 fossil2%>%
  as_tibble() %>%
  mutate(cluster = k2$cluster,
         state = row.names(fossil2)) %>%
  ggplot(aes(Total, Solid.Fuel, color = factor(cluster), label = CountryYear)) +
  geom_text()

# Didfferent clusters
 k3 <- kmeans(fossiltypes, centers = 3, nstart = 25)
 k4 <- kmeans(fossiltypes, centers = 4, nstart = 25)
 k5 <- kmeans(fossiltypes, centers = 5, nstart = 25)
 
 # plots to compare
 p1 <- fviz_cluster(k2, geom = "point", data = fossiltypes) + ggtitle("k = 2")
 p2 <- fviz_cluster(k3, geom = "point",  data = fossiltypes) + ggtitle("k = 3")
 p3 <- fviz_cluster(k4, geom = "point",  data = fossiltypes) + ggtitle("k = 4")
 p4 <- fviz_cluster(k5, geom = "point",  data = fossiltypes) + ggtitle("k = 5")
 
 library(gridExtra)
 grid.arrange(p1, p2, p3, p4, nrow = 2)

 # Find best clusters (don't run, may cause system freeze)
 # Elbow method (result is 5)
 set.seed(123)
 
 # function to compute total within-cluster sum of square 
 wss <- function(k) {
   kmeans(fossiltypes, k, nstart = 10 )$tot.withinss
 }
 
 # Compute and plot wss for k = 1 to k = 15
 k.values <- 1:15
 
 # extract wss for 2-15 clusters
 wss_values <- map_dbl(k.values, wss)
 
 plot(k.values, wss_values,
      type="b", pch = 19, frame = FALSE, 
      xlab="Number of clusters K",
      ylab="Total within-clusters sum of squares")
 
 # Silhouette method (result is 5)
 avg_sil <- function(k) {
   km.res <- kmeans(fossiltypes, centers = k, nstart = 25)
   ss <- silhouette(km.res$cluster, dist(fossiltypes))
   mean(ss[, 3])
 }
 
 # Compute and plot wss for k = 2 to k = 15
 k.values <- 2:15
 
 # extract avg silhouette for 2-15 clusters
 avg_sil_values <- map_dbl(k.values, avg_sil)
 
 plot(k.values, avg_sil_values,
      type = "b", pch = 19, frame = FALSE, 
      xlab = "Number of clusters K",
      ylab = "Average Silhouettes")
 
 # gap statistic
 gap_stat <- clusGap(fossiltypes, FUN = kmeans, nstart = 25,
                     K.max = 10, B = 50)
 print(gap_stat, method = "firstmax")
 
 ## use 5 clusters
 result = fviz_cluster(k5, geom = "point",  data = fossiltypes) + ggtitle("k = 5")
 print(result)
 
 fossiltypes %>%
   mutate(Cluster = k5$cluster) %>%
   group_by(Cluster) %>%
   summarise_all("mean")
 