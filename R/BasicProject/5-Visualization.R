#### 기본 내장 그래프 ####

getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()

### 1. plot()
# plot(y축 데이터, 옵션)
# plot(x축 데이터, y축 데이터, 옵션)

y = c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5)
plot(y, xlim = c(0, 5), ylim = c(0,5))

x <- 1:10
y <- 1:10
plot(x,y)

# type : "p", "l", "b", "o", "n"
# lty : "sold", "blank", "dashed", "dotted", "dotdash", "longdash", "twodash"
?plot
plot(x,y, xlim = c(0,20), ylim = c(0,30), main = "Graph", type = "l", pch=2, cex=0.8, col="red", lty="dashed")

str(cars)
head(cars)
plot(cars, type="o")

# 같은 속도일 때 제동거리가 다를 경우 대체적인 추세를 알기 어렵다.
# 속도에 따른 평균 제동거리를 구해서 그래프로 그려보자.
View(cars)
library(dplyr)

cars2 <- cars %>% group_by(speed) %>% summarise(mean_dist = mean(dist))
cars2

plot(cars2)

?tapply

cars3 <- tapply(cars$dist, cars$speed, mean)
cars3
plot(cars3)


### 2. points()
plot(iris$Sepal.Width, iris$Sepal.Length)
plot(iris$Petal.Width, iris$Petal.Length)

with(iris,
     {
       plot(iris$Sepal.Width, iris$Sepal.Length)
       plot(iris$Petal.Width, iris$Petal.Length)
     })

# plot + point는 같이 그려진다
with(iris,
     {
       plot(iris$Sepal.Width, iris$Sepal.Length)
       points(iris$Petal.Width, iris$Petal.Length)
       
     })

#첫 번째 코드 블록은 iris$Sepal.Width와 iris$Sepal.Length를 사용하여 모든 측정값에 대한 산점도를 그린 다음, 그 위에 iris$Petal.Width와 iris$Petal.Length를 사용하여 또 다른 산점도를 그립니다. 이 때, 두 번째 산점도가 첫 번째 산점도를 대체합니다.

#두 번째 코드 블록은 첫 번째 코드 블록과 마찬가지로 iris$Sepal.Width와 iris$Sepal.Length를 사용하여 첫 번째 산점도를 그린 후, points 함수를 사용하여 두 번째 산점도를 추가합니다. 이 경우, 두 번째 산점도는 기존의 산점도 위에 추가됩니다.

#따라서 두 코드 블록의 주요 차이점은 두 번째 코드 블록이 두 번째 산점도를 첫 번째 산점도 위에 추가하는 데 반해, 첫 번째 코드 블록은 첫 번째 산점도를 두 번째 산점도로 대체한다는 점입니다.


### 3. lines()
plot(cars)
lines(cars)

### 4. barplot(), hist(), pie(), mosaicplot(), pair(),
# persp(), contour(), ...


### 5. 그래프 배열
head(mtcars)
?mtcars

## (1) 그래프 4개를 동시에 그리기
par(mfrow=c(2,2))
plot(mtcars$wt, mtcars$mpg)
plot(mtcars$wt, mtcars$disp)
hist(mtcars$wt)
boxplot(mtcars$wt)

par(mfrow=c(1,1))
plot(mtcars$wt, mtcars$mpg)


## (2) 행과 열마다 그래프 개수를 다르게 설정
dev.new()
dev.off()

?layout
layout (matrix(c(1, 2, 3, 3), 2, 2))
layout (matrix(c(1, 2, 3, 3), 2, 2, byrow=T))
plot(mtcars$wt, mtcars$mpg)
plot(mtcars$wt, mtcars$disp)
hist(mtcars$wt)

par(mfrow=c(1,1))

### 6. 특이한 그래프

## (1) arrows()

x <- c(1, 3, 6, 8, 9)
y <- c(12, 56, 78, 32, 9)

plot(x, y)
arrows(3, 56, 7, 100)
text(4, 40, "이것은 샘플입니다", str=60)
?arrows

## (2) 꽃잎 그래프
x <- c(1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 6, 6)
y <- c(2, 1, 4, 2, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1)
plot(x,y)

sunflowerplot(x,y)


## (3) 별 그래프
# 데이터의 전체적인 윤곽을 살펴보는 그래프
# 데이터 항목에 대한 변화의 정도를 한눈에 파악

str(mtcars)

?stars
stars(mtcars[1:4], key.loc = c(13, 0.5), flip.labels = F, draw.segments = T)

## (4) symbols
x <- c(1, 2, 3, 4, 5)
y <- c(2, 3, 4, 5, 6)
z <- c(10, 5, 100, 20, 10)

symbols(x,y,z)

#### 기본 내장 그래프 ####

#### ggplot2 ####

#install.packages("ggplot2")
# http://www.r-graph-gallery.com/ggplot2-package.html
# 레이어 지원
#  1) 배경 설정(데이터)
#  2) 그래프 추가(점, 선, 막대, ...)
#  3) 설정(옵션) 추가(축 범위, 범례, 색, ...)
library(ggplot2)


# 산포도 # geom_point
mpg <- ggplot2::mpg
?ggplot
str(mpg)
ggplot(data=mpg, mapping = aes(x=displ, y=hwy)) + geom_point() + xlim(3, 6) + ylim(10, 30)

# midwest 데이터를 이용하여 전체인구(poptotal)와 아시아 인구
# (popasian) 간에 어떤 관계가 있는지 알아보려고 한다.
# x축은 전체 인구, y축은 아시안 인구로 된 산포도 작성
# 단, 전체인구는 30만명 이하, 아시아 인구는 1만명 이하인 지역만
# 산포도 표시

str(midwest)
options(scipen=99) # 지수를 숫자료 표현
ggplot(data=midwest, mapping = aes(x=poptotal, y=popasian)) + geom_point()
ggplot(midwest, aes(poptotal, popasian)) + geom_point() + xlim(0, 300000) + ylim(0, 10000)


### (2) 막대 그래프 : geom_col(), 히스토그램:geom_bar()
# mpg 데이터에서 구동방식(drv) 별로 고속도로 평균 연비를 조회하고 그 결과를 막대그래프

library(dplyr)

str(mpg)

df_mpg <- mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy))
df_mpg
ggplot(df_mpg, aes(drv, mean_hwy)) + geom_col()
# reorder(,) 재정렬하겠다.
ggplot(df_mpg, aes(reorder(drv, mean_hwy), mean_hwy)) + geom_col()
# reorder(,-) 내림차순
ggplot(df_mpg, aes(reorder(drv, -mean_hwy), mean_hwy)) + geom_col()

#구동방식을 히스토그램으로 보고싶다
ggplot(mpg, aes(drv)) + geom_bar()
# 그래프 그릴 때 질적데이터인지 양적데이터인지 확인
ggplot(mpg, aes(hwy)) + geom_bar()

# 어떤 회사에서 생산한 "suv" 차종의 도시 연비가 높은지 알아보려고 한다
# suv차종을 대상으로 평균 cty가 가장 높은 회사 5곳을 조회하고 그래프로 출력

str(mpg)
top5suvcty <- mpg %>% group_by(manufacturer) %>% filter(class == "suv") %>% summarise(mean_cty = mean(cty)) %>% head(5)
str(top5suvcty)
ggplot(top5suvcty, aes(manufacturer, mean_cty)) + geom_col()

# 자동차 종료 중에서 어떤 종류(class)가 가장 많은지 알아보려고 한다
# 자동차 종류별 빈도를 그래프로 출력
mpg_class <- mpg %>% select(class)
table_class <- table(mpg_class)
plot(table_class)

dfclass <- as.data.frame(table_class)
dfclass
ggplot(dfclass, aes(class, Freq)) + geom_point()

ggplot(dfclass, aes(class, Freq)) + geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Counts of Classes in mpg Dataset", x = "Class", y = "Count")

?geom_bar

p.195

### 영화조 버전(엄)
str(mpg)
df_cty <- mpg %>% group_by(manufacturer) %>% filter(class=="suv") %>% select(class,cty) %>%
  summarize(mean_suv_cty = mean(cty)) %>% arrange(desc(mean_suv_cty)) %>% head(5)

df_cty

ggplot(df_cty, aes(reorder(manufacturer, -mean_suv_cty), mean_suv_cty)) + geom_col()

# 자동차 종류 중에서 어떤 종류(class)가 가장 많은지 알아보려고 한다.# 자동차 종류별 빈도를 그래프로 출력
class_count <- mpg %>% group_by(class) %>% summarize(class_count = n())
ggplot(class_count, aes(reorder(class, class_count), class_count)) + geom_col()


### 영화조 버전(고)
mpg2 <- mpg[mpg$class=="suv", ] %>% group_by(manufacturer) %>% select(class, cty) %>%
  summarise(mean_cty = mean(cty)) %>% arrange(desc(mean_cty)) %>% head(5)
ggplot(data=mpg2, mapping=aes(reorder(manufacturer, -mean_cty), y=mean_cty)) + geom_col()


# 자동차 종류 중에서 어떤 종류(class)가 가장 많은지 알아보려 한다.
# 자동차 종류별 빈도를 그래프로 출력

mpg3 <- mpg %>% group_by(class) %>% summarise(class_count = n())
ggplot(data=mpg3, mapping=aes(x=class, y=class_count)) + geom_col()



### (3) 선 그래프 : geom_line()
# 주로 시계열 그래프에 활용 # 주식, 금융 등

str(economics)
head(economics)
tail(economics)

ggplot(economics, aes(date, uempmed)) + geom_line()
ggplot(economics, aes(date, psavert)) + geom_line()

### (4) 상자 그래프 : geom_boxplot()
ggplot(mpg, aes(drv, hwy)) + geom_boxplot()

# mpg 데이터에서 class가 "compact", "subcompact", "suv"인 자동차의 cty가 어떻게 다른지 비교해보려고 한다.
# 이 세 차종의 도시 연비를 비교
str(mpg)
table(mpg$class)
mpg_class <- mpg %>%
  filter(class %in% c("compact", "subcompact", "suv")) %>%
  select(class, cty)
mpg_class

ggplot(mpg_class, aes(class, cty)) + geom_boxplot()   


### (5) iris 실습
str(iris)

## 꽃받침(Sepal)의 길이에 따라서 폭의 크기가 어떤 관계인지 분포를 확인
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_point(colour="red", pch=1, size=3)

## 종별로 색깔 다르게 하고, size는 꽃잎 크기에 따라 맞춤
# 그리고 배경설정을 이것저것 꾸며보자
ggplot(iris, aes(Sepal.Length, Sepal.Width, color=Species, size=Petal.Length)) + 
  geom_point() + labs(title="꽃받침의 비교", subtitle = "꽃받침의 길이에 대한 폭의 크기 확인",
                      caption = "주석 달기",
                      x = "꽃받침의 길이", y = "꽃받침의 폭")

## geom_point 안에서 이것저것 바꿔보자
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_point(colour=c("red","green","blue")[iris$Species], pch=c(0, 2, 20)[iris$Species], size=c(1, 3, 5)[iris$Species])

## 200p, 203p 꿀팁 확인

## 같은 y축에 여러 그래프 그리기(선그래프)
# wide형을 long형으로 바꾸는 이유!
# 1) 순서를 갖는 데이터가 필요
str(iris)
head(iris)
rownames(iris)
as.integer(rownames(iris))
seq <- as.integer(rownames(iris))
cbind(seq=seq, iris)
iris_data <-cbind(seq=seq, iris)
head(iris_data)

# 2) 각 데이터에 대한 색상(rainbow(), heat.colors(), terrain.colors(), topo.colors(), cm.colors())
ex <- topo.colors(30)
pie(rep(1, 30, col=ex))

# 3) wide형을 long형으로
library(reshape2)

melt(iris_data, id.vars = c("seq", "Species"))
mdata <- melt(iris_data, id.vars = c("seq", "Species"))
View(mdata)

g <- ggplot(mdata) + geom_line(aes(seq, value, color=variable), cex = 0.8)

# 3-1) topo를 이용하여 변수마다 색깔을 지정해보자
cols = topo.colors(4, alpha = 0.5)
cols       
head(iris_data)
names(cols) <- names(iris_data)[2:5]
cols

g + scale_color_manual(name="변수명", values=cols)



#### 텍스트 마이닝과 워드 클라우드 ####

install.packages("rJava")
install.packages("memoise")
install.packages("multilinguer")
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")
install.packages("remotes")

remotes::install_github("haven-jeon/KoNLP", upgrade = "never", INSTALL_opts=c("--no-multiarch"), force=T)
install.packages("KoNLP")

library(KoNLP)
# p.266


#### 지도 시각화 ####
install.packages("mapproj")
install.packages("ggiraphExtra")
library(ggiraphExtra)

str(USArrests)
head(USArrests)
class(USArrests)

library(tibble)
#280p
crime <- rownames_to_column(USArrests, var="state")
head(crime)
crime$state <- tolower(crime$state)
head(crime)

install.packages("maps")
library(ggplot2)

states_map <- map_data("state")
str(states_map)
library(mapproj)
?ggChoropleth

ggChoropleth(data = crime, aes(fill = Murder,
                               map_id = state),
                          map = states_map)

ggChoropleth(data = crime, aes(fill = Murder,
                               map_id = state),
             map = states_map,
             interactive = T)


### 대한민국 지도 그리기 
# https://github.com/cardiomoon/kormaps2014

install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

head(korpop1)
str(korpop1)

head(kormap1)
str(kormap1)

# 컬럼 이름 변경
library(dplyr)
korpop1 <- rename(korpop1, pop="총인구_명", name="행정구역별_읍면동")
head(korpop1)
str(korpop1)

library(ggplot2)
library(mapproj)
library(ggiraphExtra)

ggChoropleth(data = korpop1,
             aes(fill=pop,
                 map_id=code,
                 tooltip=name),
             map=kormap1,
             interactive = T)

# 인터랙티브 그래프
# p.289
install.packages("plotly")
library(plotly)

p <- ggplot(data= mpg,
            aes(x = displ,
                y = hwy,
                col = drv)) + geom_point()
ggplotly(p)
# 특정 영역을 드래그하면 확대
# 더블클릭시 원래대로
# viewer 창에서 [Export -> Save as Web Page...] HTML포맷으로 저장

p <- ggplot(data=diamonds,
            aes(x = cut,
                fill = clarity)) + geom_bar(position = "dodge")
ggplotly(p)


# 인터랙티브시계열 그래프 만들기
# 293p
install.packages("dygraphs")
library(dygraphs)

economics <- ggplot2::economics
head(economics)

library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)
dygraph(eco)
# 특정 영역을 드래그하면 확대
# 더블클릭시 원래대로
dygraph(eco) %>% dyRangeSelector()
# 그래프 아래 날짜 범위 선택기능
# 좌우 이동 가능

# 한번에 여러개의 값을 표현해보자

# 저축률
eco_a <- xts(economics$psavert, order.by = economics$date)
head(eco_a)
# 실업자 수
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)
head(eco_b)

eco2 <- cbind(eco_a, eco_b)
colnames(eco2) <- c("psavert", "unemploy")
head(eco2)

dygraph(eco2)
dygraph(eco2) %>% dyRangeSelector()

#### R 마크다운 문서 만들기
# 310p
ctrl+alt+i = 마크업입력
#209p부터의 내용을 markdown으로 

