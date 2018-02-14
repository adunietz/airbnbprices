### Diggin the data - first impression.
# 11.02.18, Oren.
rm(list=ls(all.names = T))
setwd("/Users/corel/Dropbox/Docs/Data analysis/dit_deloitte_airbnb") # Mac

# load libraries
#install.packages("tidyverse")
#install.packages("glmnet")
library("tidyverse")

# read the train set
train <- read_csv("data/train.csv", col_names = T)

#### converting variables into the right types ####
# to Factor
fac_vec <- c(
"property_type",
"room_type",
"amenities",
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
train_head <- head(train)
write_csv(train_head,"results/automatic/train_head.csv")

#### Data Exploration ####







