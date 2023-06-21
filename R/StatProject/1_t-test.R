getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


#### Power Analysis ####

# 적정한 표본의 갯수를 산출
# cohen's d(effective size) : 두 집단의 평균 차이를 두 집단의 표준편차의 합으로 나누어준다
getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()
ky <- read.csv("../data/KY.csv", header = T)
View(ky)

table(ky$group)

mean.1 <- mean(ky$score[ky$group == 1])
mean.2 <- mean(ky$score[ky$group == 2])
cat(mean.1, mean.2)


sd.1 <- sd(ky$score[ky$group == 1])
sd.2 <- sd(ky$score[ky$group == 2])
cat(sd.1, sd.2)

effect_size <- abs(mean.1 - mean.2) / sqrt((sd.1^2 + sd.2^2)/2)
effect_size

install.packages("pwr")
library(pwr)
?pwr.t.test
pwr.t.test(d=effect_size, alternative = "two.sided", type = "two.sample", power = .8, sig.level = 0.05)


#### 사례1 : 두 집단의 평균 비교 ####

install.packages("moonBook")
library(moonBook)

head(acs)
str(acs)
?acs

# 경기도에 소재한 대학병원에서 2년동안 내원한 급성 관상동맥증후군 환자 데이터

summary(acs)

## 가설 설정
# 주제 : 두 집단(여성, 남성)의 나이 차이를 알고 싶다
# 귀무가설 : 남성과 여성의 평균 나이에 대해 차이가 없다
# 대립가설 : 남성과 여성의 평균 나이에 대해 차이가 있다

man.mean <- mean(acs$age[acs$sex == 'Male'])
woman.mean <- mean(acs$age[acs$sex == 'Female'])
cat(man.mean, woman.mean)

# 정규분포 테스트
moonBook::densityplot(age~sex, data=acs)

## 가설 설정
# 주제 : 두 집단의 정규 분포 여부를 알고 싶다.
# 귀무가설 : 두 집단이 정규분포이다.
# 대립가설 : 두 집단이 정규분포 아니다.

shapiro.test(acs$age[acs$sex == "Male"]) # 남자는 정규분포가 맞다
shapiro.test(acs$age[acs$sex == "Female"]) # 여자는 정규분포가 아니다 # 정규분포가 아니므로 t.test를 쓸 수 없다.

#검정 결과, 검정 통계량 (W)은 0.99631이며, 해당하는 p-값은 0.2098입니다. 결과를 해석하기 위해서는 p-값을 유의 수준 (일반적으로 0.05)과 비교할 수 있습니다. 만약 p-값이 유의 수준보다 작다면 (p < 0.05), 데이터가 정규 분포를 따르지 않는 귀무가설에 대한 증거로 해석할 수 있습니다. 반대로, p-값이 유의 수준보다 크거나 같다면 (p ≥ 0.05), 귀무가설을 기각할 충분한 증거가 없으며, 이는 데이터가 정규 분포를 따를 수 있다는 것을 나타냅니다.

#이 경우, p-값 (0.2098)이 0.05보다 크므로, 귀무가설을 기각할 충분한 증거가 없습니다. 따라서, 샤피로-윌크 검정 결과를 기반으로 하면, 해당 데이터 서브셋 (acs$sex == "남성"인 경우의 acs$age)은 정규 분포를 따를 수 있다는 것을 시사합니다.

### 등분산 테스트
# 원래는 정규분포를 통과해야 등분산 테스트를 하고 등분산을 통과하면 t.test를 쓴다.
##  가설 설정
# 주제 : 두 집단의 등분산 여부를 알고 싶다.
# 귀무가설 : 두 집단이 등분산이다.
# 대립가설 : 두 집단이 등분산이 아니다.

var.test(age~sex, data=acs)

?t.test
t.test(age~sex, data=acs, alt="two.sided", var.equals=T)

# 귀무 가설은 두 집단의 분산이 같다는 것입니다.
# 대립 가설은 두 집단의 분산이 다르다는 것입니다.
# p-값은 0.3866으로, 귀무 가설을 기각할 수 없음을 나타냅니다. 따라서 두 집단의 분산은 유의미하게 다르지 않다고 결론지을 수 있습니다.
# 이 결과는 두 집단의 평균이 다르더라도 두 집단의 분산이 동일하다는 것을 의미합니다. 따라서 두 집단의 평균을 비교하기 전에 분산을 비교해야 합니다.

### 정규분포가 아닐 때 : MWW
wilcox.test(age~sex, data=acs)

# 데이터: 성별에 따른 나이, W = 115271, p-값 < 2.2e-16
# 대립 가설: 실제 위치 변화는 0이 아님
# 이 결과를 해석해보면, 윌콕슨 순위 합 검정을 통해 성별에 따라 나이의 차이가 있는지를 평가한 것입니다.
# 검정 통계량 (W)는 115271이며, 해당하는 p-값은 2.2e-16보다 작습니다. 대립 가설은 "실제 위치 변화가 0이 아니다"로 설정되어 있습니다.

# 따라서, 검정 결과에 따르면 성별에 따라 나이에 유의한 차이가 있다는 것을 나타냅니다.
# p-값이 매우 작으므로 귀무가설을 기각하고 대립 가설을 채택합니다.
# 이는 성별에 따라 나이의 위치가 서로 다르다는 강력한 증거를 제시합니다.


### 등분산이 아닐 때, : welch's t-test
t.test(age~sex, data=acs, alt="two.sided", var.equals=F)


#### 사례2 : 집단이 하나인 경우 ####

# A회사의 건전지 수명이 1000시간일 때 무작위로 뽑아 10개의 건전지 수명에 대해 샘플이 모집단과 다르다고 할 수 있는가?
# 귀무가설 : 표본의 평균은 모집단의 평균과 같다
# 대립가설 : 표본의 평균은 모집단의 평균가 다르다

a <- c(980, 1008, 968, 1032, 1012, 1002, 996, 1017, 990, 955)
mean.a <- mean(a)
mean.a

# 정규분포 확인
shapiro.test(a)
?shapiro.test

t.test(a, mu = 1000, alt = "two.sided")
t.test(a, mu = 1000, alt = "less")
t.test(a, mu = 1000, alt = "greater")

## 어떤 학급의 수학 평균 점수가 55점이었다.0교시 수업을 하고 다시 성적을 살펴보았다.

b <- c(58, 49, 39, 99, 32, 88, 62, 30, 55, 65, 44, 55, 57, 53, 88, 42, 39)

mean(b)

shapiro.test(b)
t.test(b, mu = 55, alt = "two.sided")
t.test(b, mu = 55, alt = "less")
t.test(b, mu = 55, alt = "greater")


#### 사례3 : 하나의 집단으로 시간에 따른 비교 ####

str(sleep)
View(sleep)


## 주제 : 같은 집단에 대해 수면시간의 증가량 차이가 나는지 알고싶다.

## Independent two sample t-test
# 먼저 ID를 제거하여 서로 다른 두 집단으로 테스트를 해본다.
sleep2 <- sleep[, -3]
View(sleep2)

tapply(sleep2$extra, sleep2$group, mean)

shapiro.test(sleep2$extra[sleep2$group ==1])
with(sleep2, shapiro.test(extra[group ==2]))


var.test(extra ~ group, data = sleep2)
t.test(extra ~ group, data = sleep2, var.equal=T)

## paired sample t-test
t.test(extra ~ group, data=sleep, var.equal=T, paired=T)

## 그래프 그리기
before <- subset(sleep, group==1, extra)
before

after <- subset(sleep, group==2, extra)
after

install.packages("PairedData")
library(PairedData)

# long형으로 분리시킨 before과 after를 wide형으로(컬럼으로) 합쳐주었다.
s_graph <- paired(before, after)
s_graph

# type = "profile"
plot(s_graph, type="profile") + theme_bw()


#### 실습 1 ####
# 주제 : 시와 군에 따라서 합계 출산율의 차이가 있는지 알아보려고 한다

mydata <- read.csv("../data/independent.csv")
head(mydata)
str(mydata)
View(mydata)

shapiro.test(mydata$birth_rate[mydata$dummy ==1])
with(mydata, shapiro.test(birth_rate[dummy ==0]))

wilcox.test(birth_rate~dummy, data=mydata)
var.test(birth_rate~dummy, data=mydata)

t.test(birth_rate ~ dummy, data = mydata, var.equal=T)
t.test(birth_rate ~ dummy, data = mydata, var.equal=F)

---------------------------------------------------------------


library(moonBook)
moonBook::densityplot(birth_rate ~ dummy, data = mydata)

gun.mean <- with(mydata, mean(birth_rate[dummy == 0]))
gun.mean
si.mean <- with(mydata, mean(birth_rate[dummy == 1]))
si.mean

cat(gun.mean, si.mean)

shapiro.test(mydata$birth_rate[mydata$dummy ==1]) # 0.05 이하이므로 정규분포 아님
with(mydata, shapiro.test(birth_rate[dummy ==0])) # 0.05 이하이므로 정규분포 아님

wilcox.test(birth_rate~dummy, data=mydata) # 0.04이므로 차이가 있긴한데, 큰 차이라고 보기는 힘들다.

# 만약 정규분포였다면?(이라고 가정하고 등분산검사와 t-test까지 해보자.)
var.test(birth_rate~dummy, data=mydata) # 0.05이하이므로 등분산이 아니다.(심하게 아니다....)

# 정규분포에 등분산까지 맞다면(아니지만 그렇다고 속이고 t-test)
t.test(birth_rate ~ dummy, data = mydata, var.equal=T) # 0.05이하이므로 유의미하다..

# 정규분포였지만 등분산이 아니라면(그렇다고 속이고... welch t-test)
t.test(birth_rate ~ dummy, data = mydata, var.equal=F) # 0.05이하이므로 차이가 유의미하다


#### 실습2 ####
# 주제 : 오토와 수동에 따라 연비에 차이가 있는가?
# 기본 데이터셋에 있는 mtcars로 확인
# am : 0은 오토, 1은 수동
#mpg = 연비
str(mtcars)

cat(mean(mydata$before), mean(mydata$After)) # 큰 차이가 나기에 사실 통계학적 분석이 의미없을 정도..

library(moonBook)
moonBook::densityplot(mpg ~ am, data = mtcars)

mpgauto <- with(mtcars, mean(mpg[am == 0]))
mpgauto

mpgself <- with(mtcars, mean(mpg[am ==1]))
mpgself

shapiro.test(mtcars$mpg[mtcars$am == 0]) # 0.89는 0.05 이상이므로 정규분포이다(크게)
with(mtcars, shapiro.test(mpg[am == 1])) # 0.53은 0.05 이상이므로 정규분포이다(꽤나)

var.test(mpg~am, data=mtcars) # 0.06은 0.05이상이라 수치상 등분포가 맞다.(매우 미약하게)
t.test(mpg ~ am, data = mtcars, var.equal=T) # 0.0002는 0.05 이하이므로 차이가 있다.


#### 실습3 ####
# 주제 : 쥐의 몸무게가 전과 후의 차이가 있는지?


mydata <- read.csv("../data/pairedData.csv")
str(mydata)
View(mydata)

tapply(mydata$before, mydata$After, mean) # 현재 wide형이라 tapply를 쓰면 안된다....

# long형으로 바꿔서 사용하고 싶다면?
# long형 변환1 : melt()
library(reshape2)

mydata1 <- melt(mydata, id=("ID"), variable.name = "GROUP", value.name = "RESULT")
mydata1
View(mydata1)

# long형 변환2 : tidyr  gather
install.packages("tidyr")
library(tidyr)

?gather

mydata2 <- gather(mydata, key="GROUP", value="RESULT", -ID)
# -ID로 ID컬럼을 빼주지 않으면 GROUP안에 ID까지 들어가버림
mydata2



# 바꾼 long형으로 작업해보자

with(mydata1, shapiro.test(RESULT[GROUP=="before"])) # 0.27이므로 정규분포이다
with(mydata1, shapiro.test(RESULT[GROUP=="After"])) # 0.28이므로 정규분포이다

# long형이기에 formula를 쓸 수 있다
t.test(RESULT ~ GROUP, data=mydata1, paired=T) # 0.05이하이며 엄청난 차이가 있다.


# wide형인 상태 그대로 쓸 거라면?
beforemean <- with(mydata, mean(before))
beforemean
aftermean <- with(mydata, mean(After))
aftermean

with(mydata, shapiro.test(before)) # 0.27 이므로 정규분포이다
with(mydata, shapiro.test(After)) # 0.28 이므로 정규분포이다

t.test(mydata$before, mydata$After, paired=T)
# p-value = 6.2e-09 : 0.05이하중의 이하이므로 엄청난 차이

moonBook::densityplot(RESULT ~ GROUP, mydata1)
moonBook::densityplot(mydata$before ~ mydata$After, mydata) # wide형은 densityplot 사용불가
# long형으로 바꿔줘야 시각화나 다른 함수 사용에서 편한 경우가 많다.(fomula 등)

before <- subset(mydata1, GROUP=="before", RESULT)
before
after <- subset(mydata1, GROUP=="After", RESULT)
after

plot(paired(before, after), type="profile")


# long형으로 분리시킨 before과 after를 wide형으로(컬럼으로) 합쳐주었다.
p_graph <- paired(before, after)
p_graph

plot(p_graph, type="profile")

#### 실습 4 ####
# 주제 : 시별로 2010년도와 2015년도의 출산율의 차이가 있는가?
mydata <- read.csv("../data/paired.csv")
str(mydata)
View(mydata)
summary(mydata)

# melt로 해보자
mydata1 <- melt(mydata, id.vars = c("ID", "cities"), variable.name = "year", value.name = "birth_rate")
mydata1

# gather로 해보자
mydata2 <- gather(mydata, key="BIRTH", value="BIRTH_RATE", -c(ID, cities))
mydata2

View(mydata2)

with(mydata2, shapiro.test(BIRTH_RATE[BIRTH=="birth_rate_2015"])) # 0.01이므로 정규분포가 아니다
with(mydata2, shapiro.test(BIRTH_RATE[BIRTH=="birth_rate_2010"])) # 정규분포가 아니다

wilcox.test(BIRTH_RATE ~ BIRTH, data = mydata2, paired=T) # 0.45니까 차이가 없다..

# 만약 정규분포였다고 가정하고 t.test를 돌려보자
t.test(BIRTH_RATE ~ BIRTH, data = mydata2, paired=T) # t.test마저 0.50이므로 정말 차이가 없다.

birth2015 <- subset(mydata2, BIRTH=="birth_rate_2015", BIRTH_RATE)
birth2015
birth2010 <- subset(mydata2, BIRTH=="birth_rate_2010", BIRTH_RATE)
birth2010

plot(paired(birth2010, birth2015), type="profile")


#### 실습5 ####
# https://www.kaggle.com/code/kappernielsen/independent-t-test-example/notebook
# 주제1 : 남녀별로 각 시험에 대해 평균 차이가 있는지 알고싶다.
# 주제2 : 같은 사람에 대해서 성적의 차이가 있는지 알고싶다.
#         첫번째 시험(G1)과 세번째 시험(G3)를 사용


mat <- read.csv("../data/student-mat.csv", header=T)
View(mat)

# 주제1을 해보자
library(dplyr)

gender_score <- mat %>% select(sex, G1, G2, G3)
gender_score
str(gender_score)
summary(gender_score)

# 각 시험별 남자의 평균점수
mang1 <- with(gender_score, mean(G1[sex == "M"]))
mang1
mang2 <- with(gender_score, mean(G2[sex == "M"]))
mang2
mang3 <- with(gender_score, mean(G3[sex == "M"]))
mang3

# 남자 시험 전체 평균점수
man_avg <- mean(mang1,mang2,mang3)
man_avg

# 각 시험별 여자의 평균 점수
womang1 <- with(gender_score, mean(G1[sex == "F"]))
womang1
womang2 <- with(gender_score, mean(G2[sex == "F"]))
womang2
womang3 <- with(gender_score, mean(G3[sex == "F"]))
womang3

# 여자 시험 전체의 평균점수
woman_avg <- mean(womang1, womang2, womang3)
woman_avg

View(gender_score)

# gather로 TEST(G1,G2,G3)를 묶어서 long형으로 바꾸자 # 뻘짓이었다. # gender_score에서 다 해결 가능했다.
gender_score2 <- gather(gender_score, key="TEST", value="RESULT", -sex)
gender_score2

with(gender_score2, shapiro.test(RESULT[(TEST=="G1") & (sex == "F")])) # 0.05 이하이므로 정규분포가 아니다
with(gender_score2, shapiro.test(RESULT[(TEST=="G1") & (sex == "M")])) # 0.01 이므로 정규분포가 아니다
with(gender_score2, shapiro.test(RESULT[(TEST=="G2") & (sex == "F")]))
with(gender_score2, shapiro.test(RESULT[(TEST=="G2") & (sex == "M")]))
with(gender_score2, shapiro.test(RESULT[(TEST=="G3") & (sex == "F")]))
with(gender_score2, shapiro.test(RESULT[(TEST=="G3") & (sex == "M")])) # 모두 정규분포가 아니다

wilcox.test(G1 ~ sex, data = gender_score)
wilcox.test(G2 ~ sex, data = gender_score)
wilcox.test(G3 ~ sex, data = gender_score)


## 주제1 강사님 버전
table(mat$sex)

summary(mat$G1)
summary(mat$G2)
summary(mat$G3)

library(dplyr)
mat %>% group_by(sex) %>% summarise(mean_g1=mean(G1), mean_g2=mean(G2), mean_g3=mean(G3),
                                    sd_g1=sd(G1), sd_g2=sd(G2), sd_g3=sd(G3))

# 주제1 강사님 버전 정규분포 확인
shapiro.test(mat$G1[mat$sex=="M"])
shapiro.test(mat$G1[mat$sex=="F"])
shapiro.test(mat$G2[mat$sex=="M"])
shapiro.test(mat$G2[mat$sex=="F"])
shapiro.test(mat$G3[mat$sex=="M"])
shapiro.test(mat$G3[mat$sex=="F"])

# 정규분포가 아닐 경우(wilcox)
wilcox.test(G1 ~ sex, data = mat) # 0.05957 이므로 차이가 없.....다(0.5이하 = 차이가 있다)
wilcox.test(G2 ~ sex, data = mat) # 0.048이므로 차이가 있다.
wilcox.test(G3 ~ sex, data = mat) # 0.040이므로 차이가 있다.

# 정규분포일 경우
var.test(G1 ~ sex, data=mat) # 0.49이므로 등분산이다
var.test(G2 ~ sex, data=mat) # 0.39이므로 등분산이다
var.test(G3 ~ sex, data=mat) # 0.69이므로 등분산이다

t.test(G1 ~ sex, data=mat, var.eqaul=T, alt="two.sided") # 0.06
t.test(G2 ~ sex, data=mat, var.eqaul=T, alt="two.sided") # 0.07
t.test(G3 ~ sex, data=mat, var.eqaul=T, alt="two.sided") # 0.03 만 차이가 있다.

moonBook::densityplot(G1 ~ sex, data=mat)
moonBook::densityplot(G2 ~ sex, data=mat)
moonBook::densityplot(G3 ~ sex, data=mat)


# 주제2를 해보자(같은 사람에 대해서 성적의 차이가 있는지 알고싶다. 첫번째 시험(G1)과 세번째 시험(G3)를 사용)
# paired겠지?


# 내 버전












# 주제2 강사님 버전
mat %>% summarise(mean_g1=mean(G1), mean_g3=mean(G3))

# long형으로 변환
mydata <- gather(mat, key="GROUP", value="RESULT", "G1", "G3") # g1과 g3를 묶어버리자
mydata
str(mydata) # G1, G3는 GROUP에 묶여있고 G2만 원래대로 남아있다.

# 정규분포라 가정하고 t.test를 돌려보자
t.test(RESULT ~ GROUP, data=mydata, paired=T) # 0.00004이므로 차이가 있다.

# 정규분포가 아닐거라 가정하고 wilcox를 돌려보자 # 0.31이므로 차이가 없다.
wilcox.test(RESULT ~ GROUP, data=mydata, paired=T)

# wide형 그대로 t.test를 돌려보자
t.test(mat$G1, mat$G3, paired=T)
