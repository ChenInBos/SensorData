#### compress dups distinct_id into one ####
rawData <- read.csv(file = '~/Documents/Sensor/sensor_rawdata.csv', header = T, stringsAsFactors = F, encoding = 'UTF-8')
transData <- rawData[with(rawData, order(distinct_id)),] # sort the data frame by distinct_id

for(i in 1:(nrow(transrawData) - 1))
{
  if(transrawData[i, 1] == transrawData[i + 1, 1]) # if this distinct id is same as the next one
  {
    for(j in 2:ncol(transrawData)) # enter the loop. (current cell is [i, j])
    {
      if(is.na(transrawData[i + 1, j])) # if the next cell below ([i + 1, j]) is NA
        transrawData[i + 1, j] = transrawData[i, j] # replace it [i + 1, j] with this cell [i, j]
      transrawData[i, j] <- NA # no matter what, replace this cell ([i, j]) with NA
    }
  }
}
transData <- rawData
compress_rawData <- transrawData[which(! is.na(rawData$lib..lib)), ] # in the same distinct id group, just keep the last one.
write.csv(compress_rawData, '~/Desktop/compress_rawData.csv')

#### add events as vairable ####
subset_event_unique <- function(x)
{
  temp <- subset(rawData, event == x)[!duplicated(subset(rawData, event == x)$distinct_id), ]# subset and remove move current event category
  merge(compress_rawData, temp, by = 'distinct_id', all.x = T)$event.y
}
# update df
compress_rawData$event_pageview <- subset_event_unique('$pageview') # pageview
compress_rawData$event_about_leave <- subset_event_unique('about_leave') # about_leave
compress_rawData$event_btnClick <- subset_event_unique('btnClick') # btnClick
compress_rawData$event_click_send_cellphone <- subset_event_unique('click_send_cellphone') # click_send_cellphone
compress_rawData$event_clickSubmit <- subset_event_unique('clickSubmit') # clickSubmit
compress_rawData$event_courses_play_leave <- subset_event_unique('courses_play_leave') # courses_play_leave
compress_rawData$event_demo_leave <- subset_event_unique('demo_leave') # demo_leave
compress_rawData$event_formSubmit <- subset_event_unique('formSubmit') # formSubmit
compress_rawData$event_index_leave <- subset_event_unique('index_leave') # index_leave
compress_rawData$event_page_close <- subset_event_unique('page_close') # page_close
compress_rawData$event_verify_cellphone_code <- subset_event_unique('verify_cellphone_code') # verify_cellphone_code
# convert to binomial, NA is 0, not NA is 1
pass















