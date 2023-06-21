getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


#### 실습1 ####
# 주제 : 담배값의 인상 전의 월별 매출액과 인상 후의 월별 매출액의 관계가 있나?
# 담배값과 매출액의 관계가 있는가?


x <- c(70, 72, 62, 64, 71, 76, 0, 65, 75, 72)
y <- c(70, 74, 65, 68, 72, 74, 61, 66, 76, 75)

?cor
cor(x,y, method="pearson")
cor(x,y, method="spearman")
cor(x,y, method="kendall")

cor.test(x, y, method = "pearson")


#### 실습2 ####
# 주제 : 인구 증가율과 노령 인구 비율간의 관계가 있는가?
# pop_growth : 인구 증가율
# eldery-rate : 노령인구 비율
# finance : 재정자립도
# cultural_center : 인구 10만명당 문화기반 시설 수

mydata <- read.csv("../data/cor.csv")

View(mydata)

plot(mydata$pop_growth, mydata$elderly_rate)

cor(mydata$pop_growth, mydata$elderly_rate, method="pearson")
# 0.2 ~ 0.4까지는 약한 관계
# 0.4 ~ 0.6 어느정도 관계
# 0.7 ~ 강한 관계

attach(mydata) # 항상 메모리에 붙여둘거다 # mydata$생략가능
x <- cbind(pop_growth, birth_rate, elderly_rate, finance, cultural_center)
x
cor(x)
detach(mydata) # 메모리에서 내린다 # mydata$써야함 이제



#### 실습3 ####
install.packages("UsingR")
library(UsingR)

str(galton)

plot(child ~ parent, data=galton)
cor.test(galton$child, galton$parent) # 0.458 이므로 관계가 있다(0.05이상)

out <- lm(child ~ parent, data = galton)
summary(out)

plot(child ~ parent, data=galton)
abline(out, col = "red")

sunflowerplot(galton)

plot(jitter(child, 5) ~ jitter(parent, 5), data = galton)

#### 실습4 ####
# 세 관측소에서 관측한 오존농도, 일산화질소, 이산화질소를 30분마다 측정한 값


install.packages("SwissAir")
library(SwissAir)


View(AirQual)

Ox <- AirQual[ , c("ad.O3", "lu.O3", "sz.O3")] + 
  AirQual[ , c("ad.NOx", "lu.NOx", "sz.NOx")] -
  AirQual[ , c("ad.NO", "lu.NO", "sz.NO")]

Ox

names(Ox) <- c("ad", "lu", "sz")
plot(lu ~ sz, data = Ox)

Ox <- na.omit(Ox)
Cor(Ox$lu, Ox$sz)

# hexbin
install.packages("hexbin")
library(hexbin)
bin <- hexbin(Ox$lu, Ox$sz, xbins=50)
plot(bin)

smoothScatter(Ox$lu, Ox$sz)


# IDPmisc
install.packages("IDPmisc")
library(IDPmisc)
iplot(Ox$lu, Ox$sz)


