getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


#### type 1 : One Way ANOVA ####

library(moonBook)
View(acs)
str(acs)

# 진단 결과에 따라 저밀도 콜레스테롤 수치(LDLC)를 알고 싶다.
# 진단 결과(Dx) : STEMI(급성심근경색), NSTEMI(만성심근경색), Unstable Angina(협심증)


moonBook::densityplot(LDLC ~ Dx, data=acs)

# 정규분포 확인 # 셋중에 하나라도 정규분포가 아니면 LDLC는 정규분포가 아니다
with(acs, shapiro.test(LDLC[Dx=="NSTEMI"])) # 정규분포가 아니다
with(acs, shapiro.test(LDLC[Dx=="STEMI"])) # 정규분포이다
with(acs, shapiro.test(LDLC[Dx=="Unstable Angina"])) # 정규분포가 아니다

# 정규분포를 확인하는 또 다른 방법(ANOVA일 때)
aov() 
# 모든 조건을 통과하면 사용하는 마지막에 분석하기위한 anova함수
# 정규분포인지 테스트용으로 미리 사용해보기도 함

out = aov(LDLC ~ Dx, data=acs)
out
resid(out) # 잔차를 뽑아주는 resid() # shapiro에 넘겨주면 정규분포 확인이 가능
shapiro.test(resid(out)) # 표준편차인지 바로 확인가능

# 등분산 확인
bartlett.test(LDLC ~ Dx, data=acs) # 0.18이므로 등분산이다.

# anova 검정(정규분포이고 등분산인 경우)
out = aov(LDLC ~ Dx, data=acs)
summary(out)

# 차이가 있기 때문에 사후검정이 필요
kruskal.test(LDLC ~ Dx, data=acs) # 0.004이므로 차이가 있다.

# 등분산이 아닐 경우(oneway.test()는 aov()와 기본적으로 같지만 var.equal인자를 사용가능)
oneway.test()
oneway.test(LDLC ~ Dx, data=acs, var.equal = F) # 0.007이므로 차이가 있다.

### 사후 검정

# aov()를 사용했을 경우 : TukeyHSD()
TukeyHSD(out)

# kruskal.test()를 사용했을 경우
install.packages("pgirmess")
library(pgirmess)

#difference는 처리별 다중비교 결과를 의미하여 TRUE이면 유의미한 차이가 있다.
#FALSE는 유의미한 차이가 없다고 판단한다.
kruskalmc(acs$LDLC, acs$Dx)

# oneway.test()를 사용했을 경우
install.packages("nparcomp")
library(nparcomp)

# mctp(---Analysis----확인, ---Data Info---참조)
result <- mctp(LDLC ~ Dx, data=acs)
summary(result)


#### 실습1 ####
str(iris)

# 주제 : 품종별로 Sepal.Width의 평균 차이가 있는가?
# 만약 있다면 어느 품종과 차이가 있는가?

View(iris)
out = aov(Sepal.Width ~ Species, data = iris)
resid(out)
shapiro.test(resid(out)) # 0.32이므로 정규분포이다

moonBook::densityplot(Sepal.Width ~ Species, data = iris)


bartlett.test(Sepal.Width ~ Species, data= iris) # 0.35이므로 등분산이다
out = aov(Sepal.Width ~ Species, data = iris)
summary(out)
TukeyHSD(out)


#### 실습2 ####
# 주제 : 시, 군, 구에 따라서 합계 출산율의 차이가 있는가?
# 있다면 어느 것과 차이가 있는가?

mydata <- read.csv("../data/anova_one_way.csv", encoding = "euc-kr")
View(mydata)
str(mydata)




# 정규분포
out = aov(birth_rate ~ ad_layer, data = mydata)
shapiro.test(resid(out))


# 비모수적인 방법
kruskal.test(birth_rate ~ ad_layer, data = mydata)

# 모수적인 방법
summary(out)

# 그래프로 확인
moonBook::densityplot(birth_rate ~ ad_layer, data=mydata)


# 사후 검정
kruskalmc(mydata$birth_rate, mydata$ad_layer) # 차이가 있는게 2개, False로 차이가 없는게 1개

TukeyHSD(out)


#### 실습3 ####
# 실습 데이터 : https://www.kaggle.com
library(dplyr)

telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
View(telco)
str(telco)


# 주제 : 지불 방식별로 총 지불금액이 차이가 있는가?
# 있다면 무엇과 차이가 있는가?
# 지불 방식(paymentmethod) : Bank transfer, Credit card, Electronic check, Mailed check
# 총 지불 금액(Totalcharges)

# 각 지불방식별로 인원수와 평균 금액을 조회(먼저 눈으로 확인)

t1 <- telco %>% group_by(PaymentMethod) %>% summarise(mean_TC=mean(TotalCharges, na.rm=T))
t1

out = aov(TotalCharges ~ PaymentMethod, data=telco, na.rm=T)
resid(out)


t2 <- ifelse(is.na(telco$TotalCharges), round(mean(telco$TotalCharges, na.rm=T),2), telco$TotalCharges)
summary(t2)

out = aov(TotalCharges ~ PaymentMethod, data=t2)


## 강사님 버전 
unique(telco$PaymentMethod)
table(telco$PaymentMethod)

telco %>% select(PaymentMethod, TotalCharges) %>% group_by(PaymentMethod) %>% summarise(count=n(), mean=mean(TotalCharges, na.rm=T))

# 강사님 버전 / 그래프로 확인
moonBook::densityplot(TotalCharges ~ Paymentmethod, telco)

with(telco, shapiro.test(TotalCharges[PaymentMethod == "Bank transfer (automatic)"])) # 정규분포 아님
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Credit card (automatic)"])) # 정규분포 아님
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Electronic check"])) # 정규분포 아님
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Mailed check"])) # 정규분포 아님

out <- aov(TotalCharges ~ PaymentMethod, data=telco)
shapiro.test(resid(out)) # 5000개가 넘어서 해주지 않는다. # 5000개가 넘으면 그냥 정규분포라고 생각해도 된다.

# 앤더슨 달링 테스트(5000개 넘는 데이터를 정규분포 테스트를 하고 싶을 경우)

# 등분산 여부
bartlett.test(TotalCharges ~ PaymentMethod, data=telco)

# welch's anova
oneway.test(TotalCharges ~ PaymentMethod, data=telco, var.equal = T) # 0.05이하이므로 차이가 있다.

# 사후 검정
result <- mctp(TotalCharges ~ PaymentMethod, data=telco)
summary(result)

plot(result)

# 만약 정규분포가 아니라는 상황에서 테스트를 해본다면?????
kruskal.test(TotalCharges ~ PaymentMethod, data=telco) # 0.05이하이므로 차이가 있다고 나타내고 있다.

# 사후 검정
kruskalmc(telco$TotalCharges, telco$PaymentMethod)

library(ggplot2)
ggplot(mydata, aes(birth_rate, ad_layer, col="multichild")) + geom_boxplot()


#### type 2 : Two Way ANOVA ####

mydata <- read.csv("../data/anova_two_way.csv")
View(mydata)
str(mydata)

out <- aov(birth_rate ~ ad_layer + multichild + ad_layer:multichild, data = mydata)
shapiro.test(resid(out)) # 정규분포가 아니다


# 정규분포가 아니지만 라고 생각하고 summary....
summary(out)

# 사후검정
result <- TukeyHSD(out)
result

# 교차변수??를 써주지 않는 다면? 결과가 따로따로 나온다
out <- aov(birth_rate ~ ad_layer + multichild, data = mydata)
shapiro.test(resid(out))
summary(out)

#### 실습 4 ####

telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
View(telco)
str(telco)

# 원인 변수 : PaymentMethod, Contract
# 결과(종속) 변수 : TotalCharges

out <- aov(TotalCharges ~ Contract + PaymentMethod + Contract:PaymentMethod, data = telco)
shapiro.test(resid(out))
summary(out)



result <- TukeyHSD(out)
result

# 강사님 버전

unique(telco$Contract)
table(telco$Contract)

moonBook::densityplot(TotalCharges ~ PaymentMethod, data=telco)
moonBook::densityplot(TotalCharges ~ Contract, data=telco)

bartlett.test(TotalCharges ~ PaymentMethod, data=telco) # 등분산이 아니다~
bartlett.test(TotalCharges ~ Contract, data=telco) # 등분산이 아니다~

oneway.test(TotalCharges ~ PaymentMethod + Contract + PaymentMethod:Contract, data = telco, var.equal = F)

out <- aov(TotalCharges ~ PaymentMethod + Contract + PaymentMethod:Contract, data = telco)
summary(out)

TukeyHSD(out)

library(ggplot2)
ggplot(telco, aes(PaymentMethod, TotalCharges, col=Contract)) + geom_boxplot()

#### 실습 4 ####

#### type 3 : Repeated Measured ANOVa ####

# 주제 : 6명을 대상으로 운동능력향상의 차이가 있는지 알아보려고 한다.
df <- data.frame()
df <- edit(df)
df

means <- c(mean(df$pre),mean(df$three_month),mean(df$six_month))
means

plot(means, type="o", lty=2, col=2)

install.packages("car")
library(car)

?Anova

# 종속변수자리에 cbind로 묶어서 넣어주고, 독립변수는 따로 없으므로 1을 넣어준다.
cbind(df$pre, df$three_month, df$six_month)
lm(cbind(df$pre, df$three_month, df$six_month)~1)

multimodels <- lm(cbind(df$pre, df$three_month, df$six_month)~1)
str(multimodels)
# 벡터를 팩터로 바꿔줘라
c("pre", "three_month", "six_month") # 지금 벡터 상태
trials <- factor(c("pre", "three_month", "six_month"), ordered = F)
# 바꾼 팩터를 dataframe형식으로 idata에 넣어준다



# aov()를 써도 되긴한데... long형으로 바꿔줘야함
model1 <- Anova(multimodels, idata=data.frame(trials), idesign=~trials, type="III")

summary(model1, multivariate=F)

# 결과창의 Mauchly Tests for Sphericity

# Test        statistic  p-value
# trials        0.43353 0.18795 # p-value가 0.05보다 낮았다면 Greenhous를 봐야한다.
# 0.05를 넘겼다면 Greenhouse를 보지않아도 괜찮다.
# 1에 가까울수록 타당하다.

# 사후검정
# long형으로 변경
library(tidyr)

dflong <- gather(df, key="ID", value="SCORE", -id)
dflong

with(dflong, pairwise.t.test(SCORE, ID, paired=T, p.adjust.method = "bonferroni"))



# aov로도 써보자~~~~
out <- aov(SCORE ~ ID, data=dflong)
shapiro.test(resid(out))
summary(out)

TukeyHSD(out)
0.05/3


#### 실습5 ####
rm <- read.csv("../data/onewaysample.csv", header = T)
View(rm)
summary(rm)

rm <- rm[, 2:6]
rm

means <- c(mean(rm$score0),mean(rm$score1),mean(rm$score3), mean(rm$score6))
means

plot(means, type="o", lty=2, col=2)



multimodels <- lm(cbind(rm$score0, rm$score1, rm$score3, rm$score6)~1)
str(multimodels)
# 벡터를 팩터로 바꿔줘라
c("pre", "three_month", "six_month") # 지금 벡터 상태
trials <- factor(c("score0", "score1", "score3", "score6"), ordered = F)
# 바꾼 팩터를 dataframe형식으로 idata에 넣어준다



# Anova()
model1 <- Anova(multimodels, idata=data.frame(trials), idesign=~trials, type="III")

summary(model1, multivariate=F) # 0.25이므로 타당하다!(0.05이상)


rmlong <- gather(rm, key="ID", value="SCORE", -id)
rmlong

with(rmlong, pairwise.t.test(SCORE, ID, paired=T, p.adjust.method = "bonferroni"))

# aov()
out <- aov(SCORE~ID, data=rmlong)
shapiro.test(resid(out))

summary(out)

# Tukey방식으로 사후검정할 경우 검증방법을 따로 지정해줘야함
TukeyHSD(out)
0.5/4


## Friedman Test
?friedman.test


RoundingTimes <-
  matrix(c(5.40, 5.50, 5.55,
           5.85, 5.70, 5.75,
           5.20, 5.60, 5.50,
           5.55, 5.50, 5.40,
           5.90, 5.85, 5.70,
           5.45, 5.55, 5.60,
           5.40, 5.40, 5.35,
           5.45, 5.50, 5.35,
           5.25, 5.15, 5.00,
           5.85, 5.80, 5.70,
           5.25, 5.20, 5.10,
           5.65, 5.55, 5.45,
           5.60, 5.35, 5.45,
           5.05, 5.00, 4.95,
           5.50, 5.50, 5.40,
           5.45, 5.55, 5.50,
           5.55, 5.55, 5.35,
           5.45, 5.50, 5.55,
           5.50, 5.45, 5.25,
           5.65, 5.60, 5.40,
           5.70, 5.65, 5.55,
           6.30, 6.30, 6.25),
         nrow = 22,
         byrow = TRUE,
         dimnames = list(1 : 22,
                         c("Round Out", "Narrow Angle", "Wide Angle")))
RoundingTimes



library(reshape2)
rt <- melt(RoundingTimes)
rt

out <- aov(value ~ Var2, data = rt)
shapiro.test(resid(out)) # 0.001 # 정규분포 아님님

boxplot(value ~ Var2, data=rt)


friedman.test(RoundingTimes)
# friedman.test로 사후검정하는 방법
# https://www.r-statistics.com/2010/02/post-hoc-analysis-for-friedmans-test-r-code/

friedman.test.with.post.hoc <- function(formu, data, to.print.friedman = T, to.post.hoc.if.signif = T,  to.plot.parallel = T, to.plot.boxplot = T, signif.P = .05, color.blocks.in.cor.plot = T, jitter.Y.in.cor.plot =F)
{
  # formu is a formula of the shape:     Y ~ X | block
  # data is a long data.frame with three columns:    [[ Y (numeric), X (factor), block (factor) ]]
  # Note: This function doesn't handle NA's! In case of NA in Y in one of the blocks, then that entire block should be removed.
  # Loading needed packages
  if(!require(coin))
  {
    print("You are missing the package 'coin', we will now try to install it...")
    install.packages("coin")
    library(coin)
  }
  if(!require(multcomp))
  {
    print("You are missing the package 'multcomp', we will now try to install it...")
    install.packages("multcomp")
    library(multcomp)
  }
  if(!require(colorspace))
  {
    print("You are missing the package 'colorspace', we will now try to install it...")
    install.packages("colorspace")
    library(colorspace)
  }
  # get the names out of the formula
  formu.names <- all.vars(formu)
  Y.name <- formu.names[1]
  X.name <- formu.names[2]
  block.name <- formu.names[3]
  if(dim(data)[2] >3) data <- data[,c(Y.name,X.name,block.name)]    # In case we have a "data" data frame with more then the three columns we need. This code will clean it from them...
  # Note: the function doesn't handle NA's. In case of NA in one of the block T outcomes, that entire block should be removed.
  # stopping in case there is NA in the Y vector
  if(sum(is.na(data[,Y.name])) > 0) stop("Function stopped: This function doesn't handle NA's. In case of NA in Y in one of the blocks, then that entire block should be removed.")
  # make sure that the number of factors goes with the actual values present in the data:
  data[,X.name ] <- factor(data[,X.name ])
  data[,block.name ] <- factor(data[,block.name ])
  number.of.X.levels <- length(levels(data[,X.name ]))
  if(number.of.X.levels == 2) { warning(paste("'",X.name,"'", "has only two levels. Consider using paired wilcox.test instead of friedman test"))}
  # making the object that will hold the friedman test and the other.
  the.sym.test <- symmetry_test(formu, data = data,    ### all pairwise comparisons
                                teststat = "max",
                                xtrafo = function(Y.data) { trafo( Y.data, factor_trafo = function(x) { model.matrix(~ x - 1) %*% t(contrMat(table(x), "Tukey")) } ) },
                                ytrafo = function(Y.data){ trafo(Y.data, numeric_trafo = rank, block = data[,block.name] ) }
  )
  # if(to.print.friedman) { print(the.sym.test) }
  if(to.post.hoc.if.signif)
  {
    if(pvalue(the.sym.test) < signif.P)
    {
      # the post hoc test
      The.post.hoc.P.values <- pvalue(the.sym.test, method = "single-step")    # this is the post hoc of the friedman test
      # plotting
      if(to.plot.parallel & to.plot.boxplot)    par(mfrow = c(1,2)) # if we are plotting two plots, let's make sure we'll be able to see both
      if(to.plot.parallel)
      {
        X.names <- levels(data[, X.name])
        X.for.plot <- seq_along(X.names)
        plot.xlim <- c(.7 , length(X.for.plot)+.3)    # adding some spacing from both sides of the plot
        if(color.blocks.in.cor.plot)
        {
          blocks.col <- rainbow_hcl(length(levels(data[,block.name])))
        } else {
          blocks.col <- 1 # black
        }
        data2 <- data
        if(jitter.Y.in.cor.plot) {
          data2[,Y.name] <- jitter(data2[,Y.name])
          par.cor.plot.text <- "Parallel coordinates plot (with Jitter)"
        } else {
          par.cor.plot.text <- "Parallel coordinates plot"
        }
        # adding a Parallel coordinates plot
        matplot(as.matrix(reshape(data2,  idvar=X.name, timevar=block.name,
                                  direction="wide")[,-1])  ,
                type = "l",  lty = 1, axes = FALSE, ylab = Y.name,
                xlim = plot.xlim,
                col = blocks.col,
                main = par.cor.plot.text)
        axis(1, at = X.for.plot , labels = X.names) # plot X axis
        axis(2) # plot Y axis
        points(tapply(data[,Y.name], data[,X.name], median) ~ X.for.plot, col = "red",pch = 4, cex = 2, lwd = 5)
      }
      if(to.plot.boxplot)
      {
        # first we create a function to create a new Y, by substracting different combinations of X levels from each other.
        subtract.a.from.b <- function(a.b , the.data)
        {
          the.data[,a.b[2]] - the.data[,a.b[1]]
        }
        temp.wide <- reshape(data,  idvar=X.name, timevar=block.name,
                             direction="wide")     #[,-1]
        wide.data <- as.matrix(t(temp.wide[,-1]))
        colnames(wide.data) <- temp.wide[,1]
        Y.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, subtract.a.from.b, the.data =wide.data)
        names.b.minus.a.combos <- apply(with(data,combn(levels(data[,X.name]), 2)), 2, function(a.b) {paste(a.b[2],a.b[1],sep=" - ")})
        the.ylim <- range(Y.b.minus.a.combos)
        the.ylim[2] <- the.ylim[2] + max(sd(Y.b.minus.a.combos))    # adding some space for the labels
        is.signif.color <- ifelse(The.post.hoc.P.values < .05 , "green", "grey")
        boxplot(Y.b.minus.a.combos,
                names = names.b.minus.a.combos ,
                col = is.signif.color,
                main = "Boxplots (of the differences)",
                ylim = the.ylim
        )
        legend("topright", legend = paste(names.b.minus.a.combos, rep(" ; PostHoc P.value:", number.of.X.levels),round(The.post.hoc.P.values,5)) , fill =  is.signif.color )
        abline(h = 0, col = "blue")
      }
      list.to.return <- list(Friedman.Test = the.sym.test, PostHoc.Test = The.post.hoc.P.values)
      if(to.print.friedman) {print(list.to.return)}
      return(list.to.return)
    }    else {
      print("The results where not significant, There is no need for a post hoc test")
      return(the.sym.test)
    }
  }
  # Original credit (for linking online, to the package that performs the post hoc test) goes to "David Winsemius", see:
  # http://tolstoy.newcastle.edu.au/R/e8/help/09/10/1416.html
}

friedman.test.with.post.hoc(value ~ Var2 | Var1, rt)






#### Two Way Repeated Measured ANOVA ####
# 주제 : 시차별로 여드림에 대한 효능의 차이가 있는가?

df <- read.csv("../data/10_rmanova.csv", header = T)
df <- read.csv("C:\\kimhotak13\\Rwork\\data\\10_rmanova.csv", header = T)
View(df)

# long형으로 변경
library(reshape2)
dflong <- melt(df, id=c("group", "id"), variable.name="time", value.name="month",
               measure.vars = c("month0", "month1", "month3", "month6"))

dflong


getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()

?interaction.plot
interaction.plot(dflong$time, dflong$group, dflong$month)

out <- aov(month ~ group*time, data = dflong)
shapiro.test(resid(out))

summary(out)


# 사후 검정
acl0 <- dflong[dflong$time == "month0", ]
acl1 <- dflong[dflong$time == "month1", ]
acl3 <- dflong[dflong$time == "month3", ]
acl6 <- dflong[dflong$time == "month6", ]

t.test(month ~ group, data = acl0) # 0.8076 # 0.05%기준일 때는 차이가 없다.
t.test(month ~ group, data = acl1) # 0.01962 # 0.05%기준일 때는 차이가 있다.
t.test(month ~ group, data = acl3) # 0.0002 # 0.05%기준일 때는 차이가 있다.
t.test(month ~ group, data = acl6) # 0.0009 # 0.05%기준일 때는 차이가 있다.

#4C2
0.05/6 # 0.008

# 0.008을 기준으로 다시 사후검정할 경우

# t.test(x, y, alternative = "two.sided", var.equal = FALSE, conf.level = 0.95)

t.test(month ~ group, data = acl0) # 0.008%기준일 때는 차이가 없다.
t.test(month ~ group, data = acl1) # 0.008%기준일 때는 차이가 없다.
t.test(month ~ group, data = acl3) # 0.008%기준일 때는 차이가 있다.
t.test(month ~ group, data = acl6) # 0.008%기준일 때는 차이가 있다.


t.test(month ~ group, data = acl0) # 0.008%기준일 때는 차이가 없다.
t.test(month ~ group, data = acl1) # 0.008%기준일 때는 차이가 없다.
t.test(month ~ group, data = acl3) # 0.008%기준일 때는 차이가 있다.
t.test(month ~ group, data = acl6) # 0.008%기준일 때는 차이가 있다.


# t-test 수행
result <- t.test(month ~ group, data = acl0)

# 계산된 p-value 저장
p_value <- result$p.value

# 원하는 p-value 임계값 설정
desired_threshold <- 0.08

result
# 저장된 p-value와 임계값 비교
if (p_value <= desired_threshold) {
  # 원하는 임계값 이하에서 유의한 결과
  # 추가적인 작업 수행...
  
} else {
  # 원하는 임계값 이상에서 유의하지 않은 결과
  # 다른 작업 수행...
}

