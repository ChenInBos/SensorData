####load ,clean & calculate data####
watchdog <- read.csv(file = '~/Documents/sheets/dailyEmail/input/watchdog.csv', header = T, stringsAsFactors = F)
filecount <- read.csv(file = '~/Documents/sheets/dailyEmail/input/fileCount.csv', header = T, stringsAsFactors = F)
demographic <- read.csv(file = '~/Documents/sheets/dailyEmail/input/demographic.csv', header = T, stringsAsFactors = F)
#cast Checkin to Date format
watchdog$Checkin <- as.Date(watchdog$Checkin, format = '%Y-%m-%d')
#clean filecount HHid
filecount$hh_id <- sub('TV0', filecount$hh_id, replacement = '')
filecount$hh_id <- sub('TV', filecount$hh_id, replacement = '')
####calculate offline duration, tviOnly, arOnly, neither, both####
#offline duration
for(i in 1:length(watchdog$Checkin))
{
  if(is.na(Sys.Date() - watchdog$Checkin[i]))
    watchdog$offline.day[i] = 'NeverOnline'
  else
    watchdog$offline.day[i] = Sys.Date() - watchdog$Checkin[i]
}
#calculate tab stats
tabHH <- merge(watchdog, filecount, by.x = 'HH', by.y = 'hh_id', all.x = T)[c("HH", "Batch", "Online", "Kinect", "tvi_rows", "ar_rows")]#left join filecount and watchdog
tabHH[is.na(tabHH)] <- 0 #replace NA with 0
for(j in 1: nrow(tabHH))
{
  if(tabHH$tvi_rows[j] > 0 & tabHH$ar_rows[j] == 0)
    tabHH$stats[j] <- 'tviOnly'
  else
  {
    if(tabHH$tvi_rows[j] == 0 & tabHH$ar_rows[j] > 0)
      tabHH$stats[j] <- 'arOnly'
    else
    {
      if(tabHH$tvi_rows[j] == 0 & tabHH$ar_rows[j] == 0)
        tabHH$stats[j] <- 'neither'
      else
        tabHH$stats[j] <- 'both'
    }
  }
}
#calculate intab column
for(z in 1: nrow(tabHH))
{
  if(tabHH$stats[z] == 'both' & tabHH$Online[z] == 0 & tabHH$Kinect[z] == 1)
    tabHH$tab[z] = 'intab'
  else
    tabHH$tab[z] = 'outab'
}
#########NeverOnline HHs, Offline Over than 30 days HHs, Kinect Disconnect HHs, Kinect Blocked HHs. None of these table should have interception with each other######
#select NeverOnline HHs (offline.day = 'NeverOnline')
NeverOnlineHH <- watchdog[watchdog$offline.day == 'NeverOnline', ]
NeverOnlineHH_withEmail <- merge(NeverOnlineHH, demographic, by = 'HH')[c("HH", "Email")]
write.csv(NeverOnlineHH_withEmail, file = '~/Documents/sheets/dailyEmail/NeverOnlineHH.csv')
#select offline exceed 30 days HHs (offline.day > 30, Online = -1)
Offline_allHH <- watchdog[watchdog$Online == -1, ]
Offline_normalHH <- Offline_allHH[-which(Offline_allHH$offline.day == 'NeverOnline'),]#remove NeverOnline HHs
Offline_normalHH$offline.day <- as.numeric(Offline_normalHH$offline.day)#convert offline.day to numeric column
Offline_Over30HH <- Offline_normalHH[with(Offline_normalHH, offline.day > 30), ]
Offline_Over30HH_withEmail <- merge(Offline_Over30HH, demographic, by = 'HH')[c("HH", "Email")]
write.csv(Offline_Over30HH_withEmail, file = '~/Documents/sheets/dailyEmail/Offline_Over30HH_withEmail.csv')
#select HH offline within 30 days (offline.day = 1, Online = -1, offline.day != 'NeverOnline')
Offline_Within30HH <- Offline_normalHH[with(Offline_normalHH, offline.day <= 30 & offline.day > 0), ]
Offline_Within30HH_withEmail <- merge(Offline_Within30HH, demographic, by = 'HH')[c("HH", "Email")]
write.csv(Offline_Within30HH_withEmail, file = '~/Documents/sheets/dailyEmail/Offline_Within30HH_withEmail.csv')
#select Kinect disconnect HH, remove offline HHs (online = 0, Kinect = -1)
KinectDisconnectHH <- watchdog[which(watchdog$Kinect == -1 & watchdog$Online == 0), ]
KinectDisconnectHH_withEmail <- merge(KinectDisconnectHH, demographic, by = 'HH')[c("HH", "Email")]
write.csv(KinectDisconnectHH_withEmail, file = '~/Documents/sheets/dailyEmail/KinectDisconnectHH.csv')
#select Kinect blocked HHs (online = 0, Kinect = 1, stats = 'arOnly)
arOnlyHH <- subset(tabHH, stats == 'arOnly' & Online == 0 & Kinect == 1)
KinectBlockedHH_withEmail <- merge(arOnlyHH, demographic, by = 'HH')[c('HH', 'Email')]
write.csv(KinectBlockedHH_withEmail, file = '~/Documents/sheets/dailyEmail/KinectBlockedHH_withEmail.csv')
#sort(table(rbind(KinectBlockedHH_withEmail$HH, KinectDisconnectHH_withEmail$HH, Offline_Over30 daysHH_withEmail$HH, NeverOnlineHH_withEmail$HH)),decreasing = T)















































