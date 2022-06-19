library(ggplot2)

set.seed(735)
m <- 900
a <- qnorm(0.99,mean=0,sd=1)
Meds <- data.frame()
amp <- data.frame() 
amp_c <- data.frame()
dados <- data.frame()

for (n in seq(from = 100,to = 2500,by = 100)) {
  dados <- replicate(m,rexp(n,1.06))
  dados_c <- data.frame(dados)
  cont <- replicate(m,rexp(n*0.25,0.01))
  dados_c[seq(1, n*0.25), seq(1,m)] <- cont
  amp <- c()
  amp_c <- c()
  for (i in seq(1,m)) {
    amp <- c(amp, (2/ mean(dados[,i])) * (a/sqrt(n)))
    amp_c <- c(amp_c,(2/mean(dados_c[,i]))* (a/sqrt(n)))
  }
  Meds <- rbind(Meds,list(n,mean(amp),'Nao Contaminado'))
  Meds <- rbind(Meds,list(n,mean(amp_c),'Contaminado'))
}

colnames(Meds) <- c('Nd','Med','Est')

ggplot(Meds,aes(x=Nd,y=Med,color=Est)) +
  geom_point(shape=18,size = 4)

