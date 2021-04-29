
addOito(X, Z) :- Z is X + 8.

/*
?- maplist(addOito, [1, 4, 2, -2], L).
L = [9, 12, 10, 6].

?- maplist(reverse, [[1, 3, 5], [4, 6, 8], [5, 1]], L).
*/

mult(X,Y,Z) :- Z is X * Y.

/*
?- maplist(mult, [1, 2, 3], [1, 2, 3], [1, 4, 9]).
true.

?- maplist(mult, [1, 2, 3], [1, 2, 3], [1, 4, 25]).
false.

?- maplist(mult, [1, 2, 3], [1, 2, 3], X).
X = [1, 4, 9].

?- maplist(mult(2), [1, 2, 3], X).
X = [2, 4, 6].

*/


/*
?- length(L, 3), maplist(between(0, 1), L).

L = [0, 0, 0] ;
L = [0, 0, 1] ;
L = [0, 1, 0] ;
L = [0, 1, 1] ;
L = [1, 0, 0] ;
L = [1, 0, 1] ;
L = [1, 1, 0] ;
L = [1, 1, 1].


?- length(L, 3), maplist(between(1), [1, 3, 2], L).
L = [1, 1, 1] ;
L = [1, 1, 2] ;
L = [1, 2, 1] ;
L = [1, 2, 2] ;
L = [1, 3, 1] ;
L = [1, 3, 2].
*/

is_odd(I) :-
    0 =\= I mod 2.

/*
?- List = [1, 2, 3, 4, 5, 6], include(is_odd, List, Odd).
List = [1, 2, 3, 4, 5, 6],
Odd = [1, 3, 5].

?- List = [1, 2, 3, 4, 5, 6], exclude(is_odd, List, Ps).
List = [1, 2, 3, 4, 5, 6],
Ps = [2, 4, 6].

*/
