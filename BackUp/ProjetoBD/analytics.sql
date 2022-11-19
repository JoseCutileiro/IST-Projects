-- PARTE 5

-- CONSULTAS OLAP --

-- 1) Consultar numero total de artigos vendidos 
-- entre 1990 (1 de janeiro) e 2000 (1 de janeiro) (i.e periodo de tempo) 
-- por concelho e dia de semana (e total)

SELECT dia_semana,concelho,SUM(unidades)
FROM vendas
WHERE ano < 2000 AND ano > 1990
GROUP BY
	ROLLUP (dia_semana,concelho)


-- 2) Consultar numero total de artigos vendidos
-- num dado distrito (i.e badajoz) por concelho dia de semana (e total)

SELECT concelho,cat,dia_semana,SUM(unidades)
FROM vendas
WHERE distrito = 'Badajoz'
GROUP BY
	ROLLUP (concelho,cat,dia_semana)



