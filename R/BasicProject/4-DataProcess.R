#### 기술 통계량 ####
getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


### table()
aws <- read.delim("../data/AWS_sample.txt", sep="#")
head(aws)
str(aws)

table(aws$AWS_ID)
?table
table(aws$AWS_ID, aws$X.)
table(aws[, c("AWS_ID", "X.")]) # 위의 코드와 결과가 같다

aws[2500:3100, "X."] = "modified"
aws[2500:3100, "X."]

table(aws$AWS_ID, aws$X.)

prop.table(table(aws$AWS_ID)) # 비율을 보여준다.
prop.table(table(aws$AWS_ID))*100
paste(prop.table(table(aws$AWS_ID))*100, "%")
paste(prop.table(table(aws$AWS_ID))*100, "%", sep = "") # 공백없애주기


### 기술 통계 함수의 모듈화
# 각 컬럼 단위로 빈도와 최대, 최소값 계산

test <- read.csv("../data/test.csv", header=T)
head(test)
length(test)
str(test)

table(test$A)
max(test$A)
min(test$A)


# 컬럼별로 table, max, min이 나오도록
data_summary <- function(df){
   for(idx in 1:length(df)){
      cat(idx, "번째 컬럼의 빈도 분석 결과")
      print(table(df[idx]))
      cat("\n")
   }
   for(idx in 1:length(df)){
      f <- (table(df[idx]))
      cat(idx, "번째 컬럼의 최대/최소값 결과 : \t" )
      cat("max=", max(f), ", min=", min(f), "\n")
   }
}

data_summary(test)

# R 책의 6장부터
# 책의 연습문제들 다 풀어볼 것.

#### dplyr ####
# dplyr = pandas와 같은 존재
# 내장함수만 300여가지
install.packages("dplyr")
library(dplyr)
ls("package:dplyr")

exam <- read.csv("../data/csv_exam.csv")
exam

### 1. filter()
# sql에서 where와 비슷함
# 1반 학생들의 데이터 추출

exam[which(exam$class == "1"),]
exam[exam$class == "1", ]
subset(exam, class==1)

?filter
filter(exam, class==1)
# "%>%"

exam %>% filter(class==1)

# 2반이면서 영어점수가 80점 이상인 데이터만 추출
subset(exam, class==2)
subset(exam, class==2)>=80

exam[(exam$class == 2 & exam$english >= 80), ]
exam %>% filter(class == 2 & english >= 80)

# 1, 3, 5반에 해당하는 데이터만 추출
exam %>% filter(class == 1 | class ==3 | class ==5)
exam %>% filter(class %in% c(1,3,5))


### 2. select()
# 수학점수만 추출
exam[, 3] # 벡터타입으로 가져온다
exam %>% select(math) # 데이터프레임으로 가져온다

# 반, 수학, 영어점수 추출
exam[, c(2, 3, 4)]
exam %>% select(class, math, english)

# 1반 학생들의 수학점수만 추출(2명만 조회)
# SELECT class, math FROM exam WHERE class==1 limit 2;
result = filter(exam, class==1)
result = select(result, math)
head(result, 2)

exam %>% filter(class==1) %>% select(math) %>% head(2)

### 3. arrange()

exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class, math)


### 4. mutate()
exam$sum <- exam$math + exam$english + exam$science
exam


exam$mean <- exam$sum / 3
exam

exam <- exam[, -c(6, 7)] # 6번째, 7번째 컬럼을 지우겠다
                         # 파이썬에서는 역순이지만, R에서는 제거
exam

# mutate를 이용하면 괄호안에서 한번에 처리가 가능하고
# sum을 먼저 처리하고나서 바로 뒤에 sum을 이용할 수 있다.
exam <- exam %>% mutate(sum=math+english+science, means=sum/3)
exam

### 5. summarize()
# 자동으로 파생변수를 만들어 준다
exam %>% summarise(mean_math=mean(math), sum_math=sum(math), median_math=median(math), count=n())
exam

### 6. group_by()
# 5번을 반별로 요약
exam %>% group_by(class) %>% summarise(mean_math=mean(math), sum_math=sum(math), median_math=median(math), count=n())

### 7. left_join(), bind_rows()
test1 <- data.frame(id=c(1, 2, 3, 4, 5),
                    midterm=c(60, 70, 80, 90, 85))
test2 <- data.frame(id=c(1, 2, 3, 4, 5),
                    midterm=c(11, 22, 33, 44, 55))

left_join(test1, test2, by="id") # wide형 테이블, 열로 길어지는 테이블
bind_rows(test1, test2) # long형 테이블, 행으로 길어지는 테이블


### 8. 연습문제1
install.packages("ggplot2") # R에서 독보적인 위치의 시각화 패키지
library(ggplot2)
head(ggplot2::mpg)
# cyu : 도시연비
# hwy : 고속도로 연비
# fl : 연료
str(ggplot2::mpg)
str(test)
# tibble = data.frame형식이지만 조금 더 개선한 타입
class(ggplot2::mpg)
mpg <- as.data.frame(ggplot2::mpg) # mpg라는 변수에 저장하고, data.frame으로 바꿔주자.(티블로 작업하면 약간씩 다른 경우가 있음.)
class(mpg)
tail(mpg)
names(mpg)
dim(mpg)
View(mpg)

# (1) 배기량(displ)이 4이하인 차량의 모델명, 배기량, 생산연도 조회
mpg %>% filter(displ<=4) %>% select(model, displ, year)


# (2) 통합연비 파생변수(total)를 만들고 통합연비로 내림차순 정렬을
# 한 후에 3개의 행만 선택해서 조회
# 통합연비 : total <- (cty + hwy) / 2
mpg <- mpg %>% mutate(total=(cty + hwy) / 2)
mpg %>% arrange(desc(total)) %>% head(3)

# (3) 회사별로 "suv"차량의 도시 및 고속도로 통합연비 평균을 구해
# 내림차순으로 정렬하고 1위 ~ 5위까찌 조회
mpg %>% filter(class == "suv")
mpg %>% group_by(manufacturer) %>% filter(class == "suv") %>% summarise(mean_total=mean(total)) %>% arrange(desc(mean_total)) %>% head(5)



# (4) 어떤 회사의 hwy연비가 가장 높은지 알아보려고 한다.
# hwy평균이 가장 높은 회사 세곳을 조회
mpg %>% group_by(manufacturer) %>% summarise(mean_hwy=mean(hwy))%>% arrange(desc(mean_hwy)) %>% head(3)

# (5) 어떤 회사에서 compact(경차) 차종을 가장 많이 생산하는지
# 알아보려고 한다. 각 회사별 경차 차종 수를 내림차순으로 정렬

mpg %>% group_by(manufacturer) %>% filter(class == "compact") %>% summarise(count=n()) %>% arrange(desc(count))
# (6) 연료별 가격을 구해서 새로운 데이터 프레임을 만든 후 (fuel)
# 기존 데이터셋과 병합하여 출력.
# c:CNG = 2.35, d:Disel = 2.38, e:Ethanol = 2.11, p:Premium = 2.76, r:Regular = 2.22
c <- "CNG"
d <- "Disel"
e <- "Ethanol"
p <- "Premium"
r <- "Regular"
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"), price=c(2.35, 2.38, 2.11, 2.76, 2.22))
fuel
left_join(mpg, fuel, by="fl")
# 나중에 해결

fuel_price = data.frame(fl = c("c","d","e","p","r"), price=c(2.35,2.38,2.11,2.76,2.22))
fuel_price

mpg_fuel_price <- left_join(mpg, fuel_price, by="fl")
mpg_fuel_price

# (7) 통합 연비의 기준치를 통해 합격(pass)/불합격(fail)을 부여하는
# test 라는 이름의 파생변수 생성, 이때 기준은 20으로 한다.
mpgtest <- mpg %>% summarise(test = (total>=20))
which(mpgtest$test == TRUE)
which(mpgtest$test == FALSE)
mpgtest[which(mpgtest$test == TRUE), "test"] = "pass"
mpgtest[which(mpgtest$test == FALSE), "test"] = "fail"
mpgtest

## (7) 정승빈 버전
test_pf<-function(x){
   if(x>20)return("pass") else return("fail")
}
sapply(mpg$total,test_pf)
mpg$test_result<-sapply(mpg$total,test_pf)
mpg

## (7) 엄진성 버전

mpg_total %>% mutate(test= ifelse(total>20, "pass", "fail"))

# (8) test에 대해 합격과 불합격을 받은 자동차가 각각 몇 대인가?
table(mpgtest)

# (9) 통합 연비 등급을 A, B, C 세 등급으로 나누는 파생변수를 추가
# grade 라는 변수
# 30이상이면 A, 20~29는 B, 20미만이면 C등급으로 분류
mpggrade <- mpg %>% summarise(grade = total)
mpggrade[which(mpggrade$grade >= 30), "grade"] = "A"
mpggrade[which(mpggrade$grade >= 20 & mpggrade$grade <= 29), "grade"] = "B"
mpggrade[which(mpggrade$grade < 20), "grade"] = "C"
mpggrade

mpg$grade <- mpg %>% summarise(grade = total)
mpg[which(mpg$grade >= 30), "grade"] = "A"
mpg[which(mpg$grade >= 20 & mpg$grade <= 29), "grade"] = "B"
mpg[which(mpg$grade < 20), "grade"] = "C"
mpg
which(mpg$grade == "A")

### (9) 정승빈 버전

total_grade<-function(x){
   if(x>=30)return("A") else if(x>20) return("B") else return("C")
}
sapply(mpg$total,total_grade)
mpg$grade<-sapply(mpg$total,total_grade)
mpg

### (9) 엄진성 버전

head(mpg_test)
mpg_grade <- mpg_test %>% mutate(grade = ifelse(total >=30, "A", ifelse(total >20, "B", "C")))
table(mpg_grade$grade)

grade <- mpg_test %>% select(total) %/% 10
grade
result <- switch(as.character(grade), "3"="C","2"="B","1"="A")
result


### 9. 연습문제2

midwest <- as.data.frame(ggplot2::midwest)
str(midwest)
head(midwest)

# (1) 전체 인구 대비 미성년 인구 백분율(ratio_child) 파생변수 추가
midwest %>% summarise(ratio_child = ((poptotal - popadults) / poptotal))
midwest$ratio_child <- (midwest$poptotal-midwest$popadults)/midwest$poptotal*100
midwest
# (2) 미성년 인구 백분율이 가장 높은 상위 5개 지역(county)의
# 미성년 인구 백분율을 조회
midwest %>% group_by(county) %>% arrange(desc(midwest$ratio_child)) %>% head(5)


# (3)기준에 따라 미성년 비율 등급변수를 추가하고(grade), 각 등급에
# 몇 개의 지역이 있는지 조회
# 기준 : 미성년 인구 백분율이 40이상이면 "large",
# 30이상이면 "middle", 그렇지 않으면 "small"
midwest %>% summarise(grade=total)
midwest$grade <- midwest %>% summarise(grade = ratio_child)
midwest[which(midwest$grade >= 40), "grade"] = "large"
midwest[which(midwest$grade >= 30 & midwest$grade <= 39), "grade"] = "middle"
midwest[which(midwest$grade <= 29), "grade"] = "small"
midwest

which(midwest$grade == "large")
which(midwest$grade == "middle")
which(midwest$grade == "small")
table(midwest$grade)


# (4) 전체 인구 대비 아시아인 인구 백분율(ratio_asian) 변수를 추가,
# 하위 10개 지역의 state, county, 아시아인 인구 백분율을 조회
str(midwest)
midwest$ratio_asian <- midwest %>% summarise(ratio_asian = percasian)
midwest %>% group_by(state) %>% arrange(ratio_asian) %>% head(10)
midwest %>% group_by(county) %>% arrange(ratio_asian) %>% head(10)
midwest %>% group_by(county) %>% arrange(ratio_asian) %>% head(10)
midwest %>% select(state, county, ratio_asian) %>% arrange(ratio_asian) %>% head(10)




#### Data Preprocessing ####

### (1) 변수 이름 변경
df_raw <- data.frame(var1=c(1,2,3), var2=c(2,3,4))
df_raw

# 기본(내장) 함수
names(df_raw)
names(df_raw) <- c("v1", "v2")
names(df_raw)

# dplyr
library(dplyr)
rename(df_raw, var1=v1, var2=v2) # var1(바꾸려는이름)=v1(지금있는이름), 평소와는 순서가 반대
names(df_raw) # 원본은 그대로, rename만으로는 복사본 처리되었단느 말
df_raw <- rename(df_raw, var1=v1, var2=v2)
names(df_raw)

### (2) 결측치 처리
data1 <- read.csv("../data/dataset.csv", header=T)
head(data1)
str(data1)

# resident : 1~5까지의 값을 갖는 명목변수로 거주지를 나타냄
# gender : 1~2까지의 값을 갖는 명목변수로 남/녀를 나타냄
# job : 1~3까지의 값을 갖는 명목변수. 직업을 나타냄
# age : 양적변수(비율) : 2~69
# position : 1~5까지의 값을 갖는 명목변수. 직위를 나타냄
# price : 양적변수(비율) : 2.1 ~ 7.9
# survey : 만족도 조사 : 1~5까지 명목변수

## 1) 결측치 확인
is.na(data1)
table(is.na(data1))

summary(data1) # 마지막에 각 변수의 결측치 수가 확인가능
summary(data1$price)


## 2) 결측치 제거
sum(data1$price) # 결측치가 있어서 실행불가
sum(data1$price, na.rm=T) # 계산에서만 결측치를 빼고 계산한것. 원본에는 그대로

na.omit()
price2 <- na.omit(data1$price) 
summary(price2)

## 3) 결측치 대체 : 0으로 대체
price3 <- ifelse(is.na(data1$price), 0, data1$price)
summary(price3)

## 3) 결측치 대체 : 평균으로 대체
price4 <- ifelse(is.na(data1$price), round(mean(data1$price, na.rm=T),2), data1$price)
summary(price4)


### (3) 이상치 처리
table(data1$gender)
barplot(table(data1$gender))
pie(table(data1$gender))

## 양적 데이터 : 산술평균, 중앙값, 조화평균 > 히스토그램,
## 상자그래프. 시계열 그래프. 산포도

plot(data1$price)
boxplot(data1$price)

## 이상치 확인
data2 <- subset(data1, price>=2 & price<=8)
data2

length(data1$price)
length(data2$price)

plot(data2$price)
boxplot(data2$price)

summary(data2$age)
plot(data2$age)
boxplot(data2$age)


#### Feature Engineering ####

View(data2)


## 가독성을 위한 데이터 변경
data2$resident2[data2$resident == 1] <- "1. 서울특별시"
data2$resident2[data2$resident == 2] <- "2. 인천특별시"
data2$resident2[data2$resident == 3] <- "3. 대전특별시"
data2$resident2[data2$resident == 4] <- "4. 대구특별시"
data2$resident2[data2$resident == 5] <- "5. 시구군"
View(data2)


## 척도 변경 : Binning(양적 -> 질적)
## 나이 변수를 청년층(30층 이하), 중년층(31~55이하), 장년층(56~)

data2$age2[data2$age <= 30] <- "청년층"
data2$age2[data2$age <= 55 & data2$age >= 31] <- "중년층"
data2$age2[data2$age >= 56] <- "장년층"
View(data2)


## 역코딩 : 주로 설문조사에서 사용되는 리쿠르트 척도의 순서
## 바꾸고자 할 때 # 1  2 3 4 5 였던 애를 5 4 3 2 1
table(data2$survey)

data2$survey2 <- 6 - data2$survey
table(data2$survey2)

## Duumy : 척도 변경(질적 -> 양적)

house_data <- read.csv('../data/user_data.csv', header=T )
View(house_data)

# house_type(거주 유형) : 단톡주택(1), 다가구주택(2), 아파트(3),
# 오피스텔(4)
house_data$house_type2 <- ifelse(house_data$house_type==1 | house_data$house_type==2, 0, 1)
table(house_data$house_type2)


## 데이터의 구조 변경(wide type, long type)
## reshape, reshape2, tidyr, ...
## melt() : wide -> long로 변경, cast() : long -> wide로 변경
#install.packages("reshape2")
library(reshape2)

head(airquality)
str(airquality)

m1 <- melt(airquality, id.vars = c("Month", "Day"))
?melt
View(m1)

m2 <- melt(airquality, id.vars = c("Month", "Day"),
           variable.name = "Climate_var",
           value.name = "Climate_val")
View(m2)

?dcast
dc1 <- dcast(m2, Month+Day ~ Climate_var)
View(dc1)

## 예제1
data1 <- read.csv("../data/data.csv")
View(data1)

# 날짜별로 컬럼을 생성해서 wide하게 변경
dc2 <- dcast(data1, Customer_ID ~ Date)
View(dc2)

# 다시 long형으로 변경
m3 <- melt(dc2, id.vars = "Customer_ID", variable.name = "Date", value.name = "Buy")
View(m3)


## 예제2
data2 <- read.csv("../data/pay_data.csv")
View(data2)

# product_type을 wide하게 변경

#dc3 <- dcast(data2, user_id ~ product_type)
dc3 <- dcast(data2, user_id+pay_method ~ product_type)
View(dc3)


#### 주제 : 극단적 선택의 비율은 어느 연령대가 가장 높은가? ####
## (사망원인 통계)@
# 자살 방지를 위한 도움의 손길은 누구에게 더 지원해야 할까
library(dplyr)
# 2019_suicide.csv

#### 정승빈 버전 ####
View(suicide_data)
str(suicide_data)
head(suicide_data)

#row 정리
suicide_data <- suicide_data[-1, ]
suicide_data <- suicide_data[suicide_data$gender != "계", ]

#결측치 변경
summary(suicide_data)
suicide_data$death <- ifelse(suicide_data$death == "-", "0", suicide_data$death)
suicide_data$death <- ifelse(suicide_data$death == "-", "0", suicide_data$death)

#컬럼 타입 변경
suicide_data$death <-   as.numeric(suicide_data$death)
suicide_data$ratio <-as.numeric(suicide_data$ratio)
str(suicide_data)

#자살 비율 컬럼 추가
#
suicide_data$total <- round(suicide_data$death/sum(suicide_data$death),4)*100

#중간점검
head(suicide_data)
View(suicide_data)

suicide_data %>% arrange(desc(total)) %>% head(5)
suicide_data %>% arrange(desc(ratio)) %>% head(5)
> suicide_data %>% arrange(desc(total)) %>% head(5)

> suicide_data %>% arrange(desc(total)) %>% head(5)
cause gender       age death ratio total
1 고의적 자해(자살) (X60-X84)   남자 55 - 59세  1115  52.2  4.04
2 고의적 자해(자살) (X60-X84)   남자 45 - 49세  1090  47.9  3.95
3 고의적 자해(자살) (X60-X84)   남자 50 - 54세  1050  48.9  3.81
4 고의적 자해(자살) (X60-X84)   남자 60 - 64세   993  55.8  3.60
5 고의적 자해(자살) (X60-X84)   남자 40 - 44세   795  40.6  2.88
> suicide_data %>% arrange(desc(ratio)) %>% head(5)
cause gender       age death ratio total
1 고의적 자해(자살) (X60-X84)   남자  90세이상    79 171.6  0.29
2 고의적 자해(자살) (X60-X84)   남자 85 - 89세   212 146.8  0.77
3 고의적 자해(자살) (X60-X84)   남자 80 - 84세   479 123.8  1.74
4 고의적 자해(자살) (X60-X84)   남자 75 - 79세   607  89.8  2.20
5 고의적 자해(자살) (X60-X84)   남자 70 - 74세   556  62.9  2.02

자살자 중에서 가장 큰 비중을 차지하는 집단은 중장년의 남성이고, 
십만명 당 자살 비율이 가장 높은 집단은 노령의 남성. 
고령의 경우 자살을 하더라도 모수 자체가 적어 그 비율이 커 보일 수 있기 때문에 
도움의 손길이 가장 절실한 집단은 중장년의 남성 

#### 한태성 버전 ####
#컬럼명 변경
suicide_data1 <- suicide_data[-1]
names(suicide_data1) <- c("성별","나이","사망자수","사망율")
names(suicide_data1)

#필요없는 컬럼 제거
suicide_data1 <- suicide_data1[-1,]

#정렬을 위한 데이터 수정
suicide_data1[suicide_data1["나이"] == "1 - 4세","나이"] <- "01 - 04세"
suicide_data1[suicide_data1["나이"] == "5 - 9세","나이"] <- "05 - 09세"

#데이터 타입 변경 문자열 -> 숫자형
suicide_data1$사망자수 <- as.integer(suicide_data1$사망자수)
suicide_data1$사망율 <- as.numeric(suicide_data1$사망율)
View(suicide_data1)
str(suicide_data1)

## 데이터 구분
#사망자수 데이터
suicide_cnt_data <- suicide_data1[-4]
#사망율 데이터
suicide_per_data <- suicide_data1[-3]

#long to wide, 결측치 처리
scd <- dcast(suicide_cnt_data, 나이 ~ 성별)
scd[is.na(scd)] <- 0
View(scd)

spd <- dcast(suicide_per_data, 나이 ~ 성별)
spd[is.na(spd)] <- 0
View(spd)

suicide_data <- read.csv("../data/2019_suicide.csv")
View(suicide_data)

#### 고은경 버전 ####
View(data)
str(data)

# 불필요한 컬럼 제거, 컬럼명 변경 #
data <- data[, -1]
names(data) <- c("성별", "연령", "사망자수", "사망률")

# 사망률 "-"를 0으로 변경 후 숫자형으로 변환 #
data$사망률 <- ifelse(data$사망률=="-", 0, data$사망률)
data$사망률 <- as.numeric(data$사망률)

#----- 성별로 사망자수 확인 -----#

d1 <- data %>% group_by(성별) %>% summarize(suicide_cnt=sum(사망자수))
d1
# 단순히 사망자수만 고려하면 남자가 더 많은 극단적 선택을 했음을 알 수 있다.


#----- 연령별로 사망자수 확인 -----#

d2 <- data %>% group_by(연령) %>% summarize(suicide_cnt=sum(사망자수)) %>% arrange(desc(suicide_cnt)) %>% head(5)
d2
# 45-49세인 연령대가 제일 많은 극단적 선택을 했음을 알 수 있다.


#----- 연령대와 성별을 같이 고려해 사망자수 확인 -----#

# 성별이 "계"인 행 지운 데이터를 다른 데이터 프레임에 담기 #
d3 <- data[!(data$성별=="계"), ]

d3 <- d3 %>% group_by(연령, 성별) %>% summarize(suicide_cnt=sum(사망자수)) %>% arrange(desc(suicide_cnt))
head(d3)
# 남자 55-59세가 가장 많이 극단적 선택을 했음을 알 수 있다
# 전체 성별에서 연령대만 봤을 땐 45-49세가 가장 많았지만 성별과 같이 비교해보면 달라짐을 알 수 있다.


#----- 성별마다 가장 많은 극단적 선택을 하는 연령대 뽑아내기 -----#
d3[d3$성별=="남자",] %>% head(1)
d3[d3$성별=="여자",] %>% head(1)

#### 엄진성 버전 ####

suicide_data <- read.csv("../data/2019_suicide.csv", header=T, encoding="utf-8", skip=1) # 첫번째 행을 제거,
names(suicide_data) # 열의 이름 확인
suicide_data <- rename(suicide_data, dead_num=사망자수..명., dead_per=사망률..십만명당.) # 열의 이름 재설정

# 계를 제거하고 가져오기
suicide_data <- suicide_data[suicide_data$성별 != "계",]

View(suicide_data)
# 결측치 "-" 제거
suicide_data$dead_num <- ifelse(suicide_data$dead_num == "-", "0", suicide_data$dead_num)
suicide_data$dead_per <- ifelse(suicide_data$dead_per == "-", "0", suicide_data$dead_per)

View(suicide_data)

str(suicide_data) # 데이터 타입 확인: dead_per 에 "-"이 있기 때문에 수 계산이 불가능.

suicide_data$dead_per <- as.numeric(suicide_data$dead_per)  # 데이터 타입 숫자로 변경

# 총 인구 수 대비 자살률 컬럼 추가
suicide_data$dead_ratio <- round(suicide_data$dead_num /  sum(suicide_data$dead_num),3) * 100

suicide_data


# 총 인구수 대비 자살률: 성별과 나이에 따라, 자살률 확인 -> 사망률의 크기만 보면 전반적으로 여성보다 남성의 자살률이 더 높음.
suicide_data %>% filter(성별=="남자") %>% arrange(desc(dead_ratio)) %>% head(10)
suicide_data %>% filter(성별=="여자") %>% arrange(desc(dead_ratio)) %>% head(10)

plot(suicide_data$dead_ratio)

# 10만 명당 자살률 역시 수만 보면, 남성의 자살률이 더 높음.
suicide_data %>% filter(성별=="남자") %>% arrange(desc(dead_per)) %>% head(10)
suicide_data %>% filter(성별=="여자") %>% arrange(desc(dead_per)) %>% head(10)


#### Database 연동 ####
# https://mariadb.com/kb/en/rmariadb/
install.packages("rJava")
install.packages("DBI")
install.packages("RMySQL")

library(RMySQL)

conn <- dbConnect(MySQL(), dbname="testdb", user="root","1111")
conn


dbListTables(conn)
result <- dbGetQuery(conn, "select * from emp")
result

dbDisconnect(conn)

dbListTables(conn, "emp")

# DML
dbSendQuery(conn, "delete from tbla")
dbGetQuery(conn, "select * from tbla")


# 파일로부터 데이터를 읽어들여 DB에 저장

file_score <- read.csv("../data/score.csv", header=T)
file_score

dbWriteTable(conn, "score", file_score, row.names=F)
result <- dbGetQuery(conn, "select * from score")
result

dbDisconnect(conn)

#### sqldf ####
detach("package:RMySQL", unload=T)
install.packages("sqldf")
library(sqldf)

head(iris)
sqldf("select * from iris limit 6")

# 품종별로 sepal.length, petal.length를 10개까지 조회
# 단, petal.length가 큰 순으로 정렬하여 조회
iris %>% select(Species, Sepal.Length, Petal.Length) %>% group_by(Species) %>% arrange(desc(Petal.Length)) %>% head(10)


sqldf('select Species, "Sepal.Length", "Petal.Length" from iris group by Species order by "Petal.Length" desc limit 10')

# 중복된 품종 제거
unique(iris$Species)
sqldf("select distinct species from iris")


table(iris$Species)
sqldf("select Species, count(Species) from iris group by Species")
