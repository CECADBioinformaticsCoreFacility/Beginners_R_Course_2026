# Operator before Data Structure
# kahoot for quiz

#From Bricks to Burge Khalifa

##---------------------------##
##` Session 1: Follow Along `##
##---------------------------##
##==========================Interacting R=======================================
##=== R Script ===
## Load data
data("iris")

## display data sample
head(iris)

## get statistics
summary(iris)

## get plot
boxplot(Petal.Length ~ Species, data = iris, col=c(1:3))

## Running the script [terminal]
# Rscript boxplot.R

##=== R help ===

## ? [function]
?head

## help([function])
help(head)

## example([function])
example(head)

## demo([topic])
demo(graphics)

## browseVignettes([package])
## library([package])
browseVignettes("stats")

search()

data()


##---------------------------##
##` Session 3: Follow Along `##
##---------------------------##
##===========================Control Flow=======================================
##=== if statement ===
x <- 30L
if(is.integer(x)) {
  print("X is an Integer")
}

##=== if-else statement ===
x <- c("what","is","truth")
if("Truth" %in% x) {
  print("Truth is found")
} else {
  print("Truth is not found")
}

##=== switch statement ===
x <- switch(
  3,
  "first",
  "second",
  "third",
  "fourth"
)
print(x)

##============================R Loops===========================================

##=== for loop ===
v <- LETTERS[1:4]
#
for ( i in v) {
  print(i)
}

##=== while loop ===
v <- c("Hello","while loop")
cnt <- 2

while (cnt < 7) {
  print(v)
  cnt = cnt + 1
}

##=== repeat loop & break statement ===
v <- c("Hello","loop")
cnt <- 2

repeat {
  print(v)
  cnt <- cnt + 1
  
  if(cnt > 5) {
    break
  }
}

##=== next statement ===
v <- LETTERS[1:6]
for ( i in v) {
  
  if (i == "D") {
    next
  }
  print(i)
}

##=======================The apply family=======================================

##=== apply function ===
mtrx <- matrix(c(1:10, 11:20, 21:30), 
               nrow = 10, ncol = 3)
mtrx

apply(mtrx, 1, sum) # row-wise

apply(mtrx, 2, sum) # column-wise

st.err <- function(x){
  sd(x)/sqrt(length(x))
}

apply(mtrx,2, st.err)

##=== lapply function ===
A<-c(1:10)
B<-c(11:20)
C<-c(21:30)
my.lst<-list(A,B,C)
my.lst

lapply(my.lst, sum)

##=== sapply function ===
sapply(my.lst, mean)

##=== vapply function ===
vapply(my.lst, mean, numeric(1))

##=== tapply function ===
iris$Sepal.Length
iris$Species
tapply(iris$Sepal.Length, iris$Species, mean)

##=== mapply function ===
mapply(sum, A, B, C)

##---------------------------##
##` Session 6: Follow Along `##
##---------------------------##
##===================Measures of Central Tendency===============================
mean(iris$Sepal.Width)

median(iris$Sepal.Width)

x <- table(iris$Sepal.Width)
sort(x, decreasing = TRUE)
x<-iris$Sepal.Width
hist(x, freq=FALSE)
lines(density(x), col='red', lwd=3)
abline(v = mean(x), col="green")
abline(v = median(x), col="blue")
abline(v = 3, col="red")
legend("topright", c("mean", "median","mode"), fill=c("green","blue", "red"))
##===================Measures of Variability===================================
min(iris$Sepal.Length)

max(iris$Sepal.Length)

range(iris$Sepal.Length)

var(iris$Sepal.Length)

sd(iris$Sepal.Length)

##=================Measures of Distribution=====================================
skewness <- function(x) {
  n <- length(x)
  m3 <- sum((x - mean(x))^3) / n
  m2 <- sum((x - mean(x))^2) / n
  skew <- m3 / (m2^(3/2))
  return(skew)
}

skewness(iris$Sepal.Length)

kurtosis <- function(x) {
  n <- length(x)
  m4 <- sum((x - mean(x))^4) / n
  m2 <- sum((x - mean(x))^2) / n
  kurt <- m4 / (m2^2)
  return(kurt)
}
kurtosis(iris$Sepal.Length)

##==================Descriptive Statistics======================================
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length, probs = c(0.25, 0.5, 0.75))
quantile(iris$Sepal.Length, probs = c(0.1, 0.5, 0.9))

summary(iris)

##==============Frequency/Cross/Contingency Tables==============================
demo_data <- iris

demo_data$size <- 
  ifelse(demo_data$Sepal.Length <
           median(demo_data$Sepal.Length),
         "small", "big"
  )
table(demo_data$Species, demo_data$size)

##====================Correlation===============================================
cor(iris$Sepal.Length,iris$Sepal.Width, method = "pearson")
cor(iris$Sepal.Length,iris$Sepal.Width, method = "spearman")

# improved correlation matrix
library(corrplot)

corrplot(cor(mtcars),
         method = "number",
         type = "upper", # show only upper side
)

##==========================Correlation Test====================================
cor.test(iris$Sepal.Length,iris$Sepal.Width)

