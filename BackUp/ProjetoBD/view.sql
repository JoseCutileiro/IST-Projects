-- HELLO YOU CAN VIEW OUR VIEWS DOWN THERE : )
----------------------------------------
----------------------------------------
--                 #######
--               ####  ###
--              ####   ###
--             ####    ###   
--            ################
--            ################
--                     ###
--                     ###
--                     ###
----------------------------------------
----------------------------------------

CREATE VIEW vendas(
	ean,cat,ano,trimestre,dia_mes,dia_semana,distrito,concelho,unidades)
AS
SELECT  evento_reposicao.ean,
		prateleira.nome,
		EXTRACT(YEAR FROM evento_reposicao.instante),
		EXTRACT(QUARTER FROM evento_reposicao.instante),
		EXTRACT(DAY FROM evento_reposicao.instante),
		EXTRACT(DOW FROM evento_reposicao.instante),
		ponto_de_retalho.distrito,
		ponto_de_retalho.conselho,
		evento_reposicao.unidades
FROM evento_reposicao NATURAL JOIN prateleira NATURAL JOIN instalada_em JOIN ponto_de_retalho ON instalada_em.nome_local = ponto_de_retalho.nome;


-- TEST OUR VIEW WITH THIS CODE: 

-- SELECT *
-- FROM vendas;