getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


#### 단일(단순) 회귀 분석 ####

# y = ax + b
# a를 찾는게 머신러닝의 목표

women
?women

plot(weight ~ height, data=women)


fit <- lm(weight ~ height, data=women)
fit

abline(fit, col="blue") # 직선을 그리는 함수이므로 3개 이상의 다항일경우 사용할 수 없음
summary(fit)

# 회귀분석에서는 p value를 보는 것이 아니라 R-squared(0~1)가 1에 가까울수록 신뢰도가 높다

cor.test(women$weight, women$height)
0.9954948^2


### 설명력을 검증하기 위한 그래프
plot(fit)

par(mfrow=c(2,2))
plot(fit)

# QQ도 : 정규분포를 확인하는 그래프

### 다항 회귀 분석(Polynomial Regression)


fit1 <- lm(weight ~ height + I(height^2), data=women)
fit1
summary(fit1)

plot(weight ~ height, data = women)
lines(women$height, fitted(fit1), col="red") # 항을 하나 추가하여 곡선으로 그려줌 # 머신러닝에는 쓰지않음
par(mfrow=c(2,2))
plot(fit1)

shapiro.test(resid(fit)) # 0.1866 
shapiro.test(resid(fit1)) # 0.506 # 훨씬 더 정규분포에 가까운 것을 확인



#### 실습1  ####
getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()

mydata <- read.csv("../data/regression.csv")
View(mydata)

# social_welfare : 사회복지시설
# active_firms : 사업체 수
# urban_park : 도시 공원
# doctor : 의사
# tris : 폐수 배출 업소
# kindergarten : 유치원

str(mydata)

fit <- lm(birth_rate ~ kindergarten, data=mydata)
summary(fit) # R-squared:  0.03305 # 설명력이 3%밖에 안된다. # kindergarten 하나로는 분석을 포기해야한다.
# 하지만 실습이니까 설명력 3%를 끌어올리려는 노력을 해보겠다.

par(mfrow=c(2,2))
plot(fit)

shapiro.test(resid(fit)) # p-value = 8.088e-05, - 이므로 정규분포가 아니다.

# log로 보정하기
fit1 <- lm(log(birth_rate) ~ log(kindergarten), data=mydata)
fit1
summary(fit1) # 변수에 log를 씌워줬더니 설명력이 0.03745로 올랐다.

par(mfrow=c(2,2))
plot(fit1)

shapiro.test(resid(fit1)) # 0.2227 # 0.05를 넘었기 때문에 정규분포가 맞다.


fit2 <- lm(birth_rate ~ dummy, data=mydata)
summary(fit2) # R-squared:  0.0317 # 3%밖에 안되는 아주 약한 설명력

#### 다중 회귀 분석 ####
# https://blog.naver.com/choongchoongchoong/222632409545
# https://rpubs.com/Minkook/737813
# https://blog.naver.com/dbwjd516/222953224157
# y = a1x1 + a2x2 + a3x3 + ... + b

house <- read.csv("../data/kc_house_data.csv", header = T)
str(house)

## 가설 : 거실의 크기가 크면 매매 가격이 비쌀 것이다.
reg1 <- lm(price ~ sqft_living, data = house)
summary(reg1) # Adjusted R-squared:  0.4928 # 설명력이 49%

# 먼저 살펴볼 변수
# sqft_living, bathrooms, sqft_lot(정원의 크기), floors

attach(house)
x = cbind(sqft_living, bathrooms, sqft_lot, floors)
cor(x)

cor(x, price)

reg2 <- lm(price ~ sqft_living + floors, data = house)
summary(reg2)
# floors의 pvalue가 0.0667로 나와버렸다. 해결해야한다.

# 조절 변수를 추가 했을 떄 어떻게 달라지나?
# Interation? 임의로 넣어준 것, 꼭 넣어야하는 것이 아님
reg2_1 <- lm(price ~ sqft_living + floors + sqft_living*floors, data = house)
summary(reg2_1)
# floors의 p값은 원하는대로 나오도록 바뀌었다.
# floors -1.164e+05(Estimate) #층수가 올라갈수록 가격이 내려가는 것으로 -로 바뀌었다

# 다중 공선성 확인
install.packages("car")
library(car)
vif(reg2_1) # vif가 크다는 것 = 두 변수의 분산이 겹치는 곳이 많다 = 분산의 공통점이 많다
# 공선성이 너무 크므로 다른 변수로 다시 해보자
# sqft_living & floors는 같이 쓰지 말것
# 그래서 공선성이 몇이상이어야 높은건데? 


## 다른 변수를 가지고 시도
x = cbind(floors, sqft_above, sqft_basement)
cor(x)


x = cbind(floors, bedrooms)
cor(x)

reg3 <- lm(price ~ floors + bedrooms, data = house)
reg3
summary(reg3)

vif(reg3) # 겹치는 것이 적을수록 회귀분석에서 유리하다.


x = cbind(floors, bedrooms, waterfront)
cor(x)

cor(x, price)

## 또 다른 변수하나 더 추가

reg4 <- lm(price ~ floors + bedrooms + waterfront, data = house)
summary(reg4)

vif(reg4)


## 보정해보자

reg5 <- lm(price ~ floors + bedrooms + waterfront + bedrooms*waterfront, data = house)
summary(reg5)

vif(reg5) # 더미변수인 waterfront가  10.460394이 나왔다.(더미가 3이상일경우 큰문제)

reg6 <- lm(price ~ floors + bedrooms + waterfront + floors*waterfront, data = house)

summary(reg6)
vif(reg6) # 얘도 waterfront가 9인데 무조건 믿지 말라고? 추가적인 공부 필요요


#### 실습2 ####
library(car)

View(state.x77)

# 원하는 컬럼만 가져오기
states <- as.data.frame(state.x77[, c("Murder", "Population", "Illiteracy", "Income", "Frost")])

View(states)

fit <- lm(Murder ~ ., data = states)
summary(fit)
# 다중회귀일 떈 Adjusted R-squared:  0.5285를 본다
# Income      6.442e-05  6.837e-04   0.094   0.9253    
# Frost       5.813e-04  1.005e-02   0.058   0.9541
# Income, Frost의 p값이 0.92, 0.95여서 필요없다고 버리지 말자
# 나중에 교차했을 때 유의미한 요소로 작용할수도

vif(fit)
sqrt(vif(fit))
4 / (50 -4 -1)

### 이상 관측치를 확인할 수 있는 그래프
influencePlot(fit, id=list(method="identify"))

car::avPlots(fit, ask=FALSE, id.method="identify")

influencePlot(fit, id.method="identity", main="Influence Plot")

car::influencePlot(fit, id.method="identity", main="Influence Plot",
                   sub="Circle size is proportional to Cook`s distance")

### 회귀 모형의 교정
par(mfrow=c(2, 2))
plot(fit)
# 선형성(1,1), QQ(1,2), 등분산(2,1), 이상치(2,2) 확인하는 그래프

## 정규성을 만족하지 않을 때 : 결과 변수에 람다승
# -2, -1, -0.5, 0, 1, 2
shapiro.test(resid(fit))

summary(states$Murder)

powerTransform(states$Murder) # 0.6을 곱승(람다승)해주면 좋겠다라고 알려줌
summary(powerTransform(states$Murder))
# LR test, lambda = (0) 5.665991  1 0.017297
# LR test, lambda = (1) 2.122763  1 0.14512
# 0을 넣어도 1을 넣어도 변화가 크지 않기 때문에 바꿀 필요가 없다
# 이미 정규분포를 만족하고 있기 때문이다

## 선형성을 만족하지 않을 때
boxTidwell(Murder ~ Population + Illiteracy, data = states)
# Population       0.86939             -0.3228   0.7483
# populataion에 0.86을 곱승(람다승)해봐라, 0.74로 나올거다
# Illiteracy       1.35812              0.6194   0.5388
# Illiteracy에 1.35을 곱승(람다승)해봐라, 0.53으로 나올거다

states$Population <- states$Population ^ 0.85
states$Illiteracy <- states$Illiteracy ^ 1.35
fit2 <- lm(Murder ~ Population + Illiteracy, data = states)
summary(fit2)

## 등분산성을 만족하지 않을 경우
ncvTest(fit) # 0.2367 # 0.05를 넘으므로 등분산이다

spreadLevelPlot(fit) # 만약 등분산이 아니라면 1.2(람다승) 해봐라

## 회귀 모형의 선택
# 1. Backward Stepwise Regression
# #1 : 모든 독립변수를 대상으로 하나씩 빼는 방법

# 2. Forward Stepwise Regression
# #2 : 독립변수를 하나씩 추가하면서 테스트

# 3. : All subset Regression : 

# AIC(Akaike's Information Criterion) : AIC는 모델의 적합도와 복잡도를 모두 고려하여 계산되므로, 낮은 AIC 값을 가지는 모델이 더 적합한 모델로 간주됨. 그러나 AIC는 모델 간 비교에만 사용되며, 모델의 성능 자체를 측정하지는 못함.이 값은 작을수록 좋다.


fit1 <- lm(Murder ~., data=states)
summary(fit1)

fit2 <- lm(Murder ~ Population + Illiteracy, data = states)
summary(fit2)

AIC(fit1, fit2) # 변수4개를 가지고한 fit1(241)보다 변수2개인 fit2(237)가 더 좋다

## Backward
full.model <- lm(Murder ~ ., data = states)
reduce.model <- step(full.model, direction = "backward")
reduce.model

## Forward
min.model <- lm(Murder ~ 1, data = states)
fwd.model <- step(min.model, direction = "forward", scope = (Murder ~ Population + Illiteracy + Income + Frost))
fwd.model

## All Subset Regression 
install.packages("leaps")
library(leaps)

leap <- regsubsets(Murder ~ Population + Illiteracy + Income + Frost, data = states, nbest = 4)
leap

leap2 <- regsubsets(Murder ~ ., data = states, nbest = 4)
leap2

par(mfrow=c(1,1))
plot(leap, scale = "adjr2")
# 그래프 맨 윗줄이 가장 높음
# 검은색 = 적용된 것
# 맨윗줄(0.55) = Population + Illiteracy
# 위에서 2번째 줄(0.54) = Population + Illiteracy + Income
# 위에서 3번째 줄(0.54) = Population + Illiteracy + Frost
# 이런식으로 해석한다.


#### 실습3 ####
# 정규성, 등분산성, 다중공선성 검증
# 가장 영향력이 있는 변수들은 무엇인가?
getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()
mydata <- read.csv("../data/regression.csv")
View(mydata)
mydata <- mydata[, -1]
str(mydata)

# lm summary
fit <- lm(birth_rate ~ dummy + cultural_center + social_welfare + active_firms + pop + urban_park + doctors + tris + kindergarten, data = mydata)
summary(fit)


# vif
fit <- lm(birth_rate ~ cultural_center + social_welfare + active_firms + pop + urban_park + doctors + tris + kindergarten, data = mydata)
vif(fit)
sqrt(vif(fit))

# AIC
AIC(fit)

shapiro.test(resid(fit))

# backward
full.model <- lm(birth_rate ~ dummy + cultural_center + social_welfare + active_firms + pop + urban_park + doctors + tris + kindergarten, data = mydata)
reduce.model <- step(full.model, direction = "backward")
reduce.model

full.model <- lm(birth_rate ~ ., data = mydata)
reduce.model <- step(full.model, direction = "backward")
reduce.model

# forward
min.model <- lm(birth_rate ~ 1, data = mydata)
fwd.model <- step(min.model, direction = "forward", scope = (birth_rate ~ dummy + cultural_center + social_welfare + active_firms + pop + urban_park + doctors + tris + kindergarten))
fwd.model

# All Subset
mydata2 <- regsubsets(birth_rate ~ dummy + cultural_center + social_welfare + active_firms + pop + urban_park + doctors + tris + kindergarten, data = mydata, nbest = 9)
mydata2
par(mfrow=c(1,1))
plot(mydata2, scale = "adjr2")

#### 실습3 (강사님 버전) ####
View(mydata)
mydata <- mydata[, -1]
str(mydata)

reg1 <- lm(birth_rate ~ ., data = mydata)
summary(reg1)   
# Adjusted R-squared:  0.1089 # 10%, 설명력이 낮다.

par(mfrow=c(2,2))
plot(reg1)

## backward
full.model <- lm(birth_rate ~ ., data=mydata)
back.model <- step(full.model, direction = "backward", trace = 0)
back.model

reg2 <- lm(birth_rate ~ social_welfare + active_firms + pop + tris + kindergarten, data=mydata)
summary(reg2) # 0.1125
par(mfrow=c(2,2))
plot(reg2)

# 정규성
shapiro.test(resid(reg2)) # 0.0001626 # 0.05아래이므로 정규분포X

# 정규성이 아니므로 로그승제안
powerTransform(mydata$birth_rate) # -1.056671 
summary(powerTransform(mydata$birth_rate))
# LR test, lambda = (0) 6.602105  1 0.010186
# LR test, lambda = (1) 25.89958  1 3.5965e-07

reg3 <- lm(birth_rate^-1 ~ social_welfare + active_firms + pop + tris + kindergarten, data=mydata)
summary(reg3)

# 제안받은 로그승을 적용하고 다시 정규성 검사
shapiro.test(resid(reg3)) # 0.4624
par(mfrow=c(2,2))
plot(reg3)

# 다중공선성
sqrt(vif(reg1))
sqrt(vif(reg2))
sqrt(vif(reg3))

# 등분산성
ncvTest(reg1) # p = 9.5768e-05
ncvTest(reg2) # p = 0.0010313
ncvTest(reg3) # p = 0.03703

# 등분산이 아니라서 제안을 받겠다
spreadLevelPlot(reg3)
# Suggested power transformation:  3.364431 

reg4 <- lm((birth_rate^-1)^3.3 ~ social_welfare + active_firms + pop + tris + kindergarten, data=mydata)
summary(reg4) # 3.3제안 받기 전보다 더 떨어졌다. 그럼 이전 것을 사용하자

# 포기하기전에 일반적으로 사용하는 람다승값을 넣어보자
reg5 <- lm(log(birth_rate)^0.05 ~ social_welfare + active_firms + pop + tris + kindergarten, data=mydata)
summary(reg5)


#### 실습4 ####
getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()


mydata <- read.csv("../data/SeoulBikeData.csv")
View(mydata)
str(mydata)
summary(mydata)


## 1. 시간대별로 평균 몇대가 대여 되었을까?
library(dplyr)

result1 <- mydata %>% group_by(Hour) %>% summarise(count=mean(Rented.Bike.Count))
View(result1)

## 2. 위의 결과를 시각화
library(ggplot2)
ggplot(result1, aes(Hour, count)) + geom_line() + geom_vline(aes(xintercept = 8, size = 0.5, color = "red")) + 
  geom_vline(aes(xintercept = 18, size = 1, color = "red")) +
  annotate(geom = "text", x = 6, y = 1100, label = "출근") +
  annotate(geom = "text", x = 18, y = 1500, label = "퇴근")


## 3. 선형 회귀
attach(mydata)
reg1 <- lm(Rented.Bike.Count ~ ., data=mydata)
summary(reg1)

# 선형을 비선형으로 만들어주는 것 
# y = ax + b
# log(y) = ax + b

#### 로지스틱 회귀 분석 ####
# 일반화 선형 모델 : lm()

getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()

titanic <- read.csv("../data/train.csv", header = T)
View(titanic)

# 종속변수 : Survived(1:생존, 0:사망)
# 독립변수 : Pclass(1st, 2nd, 3rd)

titanic$Pclass1 <- ifelse(titanic$Pclass == 1, 1, 0)
titanic$Pclass2 <- ifelse(titanic$Pclass == 2, 1, 0)
titanic$Pclass3 <- ifelse(titanic$Pclass == 3, 1, 0)

View(titanic)

reg1 <- lm(Survived ~ Pclass2 + Pclass3, data = titanic)
# 더미변수로 만든 것들을 지정해주기에 3개중 2개만 선택하면 남은 1개는 자동으로 나옴
summary(reg1)

0.62963 - 0.15680
0.62963 - 0.38727

reg2 <- glm(Survived ~ Pclass2 + Pclass3, data = titanic, family = binomial())
# binomial = 이항분포
summary(reg2)
# 예측값을 그대로 쓰는 게 아니고
exp()
# exp() 기대값을 뽑아냄 # 확률값이라 -1 해줘야함 # 알아보기쉽게 백분율로 변환(*100)
(exp(0.5306)-1)*100 # 생존가능성이 69.99% 상승함
(exp(-0.6394)-1)*100 # 생존가능성이 -47.23% 하락함
(exp(-1.6704)-1)*100 # 생존가능성이 -81.018% 하락함

# Age, Fare, Gender, SibSp
titanic$GenderFemale <- ifelse(titanic$Sex == "female", 1,0)
titanic$GenderMale <- ifelse(titanic$Sex == "male", 1,0)

unique(titanic$SibSp)
table(titanic$SibSp)
titanic$SibSp0 <- ifelse(titanic$SibSp == 0, 1, 0)
titanic$SibSp1 <- ifelse(titanic$SibSp == 1, 1, 0)
titanic$SibSp2 <- ifelse(titanic$SibSp == 2, 1, 0)
titanic$SibSp3 <- ifelse(titanic$SibSp == 3, 1, 0)
titanic$SibSp4 <- ifelse(titanic$SibSp == 4, 1, 0)
titanic$SibSp5 <- ifelse(titanic$SibSp == 5, 1, 0)
titanic$SibSp8 <- ifelse(titanic$SibSp == 8, 1, 0)

reg3 <- glm(Survived ~ Age + Fare + GenderMale + SibSp1 + SibSp2 + SibSp3 + SibSp4 + SibSp5, data=titanic, family = binomial)

summary(reg3)

exp(-0.0224)
exp(0.0149) # 1달러 증가할때마다 1.015배 생존확률이 증가한다
exp(-2.461) # 혼자 타는 것에 비해 0.08% 높다

(exp(-0.0224)-1)*100 # -2.2% 감소
(exp(0.0149)-1)*100 # 생존가능성이 1.5% 올라간다?
(exp(-2.461)-1)*100 # 생존확률이 -91% 올라간다.
(exp(-2.411)-1)*100 # 남자일 때 생존가능성이 91% 낮아진다
