#----------------------------------------------------------------------------------------------------------------#
#                           Aluno:Jose Miguel Sequeira Pires de Azevedo Cutileiro                                #
#                           Numero:ist199097                                                                     #
#                           Versao:1.0.0 //FINAL                                                                 #
#----------------------------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------#
#                                 PARTE 1 -> REPRESENTACAO DO TABULEIRO                                          #
#----------------------------------------------------------------------------------------------------------------#
def tuplo3_por3(linha):
    """
    Funcao auxiliar
    Cada linha tem unicamente 3 posicoes
    nem mais nem menos
    """
    if len(linha) != 3:
        return False
    return True
#-----------------------------------------------------------------------------------------------------#
def numeros_tuplo(linha):
    """
    Funcao auxiliar
    Cada elemento da linha tem que ser 1,0 ou -1
    (1->X // -1->O // 0-> vazio)
    """
    for entrada in linha:
        if entrada not in (-1, 0, 1):
            return False
        elif type(entrada) != int:
            return False
    return True
#-----------------------------------------------------------------------------------------------------#
def eh_tabuleiro(tab):
    """
    Utilizando as funcoes auxiliares
    esta funcao conclui se o argumento inserido e um tabuleiro ou nao
    True-> e tabuleiro // False-> nao e tabuleiro
    """
    if type(tab) != tuple:
        return False
    if len(tab) != 3:                            #Cada tabuleiro tem apenas 3 linhas
        return False
    for linha in tab:                            #Verificar se cada linha e valida
        if type(linha) != tuple:                 #Uma linha tem que ser um tuplo necessariamente
            return False
        if tuplo3_por3(linha) == False:          #Cada linha tem apenas 3 posicoes
            return False
        if numeros_tuplo(linha) == False:        #Cada posicao e ocupada apenas por -1/0/1
            return False
    return True
#-------------------------------------------------------------------------------------------------------#
def eh_posicao(posicao):
    """
    Verificar se a posicao escolhida existe no tabuleiro 3x3
    (Posicoes de 1 a 9 inclusive) True->posicao valida//False->posicao invalida
    """
    if type(posicao) == int and 1 <= posicao <= 9:
        return True
    return False

#--------------------------------------------------------------------------------------------------------#
def obter_coluna(tab,num):
    """
    Recebendo um tabuleiro valido qualquer e um numero entre 1 e 3
    esta funcao ira devolver a coluna correspondente do tabuleiro
    """
    if eh_tabuleiro(tab) == False or num > 3 or num < 1 or type(num) != int:      #Verificar condicoes
        raise ValueError("obter_coluna: algum dos argumentos e invalido")
    coluna =()                                                                    #Iniciar a contrucao da coluna
    for linha in tab:
        coluna+=(linha[num-1],)                                                   #(exemplo: A coluna 2 sera a entrada 1 de cada linha)
    return coluna

#---------------------------------------------------------------------------------------------------------#
def obter_linha(tab,num):
    """
    Processo analogo ao da construcao da coluna mas correspondente as linhas
    """
    if eh_tabuleiro(tab)==False or num > 3 or num < 1 or type(num) != int:               #Verificar condicoes
        raise ValueError("obter_linha: algum dos argumentos e invalido")
    return tab[num-1]

#----------------------------------------------------------------------------------------------------------#
def obter_diagonal(tab,num):
    """
    Processo analogo ao da construcao da coluna mas correspondente as diagonais
    Nota: Apenas existem duas diagonais e nao tres
    Diagonal 1 -> Descentente da esquerda para a direita//Diagonal 2 -> Ascendente da esqueda para a direita
    """
    if eh_tabuleiro(tab) == False or num > 2 or num < 1 or type(num) != int:         #Verificar condicoes
        raise ValueError("obter_diagonal: algum dos argumentos e invalido")
    if num ==1:
        diagonal=()
        num = 0                                                                      #(analogia a diagonal principal de uma matriz)
        while num<=2:
            diagonal +=(tab[num][num],)
            num+=1
    else:                                                                            #Diagonal 2:Ascendente da esquerda para a direita
        diagonal=()
        i=0                                                                          #Coluna 1<->Linha 3|Coluna 2<->Linha 2|Coluna 3<->Linha1
        while i<=2:
            diagonal+=(tab[num][i],)
            num-=1
            i+=1
    return diagonal
#-----------------------------------------------------------------------------------------------------------#
def tabuleiro_str(tab):
    """
    Esta funcao faz uma representacao grafica do tabuleiro do jogo
    Tratando da composicao das linhas e a representacao dos 1,-1,0 em X,O," " (respetivamente)
    """
    tabuleiro_visivel = ""
    if eh_tabuleiro(tab) == False:                                          #Verificar argumentos
        raise ValueError("tabuleiro_str: o argumento e invalido")
    for num_linha in range(len(tab)):                                       #A contrucao e feita por linha
        representar_entrada = conversao(tab[num_linha])
        if num_linha < 2:
            tabuleiro_visivel += (representar_entrada[0] + "|" + representar_entrada[1] + "|" + representar_entrada[2] + "\n-----------\n")
        else:
            tabuleiro_visivel += (representar_entrada[0] + "|" + representar_entrada[1] + "|" + representar_entrada[2])
    return tabuleiro_visivel
#-----------------------------------------------------------------------------------------------------------_#
def conversao(linha):
    """
    Funcao suporte para a funcao tabuleiro_str
    Trata da conversao dos numeros em simbolos
    """
    representacao=()
    for espaco in linha:
        if espaco == 0:
            representacao += ("   ",)
        elif espaco == 1:
            representacao += (" X ",)
        elif espaco == -1:
            representacao += (" O ",)
    return representacao
#----------------------------------------------------------------------------------------------------------------#
#                              PARTE 2 -> INSPECAO E MANIPULACAO DO TABULEIRO                                    #
#----------------------------------------------------------------------------------------------------------------#
def eh_posicao_livre(tab,pos):
    """
    Funcao que devolve um valor booleano ( True//False )
    True -> Posicao livre // False ->Posicao ocupada
    """
    if eh_tabuleiro(tab) == False or eh_posicao(pos) == False:                    #Verificar condicoes
        raise ValueError("eh_posicao_livre: algum dos argumentos e invalido")

    if tab[descobre_linha(pos)-1][descobre_coluna(pos)-1] == 0:
        return True                                                           #E igual a 0, se for a posicao e livre
    else:
        return False
#--------------------------------------------------------------------------------------------------------#
def descobre_linha(pos):      #Funcao de suporte 1
    if pos/3 <= 1:              #Algoritmo que devolve o numero da linha
        linha = 1
    elif pos/3 <= 2:
        linha = 2
    else:
        linha = 3
    return linha              #Devolve o valor da linha

def descobre_coluna(pos):    #Funcaao de suporte 2
    if pos%3 == 1:             #Algoritmo analogo ao anterior mas com os restos
        coluna = 1
    elif pos%3 == 2:
        coluna = 2
    else:
        coluna = 3
    return coluna            #Devolve o valor da coluna
#---------------------------------------------------------------------------------------------------------#
def obter_posicoes_livres(tab):
    """
    Funcao que recebe um tabuleiro e avalia todas as posicoes livres nesse mesmo tabuleiro
    Devolve um tuplo com todas as posicoes livres (acumulador)
    """
    if eh_tabuleiro(tab) == False:                                                 #Verificar argumento
        raise ValueError("obter_posicoes_livres: o argumento e invalido")
    i = 1                                                                          #Iniciador do numero representativo das posicoes do tabuleiro
    pos_livres = ()                                                                 #Acumulador das posicoes ainda desponiveis
    while i <= 9:                                                                    #Varrer todas as posicoes do tabuleiro (1->9)
        if eh_posicao_livre(tab,i) == True:
            pos_livres += (i,)                                                       #Adicionar a posicao ao acumulador
        i += 1
    return pos_livres
#---------------------------------------------------------------------------------------------------------#
def jogador_ganhador(tab):
    """
    Funcao que avalia um tabuleiro devolvendo
    1 se o jogador com X e ganhador
    -1 se o jogador com O e ganhador
    0 se ainda ninguem ganhou ou e um EMPATE
    """
    if eh_tabuleiro(tab) == False:                                                 #Verificar argumentos
        raise ValueError("jogador_ganhador: o argumento e invalido")
    return verificar_vitorias(tab)
#----------------------------------------------------------------------------------------------------------#
def verificar_vitorias(tab):                              #Funcao suporte (analisar vitoria ou empate)
    i = 1
    while i <= 3:                                           #Dado que existem tantas linhas como colunas no tabuleiro vamos analisa-las em simultaneo
        linha_i = obter_linha(tab,i)
        if linha_i[0] == linha_i[1] == linha_i[2] == 1:         #Ver se todos os elementos da linha sao 1
            return 1                                      #Se forem...1 ganhou
        elif linha_i[0] == linha_i[1] == linha_i[2] == -1:      #Ver se todos os elementos da linha sao -1
            return -1                                     #Se forem...-1 ganhou
        coluna_i = obter_coluna(tab,i)
        if coluna_i[0] == coluna_i[1] == coluna_i[2] == 1:      #(o mesmo para as colunas)
            return 1
        elif coluna_i[0] == coluna_i[1] == coluna_i[2] == -1:
            return -1
        i += 1
    i = 1                                                        #Reiniciar o varredor
    while i <= 2:                                                #Apenas existem duas colunas no tabuleiro
        diagonal_i = obter_diagonal(tab,i)
        if diagonal_i[0] == diagonal_i[1] == diagonal_i[2] == 1:     #Se os valores da diagonal forem todos 1
            return 1                                           #...1 ganhou
        elif diagonal_i[0] == diagonal_i[1] == diagonal_i[2] == -1:  #Se forem -1
            return -1                                          #...-1 ganhou
        i += 1
    return 0                                                   #Empate

#----------------------------------------------------------------------------------------------------------------#
def marcar_posicao(tab,jogador,posicao):
    """
    Esta funcao permite a execucao das jogadas por parte do jogador e do computador
    """
    if eh_tabuleiro(tab)==False:
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")
    livres = obter_posicoes_livres(tab)
    if jogador not in (1,-1) or (posicao not in livres) or type(jogador)!=int:  #Verificar argumentos
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")
    novo_tabuleiro = ()                                                         #Construtor do novo tabuleiro
    i = 1
    for linha in tab:                                                           #Diferenciar em linhas (1,2,3)
        nova_linha = ()                                                          #Contrutor da nova linha
        for pos in linha:                                                       #Para cada linha do tabuleiro inicial
            if i==posicao:                                                      #Se a posicao i (1 a 9) for igual a posicao procurada
                nova_linha += (jogador,)                                          #Atualizar a nova entrada do tabuleiro
            else:
                nova_linha += (pos,)
            i += 1
        novo_tabuleiro += (nova_linha,)                                           #Contrucao do tabuleiro por cada linha
    return novo_tabuleiro                                                       #Devolver o novo tabuleiro
#--------------------------------------------------------------------------------------------------------------------#
#                                           Parte 3: Escolher funcoes do jogo                                        #
#--------------------------------------------------------------------------------------------------------------------#
def escolher_posicao_manual(tab):
    """
    Esta funcao permite o jogador escolher a sua jogada
    (desde que seja valida como e obvio)
    """
    if eh_tabuleiro(tab) == False:                                            #Verificar argumentos
        raise ValueError("escolher_posicao_manual: o argumento e invalido")
    pos = int(input("Turno do jogador. Escolha uma posicao livre: "))                                        #Jogador escolhe a posicao
    if pos not in obter_posicoes_livres(tab):                                                                #Posicao escolhida e valida
        raise ValueError("escolher_posicao_manual: a posicao introduzida e invalida")
    return pos

#-----------------------------------------------------------------------------------------------------------------------#
def escolher_posicao_auto(tab,bot,nivel):
    """
    Esta funcao recebe o tabuleiro, as informacoes do computador (se joga com 1 ou -1) e o nivel escolhido
    Cada nivel executa ordem de jogadas diferentes
    A ordem das jogadas esta mais a frente no codigo
    """
    niveis_disponiveis = ('basico','normal','perfeito')
    if nivel not in niveis_disponiveis or eh_tabuleiro(tab) == False or bot not in (1,-1):  #Verificar argumentos
        raise ValueError("escolher_posicao_auto: algum dos argumentos e invalido")
    if nivel == 'basico':                                                                 #NIVEL BASICO
        return nivel_basico(tab,bot)
    if nivel == 'normal':                                                                 #NIVEL NORMAL
        return nivel_normal(tab,bot)
    if nivel == 'perfeito':                                                               #NIVEL PERFEITO
        return nivel_perfeito(tab,bot)
#------------------------------------NIVEIS//DIFICULDADE-----------------------------------------------------------#

def nivel_basico(tab,bot):                                             #NIVEL BASICO;
    livres = obter_posicoes_livres(tab)
    if 5 in livres:                                                    #ORDEM: 5,7,8
        return jogada_cinco(tab,bot)                                   #JOGADA 5 (caso o centro esteja disponivel)
    elif 1 in livres or 3 in livres or 7 in livres or 9 in livres:
        return jogada_sete(tab,bot)                                    #JOGADA 7 (caso uma das diagonais esteja disponivel)
    else:
        return jogada_oito(tab,bot)                                    #JOGADA 8 (em ultima opcao)
#-------------------------------------------------------------------------------------------------------------------#
def nivel_normal(tab,bot):                                                  #NIVEL NORMAL;
    livres = obter_posicoes_livres(tab)
    if jogada_um(tab,bot) in livres:                                        #ORDEM: 1,2,5,6,7,8
        return jogada_um(tab,bot)                                           #JOGADA 1 (se possivel ganhar)
    elif jogada_dois(tab,-bot) in livres:
        return jogada_dois(tab,-bot)                                        #JOGADA 2 (impedir o adversario 1 de ganhar)(caso possa)
    elif 5 in livres:
        return jogada_cinco(tab,bot)                                        #JOGADA 5 (caso o centro esteja disponivel)
    elif jogada_seis(tab,bot) in livres:
        return jogada_seis(tab,bot)                                         #JOGADA 6(canto oposto)
    elif 1 in livres  or 3 in livres or 7 in livres or 9 in livres:
        return jogada_sete(tab,bot)                                         #JOGADA 7 (caso uma das diagonais esteja disponivel)
    else:
        return jogada_oito(tab,bot)                                         #JOGADA 8 (resto)
#--------------------------------------------------------------------------------------------------------------------#
def nivel_perfeito(tab,bot):
    """
    Este nivel segue a ordem perfeita do algoritmo
    Deste modo caso esta dificuldade seja selecionada o jogador nunca podera ganhar o jogo
    """
    livres = obter_posicoes_livres(tab)
    if jogada_um(tab,bot) in livres:
        return jogada_um(tab,bot)
    elif jogada_dois(tab,-bot) in livres:
        return jogada_dois(tab,-bot)
    elif jogada_tres(tab,bot) in livres:
        return jogada_tres(tab,bot)
    elif jogada_quatro(tab,-bot) in livres:
        return jogada_quatro(tab,-bot)
    elif 5 in livres:
        return jogada_cinco(tab,bot)
    elif jogada_seis(tab,bot) in livres:
        return jogada_seis(tab,bot)
    elif 1 in livres  or 3 in livres or 7 in livres or 9 in livres:
        return jogada_sete(tab,bot)
    else:
        return jogada_oito(tab,bot)
#------------------------------------------------------------------------------------------#
#                             Ordem do algoritmo                                           #
#------------------------------------------------------------------------------------------#
def jogada_um(tab,bot):              #VITORIA
    jogada = ganhar_linhas(tab,bot)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    jogada = ganhar_colunas(tab,bot)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    jogada = ganhar_diagonal(tab,bot)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    return None
#------------------------------------------------------------------------------------------#
def jogada_dois(tab,jogador):              #BLOQUEIO
    jogada = ganhar_linhas(tab,jogador)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    jogada = ganhar_colunas(tab,jogador)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    jogada = ganhar_diagonal(tab,jogador)
    if type(jogada) == int:
        if eh_posicao(jogada):
            return jogada
    return None
#------------------------------------------------------------------------------------------#
def ganhar_linhas(tab,bot):             #Funcao suporte para as jogadas 1 e 2
    i = 1
    while i <= 3:
        linha = obter_linha(tab,i)
        soma = 0
        for entrada in linha:
            if entrada == bot:
                soma += 1
        if soma == 2:
            for entrada_indice in range(len(linha)):
                if linha[entrada_indice] != bot:
                    if entrada_indice == 0 and eh_posicao_livre(tab,1 + (3*i-3)):
                        return 1 + (3*i-3)
                    elif entrada_indice == 1 and eh_posicao_livre(tab,2*i+(i-1)):
                        return 2*i+(i-1)
                    elif entrada_indice == 2 and eh_posicao_livre(tab,3*i):
                        return 3*i

        i += 1
    return None
#------------------------------------------------------------------------------------------#
def ganhar_colunas(tab,bot):         #Funcao suporte para as jogadas 1 e 2
    i = 1
    while i <= 3:
        coluna = obter_coluna(tab,i)
        soma = 0
        for entrada in coluna:
            if entrada == bot:
                soma += 1
        if soma == 2:
            for entrada_indice in range(len(coluna)):
                if coluna[entrada_indice] != bot:
                    if entrada_indice == 0 and eh_posicao_livre(tab,i):
                        return i
                    elif entrada_indice == 1 and eh_posicao_livre(tab,4+(i-1)):
                        return 4+(i-1)
                    elif entrada_indice == 2 and eh_posicao_livre(tab,7+(i-1)):
                        return 7+(i-1)

        i += 1
    return None
#----------------------------------------------------------------------------------------#
def ganhar_diagonal(tab,bot):   #Funcao suporte para as jogadas 1 e 2
    i = 1
    while i <= 2:
        diagonal = obter_diagonal(tab,i)
        soma = 0
        for entrada in diagonal:
            if entrada == bot:
                soma += 1
        if soma == 2:
            for entrada_indice in range(len(diagonal)):
                if diagonal[entrada_indice] != bot:
                    if entrada_indice == 0 and eh_posicao_livre(tab,1+(6*(i-1))):
                        return 1+(6*(i-1))
                    elif entrada_indice == 1 and eh_posicao_livre(tab,5):
                        return 5
                    elif entrada_indice == 2 and eh_posicao_livre(tab,9//(1+(2*i-2))):
                        return 9//(1+(2*i-2))
        i+=1
    return None
#----------------------------------#
def jogada_tres(tab,bot):
    """
    De maneira a criar esta funcao podemos pensar que a bifurcacao e uma jogada que se for executada
    ira criar duas possibilidades de vitoria na jogaga seguinte entao podemos simular todas as jogagas disponiveis
    e verificar se essa bifurcacao ocorre (caso ocorra deveremos executa-la)
    """
    livres = obter_posicoes_livres(tab)
    i = 1
    while i <=9:
        if i in livres:
            novo_tab = marcar_posicao(tab, bot, i)
            Novas_livres = (obter_posicoes_livres(novo_tab))
            if jogada_um(novo_tab,bot) in Novas_livres:
                novo_tab=marcar_posicao(novo_tab,-bot,jogada_um(novo_tab,bot))
                Novas_livres = (obter_posicoes_livres(novo_tab))
                if jogada_um(novo_tab,bot) in Novas_livres:
                    return i
                else:
                    i += 1
            else:
                i += 1
        else:
            i += 1

    return None
#----------------------------------------------------------#
def jogada_quatro(tab,bot):
    """
    Quando a jogada quatro e 'chamada', o valor do bot passa ao simetrico de maneira a que possamos
    simular a jogada 3 como se fossemos o adversario, caso existam varias possibilidades de jogada 3
    para o adversario entao deveremos forcar o adversario a jogar noutra pocisao (por isso e que organizamos
    todas as possibilidades de jogada 3 do adversario numa lista de jogadas)
    """
    livres = obter_posicoes_livres(tab)
    jogadas_possiveis=[]
    i = 1
    while i <=9:
        if i in livres:
            novo_tab = marcar_posicao(tab, bot, i)
            Novas_livres = (obter_posicoes_livres(novo_tab))
            if jogada_um(novo_tab,bot) in Novas_livres:
                novo_tab=marcar_posicao(novo_tab,-bot,jogada_um(novo_tab,bot))
                Novas_livres = (obter_posicoes_livres(novo_tab))
                if jogada_um(novo_tab,bot) in Novas_livres:
                    jogadas_possiveis += [i]
                    i += 1
                else:
                    i += 1
            else:
                i += 1
        else:
            i += 1
    if len(jogadas_possiveis) == 1:
        return jogada_tres(tab,bot)
    elif len(jogadas_possiveis) >= 2:
        return corte_duplo(tab,jogadas_possiveis,bot)

def corte_duplo(tab,adversario_bifurcacao,bot):
    """
    Esta funcao ocorre caso o jogador tenha mais que uma possibilidade para executar a bifurcacao
    para impedir a sua vitoria o COMPUTADOR tera que ameacar a sua vitoria criando uma possibilidade de ganhar
    """
    livres = obter_posicoes_livres(tab)
    livres = list(livres)
    indice = 0
    while indice < len(livres):
        if livres[indice] in adversario_bifurcacao:
            del(livres[indice])
        indice += 1
    for e in livres:
        tab = marcar_posicao(tab,bot,e)
        if type(jogada_um(tab,bot)) == int:
            return e
    return None
#---------------------------------#
def jogada_cinco(tab,bot):           #Jogada 5 na lista do algoritmo
    return 5                         #Jogar no centro caso esteja disponivel
#---------------------------------#
def jogada_seis(tab,bot):            #Jogada 6 -> canto oposto
    d_i = 1
    while d_i<=2:
        diagonal = obter_diagonal(tab,d_i)
        for i in range(len(diagonal)):
            if diagonal[i] == -bot and d_i == 1:
                if i == 0 and eh_posicao_livre(tab,9):
                    return 9
                if i == 2 and eh_posicao_livre(tab,1):
                    return 1
            elif diagonal[i] == -bot and d_i == 2:
                if i == 0 and eh_posicao_livre(tab,3):
                    return 3
                if i == 2 and eh_posicao_livre(tab,7):
                    return 7
        d_i += 1
    return None
#---------------------------------#
def jogada_sete(tab,bot):                 #Jogada 7 na lista do algoritmo
    i = 1                                 #Jogar nos cantos caso seja possivel
    while i <= 9:                           #Varrer a possibilidade de jogar em qualquer um dos cantos
        if i == 5:                          #cantos -> posicoes 1,3,7,9
            i += 2                          #A primeira destas posicoes disponiveis sera a escolhida
        else:
            if eh_posicao_livre(tab,i):
                return i                  #Devolver a posicao pretendida
            i += 2                          #Incrementar no caso da posicao estar indesponivel
#-----------------------------------#
def jogada_oito(tab,bot):                 #Jogada 8 na lista do algoritmo
    i = 2                                 #Jogar numa lateral nao ocupada
    while i <= 8:                           #Varrer a possibilidade de jogar em qualquer uma das laterais
        if eh_posicao_livre(tab,i):       #laterais-> posicoes 2,4,6,8
            return i                      #Devolver a posicao pretendida
        i += 2                              #Incrementar no caso da posicao estar indesponivel
#--------------------------------------------------------------------------------------------------#
#                             Parte Final:Concretizacao do jogo                                    #
#--------------------------------------------------------------------------------------------------#
def jogo_do_galo(jogador,nivel):
    """
    Concretizacao do jogo do galo
    Jogador -> se joga com X comeca a jogar// O cede a prioridade ao COMPUTADOR
    nivel -> BASICO // NORMAL // PERFEITO  (cada nivel seguira as jogadas de cada dificuldade)
    """
    print("Bem-vindo ao JOGO DO GALO.\nO jogador joga com '"+jogador+"'.")
    tab =((0,0,0),(0,0,0),(0,0,0))
    if jogador == "X":                                                      #Jogador com X
        while 0 in tab[0] or tab[1] or tab[2]:
            pos = escolher_posicao_manual(tab)
            tab = marcar_posicao(tab,1,pos)
            print(tabuleiro_str(tab))
            if verificar_vitorias(tab) == 1:
                return 'X'
            if 0 not in tab[0] and 0 not in tab[1] and 0 not in tab[2]:
                break
            print("Turno do computador ("+nivel+"):")
            pos = escolher_posicao_auto(tab,-1,nivel)
            tab = marcar_posicao(tab,-1,pos)
            print(tabuleiro_str(tab))
            if verificar_vitorias(tab) == -1:
                return 'O'
        return 'EMPATE'

    if jogador == "O":                                                     #Jogador com O
        while 0 in tab[0] or tab[1] or tab[2]:
            print("Turno do computador (" + nivel + "):")
            pos = escolher_posicao_auto(tab, 1, nivel)
            tab = marcar_posicao(tab, 1, pos)
            print(tabuleiro_str(tab))
            if verificar_vitorias(tab) == 1:
                return 'X'
            if 0 not in tab[0] and 0 not in tab[1] and 0 not in tab[2]:
                break
            pos = escolher_posicao_manual(tab)
            tab = marcar_posicao(tab, -1, pos)
            print(tabuleiro_str(tab))
            if verificar_vitorias(tab) == -1:
                return 'O'

        return 'EMPATE'


# GAME

jogo_do_galo('X','perfeito')