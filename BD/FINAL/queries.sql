-- BEM VINDO ÀS NOSSAS QUERIES :) 

-- #####################################

-- 1) PRIMEIRA

SELECT DISTINCT retalhista.nome,COUNT(DISTINCT responsavel_por.nome_cat) 
FROM retalhista NATURAL JOIN responsavel_por
GROUP BY retalhista.tin
HAVING COUNT(DISTINCT responsavel_por.nome_cat) >= ALL(
	SELECT COUNT(DISTINCT responsavel_por.nome_cat)
	FROM responsavel_por
	GROUP BY responsavel_por.tin
);

-- #####################################

-- 2) SEGUNDA

ALTER TABLE retalhista
RENAME COLUMN nome TO retalheiro ;

SELECT DISTINCT retalhista.retalheiro
FROM (retalhista NATURAL JOIN responsavel_por  JOIN categoria_simples ON responsavel_por.nome_cat = categoria_simples.nome)
GROUP BY tin
HAVING COUNT(DISTINCT responsavel_por.nome_cat) = ALL(
  SELECT COUNT(DISTINCT categoria_simples.nome)
  FROM categoria_simples
  GROUP BY tin);

ALTER TABLE retalhista
RENAME COLUMN retalheiro TO nome;


-- #####################################
-- 3) TERCEIRA

SELECT DISTINCT ean
FROM produto
EXCEPT
SELECT ean
FROM evento_reposicao
ORDER by ean;


-- #####################################
--4) QUARTA

SELECT ean 
FROM evento_reposicao
GROUP BY ean
HAVING COUNT(DISTINCT evento_reposicao.tin) = 1;
