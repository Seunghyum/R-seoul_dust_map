# 실행
# sudo Rscript make_final_data.R

library(ggplot2)
library(rgeos)
library(maptools)
library(raster) # getData함수로 서울지도 쓰려면 적용해야함
library(viridis) # 색맹, 색약을 고려한 색상 라이브러리
library(ggmap)
library(shiny)
library(plotly)

korea_gadm <- readRDS(file="../data/KOR_adm2.rds")
seoul_gadm <- korea_gadm[korea_gadm$NAME_1 %in% 'Seoul', ]

# seoul_gadm 을 data.frame 으로 바꿈
seoul_gadm_2 <- fortify(seoul_gadm, region='NAME_2')

seoul_dust_data <- url("https://raw.githubusercontent.com/Seunghyum/R-Practice-Seoul-dust-map/master/seoul_dust.csv")

dust <- read.csv(seoul_dust_data, header=T, as.is=T)

seoul_map <- merge(x=dust, y=seoul_gadm_2, by.x="location.station.en.name", by.y="id", all=T)

seoul_map <- seoul_map[order(seoul_map$location.station.en.name, seoul_map$order, decreasing = FALSE), ]

write.csv(seoul_map, file = "../data/final_data.csv")
