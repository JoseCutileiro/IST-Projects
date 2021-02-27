"""
Aluno: Jose Miguel Cutileiro
Numero: ist199097
Versao final - Jogo Moinho // Projeto 2
"""

""" ***************************************************************
         Assinatura - TAD - POSICAO

Representacao interna: [coluna,linha]

cria_posicao (string,string) -> posicao
cria_copia_pos: posicao -> copia da posicao

obter_pos_c: posicao -> str correspondete a coluna
obter_pos_l: posicao -> str correspondete a linha

eh_posicao: Argumento qualquer -> Booleano

posicoes_iguais: posicao x posicao -> Booleano

posicao_para_str : posicao -> str
*************************************************************** """


def cria_posicao(c, l):
    """
    Esta funcao cria uma posicao do tabuleiro do jogo
    que se encontra exatamenta na coluna c e na linha l
    A representacao escolhida para a posicao
    foi [c,l]
    :param c: coluna (em string)
    :param l: linha (em string)
    :exception: Caso a linha ou coluna inseridas correspondam
    a nenhuma das posicoes possiveis, devolve um erro
    :return: [c,l]
    """
    if type(c) != str or type(l) != str:
        raise ValueError('cria_posicao: argumentos invalidos')
    if c not in 'abc' or l not in '123' or len(c) != 1 or len(l) != 1:
        raise ValueError('cria_posicao: argumentos invalidos')
    return [c, l]


def cria_copia_posicao(pos):
    """
    Descricao: Copia independente
    :param pos: Posicao original
    :return: Copia da posicao (com possibilidade de se
            alterar sem afetar a posicao original)
    """
    copia = pos[:]
    return copia


def obter_pos_c(pos):
    """
    :param pos: Atraves de uma dada posicao
    :return: esta funcao devolve a coluna correspondente
    """
    return pos[0]


def obter_pos_l(pos):
    """
    :param pos: Atraves de uma dada posicao
    :return: esta funcao devolve a linha correspondente
    """
    return pos[1]


def eh_posicao(arg):
    """
    Esta funcao avalia um argumento qualquer
          }--> True: o argumento e posicao
          }--> False: o argumento nao corresponde a uma posicao
    :param arg: Argumento universal
    :return: bool (true or false)
    """
    if type(arg) != list:
        return False
    if len(arg) != 2:
        return False
    if type(obter_pos_c(arg)) != str or type(obter_pos_l(arg)) != str:
        return False
    if len(obter_pos_c(arg)) != 1 or len(obter_pos_l(arg)) != 1:
        return False
    if obter_pos_c(arg) not in 'abc' or obter_pos_l(arg) not in '123':
        return False
    return True


def posicoes_iguais(p1, p2):
    """
    Esta funcao compara duas posicoes
                }-->True: Posicoes iguais
                }-->False: Posicoes diferentes
    :param p1: posicao 1
    :param p2: posicao 2
    :return: bool (true or false)
    """
    if not eh_posicao(p1) or not eh_posicao(p2):
        return False

    return obter_pos_c(p1) == obter_pos_c(p2) and obter_pos_l(p1) == obter_pos_l(p2)


def posicao_para_str(pos):
    """
    Esta funcao trata de representar uma posicao qualquer
    de modo a que seja mais agradavel aos olhos
    :param pos: posicao
    :return: representacao da posicao
    """
    return obter_pos_c(pos) + obter_pos_l(pos)


""" ******************************************************************
      Auxiliares - Coordenadas
****************************************************************** """


def pos_para_cords(pos):
    """
    Para muitas funcoes de ordem superior, e preferivel trabalhar com as
    coordenadas de cada posicao. Esta funcao existe para tranformar cada
    posicao num par de coordenadas
    :param pos: posicao original [c,l]
    :return: coordenadas [num_c, num_l]
    """
    c = obter_pos_c(pos)
    l = obter_pos_l(pos)
    colunas = 'abc'
    x = 0
    i = 1
    for letra in colunas:
        if letra == c:
            x = i
            break
        i += 1
    y = int(l)
    return [x, y]


def cords_para_pos(cords):
    """
    Esta funcao e o operador inverso do anterior,
    ou seja recebe um par de coordenadas e tranforma-os
    em posicoes
    :param cords: [num_c, num_l]
    :return: [c,l]
    """
    x = cords[0]
    y = cords[1]
    colunas = 'abc'
    c, l = colunas[x - 1], str(y)
    return cria_posicao(c, l)


""" ******************************************************************
      Alto nivel - TAD Posicao
****************************************************************** """


def obter_posicoes_adjacentes(pos):
    """
    :param pos: Posicao em estudo
    :return: Devolve todas as posicoes para a qual a posicao original
             se pode deslocar
    """
    # Todas -> referente a posicao central
    todas = ()
    colunas = 'abc'
    linhas = '123'
    if posicoes_iguais(pos, cria_posicao('b', '2')):
        for numero in linhas:
            for letra in colunas:
                if posicoes_iguais(cria_posicao(letra, numero), cria_posicao('b', '2')):
                    pass
                else:
                    todas += (cria_posicao(letra, numero),)
        return todas

    cords = pos_para_cords(pos)
    x = cords[0]
    y = cords[1]
    # As posicoes adjacentes de uma dada posicao
    cima, esq, dir, baixo = [x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]
    # As diagonais referentes a uma dada posicao
    # (pela ordem de leitura do tabuleiro)
    d1, d2, d3, d4 = [x - 1, y - 1], [x + 1, y - 1], [x - 1, y + 1], [x + 1, y + 1]
    # Grupo ordenado pela ordem de leitura do tabuleiro
    grupo = [d1, cima, d2, esq, dir, d3, baixo, d4]
    adjacentes = ()
    # diagonais -> indices referentes a todas as diagonais no grupo
    diagonais = '0257'
    novo_grupo = []
    for i in range(len(grupo)):
        if str(i) in diagonais and grupo[i] != pos_para_cords(cria_posicao('b', '2')):
            pass
        else:
            novo_grupo += [grupo[i]]
    grupo = novo_grupo
    for e in grupo:
        if 1 <= e[0] <= 3 and 1 <= e[1] <= 3:
            adjacentes += (cords_para_pos(e),)

    return adjacentes


""" ***************************************************************
         Assinatura - TAD - PECA

Represetancao escolhida: ['jogador']

cria_peca: string -> peca
cria_copia_peca: peca -> peca

eh_peca: universal -> booleano
pecas iguais: peca x peca -> booleano

peca_para_str : peca -> string
*************************************************************** """


def cria_peca(s):
    """
    :exception: Se s nao corresponder a uma peca
    :Nota: Pecas validas -> 'X' // 'O' // ' '
    :param s: string correspondente a peca
    :return: peca // Escolha da representacao -> ['s']
    """
    if type(s) != str:
        raise ValueError('cria_peca: argumento invalido')
    if s != 'X' and s != 'O' and s != ' ':
        raise ValueError('cria_peca: argumento invalido')
    return [s]


def cria_copia_peca(p):
    """
    Criar uma copia independente de uma dada peca
    :param p: peca
    :return: copia da peca
    """
    copia = p[:]
    return copia


def eh_peca(arg):
    """
    Avalia um argumento:
           True -> o argumento corresponde a uma peca
           False -> o arguemento nao corresponde a uma peca
    :param arg: Argumento universal (qualquer um)
    :return: Bool (True // False)
    """

    return type(arg) == list and len(arg) == 1 and type(arg[0]) == str \
           and arg in (['X'], ['O'], [' '])


def pecas_iguais(p1, p2):
    """
    Compara diretamente a p1 e a p2
             True -> as pecas sao iguais
             False -> as pecas sao diferentes
    :param p1: Peca 1
    :param p2: Peca 2
    :return: Bool (True // False)
    """
    if eh_peca(p1) and eh_peca(p2):
        if p1[0] == p2[0]:
            return True
    return False


def peca_para_str(pec):
    """
    Tranformacao de uma peca para
    a sua representacao exterior
    :param pec: peca
    :return: [peca]
    """
    return '[' + pec[0] + ']'


""" ***************************************************************
                   Alto nivel - TAD PECA 
*************************************************************** """


def peca_para_inteiro(pec):
    """
    :Nota: O tradutor e o dicionario que faz
    corresponder a cada representacao exterior de uma peca
    um predefinido numero inteiro // X -> 1 //
                                // O -> -1 //
                                //   -> 0 //
    :param pec: peca
    :return: inteiro correspondente a peca
    """
    tradutor = {'[X]': 1, '[O]': -1, '[ ]': 0}
    return tradutor[peca_para_str(pec)]


def inteiro_para_peca(i):
    """
    Funcao com funcionalidade inversa a anterior
    :param i: inteiro
    :return: peca correspondente ao inteiro
    """
    tradutor = {1: cria_peca('X'), -1: cria_peca('O'), 0: cria_peca(' ')}
    return tradutor[i]


""" ***************************************************************
                   Assinatura - TAD - TABULEIRO 

cria_tabuleiro: {} -> tabuleiro
cria_copia_tabuleiro: tabuleiro 7 -> tabuleiro

obter_peca: tabuleiro x posicao 7 -> peca
obter_vetor : tabuleiro x str 7 -> tuplo de pecas

coloca_peca: tabuleiro x peca x posicao 7 -> tabuleiro
remove_peca: tabuleiro x posicao -> tabuleiro
move_peca: tabuleiro x posicao x posicao -> tabuleiro

eh_tabuleiro: universal -> booleano
eh_posica_livre: tabuleiro x posicao -> booleano

tabuleiros_iguais: tabuleiro x tabuleiro -> booleano

tabuleiro_para_str : tabuleiro -> str
tuplo_para_tabuleiro: tuplo -> tabuleiro

*************************************************************** """


def cria_tabuleiro():
    """
    :return: Criar um tabuleiro vazio
     (todas as posicoes sao livres)
    """
    livre = cria_peca(' ')
    return [[livre, livre, livre], [livre, livre, livre], [livre, livre, livre]]


def cria_copia_tabuleiro(tab):
    """
    Cria uma copia integral e indepentente
    de um tabuleiro
    (isso implica fazer uma copia independente
     de todas as entradas do tabuleiro inicial)

    :param tab: tabuleiro
    :return: copia do tabuleiro
    """
    copia = []
    for e in tab:
        e_copy = e[:]
        copia += [e_copy]
    return copia


def obter_peca(tab, pos):
    """
    :param tab: Tabuleiro
    :param pos: Posicao
    :return: peca que se encontra na posicao *pos do tabuleiro *tab
    """
    cord = pos_para_cords(pos)
    x = cord[0]
    y = cord[1]
    return cria_copia_peca(tab[y - 1][x - 1])


def obter_vetor(tab, s):
    """
    Devolve todas as pecas de uma linha ou coluna
    escolhida pelos parametros
    :param tab: Tabuleiro
    :param s: String selecionadora do vetor
    :return: Vetor selecionado pela string
    """
    # Colunas possiveis (letras)
    letras = 'abc'
    i = 1
    # Se o escolhido for uma coluna =>
    # Fazer a conversao
    if s in letras:
        for letra in letras:
            if s == letra:
                break
            i += 1
        pecas = ()
        for linha in tab:
            pecas += (linha[i - 1],)
        return pecas
    # Se o escolhido for uma linha =>
    # (linha e em numero logo a conversao e direta)
    else:
        return tuple(tab[int(s) - 1])


def coloca_peca(tab, pec, pos):
    """
    :param tab: Tabuleiro
    :param pec: Peca referente ao jogador atual
    :param pos: Posicao em que queremos colocar a peca
    :return: Tabuleiro atualizado com a nova jogada
    """
    cord = pos_para_cords(pos)
    x = cord[0]
    y = cord[1]
    tab[y - 1][x - 1] = pec
    return tab


def remove_peca(tab, pos):
    """
    De modo a remover uma peca basta colocar uma
    peca vazia no local escolhido
    :param tab: Tabuleiro
    :param pos: Posicao que queremos remover
    :return: Novo tabuleiro com a peca removida
    """
    return coloca_peca(tab, cria_peca(' '), pos)


def move_peca(tab, inicial, final):
    """
    Funcao que possibilita o descolamento de uma peca
    de uma posicao inicial para uma posicao final
    :param tab: Tabuleiro
    :param inicial: Posicao atual
    :param final: Posicao pretendida
    :Nota: Reparando com olhos de quem quer ver
    e possivel entender que para mover uma peca basta
    remover a peca da posicao inicial e colocala na final
    :return: Novo tabuleiro com o movimento escolhido
    """
    peca = obter_peca(tab, inicial)
    remove_peca(tab, inicial)
    coloca_peca(tab, peca, final)
    return tab


def eh_tabuleiro(arg):
    """
    :param arg: Argumento Universal (qualquer)
    :return: Avaliacao do argumento
        True -> e tabuleiro // False -> nao e tabuleiro
    """
    if type(arg) != list:
        return False
    if len(arg) != 3:
        return False
    for e in arg:
        if type(e) != list:
            return False
        if len(e) != 3:
            return False
    contador_X = 0
    contador_O = 0
    for linha in arg:
        for peca in linha:
            if pecas_iguais(peca, cria_peca('X')):
                contador_X += 1
            elif pecas_iguais(peca, cria_peca('O')):
                contador_O += 1
    if contador_X > 3 or contador_O > 3 or abs(contador_X - contador_O) > 1:
        return False
    vetores = 'abc123'
    pontos_vitoria = 0
    for vetor in vetores:
        v = obter_vetor(arg, vetor)
        pontos = 0
        for e in v:
            if pecas_iguais(e, cria_peca('X')):
                pontos += 1
            elif pecas_iguais(e, cria_peca('O')):
                pontos -= 1
            else:
                pontos += 0
        if pontos == 3 or pontos == -3:
            pontos_vitoria += 1
    if pontos_vitoria > 1:
        return False
    return True


def eh_posicao_livre(tab, pos):
    """
    Sera a posicao escohida livre ou nao
    :param tab: Tabuleiro
    :param pos: Posicao
    :return: True -> se for livre // False -> se estiver ocupada
    """
    peca = obter_peca(tab, pos)
    if pecas_iguais(peca, cria_peca(' ')):
        return True
    return False


def tabuleiros_iguais(tab1, tab2):
    """
    :param tab1: Tabuleiro 1
    :param tab2: Tabuleiro 2
    Compara dois argumentos
        :Se forem iguais -> True
        :Se forem diferentes -> False
    :return: True // False
    """
    if not eh_tabuleiro(tab1) or not eh_tabuleiro(tab2):
        return False
    for c in 'abc':  # Verificar para todos os vetores
        for l in '123':
            if not pecas_iguais(obter_peca(tab1, cria_posicao(c, l)), obter_peca(tab2, cria_posicao(c, l))):
                return False
    return True


def tabuleiro_para_str(tab):
    """
    Desenvolvimento semi grafico de um tabuleiro
    :param tab: Tabuleiro
    :return: Faz a construcao do tabuleiro em string
     (De modo a que o jogador perceba mais facilmente o jogo)
    """
    return '   a   b   c\n' + tab_para_str_aux(tab, 1) + '\n' \
                                                         '   | \\ | / |\n' + tab_para_str_aux(tab, 2) + '\n' \
                                                                                                        '   | / | \\ |\n' + tab_para_str_aux(
        tab, 3)


def tab_para_str_aux(tab, i):
    """
    Conversao por linhas (mais facil para desenvolver no final)
    :param tab: Tabuleiro
    :param i: Inteiro
    :return: Linha correspodnente em string
    """
    linha_i = obter_vetor(tab, str(i))
    a, b, c = peca_para_str(linha_i[0]), peca_para_str(linha_i[1]), peca_para_str(linha_i[2])
    return str(i) + ' ' + a + '-' + b + '-' + c


def tuplo_para_tabuleiro(t):
    """
    :param t: Recebe um tuplo com -1/0/1
    :Nota: // -1 -> O // 0 ->   // 1 -> X //
    :return: Cria um tabuleiro correspondente ao tuplo
    """
    tab = cria_tabuleiro()
    for i1 in range(len(t)):  # Descricao: i1 - indice da coluna do tuplo
        for i2 in range(len(t[i1])):  # Descricao: i2 - indice da linha do tuplo
            tab[i1][i2] = inteiro_para_peca(t[i1][i2])
    return tab


""" ***************************************************************
                   Alto nivel - TAD TABULEITRO 
*************************************************************** """


def obter_ganhador(tab):
    """

    :param tab: Tabuleiro
    :return: Devolve a peca que corresponde a peca ganhadora no tabuleiro
    X se o ganhador for X // O se o ganhador for O // ' ' se o ganhador nao for ninguem
    """
    # Avaliacao integral de TODOS os vetores no tabuleiro
    # (quando houver um vencedor devolver o vencedor)
    entradas = 'abc123'
    for entrada in entradas:
        v = obter_vetor(tab, entrada)
        pontos = 0
        for e in v:
            if pecas_iguais(cria_peca('X'), e):
                pontos += 1
            elif pecas_iguais(cria_peca('O'), e):
                pontos -= 1
            else:
                pontos += 0
        if pontos == 3:
            return cria_peca('X')
        elif pontos == -3:
            return cria_peca('O')
    # Se em Todos os vetores nao houver um unico vencedor
    # Entao devolver um EMPATE
    return cria_peca(' ')


def obter_posicoes_livres(tab):
    """
    As posicoes livres correspondem as posicoes com a peca ' '
    :param tab: Tabuleiro
    :return: Todas a posicoes livres (em tuplo)
    """
    return obter_posicoes_jogador(tab, cria_peca(' '))


def obter_posicoes_jogador(tab, pec):
    """

    :param tab: Tabuleiro
    :param pec: Peca em estudo
    :return: Todas as posicoes com a peca em estudo
    :NOTA IMPORTANTE: As posicoes devolvidas
                      NAO sao necessariamente livres
    """
    colunas = 'abc'
    linhas = '123'
    # Nota: O jogador pode ser ' '
    ocupadas_jogador = ()
    # Fazer a varredura de todas as posicoes
    for numero in linhas:
        for letra in colunas:
            peca = obter_peca(tab, cria_posicao(letra, numero))
            if pecas_iguais(peca, pec):
                ocupadas_jogador += (cria_posicao(letra, numero),)
    return ocupadas_jogador


""" ***************************************************************
                   FUNCOES ADICIONAIS 
*************************************************************** """


def obter_movimento_manual(tab, pec):
    """
    :exception: Caso o movimento escolhido ou posicao escolhida nao sejam
    validos consoante o tabuleiro em causa para a peca em causa
    :param tab: Tabuleiro
    :param pec: Peca
    :return: Colocacao ou movimentacao de uma peca escolhida manualmente
    """
    pos_player = obter_posicoes_jogador(tab, pec)
    if len(pos_player) < 3:  # Se o jogador tiver 3 posicoes
        pre_pos = input('Turno do jogador. Escolha uma posicao: ')  # Significa que estamos na fase de colocacao
        if len(pre_pos) != 2:
            raise ValueError('obter_movimento_manual: escolha invalida')  # Fazer as validacoes da posicao escolhida
        disponiveis = 'a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3'
        if pre_pos not in disponiveis:
            raise ValueError('obter_movimento_manual: escolha invalida')
        if len(pre_pos) != 2:
            raise ValueError('obter_movimento_manual: escolha invalida')
        if pre_pos[0] not in 'abc' or pre_pos[1] not in '123':
            raise ValueError('obter_movimento_manual: escolha invalida')
        pos = cria_posicao(pre_pos[0], pre_pos[1])
        if eh_posicao_livre(tab, pos):  # Cso seja uma posicao valida
            return pos,  # Escolher a posicao
        else:
            raise ValueError('obter_movimento_manual: escolha invalida')
    else:  # FASE DE MOVIMENTACAO:
        sem_jogadas = 0  # Se sem jogadas = 0 -> nao existe nenhuma
        for pos in pos_player:  # jogada disponivel e o jogador e forcado
            adj = obter_posicoes_adjacentes(pos)  # a escolher um movimento de passar a  jogada
            for e in adj:  # (caso contrario passar a jogada nao e permitido)
                if eh_posicao_livre(tab, e):
                    sem_jogadas = 1
        pre_mov = input('Turno do jogador. Escolha um movimento: ')
        if len(pre_mov) != 4:  # Verificacoes de escolha de movimento
            raise ValueError('obter_movimento_manual: escolha invalida')
        if pre_mov[0] not in 'abc' or pre_mov[1] not in '123' or pre_mov[2] not in 'abc' or pre_mov[3] not in '123':
            raise ValueError('obter_movimento_manual: escolha invalida')
        partida = cria_posicao(pre_mov[0], pre_mov[1])
        chegada = cria_posicao(pre_mov[2], pre_mov[3])
        if posicoes_iguais(partida, chegada) and sem_jogadas != 0:
            raise ValueError('obter_movimento_manual: escolha invalida')
        if not pecas_iguais(obter_peca(tab, partida), pec):
            raise ValueError('obter_movimento_manual: escolha invalida')
        if eh_pos_adj(partida, chegada) and eh_posicao_livre(tab, chegada):
            return partida, chegada
        jogadas_jogador = obter_posicoes_jogador(tab, pec)
        i = 0
        for jogada in jogadas_jogador:
            if not all(eh_posicao_livre(tab, pos) for pos in obter_posicoes_adjacentes(jogada)):
                i += 1
        if i == 3:
            if posicoes_iguais(partida, chegada):
                return partida, chegada  # Execucao do movimento
            else:
                raise ValueError('obter_movimento_manual: escolha invalida')
        raise ValueError('obter_movimento_manual: escolha invalida')


def eh_pos_adj(p1, p2):  # Verificar se e posicao adjunta, respeitando as barreiras de Abstracao
    return eh_posicao(p1) and eh_posicao(p2) and \
           any(posicoes_iguais(p2, pa) for pa in obter_posicoes_adjacentes(p1))


def obter_movimento_auto(tab, pec, dificuldade):
    """
    :param tab: Tabuleiro
    :param pec: Peca em causa
    :param dificuldade: Dificuldade(string)
    :return: Movimento adequado para cada dificuldade
    """
    pos_bot = obter_posicoes_jogador(tab, pec)
    sem_hipoteses = 0
    if len(pos_bot) == 3:  # Se existirem 3 pecas
        for pos in pos_bot:  # E nao houver jogadas disponiveis
            for e in obter_posicoes_adjacentes(pos):  # Devemos devolver o movimento:
                if eh_posicao_livre(tab, e):  # Da primeira posicao para a primeira posicao
                    sem_hipoteses = 1
        if sem_hipoteses == 0:
            return pos_bot[0], pos_bot[0]
    if len(pos_bot) != 3:  # Se ainda nao existirem 3 pecas
        return fase_de_colocar(tab, pec)  # Ainda estamos na fase da colocacao
    else:
        if dificuldade == 'facil':  # Se ja existirem 3 pecas
            return mov_facil(tab, pec)  # Devemos escolher a dificuldade pretendida
        elif dificuldade == 'normal':
            return mov_normal(tab, pec)
        else:
            return mov_dificil(tab, pec)


""" ***************************************************************
                   FASE DE COLOCAR 
*************************************************************** """


def fase_de_colocar(tab, pec):
    """
    Nota: As jogadas sao avaliadas em posicao ou None
         posicao -> A posicao esta livre e respeita o algoritmo 1.3.1
         None -> A posicao nao esta livre ou nao respeita o algoritmo 1.3.1
    :param tab: Tabuleiro
    :param pec: Jogador
    :return: Devolve um tuplo com apenas uma posicao
              (a posicao e escolhida de acordo com o ponto 1.3.1)
             //estrategia de jogo automatico - Fase de colocacao//
    """
    if vitoria(tab, pec) is not None:  # Se for possivel concretizar a vitoria
        return vitoria(tab, pec),  # Entao concretizar
    'Nota: O bloqueio nao e mais que prever a vitoria do adversario'  # Se for possivel bloquear o adversario
    if vitoria(tab, troca_pec(pec)) is not None:  # Entao bloquear
        return vitoria(tab, troca_pec(pec)),
    if eh_posicao_livre(tab, cria_posicao('b', '2')):  # Se o meio estiver disponivel
        return cria_posicao('b', '2'),  # Jogar no meio
    if obter_canto_vazio(tab) is not None:  # Se algum dos cantos esta disponivel
        return obter_canto_vazio(tab),  # Jogar no canto
    return obter_posicoes_livres(tab)[0],  # Caso contrario jogar na primeira posicao disponivel


def vitoria(tab, pec):
    """
    Esta funcao e utilizada em duas partes:
                        - Vitoria: Coloca a peca no local correto para ganhar
                        - Bloqueio: Executa o bloqueio de modo a impedir o adversario de ganhar
    :param tab: Tabuleiro
    :param pec: Jogador
    :return: Devolve a posicao quee corresponde a uma vitoria
             ou a um bloqueio
             nota: caso nao seja possivel ganhar ou bloqueiar devolve None
    """
    entradas = 'abc123'  # Todas as entradas possiveis num tabuleiro 3x3
    for entrada in entradas:
        v = obter_vetor(tab, entrada)  # Para todas as entradas
        i = 0  # Obtemos um vetor
        for p in v:  # Para cada vetor
            if pecas_iguais(p, pec):  # Avaliamos as pecas que sao iguais a peca
                i += 1  # (peca do jogador ou peca do jogaodor contrario)
        if i == 2:
            if entrada in 'abc':  # Se duas das pecas forem iguais
                numeros = '123'  # A a outra peca estiver disponivel
                for num in numeros:  # Devemos concretizar a jogada
                    if eh_posicao_livre(tab, cria_posicao(entrada, num)):
                        return cria_posicao(entrada, num)
            else:
                letras = 'abc'
                for let in letras:
                    if eh_posicao_livre(tab, cria_posicao(let, entrada)):
                        return cria_posicao(let, entrada)
    'Nenhuma posicao disponivel para a vitoria (ou bloqueio)'
    return None


def troca_pec(pec):
    """
    X -> O
    O -> X
    :param pec: Recebe uma peca
    :return: Devolve a peca contraria
    """
    if pecas_iguais(pec, cria_peca('X')):
        copia_pec = cria_peca('O')
    else:
        copia_pec = cria_peca('X')
    return copia_pec


def obter_canto_vazio(tab):
    """
    :param tab: Tabuleiro
    :return: Devolve a posicao que corresponde ao primeiro canto
             vazio (None caso nao haja nenhum canto vazio)
    """
    cantos = (cria_posicao('a', '1'), cria_posicao('c', '1'), cria_posicao('a', '3'), cria_posicao('c', '3'))
    for pos in cantos:
        if eh_posicao_livre(tab, pos):
            return pos
    return None


""" ***************************************************************
                   FASE DE MOVER 
*************************************************************** """


def mov_facil(tab, pec):
    """
    :Descricao: a peca a movimentar e sempre a que ocupa a primeira posicao na
                ordem de leitura do tabuleiro que tenha alguma posicao adjacente livre. A posicao
                de destino e a primeira posicao adjacente livre.

    :param tab: Tabuleiro
    :param pec: Peca
    :return: Movimento escolhido para Grau: Facil
    """
    pos_bot = obter_posicoes_jogador(tab, pec)  # Posicoes em que existem pecas do 'BOT'
    livres = obter_posicoes_livres(tab)  # Todas as posicoes livres do tabuleiro
    for pos in pos_bot:
        jogada = ()
        jogada += (pos,)
        adj = obter_posicoes_adjacentes(pos)  # Posicoes adjacentes a posicao do 'BOT'
        for e in adj:
            if eh_posicao_livre(tab, e):  # Se a posicao adajacente em causa estiver livre
                jogada += (e,)  # Entao o movimento facil e esse mesmo
                return jogada  # NOTA: Sabemos a priori que existe pelo menos uma posicao adjacente livre
    return livres[0], livres[0]  # pois se nao existir a jogada ja teria sido realizada


def mov_normal(tab, pec):
    """
    :Descricao: Algoritmo de recursao minimax com profundidade = 1
     (nota: Esta funcao foi criada antes do minimax estar concluido
      contudo faz exatamento o que e pretendido. Nao foi alterada pois esta solucao
      tambem e adequada)
    :param tab: Tabuleiro
    :param pec: Peca
    :return: Movimento escolhido para Grau: Normal
    """
    pos_bot = obter_posicoes_jogador(tab, pec)
    for pos in pos_bot:
        adjacentes = obter_posicoes_adjacentes(pos)
        for adj in adjacentes:
            if eh_posicao_livre(tab, adj):
                copia_tab = cria_copia_tabuleiro(tab)
                copia_tab = move_peca(copia_tab, pos, adj)

                if pecas_iguais(obter_ganhador(copia_tab), pec):
                    return pos, adj  # Nota: Caso nao seja possivel 'marcar a vitoria'
    return mov_facil(tab, pec)  # Voltamos para a jogada facil


def mov_dificil(tab, jogador):
    """
    :Descricao: Este nivel de dificuldade corresponde a utilizacao do minimax
    com profundidade 5 **Caso pretenda saber o que e profundidade = 5 deve ver a funcao minimax
    :param tab: Tabuleiro
    :param jogador: Jogador (Peca correspondente ao 'BOT')
    :return: Jogada adequada ao nivel de dificuldade 5 (dificil)
    """
    seq = minimax(tab, jogador, 5, [])[1]
    partida = seq[0]
    chegada = seq[1]
    return partida, chegada


def minimax(tab, pec, profundidade, seq_mov):
    """
    :Algoritmo baseado no Pseudo-codigo
    :(Pseudo codigo disponvivel no topico 2.1)
    :param profundidade: A profundidade basicamente ao nivel de previsao do algoritmo
    :Quanto maior for a profundidade melhor sera o desempenho do 'BOT'
    :NOTA IMPORTANTE: Neste jogo especifico um grau de profundidade de 5 e mais que suficiente
    :dado que as possibilidades de movimentacao sao muito reduzidas. Ter profundidade de 6 seria
    quase igual ou ate igual e 5 mas a rapidez do algoritmo seria muito inferior
    :param seq_mov: Sequencia de movimentos
    :return: Melhor resultado, Melhor sequencia de movimento -> Caso terminal
             Valor do tabuleiro, Seq_mov -> Caso nao terminal
    """
    if not pecas_iguais(obter_ganhador(tab), cria_peca(' ')) or profundidade == 0:  # Permitir a recursao
        return valor(tab), seq_mov
    else:  # Concretizar a recursao
        melhor_resultado = ganha(troca_pec(pec))
        melhor_seq = []

        pos_player = obter_posicoes_jogador(tab, pec)  # Para uma descricao mais pormenorizada do algoritmo
        for pos in pos_player:  # do minimax ver Topico 2.1
            adj = obter_posicoes_adjacentes(pos)
            for e in adj:
                if eh_posicao_livre(tab, e):
                    copia_tab = cria_copia_tabuleiro(tab)
                    novo_tab = move_peca(copia_tab, pos, e)
                    novo_res, nova_seq = minimax(novo_tab, troca_pec(pec), profundidade - 1, seq_mov + [pos, e])

                    if not melhor_seq or \
                            (pecas_iguais(pec, cria_peca('X')) and novo_res > melhor_resultado) or \
                            (pecas_iguais(pec, cria_peca('O')) and novo_res < melhor_resultado):
                        melhor_resultado, melhor_seq = novo_res, nova_seq
        return melhor_resultado, melhor_seq


def valor(tab):  # Funcao auxiliar para o minimax
    """
    :param tab: Tabuleiro
    :return: Obter o valor de um tabuleiro
     Valores:  1 caso o vitorioso seja X // -1 caso o vitorioso seja O // 0 caso seja EMPATE
    """
    if pecas_iguais(obter_ganhador(tab), cria_peca('X')):
        return 1
    elif pecas_iguais(obter_ganhador(tab), cria_peca('O')):
        return -1
    else:
        return 0


def ganha(pec):  # Funcao auxiliar para o minimax
    """
    :param pec: Peca que queremos que ganhe
    :return: Queremos que o X ganhe -> Ganha(pec) = 1
             Queremos que o O ganhe -> Ganha(pec) = -1
    """
    if pecas_iguais(pec, cria_peca('X')):
        return 1
    elif pecas_iguais(pec, cria_peca('O')):
        return -1


""" ***************************************************************
                   Jogo do moinho 
*************************************************************** """


def moinho(jogador, dificuldade):
    """
    :param jogador: Jogador joga com *jogador
    :param dificuldade: Dificuldae escohida em string
    :return: Jogo completo
    """
    peca_player = cria_peca(jogador[0])
    peca_bot = troca_pec(peca_player)
    vencedor = cria_peca(' ')
    tab = cria_tabuleiro()  # Criar um tabuleiro vazio // Iniciar o jogo
    print('Bem-vindo ao JOGO DO MOINHO. Nivel de dificuldade ' + dificuldade + '.')
    print(tabuleiro_para_str(tab))
    if pecas_iguais(peca_player, cria_peca('X')):
        return jogas_com_x(dificuldade, peca_player, peca_bot, vencedor, tab)
    else:
        return jogas_com_o(dificuldade, peca_player, peca_bot, tab)


def jogas_com_x(dificuldade, peca_player, peca_bot, vencedor, tab):
    """
    Caso em que se joga com X
    """
    contador = 1  # Jogador -> X // entao contador inicial e 1
    if pecas_iguais(peca_player, cria_peca('O')):  # Jogador -> O // entao contador inicial e 0
        contador = 0
    while pecas_iguais(vencedor, cria_peca(' ')):  # Fase de colocacao
        if len(obter_posicoes_jogador(tab, peca_player)) < 3:
            tab = coloca_peca(tab, peca_player, obter_movimento_manual(tab, peca_player)[0])
            print(tabuleiro_para_str(tab))
            vencedor = obter_ganhador(tab)
            if not pecas_iguais(vencedor, cria_peca(' ')):  # Verificar se ja existe vencedor
                return peca_para_str(vencedor)  # Caso exista -> terminar o jogo
            if len(obter_posicoes_jogador(tab, troca_pec(peca_player))) < 3:
                print('Turno do computador ' + '(' + dificuldade + ')' + ':')
                tab = coloca_peca(tab, peca_bot, obter_movimento_auto(tab, peca_bot, dificuldade)[0])
                print(tabuleiro_para_str(tab))
                vencedor = obter_ganhador(tab)
        else:  # Fase de movimentacao
            if contador != 0:  # Se contador e 1
                manual = obter_movimento_manual(tab, peca_player)  # O jogador move se
                tab = move_peca(tab, manual[0], manual[1])
                print(tabuleiro_para_str(tab))
                vencedor = obter_ganhador(tab)
                if not pecas_iguais(vencedor, cria_peca(' ')):
                    return peca_para_str(vencedor)
            print('Turno do computador ' + '(' + dificuldade + ')' + ':')  # O bot move-se
            auto = obter_movimento_auto(tab, peca_bot, dificuldade)
            tab = move_peca(tab, auto[0], auto[1])
            print(tabuleiro_para_str(tab))
            vencedor = obter_ganhador(tab)
            contador = 1  # Atualizar o contador para 1 de modo a que o jogador se possa mover
    return peca_para_str(vencedor)  # Nota: O contador so comeca a 0 se o jogador for O


def jogas_com_o(dificuldade, peca_player, peca_bot, tab):
    """
    Caso em que se joga com O (codigo simplificado)
    """
    print('Turno do computador ' + '(' + dificuldade + ')' + ':')
    tab = coloca_peca(tab, peca_bot, obter_movimento_auto(tab, peca_bot, dificuldade)[0])  # Primeira colocacao //BOT//
    print(tabuleiro_para_str(tab))
    vencedor = obter_ganhador(tab)  # Reaproveitar o codigo de jogar com X
    return jogas_com_x(dificuldade, peca_player, peca_bot, vencedor, tab)  # Com ligeiras alteracoes


moinho(cria_peca('X'),'dificil')