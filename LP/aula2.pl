soma_5_e_duplica(X, Y) :- Y is 2 * (X + 5).


% -------------------------------------------------------------
%                                   Factorial
% -------------------------------------------------------------

% Gera processo recursivo
factorial(1, 1).
factorial(N, F) :- N > 1, 
                             N1 is N-1, 
                            factorial(N1, F1), 
                            F is N * F1.

% factorial(3, F).
% factorial(X, 6). 
% Vai dar o erro dos "Arguments are not sufficiently instantiated"

% Gera processo iterativo
% Nao resolve erro anterior.  Ou seja tambem da asneira na polimodalidade

factorial1(N, F) :- fact(N, 1, F).
fact(1, F, F).
fact(N, Ac, F) :- N > 1, 
                            Ac1 is N*Ac, 
                            N1 is N-1, 
                            fact(N1, Ac1, F).

% factorial1(X, 6).