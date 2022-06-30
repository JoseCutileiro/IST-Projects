-- schema.sql

-- EM FALTA: 
-- RI-REx
-- DEPOIS DE FK: 
-- 	REFERENCES categoria(nome) ON DELETE CASCADE 
--                             ON UPDATE CASCADE
--                             ON INSERT CASCADE?
-- DUV: descr pode ser NULL?
-- DUV: CHECK nro|numero_serie > 0?


-- LIMPAR TABELAS (se existirem)
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS categoria_simples CASCADE;
DROP TABLE IF EXISTS super_categoria CASCADE;
DROP TABLE IF EXISTS tem_outra CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS tem_categoria CASCADE;
DROP TABLE IF EXISTS IVM CASCADE;
DROP TABLE IF EXISTS ponto_de_retalho CASCADE;
DROP TABLE IF EXISTS instalada_em CASCADE;
DROP TABLE IF EXISTS prateleira CASCADE;
DROP TABLE IF EXISTS planograma CASCADE;
DROP TABLE IF EXISTS retalhista CASCADE;
DROP TABLE IF EXISTS responsavel_por CASCADE;
DROP TABLE IF EXISTS evento_reposicao CASCADE;


-- DEBUG APAGAR
-- DROP TABLE IF EXISTS debugs CASCADE;
-- CREATE TABLE debugs (
  -- logs character varying(255) NULL
-- );


-- INICIALIZAR TABELAS (criar o schema)
CREATE TABLE categoria
	(nome VARCHAR(25) NOT NULL,
	PRIMARY KEY (nome)); -- TODO:RI-RE1

CREATE TABLE categoria_simples
	(nome VARCHAR(25) NOT NULL,
	PRIMARY KEY (nome),
	FOREIGN KEY (nome) -- TODO: RI-RE2
		REFERENCES categoria(nome) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE super_categoria
	(nome VARCHAR(25) NOT NULL,
	PRIMARY KEY (nome),
	FOREIGN KEY (nome)
		REFERENCES categoria(nome) ON DELETE CASCADE ON UPDATE CASCADE); -- TODO: RI-RE3


CREATE TABLE tem_outra (
	nome_super_categoria VARCHAR(255) NOT NULL,
  	nome_categoria VARCHAR(255) NOT NULL,
  	FOREIGN KEY(nome_super_categoria) REFERENCES super_categoria(nome) on DELETE CASCADE,
  	FOREIGN KEY(nome_categoria) REFERENCES categoria(nome) on DELETE CASCADE,
  	CHECK(nome_super_categoria <> nome_categoria),
  	PRIMARY KEY(nome_categoria)
);

CREATE TABLE produto
	(ean BIGINT NOT NULL,
    cat VARCHAR(25) NOT NULL,
    descr VARCHAR(200) NOT NULL,
	PRIMARY KEY (ean),
	FOREIGN KEY (cat)
		REFERENCES categoria(nome) ON DELETE CASCADE ON UPDATE CASCADE,
	-- TODO: RI-RE6
	CHECK (ean BETWEEN 1000000000000 AND 9999999999999)
);

CREATE TABLE tem_categoria
	(ean BIGINT NOT NULL,
	nome VARCHAR(25),
	-- DUV: Qual é a primary key? 
	PRIMARY KEY (ean, nome),
	FOREIGN KEY (ean)
		REFERENCES produto(ean) ON DELETE CASCADE ON UPDATE CASCADE,
 	FOREIGN KEY (nome)
	 	REFERENCES categoria(nome) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (ean BETWEEN 1000000000000 AND 9999999999999));
    
    
 CREATE TABLE IVM
	(num_serie INT NOT NULL,
	fabricante VARCHAR(25) NOT NULL,
	PRIMARY KEY (num_serie,fabricante));
    
    
 CREATE TABLE ponto_de_retalho
	(nome VARCHAR(25) NOT NULL,
	distrito VARCHAR(25) NOT NULL,
	conselho VARCHAR(25) NOT NULL,
	PRIMARY KEY (nome));


CREATE TABLE instalada_em
	(num_serie INT NOT NULL,
	fabricante VARCHAR(25) NOT NULL,
	nome_local VARCHAR(25) NOT NULL,
	PRIMARY KEY (num_serie,fabricante),
	FOREIGN KEY (num_serie,fabricante)
		REFERENCES IVM(num_serie,fabricante) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (nome_local)
		REFERENCES ponto_de_retalho(nome) ON DELETE CASCADE ON UPDATE CASCADE);
        
CREATE TABLE prateleira
	(nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(25),
	altura INT NOT NULL,
	nome VARCHAR(25),
	PRIMARY KEY (nro,num_serie,fabricante),
	FOREIGN KEY (num_serie,fabricante)
		REFERENCES IVM(num_serie,fabricante) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (nome)
		REFERENCES categoria(nome) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (altura > 0));
    
CREATE TABLE planograma
	(ean BIGINT NOT NULL,
	nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(25) NOT NULL,
	faces INT NOT NULL,
	unidades INT NOT NULL,
	loc INT NOT NULL,
	PRIMARY KEY (ean,nro,num_serie,fabricante),
	FOREIGN KEY (ean)
		REFERENCES produto(ean) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (nro,num_serie,fabricante)
		REFERENCES prateleira(nro,num_serie,fabricante) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (faces > 0),
	CHECK (unidades > -1));
    
CREATE TABLE retalhista
	(tin INT NOT NULL,
	nome VARCHAR(25),
	PRIMARY KEY (tin),
	-- RI-RE7
	UNIQUE (nome));

CREATE TABLE responsavel_por
	(nome_cat VARCHAR(25) NOT NULL,
	tin INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(25) NOT NULL,
	PRIMARY KEY (num_serie,fabricante),
	FOREIGN KEY (num_serie,fabricante)
		REFERENCES IVM(num_serie,fabricante) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (tin)
		REFERENCES retalhista(tin) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (nome_cat)
		REFERENCES categoria(nome));
        
CREATE TABLE evento_reposicao
	(ean BIGINT NOT NULL,
	nro INT NOT NULL,
	num_serie INT NOT NULL,
	fabricante VARCHAR(25) NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INT NOT NULL,
	tin INT NOT NULL,
	PRIMARY KEY (ean,nro,num_serie,fabricante,instante),
	FOREIGN KEY (ean,nro,num_serie,fabricante)
		REFERENCES planograma(ean,nro,num_serie,fabricante),
	FOREIGN KEY (tin)
		REFERENCES retalhista(tin),
	-- TODO: RI-RE8
	CHECK (unidades > 0),
	CHECK (ean BETWEEN 1000000000000 AND 9999999999999));

