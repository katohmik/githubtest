#### 조건문 ####

# 난수 준비
?runif


x <- runif(1) # 0~1까지
x

# x가 0.5보다 크면 출력
if(x > 0.5){print(x)}

# x가 0.5보다 작으면 1-x로 출력하고, 그렇지 않으면 x를 출력
if(x < 0.5){
   print(1-x)
}else{
   print(x)
}

if(x < 0.5) print(1-x) else print(x)

### ifelse() ###
ifelse(x<0.5, 1-x, x)


avg <- scan()

if(avg >= 90){
   print("당신의 학점은 A학점입니다.")
}else if(avg >= 80){
   print("당신의 학점은 B학점입니다.")
}else if(avg >= 70){
   print("당신의 학점은 C학점입니다.")
}else if(avg >= 60){
   print("당신의 학점은 D학점입니다.")
}else{
   print("당신의 학점은 F학점입니다.")
}

### switch(비교문, 실행문1, 실행문2, ...)
# 안에 들어가는 것이 문자열이어야 한다. 문자열로 비교해야한다.
a <- "중1"
switch(a, "중1"=print("14살"), "중2"=print("15살"))
switch(a, "중1"="14살", "중2"="15살")

b <- 3
switch(b, "14살", "15살", "16살")
b <- 2
switch(b, "14살", "15살", "16살")

empname <- scan(what="")
switch(empname, hong=250, lee=350, kim=200, kang=400)

# 위의 다중 조건을 switch로 작성
score <- scan()
switch(score, (90<=score)=="당신의 학점은 A학점입니다",
       (80<=score)=="당신의 학점은 B학점입니다", 
       (70<=score)=="당신의 학점은 C학점입니다", 
       (60<=score)=="당신의 학점은 D학점입니다", 
       (60>score)=="당신의 학점은 F학점입니다")

# 강사님 버전 참고...

?switch
avg <- scan()
grade <- switch(as.character(avg >= 60), "TRUE" = switch(as.character(avg >= 70), 
"TRUE" = switch(as.character(avg >= 80),"TRUE" = switch(as.character(avg >= 90),
"TRUE" = "A","FALSE" = "B"),"FALSE" = "C"),"FALSE" = "D"),"FALSE" = "F")

print(paste("당신의 학점은", grade, "학점입니다."))








### 위의 다중 조건을 switch로 작성(강사님 버전)

avg <- as.character(scan() %/% 10)

result <-switch(avg, "10"="A", "9"="A", "8"="B", "7"="C", "6"="D", "5"="F")
cat("당신의 학점은", result, "입니다")

## 문자열로 avg를 씌워준다 아래든 위든
avg <- scan() %/% 10

result <-switch(as.character(avg), "10"="A", "9"="A", "8"="B", "7"="C", "6"="D", "5"="F")
cat("당신의 학점은", result, "입니다")

### which() : 값의 위치(index)를 찾아주는 함수

# vector에서 사용
x <- c(2:10)
x

which(x == 3)
x[which(x==3)]

# matrix에서 사용
m <- matrix(1:12, 3, 4)
m

?which
which(m%%3 == 0)
which(m%%3 == 0, arr.ind=F)
which(m%%3 == 0, arr.ind=T)

# data.frame에서 사용
no <- c(1:5)
name <- c("홍길동", "유비", "관우","장비", "전우치")
score <- c(85, 78, 89, 90, 74)
exam <- data.frame(학번=no, 이름=name, 성적=score)
exam

# 이름이 장비인 사람 검색
which(exam$이름 == "장비")
exam[which(exam$이름 == "장비"), ]
exam[4, ]

exam[exam$이름 == "장비", ]

# which.max(), which.min() : 숫자에만 인식
# 가장 높은 점수를 ㅡ가진 학생은?
which.max(exam$성적)
exam[which.max(exam$성적), ]


### any(), all()
x <- runif(5)
x

# x값들 중에서 0.8이상이 있는가?
any(x >= 0.8)

# x값들이 모두 0.7 이하인가?
all(x <= 0.7)


#### 반복문 ####

# 1부터 10까지의 합계
sum <- 0
for(i in seq(1, 10)){
   sum <- sum + i
}
sum

# 1부터 10까지의 합계(한줄로)
sum <- 0
for(i in seq(1, 10)) sum <- sum + i
sum

#### 함수 ####

### 함수 만들기 ###

# 인자 없는 함수
test1 <- function(){
   x <- 10
   y <- 20
   return(x*y)
}

test1()

# 인자 있는 함수
test2 <- function(x, y){
   a <- x
   b <- y
   return(a-b)
}
test2(10, 5)
test2(y=10, x=5)   
test2(y=-10, x=5)

# 가변인수
test3 <- function(...){
   print(list(...))
}

test3(10)
test3(10,20)
test3(10,20,30)
test3('3','홍길동',30)

# 가변인수 for문
test4 <- function(...){
   for(i in list(...)) print(i)
}

test4(10)
test4(10,20)
test4(10,20,30)
test4('3','홍길동',30)

## 가변인수와 매개변수를 같이 쓰자
# 같이 쓸 경우 가변인수를 맨 마지막에 쓰자(앞에 쓰거나 중간에 쓰면 순서를 모름)

test5 <- function(a, b, ...){
   print(a)
   print(b)
   print("----------------")
   print(list(...))
}

test5(10, 20, 30, 40)



### 문자열 함수
# r에서는 \를 인식 못하기 때문에 \\로 사용함
# stringr : 정규표현식을 활용
# install.packages("stringr")
library(stringr)

str1 <- "홍길동35이순신45임꺽정35"
str_extract(str1, "\\d{2}")
str_extract_all(str1, "\\d{2}")
str_extract_all(str1, "[0-9]{2}")
str_extract_all(str1, "[0-9]{1}")
class(str_extract_all(str1, "[0-9]{1}")) # 대부분의 데이터는 list로 묶여있음.

# 리스트 풀때는 unlist()

str2 <- "hongkd1051eess1002you25TOM400강 감 찬2005"
str_extract_all(str2, "[a-zA-Z]{1}") # 영어만 1개씩 가져오고
str_extract_all(str2, "[a-zA-Z]+") # 영어만 단어로 가져오고
str_extract_all(str2, "[가-힣]{1}") # 한글만 1개씩 가져오고
str_extract_all(str2, "[가-힣]+") # 한글만 단어로 가져오고
str_extract_all(str2, "\\D{1}") # 문자열만 1개씩 가져오고
str_extract_all(str2, "\\D+") # 문자열만 단어로 가져오되 공백도 포함한 단어
str_extract_all(str2, "[a-zA-Z가-힣]+") # 모든 문자를 단어별로 가져오고

length(str2)
str_length(str2)

str_locate(str2, "강 감 찬")

str_c(str2, "유비55") # 새로운 데이터를 연결시켜 줄 때
str2 # 원본에서는 안바뀌어 있다. # 복사본으로 따로 만들어진 것이다

library(stringr)
name <- "홍길동1234,이순신5678,강감찬1012"
str_extract_all(name, "[a-zA-Z가-힣0-9]{7}+") 


### 기본 함수

sample <- data.frame(c1=c("abc_abcdefg", "abc_ABCDE", "ccd"), c2=1:3)
sample


nchar(sample[1, 1]) # 문자수
which(sample[,1] == "ccd")
toupper(sample[1,1]) # 대문자로
tolower(sample[2,1]) # 소문자로
substr(sample[,1], start=1, stop=1)
substr(sample[,1], start=1, stop=2)
substr(sample[,1], start=1, stop=3)
substr(sample[,1], start=1, stop=4)
substr(sample[,1], start=1, stop=5)
paste0(sample[,1], sample[,2]) # 모든 1열의 값과 2열의 값을 붙이겠다.
paste(sample[,1], sample[,2], sep="@@")

# paste0 = 연결만 해준다
# paste = 연결을 해주고 sep으로 사이값을 지정할 수 있다.

### 문자열을 분리해서 하나의 컬럼을 두 개의 컬럼으로 확장
install.packages("splitstackshape")
library(splitstackshape)

cSplit(sample, splitCols = "c1", sep = "_")
sample # 원본은 그대로다

# 패키지의 함수 목록 확인
ls()
ls("package:stringr")
