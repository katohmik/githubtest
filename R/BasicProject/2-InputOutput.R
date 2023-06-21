#### 키보드 입력 ####
# scan() : 벡터 입력
# edit() : 데이터 프레임 입력
getwd()
setwd("C:\\kimhotak13\\Rwork\\BasicProject")
getwd()


a <- scan() # 숫자 형식의 데이터 입력, 입력을 중단할 경우 빈칸에 엔터

a

?scan
b <- scan(what=character())
b

df <- data.frame()
df <- edit(df)
df

#### 파일 입력 ####
# read.csv(), read.table(), read.delim()
# read.xlsx(), read.spss()

?read.table

getwd()

student <- read.table("../data/student.txt")
student

student1 <- read.table("../data/student1.txt", header=T, encoding = "utf-8")
student1

student2 <- read.table(file.choose(), header=T, sep=";", encoding = "utf-8")
student2

student3 <- read.table("../data/student3.txt", header = T, na.strings = "-", encoding = "UTF-8")
student3
student3 <- read.table("../data/student3.txt", header = T, na.strings = c("-". "+", "&"))
student3

#getwd()
#setwd("C:/katohmik13/Rwork/BasicProject")
studentx <- read.table("../data/student.txt")
studentx
class(studentx)

install.packages("readxl")
library(readxl)
data <- read_excel("../data/studentexcel.xlsx")
data

                       
### read.xlsx()
install.packages("rJava")
install.packages("xlsx")
install.packages("XLConnect")
remove.packages("rJava")
install.packages("rJava")
library(rJava)
library(xlsx)

options(java.home = "C:/Program Files/Java/jdk-11")
system("java -version")
.jinit()


# studentx <- read.xlsx(file.choose())
# sheetName이나 sheetIndex를 지정해줘야 excel을 읽어올 수 있다.
studentx

studentx <- read.xlsx(file.choose(), sheetIndex = 1)
studentx
studentx1 <- read.xlsx(file.choose(), sheetName = "emp2")
studentx1

### read.spss()
install.packages("foreign")
library(foreign)

raw_welfare <- read.spss("../data/Koweps_hpc10_2015_beta1.sav")
raw_welfare
View(raw_welfare)
summary(raw_welfare)

#### 화면 출력 ####
# 변수명
# (식)
# print()
# cat()

x <- 10
y <- 20
z <- x + y
z

(z <- x + y)

print(z)
print(z <- x + y)

#print("x+y의 결과는", z, "입니다")
cat("x+y의 결과는", z, "입니다")

#### 파일로 출력 ####
# write.csv(), write.table(), write.xlsx()

studentx <- read.xlsx("../data/studentexcel.xlsx", sheetName = "emp2")
studentx



#환경변수 - 시스템 - 고급 시스템 설정 - 환경변수 - 
#JAVA_HOME
#program Files\Java\jdk-11


write.table(data, "C:\\katohmik13\\Rwork\\data\\stud1.txt")
write.table(data, "C:\\katohmik13\\Rwork\\data\\stud2.txt", row.names = F)
write.table(data, "C:\\katohmik13\\Rwork\\data\\stud3.txt", row.names = F, quote = F)
write.csv(data, "C:\\katohmik13\\Rwork\\data\\stud3.txt", row.names = F, quote = F)
?write.table

library(rjava)
library(xlsx)
write.xlsx(studentx, "../data/stud5.xlsx")


version


#### rda 파일 입출력 ####
# save()
# load()

save(studentx, "../data/stud6.rda")

rm(studentx)
studentx



#### sink() ####

?data
data()
data(iris)
head(iris)
tail(iris)
str(iris)

sink("../data/iris.txt")
head(iris)
tail(iris)

sink()

head(iris)
