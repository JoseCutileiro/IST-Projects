# Relatório entrega final

## Alunos:
```
Franscisco Guilherme - 99069
Guilherme Pascoal - 99079
José Cutileiro - 99097
```

## Explicação da solução: 



### #1: Inicializar os servidores
```
Atributos adicionais
    1. Server index
    2. Vector clocks (valueTS, replicaTS ,prevTS ,opTS e opPrev)

    valueTS: Operações executadas
    replicaTS: Operações guardadas
    prevTS: Operações chamadas (pelos clientes)
    opTS: timestamp associado à criação da operação (replica)
    opPrev: timestamp associado à criacao da operacao (value)

        1. Quando ligamos um servidor, este verifica quantos servidores já existem
            ficando com o valor 'server_index' associado a este número. Inicializa também 
            o vector clock com entradas a 0 para cada servidor.
        2. Precisamos também de avisar os servidores que já estavam ativos anteriormente da nossa
            existência. Para isto adicionamos um novo serviço ao cross server. Os que recebem esta
            chamada acrescentam uma nova entrada aos seus vector clocks.
    
    Com isto conseguimos ter um número arbitrário de servidores compativeis com o algoritmo 'gossip'
        apresentado nas aulas.
    Problema: Esta solução tem limitações quando um dos servidores falha (ou é apagado).
    (este problema não foi resolvido dado o ambito académico do projeto)
```

### #2: Algoritmo gossip

```
Notas: 
1. VC = vector clock

(1) Leituras:
    Sempre que ocorre uma leitura ao estado de um dos servidores devemos:
        Verificar se o prevTS <= que o valueTS
        Se sim a leitura é válida caso contrário o servidor está atrasado 
        em relação ao cliente logo é incapaz de responder.  

(2) Escritas:
    Sempre que ocorre uma escrita no estado de um dos servidores devemos:
        Incrementar o prevTS recebido pelo cliente e devolver IMEDIATAMENTE.
        Adicionamos a operação ao ledger e incrementamos o replicaTS. Se o prevTS for <= que o valueTS dizemos 
        que a operacao é stable e executamos a mesma. Fazemos também merge do valueTS com o replicaTS.
        Caso contrario dizemos que não é stable e não a executamos (por enquanto).

(3) Propagação:
    Sempre que um administrador acha necessário devemos:
        1. Escolher o servidor que queremos que execute esta propagação 
        2. Enviamos o ledger e o replicaTS deste servidor às restantes réplicas
        Exemplo: Propagação do A para o B
        3. As operações do A com opTS <= que o replicaTS do B são descartadas, as restantes 
        são adicionadas ao ledger de B. Se opPrev for <= que o valueTS de B dizemos que 
        a nova operação é stable e executamos (fazendo também o merge do valueTS com o opTS)
        caso contrario esta operação ainda não é stable e não a executamos.
    
        A meio do caminho fazemos um merge das réplicas de B e de A

        Por último vamos a todas as operações no B para verificar se já podemos executá-las
        ou não (agora que já temos mais informações). Para isto basta ver se o opPrev é <=
        que o valueTS de B (e esta operação ainda não foi executada, ou seja não é stable). Se isto se verificar 
        encontramos uma nova operação stable e executamos (fazendo merge do valueTS de B no fim
        com o opTS da nova operação)
```