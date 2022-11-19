# Learning R and R studio -> Class 0
# Author: José Cutileiro
# Date: 13 March 2022



# Datasets packege: Used to give some data examples (useful to make some tests) 
library(datasets)

# Example 1: IRIS -> plot()
head(iris)


# Testing plot in iris colection
plot(iris$Species)
plot(iris$Species,col= "#cc0000")
plot(iris$Species,col= "#398293",main="Testing plot args")

# Testing plot with generic functions
plot(cos,0,2*pi,"Function: cos")
plot(exp,1,10,main="Exponencial example",col="#ff0000")
plot(dnorm,-10,10,main="Normal distribution",lwd=5)


# Example 2: mtcars -> Bar charts
head(mtcars)

# Associate variable to a table
cylindres <- table(mtcars$cyl)
barplot(cylindres)
plot(cylindres)
plot(cylindres,lwd=10)

# Note: barplot != plot, however they are similar


# Example 3: iris -> Histograms


head(iris)


# Basic histograms

iris
hist(iris$Sepal.Length)
hist(iris$Sepal.Width)
hist(iris$Species) # Error -> 'x' must be numeric

# Histogram by group
par(mfrow = c(3,1))   # Show three graphics at the same time 
par(mfrow = c(1,1))   # Reset 
  
hist(iris$Petal.Width [iris$Species == "setosa"],
     xlim = c(0,3),
     breaks = 9,
     main = "Insert title here",
     xlab = "",
     col = "red")

hist(iris$Petal.Width [iris$Species == "versicolor"],
     xlim = c(0,3),
     breaks = 9,
     main = "Insert title here",
     xlab = "",
     col = "#00ff00")
 
hist(iris$Petal.Width [iris$Species == "virginica"],
     xlim = c(0,3),
     breaks = 9,
     main = "Insert title here",
     xlab = "",
     col = "#0000ff")



     





