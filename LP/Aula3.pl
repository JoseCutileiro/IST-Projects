p(3,5,2).
p(1,3,5).
p(2,4,2).
p(2,4,1).
p(4,3,1).

/*
?- bagof(Z,p(X,Y,Z),Saco).
?- setof(Z,p(X,Y,Z),Conjunto).
?- findall(Z,p(X,Y,Z),Saco).
?- bagof(Z,X^Y^p(X,Y,Z),Saco).
*/

% -------------------------------------------------------------
%                                   Ultimo
% -------------------------------------------------------------

ultimo([X], X).
ultimo([_|Cauda], X) :- ultimo(Cauda, X).

/*
?- ultimo([1], X).
?- ultimo([1, 2, 3], X).
?- trace(ultimo).
?- ultimo([1, 2, 3], X).
?- nodebug.
*/

% -------------------------------------------------------------
%                                   Soma
% -------------------------------------------------------------

soma([], 0).
soma([Cabeca | Cauda], N) :- soma(Cauda, M), N is M + Cabeca.

% soma([1, 5, 6], X).
% trace(soma).
% soma([1, 5, 6], X).


% -------------------------------------------------------------
% e in l 
% ------------------------------------------------------------

in([E],E]).
in([E|_],E).
in([_|cauda],E) :- in(cauda,E).




% -------------------------------------------------------------
%                Comprimentos de uma lista
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
