library(tidyverse)
# tweets.from.ids <- read_csv("~/Documents/recovery-prediction/data/dorian/dorian_tweets.csv")

library(lubridate)
url_data <- tibble(dates = floor_date(ymd_hms(tweets.from.ids$parsed_created_at), unit = 'day'),
                   has_url = (tweets.from.ids$urls != ''))

df <- tibble(dates = unique(url_data$dates),
             numT = double(length(unique(url_data$dates))),
             numF = double(length(unique(url_data$dates))))

for (i in 1:length(unique(url_data$dates))) {
  d <- url_data[which(url_data$dates == df$dates[i]),]
  df$numT[i] <- length(d[which(d$has_url == TRUE),]$has_url)
  df$numF[i] <- length(d[which(is.na(d$has_url)),]$has_url)
}

url_ratio <- tibble(Dates = df$dates, Ratio = df$numT / df$numF)

library(ggplot2)
url_plot <- ggplot(url_ratio, aes(x = Dates, y = Ratio)) + 
  geom_line() + 
  geom_point() + 
  ggtitle('URL Ratio over Time') + 
  xlab('Days') + 
  ylab('Ratio')
  

url_plot
