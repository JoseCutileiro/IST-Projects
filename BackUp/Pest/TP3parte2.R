# TP3: Parte 2 -> Estatistica descritiva

# Tabelas

library(datasets)

tbl1 <- table(iris$Sepal.Length)

tbl2 <- table(iris$Sepal.Length,iris$Petal.Length)

View(tbl2)

View(tbl1)
prop.table(tbl2,2)

#/* Prop: Proporções */
#  1 -> Em cada uma das linhas (frequência relativas à linha)
#  2 -> Em cada uma das colunas (frequências relativas às colunas)
 
hospitals <- read.table("https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/hospitals.txt")



head(hospitals)  
brk <- seq(6,20,by=2)
cut(hospitals$V2, breaks = brk)
  
names(hospitals) <- c("Stay","Age","Risk","Culturing","X-Ray","Beds","MSA","Region")


water <- read.csv("https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/water.csv")

head(water)  
    
summary(water)

# Definicoes

#Primeiro quartil -> 0.25
#Mediana -> 0.5 (segundo quartil)
#Terceiro quartil -> 0.75

# Media
mean(water$mortality)
# Desvio padrão
sd(water$mortality)

quantile(water$mortality)



# DIVIDA PUBLICA DO ESTADO PT (1850 - 2021)

divida_AP <- read.csv("https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/divida.csv")




