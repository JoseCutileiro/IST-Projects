# PERGUNTA 5

set.seed(1097)

ordenado <- ecdf(rexp(465,0.1))

1 - ordenado(1) - (1 - pexp(1,0.1))

