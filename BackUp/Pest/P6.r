library(ggplot2)
library(dplyr)
library(tidyr)
library(readxl)


set.seed(381)

vec <- c(4,26,9)

aux <- data.frame()

#colnames()

for (i in vec) {
  for (j in seq(1940)) {
    amostras <- runif(i,14,18)
    med <- mean(amostras)
    aux <- rbind(aux,c(med))
  }
  #media_total <- mean(aux$X15.1387947464827)
  #var_total <- var(aux$X15.1387947464827)
  media_total <- (14+18)/2
  var_total <- 16/12
  print(ggplot(aux,aes(aux$X15.1387947464827)) + 
        geom_histogram(aes(y=..density..)) + 
        geom_function(fun = dnorm, 
                      args = list(mean = media_total, sd = sqrt(var_total / i)),
                      color = "magenta"))
}

