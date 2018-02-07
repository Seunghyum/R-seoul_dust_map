# sudo Rscript divide_by_time_2.R

# 전체 파일을 날짜별로 분화
# setwd("/Users/seunghyunmoon/Code/R_Studio/dust/script")
all <- read.csv("../data/final_data.csv", header=T, as.is=T)

for( i in unique(all$day) ){
  result <- subset(all, all$day == i)
  fileName = paste("../data/" , i, ".csv", sep="")
  write.csv(result, fileName)
}

