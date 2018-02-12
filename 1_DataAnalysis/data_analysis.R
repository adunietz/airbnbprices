# Data analysis

# Import required libraries
library(RCurl)

# Load data
# Better to use RData files, as they're less heavy
# train_rawdata = read.csv(text = getURL("https://raw.githubusercontent.com/adunietz/airbnbprices/master/0_DataAndInitialization/train.csv"), header = TRUE)
# test_rawdata = read.csv(text = getURL("https://raw.githubusercontent.com/adunietz/airbnbprices/master/0_DataAndInitialization/test.csv"), header = TRUE)

# Save to RData, so you can use in Rmarkdown
# save(train_rawdata, file = "train_rawdata.RData")
# save(test_rawdata, file = "test_rawdata.RData")

# RData files from Github
load(url("https://github.com/adunietz/airbnbprices/raw/master/0_DataAndInitialization/train_rawdata.RData"))
load(url("https://github.com/adunietz/airbnbprices/raw/master/0_DataAndInitialization/test_rawdata.RData"))
