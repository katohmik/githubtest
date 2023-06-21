getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


#### 실습1 ####
# 주제 : 자동차의 실런더 수와 변속기의 관계를 알고 싶다.

View(mtcars)


# 실린더 수와 변속기 종류 파악
table(mtcars$cyl, mtcars$am)

# 테이블의 가독성을 높이기 위해 전처리
mtcars$tm <- ifelse(mtcars$am == 0, "auto", "manual")
result <- table(mtcars$cyl, mtcars$tm)
result

dev.new(width = 10, height = 10) # :figure margins too large 에러가 뜰 경우 창크기 조절
barplot(result)

# auto의 눈금이 벗어났기 때문에 최대값을 알 수 없다.(눈금 조정) # 범례 추가(legend)
barplot(result, ylim = c(0,20), legend = rownames(result))


# 이름 이어적기
myrownames <- paste(rownames(result), "cyl")
myrownames
barplot(result, ylim = c(0, 20), legend=myrownames)

# 그래프를 수직으로 나누기
barplot(result, ylim = c(0, 20), legend=myrownames, beside=T)

#그래프를 수평으로 나누기
barplot(result, ylim = c(0, 20), legend=myrownames, beside=T, horiz = T)

# 색상
barplot(result, ylim = c(0, 20), legend=myrownames, beside=T, horiz = T, col = c("tan1", "coral2", "firebrick2"))

result
addmargins(result) # 행과열에 합계 추가 addmargins()


# 교차 분석
chisq.test(result) # 0.012
# p-value가 0.05보다 낮으므로 유의미한 차이가 있다고 결론내릴 수 있다.

fisher.test(result) # 0.009
# p-value가 0.05보다 낮으므로 유의미한 차이가 있다고 결론내릴 수 있다.

#### 실습2 ####
# 주제 : 시군구와 다가구 자녀지원 조례가 관계가 있는가?

mydata <- read.csv("../data/anova_two_way.csv")
View(mydata)

result <- table(mydata$ad_layer, mydata$multichild)

chisq.test(result) # 0.7133

fisher.test(result) # 0.7125

#### 실습3 : Cocran-Armitage Trend Test ####
# 흡연 여부와 고혈압의 유무가 서로 관련이 있는가?

library(moonBook)
View(acs)

result <- table(acs$HBP, acs$smoking)
chisq.test(result)

# 테이블 컬럼 순서 조절
acs$smoking <- factor(acs$smoking, levels = c("Never", "Ex-smoker", "Smoker"))
result <- table(acs$HBP, acs$smoking)
result

library(stats)

chisq.test(result)

?prop.trend.test

# x : 사건이 발생한 횟수
# m : 시도한 횟수

result
result[2,] # 사건이 발생한 횟수(고혈압이 발생한 사람 수)
result[,3]

# 고혈압이 있고 없고에 관계없이 다 합쳐서 흡연 여부를 알고 싶을 때
colSums(result) # 열의 합계를 구해주는 기본함수 colSums()

prop.trend.test(result[2,], colSums(result)) # p-value = 9.282e-11 # 매우 강한 관계가 있다.

#시각화
mosaicplot(result, color=c("tan1", "firebrick2"))

# 전치를 통해 그래프의 행과 열을 바꿔보자
result
t(result)


mosaicplot(t(result), color=c("tan1", "firebrick2"),
           ylab = "Hypertension",
           xlab = "Smoking")

# 색상 정보
colors()
demo("colors")

mytable(smoking ~ age, data=acs)


# 상관 분석과 교차분석으로 원인을 파악하려고 해서는 안된다


