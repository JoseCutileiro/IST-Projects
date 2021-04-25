% -------------------------------------------------------------
%                Comprimento de uma lista
% -------------------------------------------------------------

% Versao O(N) - requisito de memoria para lista de tamanho N
% Gera processo recursivo

comp1([], 0).
comp1([_| Cauda], N) :- comp1(Cauda, M), N is M + 1.

% Versao O(1) - requisito de memoria para lista de tamanho N
% Gera processo iterativo
comp2(L, C) :- comp2(L, 0, C).
comp2([], C, C).
comp2([_ | Cauda], Acum, C) :- Acum1 is Acum + 1, comp2(Cauda, Acum1, C).

/*
[debug]  ?- comp1([1, 2, 6], C).
T Call: (6) comp1([1, 2, 6], _G2303)
T Call: (7) comp1([2, 6], _G2417)
T Call: (8) comp1([6], _G2417)
T Call: (9) comp1([], _G2417)
T Exit: (9) comp1([], 0)
T Exit: (8) comp1([6], 1)
T Exit: (7) comp1([2, 6], 2)
T Exit: (6) comp1([1, 2, 6], 3)
C = 3.

debug]  ?- comp2([1, 2, 6], C).
T Call: (6) comp2([1, 2, 6], _G2303)
T Call: (7) comp2([1, 2, 6], 0, _G2303)
T Call: (8) comp2([2, 6], 1, _G2303)
T Call: (9) comp2([6], 2, _G2303)
T Call: (10) comp2([], 3, _G2303)
T Exit: (10) comp2([], 3, 3)
T Exit: (9) comp2([6], 2, 3)
T Exit: (8) comp2([2, 6], 1, 3)
T Exit: (7) comp2([1, 2, 6], 0, 3)
T Exit: (6) comp2([1, 2, 6], 3)
C = 3.
*/

% -------------------------------------------------------------
%      Junta listas ordenadas (e elimina repetidos)
% -------------------------------------------------------------

% O corte e so para evitar calculos desnecessarios

junta_ord(L, [], L).
junta_ord([], L, L).
junta_ord([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca1 |  CaudaFinal ]) :-
    Cabeca1 < Cabeca2, junta_ord(Cauda1 , [ Cabeca2 | Cauda2 ], CaudaFinal).
junta_ord([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca1 |  CaudaFinal ]) :-
    Cabeca1 =:= Cabeca2, junta_ord(Cauda1 , Cauda2, CaudaFinal).
junta_ord([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca2 |  CaudaFinal ]) :-
    Cabeca1 > Cabeca2, junta_ord([ Cabeca1 | Cauda1 ] , Cauda2, CaudaFinal).
    
%?- junta_ord([1, 2, 4, 8], [1, 3, 6, 10], L).
%L = [1, 2, 3, 4, 6, 8, 10] ;
%false.

junta_ord1(L, [], L) :- !.
junta_ord1([], L, L) :- !.
junta_ord1([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca1 |  CaudaFinal ]) :-
    Cabeca1 < Cabeca2, !, junta_ord1(Cauda1 , [ Cabeca2 | Cauda2 ], CaudaFinal).
junta_ord1([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca1 |  CaudaFinal ]) :-
    Cabeca1 =:= Cabeca2, !, junta_ord1(Cauda1 , Cauda2, CaudaFinal).
junta_ord1([ Cabeca1 | Cauda1 ], [ Cabeca2 | Cauda2 ], [ Cabeca2 |  CaudaFinal ]) :-
    Cabeca1 > Cabeca2, !, junta_ord1([ Cabeca1 | Cauda1 ] , Cauda2, CaudaFinal).

%?- junta_ord1([1, 2, 4, 8], [1, 3, 6, 10], L).
%L = [1, 2, 3, 4, 6, 8, 10].
% Nao da hipotese de por ;

