# TP 3


# Dados -> https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/pew.txt

pew <- read.table("https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/pew.txt")

# Vamos precisar de um argumento adicional para organizar um pouco melhor

pew <- read.table("https://web.tecnico.ulisboa.pt/paulo.soares/pe/dados/pew.txt",header = TRUE, check.names = TRUE)


library(tidyr)

head(pew)

pew

# $ -> Variaveis

# pivot_longer(Coleção a operar, [A afetar]-religion,mudar nomes)
pew_p <- pivot_longer(pew,-religion,names_to = "Income", values_to = "Frequency")

head(pew_p)

plot(pew_p)

View(pew_p)









