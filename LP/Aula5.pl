
:- write('A professora de LP adora os seus queridos alunos!').



isDifferent(A,A) :- !, fail. 
isDifferent(_,_).

/*
?- isDifferent(a, a).
false.

?- isDifferent(a, 5).
true.

*/
% Tirem o corte e vejam o que acontece:

isDifferent1(A,A) :- fail. 
isDifferent1(_,_).

/*
?- isDifferent1(a, a).
true.

?- isDifferent1(a, 5).
true.
*/

ave(pong).
ave(piupiu).
pinguim(pong).
nada(piupiu).
voa(P) :- ave(P), \+ pinguim(P).
voa(P) :- ave(P), \+ nada(P).

/*
?- voa(X).
X = piupiu.
*/

voa1(P) :- \+ pinguim(P), ave(P).
/*
?- voa1(X).
false.
*/

heroi(X) :- temSuperPoderes(X), not(mau(X)).
temSuperPoderes('Homelander').
temSuperPoderes('11').
mau('Homelander').

heroi1(X) :- not(mau(X)), temSuperPoderes(X).
