library(ggplot2)
library(scales)
library(ggmap)
library(stringr)
library(animation)


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

map <- get_map(location="New York City", zoom=12)

plot_time <- function(cbin) {
  str_int <- str_pad(toString(cbin), 2, pad='0')
  out_map <- ggmap(map) + 
    geom_point(aes(x = Lon, y = Lat), data = subset(data, bin==cbin), alpha=0.01) +
    #stat_density2d(data = subset(data, bin==cbin), aes(x = Lon, y = Lat,  fill = ..level.., alpha = ..level..), size = 0.01, bins = 16, geom = 'polygon') +
    annotate("text", x=-74.025, y=40.785, label=paste(str_int, ":00", sep=''), size=16) +
    ggtitle("NYC Uber Pickups in April 2014") + 
    theme(legend.position = "none", axis.title = element_blank())
  #ggsave(paste("hour-", str_int, ".jpg", sep=''))
  print(out_map)
}

start <- min(data$just_times)
data$bin <- cut(data$just_times, breaks = start + seq(0, 60*60*24, by = 60*60), labels = 0:23)
plot_time(0)

saveGIF({
  for(x in 0:23) {
    plot_time(x)
  }
}, interval = 0.2)
