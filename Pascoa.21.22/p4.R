# Projeto de PE - Pergunta 2
# Estudante: José Cutileiro (ist199097)
# Data: 2 de maio de 2022

library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)

dados <- read_excel("C:\\Users\\35196\\OneDrive\\Ambiente de Trabalho\\ferias\\pest\\Utentes.xlsx", col_names = TRUE, range = "A1:D77")


ggplot(data=dados, aes(x = Colesterol, y =TAD))+
  geom_point()+
  geom_smooth(method = "lm")
