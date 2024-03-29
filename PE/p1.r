# Projeto de PE - Pergunta 1
# Estudante: José Cutileiro (ist199097)
# Data: 1 de maio de 2022

library(readxl)
library(ggplot2)
library(tidyr)
library(dplyr)


# Leitura original
dados <- read_excel("C:\\Users\\35196\\OneDrive\\Ambiente de Trabalho\\ferias\\pest\\ResiduosPerCapita.xlsx", col_names = FALSE, range = "A13:C43")
names(dados) <- c("País","2004","2018")

# Organizar dados
dados_ok <- pivot_longer(dados,2:3,names_to = "Ano",values_to="Valor")

# Data frame com os paises indicados -> "HR - Croacia, ES - Espanha, e LT - Lituania"
# Nota: Para a primeira pergunta decidi fazer brute force (o filtro estava-me a desorganizar os dados)
paises_pedidos <-c(dados_ok$País[13],dados_ok$País[14],dados_ok$País[21],dados_ok$País[22],dados_ok$País[39],dados_ok$País[40])
residuos_pedidos <- c(dados_ok$Valor[13],dados_ok$Valor[14],dados_ok$Valor[21],dados_ok$Valor[22],dados_ok$Valor[39],dados_ok$Valor[40])
anos_pedidos <- c(dados_ok$Ano[13],dados_ok$Ano[14],dados_ok$Ano[21],dados_ok$Ano[22],dados_ok$Ano[39],dados_ok$Ano[40])
df <- data.frame(país=paises_pedidos,residuos=residuos_pedidos ,ano=anos_pedidos)


# Criar plot pedido 
p <- ggplot(data=df, aes(x=país, y=residuos, fill=ano)) +
  geom_bar(stat="identity", position=position_dodge())
p
