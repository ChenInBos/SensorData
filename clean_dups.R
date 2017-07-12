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