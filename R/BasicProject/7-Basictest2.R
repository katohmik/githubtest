
#[문항1] 아래의 요구 사항에 맞춰 문제을 해결하시오. (배점:20)

#1) 월요일부터 금요일까지 5일간 판매된 바나나 우유의 개수가 요일별로 140, 50, 20, 120, 240개이다. 5일간의 바나나 우유 판매 개수를 갖는 bmilk라는 변수를 만들어라.

bmilk <- c(140, 50, 20, 120, 240)
bmilk

#2) 월요일부터 금요일까지 5일간 판매된 초콜릿 우유의 개수가 요일별로 24, 50, 100, 350, 10개이다. 5일간의 초콜릿 우유 판매 개수를 갖는 cmilk라는 변수를 만들어라.

cmilk <- c(24, 50, 100, 350, 10)
cmilk

#3) 월요일부터 금요일까지("Monday", "Tuesday", "Wednesday", "Thursday", "Friday") 요일의 이름을 갖는 days라는 변수를 만들고, bmilk와 cmilk 벡터의 각 칸의 이름을 days라는 변수를 활용하여 입력하라.

days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
days
names(bmilk) <- days
bmilk
names(cmilk) <- days
cmilk

#bmilk
#Monday Tuesday Wednesday Thursday Friday
#140          50                20          120    240

#cmilk
#Monday  Tuesday Wednesday  Thursday    Friday
#24            50              100          350        10



4) 5일간 총 판매된 바나나 우유의 개수와 초콜릿 우유의 개수를 각각 구하라.

bmilk
sum(bmilk)
cmilk
sum(cmilk)

5) 바나나 우유와 초콜릿 우유의 요일별 판매 합계를 값으로 갖는 벡터 totalmilik를 만들고, 이를 이용하여 일평균 판매 개수를 구하라.

bmilk <- c(140, 50, 20, 120, 240)
cmilk <- c(24, 50, 100, 350, 10)
daily <- bmilk + cmilk
days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
names(bmilk) <- days
names(cmilk) <- days
totalmilik <- rbind(bmilk, cmilk, daily)
totalmilik




[문항2] 아래 표의 내용을 데이터 프레임으로 만들어 출력하시오.
이렇게 만든 데이터프레임을 이용해 과일 가격 평균, 판매량 평균을 구해 보시오. (배점:20)

<aside>
  제품    가격    판매량
-------------------------------
사과    1800          24
딸기    1500          38
수박    3000          13


no <- c(1, 2, 3)
name <- c('hong', 'lee', 'kim')
pay <- c(150.25, 250.18, 300.34)
emp <- data.frame(No=no, Name=name, Payment=pay)
emp

fruit <- c("사과", "딸기", "수박")
price <- c(1800, 1500, 3000)
sales <- c(24, 38, 13)

aside <- data.frame(Fruit=fruit, Price = price, Sales=sales)
aside

library(dplyr)

aside %>% summarise(mean_price = mean(price))
aside %>% summarise(mean_price = mean(sales))


[문항3] 구구단을 사용자 입력으로 처리하시오. (배점:20)
예)
2 (엔터)  # 단을 입력받음
2 X 1 = 2
2 X 2 = 4
...
2 X 9 = 18

base <- seq(1, 9, 1)
base*scan()

[문항4] 다음과 같은 리스트변수가 있을 때 질문에 답하시오. (배점:20)

x1 <- 1
x2 <- data.frame(var1=c(1, 2, 3), var2=c('a', 'b', 'c'))
x3 <- matrix(c(1:12), ncol=2)
x4 <- array(1:20, dim=c(2, 5, 2))

list1 <- list(c1=x1, c2=x2, c3=x3, c4=x4)

1) c2에 있는 var2의 "b"라는 값을 추출하시오.

list1$c2[[2]][2]

2) c4에서 2번째 면에 있는 4번째 컬럼인 17, 18값을 추출하시오.

list1$c4[,,2][,4]











[문항5] 아래와 같은 다중 if문을 switch()를 이용하여 작성하시오. (배점:20)

avg <- scan()

if(avg >= 90){
  print("A학점")
}else if(avg >= 80){
  print("B학점")
}else if(avg >= 70){
  print("c학점")
}else if(avg >= 60){
  print("D학점")
}else{
  print("F학점")
}



avg <- as.character(scan() %/% 10)
result <-switch(avg, "10"="A", "9"="A", "8"="B", "7"="C", "6"="D", "5"="F")
cat("Your grade is", result)




















