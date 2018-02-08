# sudo Rscript representitive_region_3.R

# 시간에 따른 구역들의 값을 추출(테이블에 쓰일)
setwd("/Users/seunghyunmoon/Code/R_Studio/dust/script")
all <- read.csv("../data/final_data.csv", header=T, as.is=T)

for( i in unique(all$day) ){
  result <- subset(all, all$day == i)
  df <- data.frame(Date=as.Date(character()),
                   File=character(), 
                   User=character(), 
                   stringsAsFactors=FALSE) 
  for( j in unique(all$location.station.kr.name) ){
    a <- result[result$location.station.kr.name == j,]
    rs <- a[1,c("location.station.kr.name","long", "lat", "day", "SO2", "CO", "O3", "NO2", "PM10", "PM25")]
    df <- rbind(df, rs)
  }
  fileName = paste("../data/" , i, "_rep", ".csv", sep="")
  write.csv(df, fileName)
}
