

#### RESPOSTA 9 ############################################### LOBO
set.seed(92)

dim <- 1310
lambda <- 2.79
conf <- 0.93

amplitudes <- data.frame()

for (i in seq(1300)) {
  amostra <- rexp(dim,lambda)
  media <- mean(amostra)
  b <- qnorm((1+conf)/2)
  amplitude <- (2/media) * (b/sqrt(dim))
  amplitudes <- rbind(amplitudes,amplitude)
}

print(mean(amplitudes[,1]))


#### RESPOSTA 8 ############################################### LOBO
set.seed(321)

dim <- 1158
lambda <- 0.8
conf <- 0.999

amplitudes <- data.frame()

for (i in seq(1050)) {
  amostra <- rexp(dim,lambda)
  media <- mean(amostra)
  b <- qnorm((1+conf)/2)
  amplitude <- (2/media) * (b/sqrt(dim))
  amplitudes <- rbind(amplitudes,amplitude)
}

print(mean(amplitudes[,1]))

