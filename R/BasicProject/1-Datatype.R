#### 변수 ####

goods = "냉장고"
goods


# 변수 사용 시 객체 형태로 사용하는 것을 권장
goods.name = "냉장고"
goods.code = "ref001"
goods.price = 600000


# 값을 대입할 경우 = 대신 <- 사용
goods.name <- "냉장고"
goods.code <- "ref001"
goods.price <- 600000


# 데이터 타입 확인
class(goods.name)
class(goods.price)
mode(goods.name)
mode(goods.price)


#### Vector ####

# c()
v <- c(1, 2, 3, 4, 5)
v
class(v)
mode(v)

(v <- c(1,2,3,4,5))
print(v <- c(1,2,3,4,5))

c(1:5)
c(1,2,3,4, "5")
c

# seq()
?seq

seq(from=1, to=10, by=1)
seq(1, 10, 1)

# rep()
rep(1:3, 3)

# 벡터의 접근

v <- c(1:50)
v[10:45]
length(v)

v[10:length(v)-5]
v[10:(length(v)-5)]

v1 <- c(13, -5, 20:23, 12, -2:3)
v1

v1[1]
v1[c(2, 4)]
v1[c(4, 5:8, 7)]
v1[-1] # r에서의 인덱스 -1은 첫번째 값 제거> v1
v1[-1]
v1[-2]
v1[c(-2, -4)]
v1[-c(2, 4)]

 

# 집합 연산

x <- c(1,3, 5, 7)
y <- c(3, 5)

union(x, y); setdiff(x, y); intersect(x, y)

# 컬럼명 지정
age <- c(30, 35, 40)
age
names(age) <- c("홍길동", "임꺽정", "신돌석")
age

# 특정 변수의 데이터 제거
age <- NULL
age

# 벡터 생성의 또다른 표현
x <- c(2, 3)
x <- (2:3) # 이렇게 범위로 지정하면 c를 생략가능
x



#### Factor ####

gender <- c("man", "woman", "woman", "man", "man")
gender
class(gender)
mode(gender)
is.factor(gender)

ngender <- as.factor(gender)
ngender
class(ngender)
mode(ngender) # 범주형일 때는 0과1로 값을 처리함
is.factor(ngender)
plot(ngender) # 범주형은 이렇게 쉽게 그래프로 그릴 수 있음
#plot(gender) # 범주형이 아니기에 그래프로 그릴 수 없음
table(ngender)
table(gender) # table함수는 factor가 아니라도 사용가능

?factor
gfac <- factor(gender, levels = c("woman", "man"))
gfac
plot(gfac)


#### Matrix ####

# matrix()
matrix(1:5)
matrix(c(1:11), nrow=2)
matrix(c(1:10), nrow=2)
m <- matrix(c(1:10), nrow=2, byrow=T) # 세로로 12, 34, 56으로 진행되던게 가로로 12345, 6798910이 되었다.
class(m)
mode(m)
m
# rbind(), cbind()
x1 <- c(3, 4, 50:52) 
x2 <- c(30, 5, 6:8, 7, 8)
cbind(x1, x2) # 가로로 옆을 붙이듯이 묶고 모자란 값은 처음부터 반복
rbind(x1, x2) # 새로로 포개듯이 묶고, 모자란 값은 처음부터 반복


# matrix의 차수 확인
x <- matrix(c(1:9), ncol=3)
x

x <- matrix(c(1:9), nrow=3)
x

length(x); nrow(x); ncol(x); dim(x)

# 컬럼명 지정
colnames(x) <- c("one", "two", "three")
x
colnames(x)

# apply()
# apply(X, MARGIN, FUN, ..., simplify = TRUE)
# margin : 1 = row
# margin : 2 = col
?apply
apply(x, 1, max) # 행끼리 비교해서 가장 높은 값은?
apply(x, 2, max) # 열끼리 비교해서 가장 높은 값은?
apply(x, 1, sum) # 행끼리 총합은?
apply(x, 2, sum) # 열끼리 총합은?


#### DataFrame ####

# data.frame()

no <- c(1, 2, 3)
name <- c('hong', 'lee', 'kim')
pay <- c(150.25, 250.18, 300.34)
emp <- data.frame(No=no, Name=name, Payment=pay)
emp

# read.csv(), read.table(), read.delim()
getwd() # get work directory 내가 어디서 작업중인지 확인인
getwd()
setwd("C:\\kimhotak13\\Rwork\\StatProject")
getwd()


read.table("../data/emp.txt")
txtemp <- read.table("../data/emp.txt", header=T, sep=" ")
# csv파일을 불러올 때는 sep = "," 콤마로
class(txtemp)
mode(txtemp)

setwd("../data")
getwd()
csvemp <- read.csv("emp.csv")
csvemp

read.csv("emp.csv", col.name=c("사번", "이름", "급여"))
read.csv("emp2.csv", header=F, col.name=c("사번", "이름", "급여"))


read.table("aws_sample.txt", sep="#")
aws <- read.delim("aws_sample.txt", sep="#")
head(aws)
View(aws)

#접근

aws[1,1]
aws[1:3, 2:4]

x1 <- aws[1:3, 2:4]
x1

x2 <- aws[9:11, 2:4]
x2

cbind(x1, x2)
rbind(x1, x2)

class(aws[,1])
mode(aws[,1])

aws[,1] # 벡터 # 하나의 행의 모든열에 접근할 때
aws$AWS_ID


# 구조 확인
str(aws)

# 기본 통계량
summary(aws)


# apply()
# 슬라이싱(범위)로 지정할 경우 c 생략가능
df <- data.frame(x=(1:5), y=seq(2, 10, 2), z=c("a", "b", "c", "d", "e"))
df

apply(df[,c(1,2)], 1, sum) # 행끼리 더하고
apply(df[,c(1,2)], 2, sum) # 열끼리 더하고

# 데이터의 일부 추출(133p)
subset(df, x>=3)
subset(df, x>=2 & y <=6 )


# 병합
height <- data.frame(id=c(1,2), h=c(180, 175))
weight <- data.frame(id=c(1,2), w=c(80, 75))
height
weight

merge(height, weight, by.x="id", by.y="id")


#### array ####

v <- c(1:12)
v
?array


arr <-array(v, c(4, 2, 3))
arr
# 접근
#array(data = NA, dim = length(data), dimnames = NULL)
# [x,y,z] x생략하면 모든 행, y생략하면 모든 열, z는 면(몇번째 차원)
# v값이 끝난 후에도 못채우면 첫번째 값부터 다시 반복

arr[,,1]
arr[,,2]
arr[,,3]

# 추출
arr[2,2,1] # 첫번째 면에서 2,2 자리
arr[,,1][2,2] # 첫번째 면 전체에서 2,2 자리


#### List ####

x1 <- 1
x2 <- data.frame(var1=c(1,2,3), var2=c('a','b','c'))
x2
x3 <- matrix(c(1:12),ncol=2)
x3
x4 <- array(1:20, dim=c(2, 5, 2))
x4
x5 <- list(c1=x1, c2=x2, c3=x3, c4=x4)
x5

x5$c2

list1 <- list(c("lee","kim"), "이순신", 95)
list1


list1[1]
list1[[1]]
list1[[1]][1]
list1[[1]][2]

list1 <- list("lee", "이순신", 95)
list1
un <- unlist(list1)
un
class(un)

# lapply(), sapply()
# lapply() : list에서 쓰기위한 apply. apply()는 2차원 데이터만 입력을 받는다. vector 또는 그 이상의 차원을 입력받기 위한 방법으로 사용. 반환형은 list형이디.
# sapply() : 반환형이 matrix 또는 vector로 반환(lapply의 wrapper)
a <- list(c(1:5))
a

b <- list(c(6:10))
b

c <- c(a,b)
c
class(c)
x <-lapply(c, max)
x
x1 <- unlist(x)
x1


x <- sapply(c, max)
x
x1 <- unlist(x)
x1

#### 기타 데이터 입력

# 날짜
Sys.Date()
Sys.time()

a<- '23/3/31'
class(a)

b <- as.Date(a)
b
class(b)

as.Date(a,"%y/%m/%d")
