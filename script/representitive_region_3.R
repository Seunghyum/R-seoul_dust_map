# sudo Rscript representitive_region_3.R

# 전체 파일을 날짜별로 분화
setwd("/Users/seunghyunmoon/Code/R_Studio/dust/script")
all <- read.csv("../data/final_data.csv", header=T, as.is=T)
unique <- unique(all[,"location.station.kr.name"])

df <- data.frame(Date=as.Date(character()),
                 File=character(), 
                 User=character(), 
                 stringsAsFactors=FALSE) 
#result <- data.frame(,row c("location.station.kr.name","long", "lat", "day", "SO2", "CO", "O3", "NO2", "PM10", "PM25"))

for( i in unique ){
  a <- all[all$location.station.kr.name == i,]
  rs <- a[1,c("location.station.kr.name","long", "lat", "day", "SO2", "CO", "O3", "NO2", "PM10", "PM25")]
  df <- rbind(df, rs)
}
write.csv(df, "../data/representitive_region.csv")
