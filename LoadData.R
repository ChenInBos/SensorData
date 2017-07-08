# 1. Load Data

# lengh = 7 data
setfile <- file('~/Documents/Sensor/sensorswww_data.txt', 'r')# set file connnection for read lines
filelines <- readLines(con = setfile, n = -1L)# read lines, all lines (still json format structure data)
subfile <- filelines[c(1:1798, 1800:13472, 13474:25366, 25368:39453, 39455, 
                       39457:44566, 44568:49012, 49014:49016, 49018:49020, 49022:49027, 49029)]#some lines cannot be bind as dataframe, subset
rawData <- lapply(X = subfile, RJSONIO::fromJSON)# read json format data into a nested list
indx <- sapply(rawData, length)
df7 <- do.call(plyr::rbind.fill, lapply(rawData[which(indx == 7)], data.frame))# row bind list into a data frame
# length = 8 data
subfile8 <- filelines[1: 51048]#some lines cannot be bind as dataframe, subset
rawData8 <- lapply(X = subfile8, RJSONIO::fromJSON)# read json format data into a nested list
indx <- sapply(rawData8, length)
df8 <- do.call(plyr::rbind.fill, lapply(rawData8[which(indx == 8)], data.frame))# row bind list into a data frame
# length = 6 data
subfile6 <- filelines[c(1, 3:14)]#some lines cannot be bind as dataframe, subset
rawData6 <- lapply(X = subfile6, RJSONIO::fromJSON)# read json format data into a nested list
indx <- sapply(rawData6, length)
df6 <- do.call(plyr::rbind.fill, lapply(rawData6[which(indx == 6)], data.frame))# row bind list into a data frame
write.csv(df7, file = '~/Desktop/df7.csv')

#ddd <- ldply(rawData, rbind)
#lapply(rawData, function(x) {x[sapply(x, is.null)] <- NA})


#json_file <- lapply(rawData, function(x) {
#  x[sapply(x, is.null)] <- NA
#  unlist(x)
#})


#do.call("rbind", json_file)

# bad point: 1799, 13473, 25367, 39454, 39456, 44567, 49013, 49017, 49021, 49028
#c(1:1798, 1800:13472, 13474:25366, 25368:39453, 39455, 39457:44566, 44568:49012, 49014:49016, 49018:49020, 49022:49027, 49029:51048)

write.csv(df7, file = '~/Desktop/df7.csv')






