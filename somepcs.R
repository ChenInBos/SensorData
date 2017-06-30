table(watchdog[watchdog$offline.day =='NeverOnline', ]$Batch)
forBeth <- read.csv('~/Desktop/ChicagoJuneRenew.csv', header = F)

forBethFull <- merge(y = forBeth, x = demographic, by.y = 'V1', by.x = 'HH')[c('HH', 'Email', 'Phone', 'Name')]
write.csv(forBethFull, file = '~/Desktop/JunChi_drop.csv')
write.csv(watchdog[watchdog$offline.day =='NeverOnline', ], file = '~/Desktop/allNeverOnlineHH.csv')
watchdog[watchdog$offline.day =='NeverOnline', ], file = '~/Desktop/allNeverOnlineHH.csv'

merge(x = watchdog[watchdog$offline.day =='NeverOnline', ], y = demographic, by = 'HH'])[c('HH', 'Email', 'Name', 'Batch', 'Phone')]
allNO <- watchdog[watchdog$offline.day =='NeverOnline', ]


allNever <- merge(x = allNO, y = demographic, by = 'HH')[c('HH', 'Email', 'Name', 'Batch.x', 'Phone', 'S.N.x')]
write.csv(allNever, file = '~/Desktop/allNeverOnlineHH.csv')


DallasOnlineNoData <- subset(tabHH, Online == 0 & Batch == 'Dallas' & stats == 'neither' & Kinect == 1)
View(subset(tabHH, Online == 0 & Batch == 'Boston' & stats == 'neither' & Kinect == 1))
subset(tabHH, stats == 'neither')


dim(subset(watchdog, Online == 0 & Batch == 'Dallas'))

watchdog[watchdog$Online == 0,]

#Check 
filecount[!(watchdog$HH %in% filecount$hh_id),]
watchdog[!(watchdog$HH %in% filecount$hh_id), ]

####read multiple csv into difference data frame####
X <- dir(path = '~/Documents/sheets/dailyEmail/input', pattern = 'csv', full.names = T)
tryList <- list()
for(w in 1:length(X))
{
  tryList[w] <- lapply(X[w], read.csv)
}
Y <- dir(path = '~/Documents/sheets/dailyEmail/input', pattern = 'csv', full.names = F)
for(g in 1:length(X))
{
  names(tryList)[g] <- Y[g]
}



forBeth <- read.csv(file = '~/Desktop/Up for renewal 6.23_V2.csv', header = T)

forBeth_v2 <- merge(forBeth, demographic, by = 'HH')[c('decision', 'Name', 'Phone', 'Email')]



write.csv(forBeth_v2, file = '~/Desktop/ChicagoRenewList_V2.csv')

data <- NULL
data111 <- as.data.frame(read.csv(file = '~/Desktop/data.csv', header = T)[, 1])
data111 <- na.omit(data111)
colnames(data111) <- 'HH'
data$Checkin <- as.Date(as.character(data$Checkin), format = '%m/%d/%y')


#offline duration
for(i in 1:length(data$Checkin))
{
  if(is.na(Sys.Date() - data$Checkin[i]))
    data$offline.day[i] = 'NeverOnline'
  else
    data$offline.day[i] = Sys.Date() - data$Checkin[i]
}
data_v2 = NULL
power_hr <- merge(watchdog, demographic[, c('HH', 'Email', 'Phone', 'Name')], 
                  by.x = 'HH', by.y = 'HH', all.x = T)[c('HH', 'Batch', 'Online', 'Checkin', 'offline.day', 'Name', 'Phone', 'Email')]
power_hr_sub <- subset(power_hr, Online != 0)
write.csv(power_hr_sub, file = '~/Desktop/power_hr.csv')


merge(data, watchdog, by.x = 'HH', by.y = "HH")$Online



dups <- read.csv(file = '~/Desktop/Duplicate Households from ZOHO .csv')


res <- merge(dups, demographic, by.x = "Household.ID", by.y = "HH", all.x = T)


try <- merge(res, demographic, by.x = "S.N", by.y = "S.N")
aaa <- sort(table(try$S.N), decreasing = T)[sort(table(try$S.N), decreasing = T) > 2]
aaa <- as.data.frame(aaa)

colnames(aaa) <- c("SN", "count")

bbb<- merge(aaa, demographic, by.x = 'SN', by.y = 'S.N', all.x = T)[c("SN", "HH", "Name", "Status")]
bbb <- subset(bbb, Status == 'Normal' & Name == "Automated")























