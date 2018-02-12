# Data analysis

# Import required libraries
library(RCurl)

# Load data
train_rawdata = read.csv(text = getURL("https://raw.githubusercontent.com/adunietz/airbnbprices/master/0_DataAndInitialization/train.csv"), header = TRUE)
test_rawdata = read.csv(text = getURL("https://raw.githubusercontent.com/adunietz/airbnbprices/master/0_DataAndInitialization/test.csv"), header = TRUE)