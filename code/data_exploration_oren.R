### Diggin the data - first impression.
# 11.02.18, Oren.
rm(list=ls(all.names = T))
setwd("/Users/corel/Dropbox/Docs/Data analysis/dit_deloitte_airbnb") # Mac

# load libraries
library("tidyverse") #  data manipulation and graphs
library(stringr) #  string manipulation
library(lubridate) #  date manipulation
library('wordcloud') #  wordcloud
library(tidytext) # tidy implementation of NLP methods
library(DT)       # table format display of data
library(leaflet) # maps
library(igraph) #  graphs
# library(ggraph) #  graphs
library(topicmodels) # for LDA topic modelling 
library(tm) # general text mining functions, making document term matrixes
library(SnowballC) # for stemming
library(textcat)
# read the train set
train <- read_csv("data/train.csv", col_names = T)

#### converting variables into the right types ####
# to Factor
fac_vec <- c(
"property_type",
"room_type",
"bed_type",
"cancellation_policy",
"city")
# check the types
fac_list <- train %>% select(fac_vec) 
lapply(fac_list, typeof)
# convert
for(i in fac_vec){
  train[[i]] <-  as.factor(train[[i]])
}
# check again
fac_list <- train %>% select(fac_vec) 
lapply(fac_list, class)

# to Logical
logi_vec <- c("cleaning_fee",
"host_has_profile_pic",
"host_identity_verified",
"instant_bookable")
# check the types
logi_list <- train %>% select(logi_vec) 
lapply(logi_list, class)
# change "t" to True and "f" to False
for(i in logi_vec){
  train[[i]] <- gsub("t","True", train[[i]])
  train[[i]] <- gsub("f","False", train[[i]])
}
# convert
for(i in logi_vec){
  train[[i]] <-  as.logical(train[[i]])
}
# check again
logi_list <- train %>% select(logi_vec) 
lapply(logi_list, class)
lapply(logi_list, head)

# to Numeric and other num-issues
# host_response_rate - change to numeric, remove the "%"
train$host_response_rate <- gsub("%","",train$host_response_rate)
train$host_response_rate <- as.numeric(train$host_response_rate)
train$host_response_rate <- train$host_response_rate /100

# zip code - remove the ".0"
train$zipcode <- gsub("\\.0","",train$zipcode)

# to Date
date_vec <- c("first_review",
"host_since",
"last_review")
# check the types
date_list <- train %>% select(date_vec) 
lapply(date_list, class) # all date already!

rm(date_vec,logi_vec,fac_vec,fac_list,logi_list,date_list,i)
#train_head <- head(train)
#write_csv(train_head,"results/automatic/train_head.csv")

#### Data Exploration ####
fillColor = "#FFA07A"
fillColor2 = "#F1C40F"

train %>% group_by(room_type) %>% summarise(mean_log_price = mean(log_price)) %>% 
  ggplot(aes(x= room_type, y=mean_log_price)) +
          geom_bar(stat = "identity")

# ameneties
train$amenities <- gsub('(")|(\\{)|(\\})',"",train$amenities)
train$amenities <- gsub("translation missing.*","",train$amenities)
train$amenities <- gsub(",$","",train$amenities)

glimpse(train)
# most occuring ameneties
categories <- str_split(train$amenities,",")
categories <- as.data.frame(unlist(categories))
colnames(categories) <- c("Name")

categories %>% group_by(Name) %>% summarise(Count = n()) %>% arrange(desc(Count)) %>% 
  ungroup() %>% mutate(Name = reorder(Name,Count)) %>% head(10) %>% 
  
  ggplot(aes(x = Name, y = Count)) +
  geom_bar(stat = "identity", color = "white", fill = fillColor2) +
  geom_text(aes(x = Name, y = 1, label = paste0("(",Count,")",sep="")),
            hjust=0, vjust = 0.5, size = 4, color = "black", fontface = "bold") +
  labs(x = "Name of Amenity", y = "Count", title = "Top 10 Amenities, AirBNB") +
  coord_flip() +
  theme_bw()

# names of properties with most 100-rating reviews
most_100_reviews <- train %>% filter(review_scores_rating == 100) %>% group_by(id) %>% 
  arrange(desc(number_of_reviews)) %>% ungroup() %>% 
  mutate(PropertyID = reorder(id,number_of_reviews)) %>% head(10)

most_100_reviews %>% mutate(name = reorder(name,number_of_reviews)) %>% 
  ggplot(aes(x = name, y = number_of_reviews)) +
  geom_bar(stat = "identity", color = "white", fill = fillColor) +
  geom_text(aes(x = name, y = 1, label = paste0("(",number_of_reviews,")",sep="")),
            hjust=0, vjust=0.5, size = 4, color = "black", fontface = "bold") +
  labs(x = "Name of the Property", y = "Number of Reviews", 
       title = "Top 10 Highest Rated Properties, by Number of Reviews") +
  coord_flip() +
  theme_bw()
  
# lets look at NYC and location
NYC_coords <- train %>% filter(city == "NYC")  

center_lon <- median(NYC_coords$longitude, na.rm = T)
center_lat <- median(NYC_coords$latitude, na.rm = T)

leaflet(NYC_coords) %>% addProviderTiles("Esri.NatGeoWorldMap") %>% 
  addCircles(lng = ~longitude, lat = ~latitude, radius = ~sqrt(number_of_reviews)) %>% 
  # controls
  setView(lng = center_lon, lat = center_lat, zoom = 13)

# Word Cloud for description
createWordCloud <- function(mydata)
{
  mydata %>% unnest_tokens(word,description) %>% filter(!word %in% stop_words$word) %>% 
    count(word, sort = T) %>% ungroup() %>% head(30) %>% 
    
    with(wordcloud(word, n, max.words = 20, colors = brewer.pal(8, "Dark2")))
}
# cloud for NYC
createWordCloud(train %>% filter(city == "NYC")) 
# cloud for Chicago 
createWordCloud(train %>% filter(city == "Chicago"))   
# cloud for LA 
createWordCloud(train %>% filter(city == "LA"))     
  





