library(ggplot2)
library(scales)

data = read.csv("./uber-raw-data-apr14.csv")
head(data)

datetimes <- strptime(data$Date.Time, format="%m/%d/%Y %H:%M:%S")
times <- strptime(strftime(datetimes, '%X'), format='%X')
data$just_times = times

dens <- density(as.numeric(data$Date.Time))
plot(dens)

ggplot(data) +
  geom_density(aes(x=just_times), bw="nrd0") +
  scale_x_datetime(labels=date_format("%H"), date_breaks="2 hour")

min_Lat <- 40.6
max_Lat <- 40.9
min_Lon <- -74.1
max_Lon <- -73.75

plt <- ggplot(data, aes(x=Lon, y=Lat)) +
  geom_point(size=0.03, alpha=0.05) + 
  scale_x_continuous(limits=c(min_Lon, max_Lon)) +
  scale_y_continuous(limits=c(min_Lat, max_Lat)) +
  labs(title="NYC viewed by Uber Pickups in April 2014") + 
  coord_equal()
plt
png("./nyc-uber-pickups.png", w=800, h=800, res=150)
dev.off()

library(ggmap)
map <- get_map(location="New York City", zoom=7)
ggmap(map) + 
  geom_point(aes(x = Lon, y = Lat), data = data, alpha=0.003)
