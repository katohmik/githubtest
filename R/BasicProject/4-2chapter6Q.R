#### 6장 연습문제 ####

getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()

install.packages("dplyr")
library(dplyr)

install.packages("ggplot2")
library(ggplot2)
#### 5 데이터 다루기 ####

mpg <- as.data.frame(ggplot2::mpg)
summary(mpg)

# Q1 ggplot2() 패키지의 mpg 데이터를 사용할 수 있도록 불러온 후 복사본을 만드세요
mpg <- as.data.frame(ggplot2::mpg)
mpg2 <- mpg

# Q2 복사본 데이터를 이용해 cty는 city로, hwy는 highway로 수정하세요
mpg2 <- rename(mpg2, city = cty, highway = hwy)
mpg2

# Q3 데이터 일부를 출력해 변수명이 바뀌었는지 화인해보세요.
head(mpg2)

#### 6-2 조건에 맞는 데이터만 추출하기 ####

# Q1 자동차 배기량에 따라 고속도로 연비가 다른지 알아보자. displ(배기량)이 4이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 더 높은지 알아보세요.

d4d <- mpg %>% filter(displ <= 4)
mean(d4d$hwy)

d5u <- mpg %>% filter(displ >= 5)
mean(d5u$hwy)

mean(d4d$hwy) > mean(d5u$hwy)

# Q2 자동자 제조 회사에 따라 도시 연비가 다른지 알아보자.
# audi와 toyota 중 어느 manufacturer의 cty가 평균적으로 더 높은지 알아보자.

audi <- mpg %>% filter(manufacturer == "audi")
mean(audi$cty)

toyota <- mpg %>% filter(manufacturer == "toyota")
mean(toyota$cty)

mean(audi$cty) < mean(toyota$cty)


# Q3 chevrolet, ford, honda 자동차의 고속도로 연비 평균을 알아보자
# 이 회사들의 데이터를 추출한 후 hwy 전체 평균을 구해 보세요.
# |(or) or %in%

cfh <- mpg %>% filter(manufacturer == "chevrolet" | manufacturer == "ford" | manufacturer == "honda")
mean(cfh$hwy)

cfh2 <- mpg %>% filter(manufacturer %in% c("chevrolet","ford","honda"))
mean(cfh$hwy)

#### 6-3 필요한 변수만 추출하기 ####

# Q1 mpg 데이터는 11개로 구성
# mpg에서 class, cty 변수를 추출해 새로운 데이터를 만들라.
# 새로 만든 데이터의 일부를 출력해 확인해라.

cc <- mpg %>% select(class, cty)
head(cc)

# Q2 자동차 종류에 따라 도시 연비가 다른지 알아보자
# class가 suv인 자동차와 compact인 자동차 중 어떤 자동차의 cty의 평균이 높은가?

suv <- cc %>% filter(cc$class == "suv")
mean(suv$cty)

compact <- cc %>% filter(cc$class == "compact")
mean(compact$cty)

#### 6-4 순서대로 정렬하기 ####

# Q1 audi에서 생산한 자동차 중에 어떤 자동차 모델의 hwy가 높은지 알아보자
# audi에서 생산한 자동차 중 hwy가 1~5위에 해당하는 자동차의 데이터를 출력해라

audihwy <- mpg %>% filter(mpg$manufacturer == "audi") %>% arrange(desc(hwy))
head(audihwy, 5)

mpg %>% filter(manufacturer == "audi") %>% arrange(desc(hwy)) %>% slice(1:5)

mpg %>% 
  filter(manufacturer == "audi") %>% 
  arrange(desc(hwy)) %>% 
  slice(1:5)

mpg %>%
  filter(manufacturer == "audi") %>%
  arrange(desc(hwy)) %>%
  .[1:5, ]


#### 6-5 파생 변수 추가하기 ####

# Q1 mpg 데이터 복사본을 만들고, cty와 hwy를 더한 합산 연비 변수를 추가하시오

mpg2 <- mpg %>% mutate(ctyhwy = cty + hwy) %>% head
head(mpg2)

# Q2 합산 연비 변수를 2로 나눠 평균 연비 변수를 추가

mpg3 <-mpg2 %>% mutate(avgwy = ctyhwy/2) %>% head
head(mpg3)

# Q3 평균 연비 변수가 가장 높은 자동차 3종의 데이터를 출력

mpg3 %>% arrange(desc(avgwy)) %>% .[1:3, ]

# Q4 1~3을 한줄로 작성해라

mpg4 <- mpg %>% mutate(ctyhwy = cty + hwy, avgwy = ctyhwy/2) %>% arrange(desc(avgwy)) %>% .[1:3, ]
head(mpg4)


#### 6-6 집단별로 요약하기 ####

# Q1 mpg 데이터의 class는 suv, compact등 자동차를 특징에 따라 7종류로 분류한 변수이다.
# 어떤 차종의 도시 연비가 높은지 비교해보려고 한다.
# class별 cty의 평균을 구해라


mean_cty <- mpg %>% group_by(class) %>% summarise(mean_cty=mean(cty))

# Q2 앞 문제의 출력 결과는 class 값 알파벳 순으로 정렬되어 있다.
# 어떤 차종의 도시 연비가 높은지 쉽게 알아볼 수 있도록 cty 평균이 높은 순으로 정렬해라

mean_cty %>% arrange(desc(mean_cty))

# Q3 어떤 회사 자동차의 hwy가 가장 높은지 알아보려고 한다.
# hwy 평균이 가장 높은 회사 세곳을 출력해라.

mpg %>% group_by(class) %>% summarise(mean_hwy = mean(hwy)) %>% arrange(desc(mean_hwy)) %>% .[1:3, ]


# Q4 어떤 회사에서 compact 차종을 가장 많이 생산하는지 알아보자.
# 각 회사별 compact 차종 수를 내림차순으로 정렬해 출력해라

mpg %>% filter(class == "compact") %>% group_by(manufacturer) %>% summarise(n = n()) %>% arrange(desc(n))


#### 6-7 데이터 합치기 ####

# Q1 mpg데이터의 f1 변수는 연료를 의미한다.
# c : cng = 2.35
# d : diesel = 2.38
# e : ethanol E85 = 2.11
# p : premium = 2.76
# r : regular = 2.22
# 우선 이 정보를 이용해 연료와 가격으로 구성된 데이터 프레임을 만들어보라.


fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22))
fuel

# Q1 mpg 데이터에는 연료 종류를 나타낸 f1 변수는 있지만 연료 가격을 나타내는 변수는 없다.
# 위에서 만든 fuel 데이터를 이용해 mpg 데이터에 price_fl 변수를 추가해라.

mpgfl <- left_join(mpg, fuel, by = "fl")
mpgfl

# Q2 확인하기 위해 model, fl, price_fl 변수를 추출 후 앞부분 5행을 출력

mpgfl %>% select(model, fl, price_fl) %>% .[0:5,]

#### 7-1 빠진 데이터를 찾아라! - 결측치 정제하기 ####

# 결측치가 들어있는 mpg 데이터를 이용해 분석 문제를 해결하라
# 일부러 몇 개의 값을 결측치로 만들겠다.

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA
# hwy의 해당 숫자의 인덱스의 위치의 값을 NA로 만들어줌

# Q1 drv별로 hwy 평균이 어떻게 다른지 알아보려고 한다.
# 분석을 하기전에 우선 두 변수에 결측치가 있는지 확인.

table(is.na(mpg$drv))
table(is.na(mpg$hwy))

# Q2 filter()를 이용해 hwy의 결측치를 제외하고, 어떤 구동 방식의 hwy 평균이 높은지 알아보자
# 하나의 dplyr 구문으로 만들어라
# mpg %>% filter(is.na(mpg$hwy)) = 결측치가 있는 녀석들
# is앞에 ! = 결측치를 제외한 녀석들

mpg %>% filter(!is.na(mpg$hwy)) %>% group_by(drv) %>% summarise(mean_hwy = mean(hwy)) %>% arrange(desc(mean_hwy))

#### 7-2 이상한 데이터를 찾아라! - 이상치 정제하기 ####

# 우선 데이터를 불러와 이상치를 만들겠다.
# drv 변수의 값은 4(사륜구동), f(전륜구동), r(후륜구동) 세 종류로 되어 있다.
# 몇개의 행에 존재할 수 없는 값 k를 할당한다.
# cty 변수도 몇 개의 행에 극단적으로 크거나 작은 값을 할당한다.

mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10,14,58,93), "drv"] <- "k"
mpg[c(29,43,129,203), "cty"] <- c(3, 4, 39, 42)

# Q1 drv에 이상치가 있는지 확인해라. 이상치를 결측 처리 후 이상치가 사라졌는지 확인.
# 결측 처리를 할 때는 %in%를 활용해라.

table(mpg$drv)
mpg$drv <- ifelse(mpg$drv == "k", NA, mpg$drv)
table(is.na(mpg$drv))


table(mpg$cty)
mpg$cty <- ifelse(mpg$cty %in% c(3, 4, 39, 42), NA, mpg$cty)
table(is.na(mpg$cty))

# Q2 상자 그림을 이용해 cty에 이상치가 있는지 확인.
# 상자 그림의 통계치를 이용해 정상 범위를 벗어난 값을 결측 처리
# 다시 상자 그림을 만들어 이상치가 사라졌는지 확인

boxplot(mpg$cty)$stats
# 9~26까지가 정상 범위

mpg$cty <- ifelse(mpg$cty < 9 | mpg$cty > 26, NA, mpg$cty)
table(is.na(mpg$cty))

mpg <- mpg %>% filter(!is.na(mpg$cty))
boxplot(mpg$cty)

# Q3 두 변수의 이상치를 결측 처리 했으니 이제 분석해라
# 이상치를 제외한 다음 drv 별로 cty 평균이 어떻게 다른지 알아봐라.
# 하나의 dplyr 구문으로 만들어라.

table(is.na(mpg))

mpg3 <-mpg %>% filter(!is.na(mpg$cty)) %>% filter(!is.na(mpg$drv)) %>% group_by(drv) %>% summarise(mean_cty=mean(cty)) %>% arrange(desc(mean_cty))
table(is.na(mpg3))
mpg3
