%%%%%%% Projeto: LP 2020/2021 %%%%%%%
%%%%%%% Aluno: Jose Cutileiro %%%%%%%
%%%%%%% Numero: 99097         %%%%%%%
%%%%%%% Linguagem: Prolog.    %%%%%%%


%%%%%%% ** Parte 0, Pre codigo ** %%%%%%%

:- [codigo_comum].

%%%%%%% ** Parte 1, Funcoes auxiliares ** %%%%%%%

% 0.1 soma_lista/2: Soma os elementos de uma lista %
% Utilizado nas seguintes funcoes:
% * combinacoes_soma *
% * permutacoes_soma *

soma_lista([],0).
soma_lista([H|C],N) :-
    soma_lista(C,M),
    N is M+H.

% 0.2 lenf/2: devolve o numero de elementos
% de uma lista. Nota: [[3,3],[2]] tem tamanho 2

lenf([],0).
lenf([_|C],N) :-
    lenf(C,M),
    N is M+1.


%%%%%%% ** Parte 2, Predicados ** %%%%%%%

%%% 3.1.1 combinacoes soma/4: Ve todas as combinacoes possiveis (Combs)        %%%
%%% para que a soma de uma certa combinacao (N a N) de uma lista (Els) seja    %%%
%%% igual ao numero pretendido (Soma)                                          %%%

combinacoes_soma(N,Els,Soma,Combs) :-
    findall(Comb,(combinacao(N,Els,Comb),soma_lista(Comb,M),M=:=Soma),Combs).


%%% 3.1.2 permutacoes_soma/4: Devolve todas as permutacoes (Perms)    %%%
%%% possiveis para que a soma de uma certa permutacao (N a N) de uma  %%%
%%% lista (Els) seja igual ao numero pretendido (Soma)                %%%

permutacoes_soma(N,Els,Soma,Perms) :-
    findall(Perm,(combinacao(N,Els,Comb),soma_lista(Comb,M),M=:=Soma,permutation(Comb,Perm)),PrePerms),
    sort(PrePerms,Perms).


%%% 3.1.3 espaco_fila/3: Recebendo um fila (horizontal ou vertical)  %%%
%%% esta funcao ira devolver um conjunto de variaveis que contribuem %%%
%%% para cada porcao da fila em causa                                %%%
%%% Nota: Utiliza predicados auxiliares                              %%%

% find_space/3: Distingue se a Fila e ou nao vertical

find_space([_|S],h,Res) :-
    nth1(1,S,Res).


find_space([P|_],v,Res) :-
    Res=P.

% while_var/3: Enquanto e variavel percorre a lista

while_var([H|C],PreRes,Res) :-
    var(H),
    append(PreRes,[H],NewRes),
    while_var(C,NewRes,Res).

while_var([H|_],PreRes,Res) :-
    is_list(H),
    Res = PreRes.
    
% espaco_fila_aux/3: Auxiliar principal, cria um espaco
% para o primeiro elemento de uma lista

espaco_fila_aux([],_,_).

espaco_fila_aux([H|C],Esp,H_V) :-
    var(H),
    espaco_fila(C,Esp,H_V).


espaco_fila_aux([H|C],Esp,H_V) :-
    is_list(H),
    while_var(C,[],Var_Group),
    find_space(H,H_V,Value),
    length(Var_Group,Size),
    Size > 0,
    Esp = espaco(Value,Var_Group).

% ate_el/3: Percorre uma lista ate um
% alcancar um elemento especifico(El)

ate_el([H|C],El,Res) :-
    H \== El,
    ate_el(C,El,Res).
        

ate_el([H|C],El,Res) :-
    H == El,
    append([H],C,Res).

% espaco_fila/3: funcao principal do 3.1.3
% (aplica o espaco_fila_aux a todas as listas na fila)

espaco_fila(Fila,Esp,H_V) :-
    % Estava um erro para o ultimo elemento entao
    % adicionei um novo elemento para ser o novo ultimo.
    append(Fila,[[2,3],_],Nova_Fila),
    bagof(Sp,(member(X,Nova_Fila),is_list(X),ate_el(Nova_Fila,X,New),espaco_fila_aux(New,Sp,H_V)),SemEsp),
    member(Esp,SemEsp).

%%% 3.1.4 espacos_fila/2: Esta funcao ira obter todos os espacos       %%%
%%% que estao numa determinada fila (ter em conta caso de lista vazia) %%%

espacos_fila(H_V, Fila, Esps) :-
    bagof(Esp,espaco_fila(Fila,Esp,H_V),Esps),!.

espacos_fila(H_V, Fila, Esps) :-
    not(bagof(Esp,espaco_fila(Fila,Esp,H_V),_)),
    Esps = [],!.
%          ^^
%   caso da lista vazia

%%% 3.1.5 espacos_puzzle/2: Recebendo um puzzle como input %%%
%%% esta funcao ira devolver todos os espacos              %%%
%%% (tanto horizontais como verticais) desse mesmo puzzle  %%%

% esta funcao utiliza a mat_transposta (definida no codigo_comum)
% (mat_transposta devolve a matriz transposta)

espacos_puzzle(Puzzle,Espacos) :-
    mat_transposta(Puzzle,T_Puzzle),
    length(Puzzle,Len_H),
    length(T_Puzzle,Len_V),
    length(Hor,Len_H),
    length(Ver,Len_V),
    maplist(espacos_fila(h),Puzzle,Hor),
    maplist(espacos_fila(v),T_Puzzle,Ver),
    append(Hor,PreH),
    append(Ver,PreV),
    append(PreH,PreV,Espacos),!.

espacos_puzzle(_,_) :- !.
%                      ^
%               otimizacao ligeira


%%% 3.1.6 espacos_com_posicoes_comuns/3: Ve todos os espacos que tem  %%%
%%% alguma posicao comum com o Esp em causa                           %%%

% espacos_com_posicoes_comuns_aux/3: Indidualizar opcoes

espacos_com_posicoes_comuns_aux(Espacos, Esp, Esps_com) :-
    setof(Esp2,(member(Esp2,Espacos),
                Esp\==Esp2,espaco(_,X1) = Esp,
                espaco(_,Y1) = Esp2,member(X,X1),
                member(Y,Y1),X==Y),Esps_com_aux),
          member(Esps_com,Esps_com_aux).

% espacos_com_posicoes_comuns/3: Generalizar opcoes

espacos_com_posicoes_comuns(Espacos,Esp,Esps_com) :-
    bagof(Esp_Ok,espacos_com_posicoes_comuns_aux(Espacos,Esp,Esp_Ok),Esps_com_no_order),
    bagof(Esp_Order,(member(Esp_Order,Espacos),member(Esp_Order,Esps_com_no_order)),Esps_com).

%%% 3.1.7 permutacoes_soma_espacos/2: Recebendo uma lista de espacos %%%
%%% esta funcao ira encontrar todas as permutacoes possiveis para    %%%
%%% cada espaco                                                      %%%


permutacoes_soma_espacos(Espacos,Perms_soma) :-
    bagof([Esp,Perms],
    Vars^Len^Soma^(member(Esp,Espacos),
                    espaco(Soma,Vars) = Esp,length(Vars,Len),
                    permutacoes_soma(Len,[1,2,3,4,5,6,7,8,9],Soma,Perms)),
                    Perms_soma).

% Nota:[1,2,3,4,5,6,7,8,9] faz qualquer permutacao necessaria para resolver    %
% o nosso problema                                                             %


%%% 3.1.8 permutacao_possivel_espaco/4: Esta funcao ira encontrar       %%%
%%% todas as permutacoes possiveis para um dado espaco e individualizar %%%
%%% cada uma delas na variavel 'Perm'                                   %%%

% Por alguma razao a minha funcao permutacao_possivel_espaco_aux                 %
% devolvia varios valores repetidos, de modo a poupar tempo de                   %
% desenvolvimento do projeto criei uma funcao que remove os elementos repetidos  %
% em vez de refazer tudo do zero (remove_duplicates/2)                           %

remove_duplicates([],[]).

remove_duplicates([H | T], List) :-    
     member(H, T),
     remove_duplicates( T, List).

remove_duplicates([H | T], [H|T1]) :- 
      \+member(H, T),
      remove_duplicates( T, T1).

% Funcao auxiliar para permutacao_possivel_espaco %
% (esta funcao ira encontrar TODAS as permutacoes %
% possiveis para o Esp em estudo)                 %

permutacao_possivel_espaco_aux(Perm, Esp, Espacos, Perms_soma) :-

    espacos_com_posicoes_comuns(Espacos, Esp, Esps_com),

    bagof(PermI,(                         % Nota: O forall e utilizado de modo
                                          % de modo e evitar unificacoes
        member(PSI,Perms_soma),           % indesejadas
        member(Esp,PSI),
        member(PermsI,PSI),
        member(PermI,PermsI),

        espaco(_,L) = Esp,             % Nota: espaco(_,L) TEM que ser unificavel com Esp
                                       % isto garante que Esp e efetivamente um espaco
        forall((L=PermI,
            member(PSJ,Perms_soma),
            member(EspC,PSJ),
            PSJ\==PSI,                    % <- e importante que PSJ e diferente de PSI
            member(EspC,Esps_com))        % <- caso contrario TODAS as perms seriam contabilizadas 
            ,(
            member(PermsJ,PSJ),
            member(PermJ,PermsJ),
            espaco(_,LC) = EspC,

            LC = PermJ))
       
	    )
	    ,Perm
	    ).

% funcao principal do 3.1.8, ira individualizar cada permutacao encontrada %
  
permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma) :-
    permutacao_possivel_espaco_aux(Perm_aux, Esp, Espacos, Perms_soma),!,
    remove_duplicates(Perm_aux,Perm_aux2),
    member(Perm,Perm_aux2).
%                   ^
%           Lista de permutacoes nao    | Nota: Perm_aux (obtida em permutacao_possivel_espaco_aux)
%               repetidas               | apresenta resultados repetidos por motivos desconhecidos
% (As respostas serao qualquer um dos)  |
%       membros da Perm_aux2)           |


%%% 3.1.9 permutacoes_possiveis_espaco/4: Generalizacao do predicado anterior %%%
%%% obtendo o conjunto de TODAS as permutacoes possiveis para um dado esp     %%%
%%% em simultaneo (o anterior obtia cada uma separadamente)                   %%%


permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp,Perms_poss) :-
    bagof(Perm,permutacao_possivel_espaco(Perm,Esp,Espacos,Perms_soma),Perms),
    espaco(_,Vars) = Esp,
    Perms_poss = [Vars,Perms].
%                     ^                                     %
%           A resposta e apresentada como                   %
%       sendo uma lista em que a primeira componente        %
%   sao as variaveis e a segunda sao as permutacoes todas   %

%%% 3.1.10 permutacoes_possiveis_espacos/2: Esta funcao ira genetalizar ainda %%%
%%% mais os nossos resultados anteriores, passando de encontrar todas as      %%%
%%% permutacoes possiveis para apenas um espaco, para encontrar logo TODAS de %%%
%%% TODOS os espaco que se encontram num determinado puzzle ou problema       %%%

permutacoes_possiveis_espacos(Espacos, Perms_poss_esps) :-
    permutacoes_soma_espacos(Espacos,Perms_soma),
    bagof(Para_Esp,Esp^(member(Esp,Espacos),
                    permutacoes_possiveis_espaco(Espacos,Perms_soma,Esp,Para_Esp)),
        Perms_poss_esps).


%%% 3.1.11/2: Numeros comuns: Recebe uma lista de permutacoes         %%%
%%% e ira devolver uma lista de tuplos com (pos,num) em que pos       %%%
%%% e a posicao em que num aparece em todas as listas dadas no input  %%%

%comuns_aux/3: auxiliar para usar no maplist
% de modo a percorrer as listas mais facilmente

comuns_aux(Pos,Num,L) :-
    nth1(Pos,L,Num).

numeros_comuns(L,Numeros_comuns) :-
    setof((Pos,Num),(maplist(comuns_aux(Pos,Num),L)),Numeros_comuns),!.
%     ^
% atencao ordem

numeros_comuns(L,Numeros_comuns) :-
    not(setof((Pos,Num),(maplist(comuns_aux(Pos,Num),L)),Numeros_comuns)),
    Numeros_comuns = [],!.
%                    ^^
%            Caso da lista vazia 
%   caso nao haja nenhum numero comum a todas


%%% 3.1.12 atribui_comuns(Perms_Possiveis)/1: Faz as atribuicoes %%%
%%% que sao possiveis no espaco tempo 'atual'. Tendo em conta    %%%
%%% os numeros comuns de um determinado grupo de permutacoes     %%%
%%% (como seria de esperar, utiliza o predicado anterior)        %%%

% aux_final/2: Com <-> Comuns || Vars <-> Variaveis; %
% ira ser aproveitada pelo maplist de modo a         %
% simplificar o trabalho                             %

aux_final(Vars,Com) :-
    (Ind,Val) = Com,
    nth1(Ind,Vars,Val).

% atribui_comuns_aux/2: Utilizando um maplist ira ver para  %
% todas as variaveis quais sao todos os seus numeros comuns %

atribui_comuns_aux(Vars,Numeros_comuns) :-
    maplist(aux_final(Vars),Numeros_comuns).
    
atribui_comuns_aux(_,[]).
%                    ^^                    %
%            caso particular de            %
%    modo a evitar falsidades inesperadas  %


atribui_comuns(Perms_poss_esps) :-

    maplist(nth1(1),Perms_poss_esps,Vars),     % Todas as Vars estao no index 1
    maplist(nth1(2),Perms_poss_esps,Perms),    % Todas as Perms estao no index 2
    
    maplist(numeros_comuns,Perms,Numeros_comuns),
%               ^           ^         ^         %
%      Encontra os numeros comuns em cada Perm  %

    maplist(atribui_comuns_aux,Vars,Numeros_comuns),!.
%                 ^             ^        ^       %
%   Atribui TODOS os numeros comuns a cada Var   %


%%% 3.1.13 retira_impossiveis/2: Ira retirar TODAS as %%%
%%% permutacoes que ja nao sao possiveis apos alguma  %%%
%%% alteracao (ex: apos aplicar 3.1.12)               %%%

% mega_aux/2: ve se uma variavel e ou nao unificavel          %
% com uma dada permutacao (e mega porque apesar de simples    %
% reproduz resultados bastante uteis para a funcao principal) %

mega_aux(Vars,Perm) :-
    Perm \= Vars.

% retira_impossiveis_aux/2: funcao desenhada para ser compativel %
% com o maplist, ira atualizar casa PSI para NEWPSI (uma de      %
% cada vez)                                                      %

retira_impossiveis_aux(PSI,NEWPSI) :-
    member(Perms,PSI),
    member(Perm,Perms),
    is_list(Perm),!,     % Perm: se nao for lista sabemos que e uma var
    member(Vars,PSI),    % Vars: Se nao for Perm entao e var
    Vars \== Perms,
    exclude(mega_aux(Vars),Perms,NewPerms),   % excluir as permutacoes impossiveis
    NEWPSI = [Vars,NewPerms].

retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis) :-
    maplist(retira_impossiveis_aux,Perms_Possiveis,Novas_Perms_Possiveis),!.
%                                       ^                   ^                   %
% Retira TODAS as permutacoes impossiveis de Perms_Possiveis atualizando o novo %
% grupo de permutacoes para Novas_Perms_Possiveis, aproveitando a auxiliar      %

    
%%% 3.1.14 simplifica(Perms_Possiveis, Novas_Perms_Possiveis): %%%
%%% simplificar um puzzle original utilizando predicados       %%%
%%% definidos anteriormente                                    %%%

simplifica(Perms_Possiveis, Novas_Perms_Possiveis) :-     % Nota: O predicado 3.1.14 deve ser
    atribui_comuns(Perms_Possiveis),                      % aplicado continuamente ate que ja
    retira_impossiveis(Perms_Possiveis,New_aux),          % nao seja possivel fazer nenhuma
    New_aux \== Perms_Possiveis,                          % simplificacao
    simplifica(New_aux,Novas_Perms_Possiveis).

simplifica(Perms_Possiveis,Novas_Perms_Possiveis) :-     % <- Este seria o caso terminal dado que
    atribui_comuns(Perms_Possiveis),                     % <- ao atualizar as permutacoes, obtemos
    retira_impossiveis(Perms_Possiveis,New_aux),         % <- um resultado exatemente igual ao 
    New_aux == Perms_Possiveis,                          % <- anterior
    Novas_Perms_Possiveis = New_aux.                     % <- (inalterado == nao e mais simplificavel)


%%% 3.1.15 inicializa(Puzzle, Perms_Possiveis): Recebendo %%%
%%% um puzzle, seguimos um pequeno algoritmo inicial      %%%

inicializa(Puzzle, Perms_Possiveis) :-                            % Descricao: Primeiro encontramos TODOS
    espacos_puzzle(Puzzle,Espacos),                               % os espacos del puzzle. Depois encontramos 
    permutacoes_possiveis_espacos(Espacos,Perms_Possiveis_Aux),   % TODAS as permutacoes para esses espacos
    simplifica(Perms_Possiveis_Aux,Perms_Possiveis).              % depois simplificamos estas permutacoes

/* Nota: Trabalho inacabado */
 %
 % 3.1.15 MLE
 % 3.2.1 [-]
 % 3.2.2 [-]
 % 3.2.3 [-]
 % 3.3.1 [-]
 %
 % Pontuacao no mooshak: 1075/1600
