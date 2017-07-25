###$ 1. load data ####
rawData <- read.csv(file = '~/Documents/SensorData/sensor_rawdata.csv', header = T, stringsAsFactors = F, encoding = 'UTF-8')
#### 2. explore data, start from event == click_send_cellphone & verify_cellphone_code ####
df_csc <- subset(rawData, event == 'click_send_cellphone')
df_vcc <- subset(rawData, event == 'verify_cellphone_code')

View(subset(df_vcc, distinct_id == 'aed74711a86a2c287de8bdf26731fc5f6eb9b845'))
View(subset(df_csc, distinct_id == 'aed74711a86a2c287de8bdf26731fc5f6eb9b845'))

# lookup the user that requested code but didnt verify on the phone
fail_verfify <- df_csc[which(!(df_csc$distinct_id %in% df_vcc$distinct_id)),]


df_clickSubmit <- subset(rawData, event == 'clickSubmit')
df_ <- subset(rawData, event == 'clickSubmit')
which(is.na(rawData$properties..latest_referrer_host))

df_play <- subset(rawData, distinct_id == '1e8664a9f6e2b4cd768670e6b6045fd05a4f3de4')


#### compress dups distinct_id into one ####
rawData <- rawData[with(rawData, order(distinct_id)),] # sort the data frame by distinct_id

for(i in 1:(nrow(rawData) - 1))
{
  if(rawData[i, 1] == rawData[i + 1, 1]) # if this distinct id is same as the next one
  {
    for(j in 2:ncol(rawData)) # enter the loop. (current cell is [i, j])
    {
      if(is.na(rawData[i + 1, j])) # if the next cell below ([i + 1, j]) is NA
        rawData[i + 1, j] = rawData[i, j] # replace it [i + 1, j] with this cell [i, j]
      rawData[i, j] <- NA # no matter what, replace this cell ([i, j]) with NA
    }
  }
}
compress_rawData <- rawData[which(! is.na(rawData$lib..lib)), ] # in the same distinct id group, just keep the last one.
write.csv(compress_rawData, '~/Desktop/compress_rawData.csv')
#0721: 
# 1. concatenate page and name, 
# 2. new definition: signup success = either clickSubmit, click_send_cellphone, or formSubmit,
#3. Data loss calculation

# 1. concatenate page and name, 
rawNew <-read.csv('~/Documents/Sensor/compress_rawData_v3.csv', header = T)
for(i in 1: nrow(rawNew))
{
  if(!is.na(rawNew$properties.page[i]) & !is.na(rawNew$properties.name[i]))
    rawNew$PageBtn[i] <- paste0(rawNew$properties.page[i], sep = "-", rawNew$properties.name[i])
}

# 2. new definition: signup success = either clickSubmit, click_send_cellphone, or formSubmit
rawNew$ynclickSubmit <- NA
i = NULL
for(i in 1: nrow(rawNew))
{
  if(rawNew$event_clickSubmit[i] == 'Yes' | rawNew$event_click_send_cellphone[i] == 'Yes'| rawNew$event_formSubmit[i] == 'Yes')
    rawNew$ynclickSubmit[i] <- 'Yes'
  else
    rawNew$ynclickSubmit[i] <- 'No'
}
rawNew$event_clickSubmit[2] == 'Yes' | rawNew$event_click_send_cellphone[2] == 'Yes'| rawNew$event_formSubmit[2] == 'Yes'
write.csv(file = '~/Desktop/compress_rawData_v4.csv', rawNew)
#3. Data loss calculation
rawData <- read.csv(file = '~/Documents/Sensor/sensor_rawdata.csv', header = T, stringsAsFactors = F, encoding = 'UTF-8')
rawData <- rawData[order(rawData$distinct_id),] # sort the data frame by distinct_id
rawData <- na.omit(rawData)
countRaw <- rep(0, (ncol(rawData) - 1))
for(i in 1:(nrow(rawData) - 1))
{
  if(rawData[i, 1] == rawData[i + 1, 1]) # if this distinct id is same as the next one
  {
    for(j in 2:ncol(rawData)) # enter the loop. (current cell is [i, j])
    {
      if(! is.na(rawData[i, j]))
      {
        if(! rawData[i, j] == rawData[i + 1, j])
          countRaw[j - 1] <- countRaw[j - 1] + 1
      }
    }
  }
}


























