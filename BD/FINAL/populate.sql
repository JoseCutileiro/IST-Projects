-- PARTE 1: [AMOSTRAS]

-- Lets populate the table :) 
-- This fill up statements wont be generated randomly for debug porpuses 


-- ##### Categoria | Categoria_simples | Super_Categoria | tem_outra #####

------ Congelados e carnes,legumes,pre-cozinhados ------  

INSERT INTO categoria
VALUES ('Congelados');

INSERT INTO super_categoria
VALUES ('Congelados');

INSERT INTO categoria
VALUES ('Carnes');

INSERT INTO categoria_simples
VALUES ('Carnes');

INSERT INTO tem_outra
VALUES ('Congelados','Carnes');

INSERT INTO categoria
VALUES ('Legumes');

INSERT INTO categoria_simples
VALUES ('Legumes');

INSERT INTO tem_outra
VALUES ('Congelados','Legumes');

INSERT INTO categoria
VALUES ('Pre-cozinhados');

INSERT INTO categoria_simples
VALUES ('Pre-cozinhados');

INSERT INTO tem_outra
VALUES ('Congelados','Pre-cozinhados');

------ Sobremesas e gomas,chocolates,frutas,bolos ------ 

INSERT INTO categoria
VALUES ('Sobremesas');

INSERT INTO super_categoria
VALUES ('Sobremesas');

INSERT INTO categoria
VALUES ('Gomas');

INSERT INTO categoria_simples
VALUES ('Gomas');

INSERT INTO tem_outra
VALUES ('Sobremesas','Gomas');

INSERT INTO categoria
VALUES ('Frutas');

INSERT INTO categoria_simples
VALUES ('Frutas');

INSERT INTO tem_outra
VALUES ('Sobremesas','Frutas');

INSERT INTO categoria
VALUES ('Bolos');

INSERT INTO super_categoria
VALUES ('Bolos');

INSERT INTO tem_outra
VALUES ('Sobremesas','Bolos');

INSERT INTO categoria
VALUES ('Bolo-Chocolate');

INSERT INTO categoria_simples
VALUES ('Bolo-Chocolate');

INSERT INTO tem_outra
VALUES ('Bolos','Bolo-Chocolate');

INSERT INTO categoria
VALUES ('Bolo-Morango');

INSERT INTO categoria_simples
VALUES ('Bolo-Morango');

INSERT INTO tem_outra
VALUES ('Bolos','Bolo-Morango');

INSERT INTO categoria
VALUES ('Bolo-Cenoura');

INSERT INTO categoria_simples
VALUES ('Bolo-Cenoura');

INSERT INTO tem_outra
VALUES ('Bolos','Bolo-Cenoura');

-- ######################### Produtos #########################


-- 1) CONGELADOS
 
INSERT INTO produto
VALUES (2000000000001,'Carnes','Uma bela carne de porco, 250g de pura delícia');

INSERT INTO produto
VALUES (2000000000002,'Carnes','Carne de vaca, 300g');

INSERT INTO produto
VALUES (2000000000003,'Carnes','Bife de frango, 1 frango inteiro');

INSERT INTO produto
VALUES (2000000000004,'Legumes','Batata Congelada');

INSERT INTO produto
VALUES (2000000000005,'Legumes','Cenoura Congelada');

INSERT INTO produto
VALUES (2000000000006,'Legumes','Ervilhas Congeladas');

INSERT INTO produto
VALUES (2000000000007,'Pre-cozinhados','Pizza');

INSERT INTO produto
VALUES (2000000000008,'Pre-cozinhados','Douradinhos');

INSERT INTO produto
VALUES (2000000000009,'Pre-cozinhados','Nuggetas');

-- 2) SOBREMESAS

INSERT INTO produto
VALUES (2000000000010,'Gomas','Haribo Ursinhos :)');

INSERT INTO produto
VALUES (2000000000011,'Gomas','Haribo Tijolos');

INSERT INTO produto
VALUES (2000000000012,'Gomas','Haribo Mix');

INSERT INTO produto
VALUES (2000000000013,'Frutas','Uvas');

INSERT INTO produto
VALUES (2000000000014,'Frutas','Laranja :)');

INSERT INTO produto
VALUES (2000000000015,'Frutas','Papaia (uma fruta tropical muito popular)');

INSERT INTO produto
VALUES (2000000000016,'Frutas','Morangos :)');

INSERT INTO produto
VALUES (2000000000017,'Bolo-Chocolate','[CHOC] Bolo com pepitas');

INSERT INTO produto
VALUES (2000000000018,'Bolo-Chocolate','[CHOC] Bolo com recheio extra');

INSERT INTO produto
VALUES (2000000000019,'Bolo-Morango','[MOR] Bolo com recheio extra');

INSERT INTO produto
VALUES (2000000000020,'Bolo-Cenoura','[CEN] Bolo com passas');

-- ######################### TEM CATEGORIA #########################

INSERT INTO tem_categoria
VALUES (2000000000001,'Carnes');

INSERT INTO tem_categoria
VALUES (2000000000002,'Carnes');

INSERT INTO tem_categoria
VALUES (2000000000003,'Carnes');

INSERT INTO tem_categoria
VALUES (2000000000004,'Legumes');

INSERT INTO tem_categoria
VALUES (2000000000005,'Legumes');

INSERT INTO tem_categoria
VALUES (2000000000006,'Legumes');

INSERT INTO tem_categoria
VALUES (2000000000007,'Pre-cozinhados');

INSERT INTO tem_categoria
VALUES (2000000000008,'Pre-cozinhados');

INSERT INTO tem_categoria
VALUES (2000000000009,'Pre-cozinhados');

INSERT INTO tem_categoria
VALUES (2000000000010,'Gomas');

INSERT INTO tem_categoria
VALUES (2000000000011,'Gomas');

INSERT INTO tem_categoria
VALUES (2000000000012,'Gomas');

INSERT INTO tem_categoria
VALUES (2000000000013,'Frutas');

INSERT INTO tem_categoria
VALUES (2000000000014,'Frutas');

INSERT INTO tem_categoria
VALUES (2000000000015,'Frutas');

INSERT INTO tem_categoria
VALUES (2000000000016,'Frutas');

INSERT INTO tem_categoria
VALUES (2000000000017,'Bolo-Chocolate');

INSERT INTO tem_categoria
VALUES (2000000000018,'Bolo-Chocolate');

INSERT INTO tem_categoria
VALUES (2000000000019,'Bolo-Morango');

INSERT INTO tem_categoria
VALUES (2000000000020,'Bolo-Cenoura');

-- ######################### IVM #########################

INSERT INTO ivm
VALUES (1,'Marta Linda');

INSERT INTO ivm
VALUES (2,'Leonor Mais Linda');

INSERT INTO ivm
VALUES (3,'Palmira Sequeira');

INSERT INTO ivm
VALUES (4,'Graca Vale');

INSERT INTO ivm
VALUES (5,'Maria Domingas');

INSERT INTO ivm
VALUES (6,'1');

INSERT INTO ivm
VALUES (7,'2');

INSERT INTO ivm
VALUES (8,'3');

INSERT INTO ivm
VALUES (9,'4');

INSERT INTO ivm
VALUES (10,'5');

INSERT INTO ivm
VALUES (11,'6');

INSERT INTO ivm
VALUES (12,'7');

INSERT INTO ivm
VALUES (13,'8');

INSERT INTO ivm
VALUES (14,'9');

INSERT INTO ivm
VALUES (15,'10');

INSERT INTO ivm
VALUES (16,'11');

INSERT INTO ivm
VALUES (17,'12');

INSERT INTO ivm
VALUES (18,'13');

INSERT INTO ivm
VALUES (19,'14');

INSERT INTO ivm
VALUES (20,'15');

INSERT INTO ivm
VALUES (21,'16');




-- ######################### Ponto de retalho #########################

INSERT INTO ponto_de_retalho
VALUES ('Galp Elvas','Portalegre','Elvas');

INSERT INTO ponto_de_retalho
VALUES ('Terrinha do PORTO','Porto','Portinho');

INSERT INTO ponto_de_retalho
VALUES ('El-Faro','Badajoz','Olivencia');

-- ######################### instalada_em #########################

INSERT INTO instalada_em
VALUES (1,'Marta Linda','Galp Elvas');

INSERT INTO instalada_em
VALUES (2,'Leonor Mais Linda','Galp Elvas');

INSERT INTO instalada_em
VALUES (3,'Palmira Sequeira','Terrinha do PORTO');

INSERT INTO instalada_em
VALUES (4,'Graca Vale','El-Faro');

INSERT INTO instalada_em
VALUES (5,'Maria Domingas','El-Faro');

-- ######################### prateleira #########################

------------------- MARTA LINDA -----------------------
INSERT INTO prateleira
VALUES (1,1,'Marta Linda',5,'Carnes');

INSERT INTO prateleira
VALUES (2,1,'Marta Linda',4,'Carnes');

INSERT INTO prateleira
VALUES (3,1,'Marta Linda',3,'Carnes');

INSERT INTO prateleira
VALUES (4,1,'Marta Linda',5,'Carnes');

INSERT INTO prateleira
VALUES (5,1,'Marta Linda',6,'Carnes');

-----------------LEONOR MAIS LINDA-------------------
INSERT INTO prateleira
VALUES (1,2,'Leonor Mais Linda',6,'Bolo-Chocolate');

INSERT INTO prateleira
VALUES (2,2,'Leonor Mais Linda',8,'Bolo-Chocolate');

INSERT INTO prateleira
VALUES (3,2,'Leonor Mais Linda',2,'Frutas');

INSERT INTO prateleira
VALUES (4,2,'Leonor Mais Linda',3,'Frutas');

INSERT INTO prateleira
VALUES (5,2,'Leonor Mais Linda',4,'Gomas');

-----------------PALMIRA SEQUEIRA-------------------
INSERT INTO prateleira
VALUES (1,3,'Palmira Sequeira',3,'Bolo-Chocolate');

INSERT INTO prateleira
VALUES (2,3,'Palmira Sequeira',3,'Bolo-Morango');

INSERT INTO prateleira
VALUES (3,3,'Palmira Sequeira',4,'Frutas');

-----------------GRAÇA VALE-------------------
INSERT INTO prateleira
VALUES (1,4,'Graca Vale',3,'Gomas');

INSERT INTO prateleira
VALUES (2,4,'Graca Vale',3,'Gomas');

INSERT INTO prateleira
VALUES (3,4,'Graca Vale',3,'Gomas');

INSERT INTO prateleira
VALUES (4,4,'Graca Vale',3,'Gomas');

-----------------MARIA DOMINGAS-------------------
INSERT INTO prateleira
VALUES (1,5,'Maria Domingas',4,'Legumes');

INSERT INTO prateleira
VALUES (2,5,'Maria Domingas',4,'Gomas');

INSERT INTO prateleira
VALUES (3,5,'Maria Domingas',4,'Pre-cozinhados');

INSERT INTO prateleira
VALUES (4,5,'Maria Domingas',3,'Frutas');

INSERT INTO prateleira
VALUES (5,5,'Maria Domingas',3,'Bolo-Cenoura');



-- ##############################################################
-- ######################### PLANOGRAMA #########################
-- ##############################################################


-- EAN | [NRO,NUMSERIE,FABRICANTE] | FACES | UNIDADES | LOC


-- 1) MARTA

INSERT INTO planograma
VALUES (2000000000001,1,1,'Marta Linda',4,40,50);

INSERT INTO planograma
VALUES (2000000000002,2,1,'Marta Linda',4,32,40);

INSERT INTO planograma
VALUES (2000000000002,3,1,'Marta Linda',4,12,30);

INSERT INTO planograma
VALUES (2000000000003,4,1,'Marta Linda',4,20,20);

INSERT INTO planograma
VALUES (2000000000003,5,1,'Marta Linda',4,11,10);

-- 2) LEONOR

INSERT INTO planograma
VALUES (2000000000017,1,2,'Leonor Mais Linda',2,21,11);

INSERT INTO planograma
VALUES (2000000000018,2,2,'Leonor Mais Linda',2,21,12);

INSERT INTO planograma
VALUES (2000000000014,3,2,'Leonor Mais Linda',2,10,13);

INSERT INTO planograma
VALUES (2000000000014,4,2,'Leonor Mais Linda',3,44,14);

INSERT INTO planograma
VALUES (2000000000011,5,2,'Leonor Mais Linda',5,32,15);

-- 3) PALMIRA

INSERT INTO planograma
VALUES (2000000000018,1,3,'Palmira Sequeira',2,20,11);

INSERT INTO planograma
VALUES (2000000000019,2,3,'Palmira Sequeira',2,10,22);

INSERT INTO planograma
VALUES (2000000000013,3,3,'Palmira Sequeira',2,20,33);

-- 4) GRAÇA

INSERT INTO planograma
VALUES (2000000000011,1,4,'Graca Vale',2,20,11);

INSERT INTO planograma
VALUES (2000000000011,2,4,'Graca Vale',3,20,22);

INSERT INTO planograma
VALUES (2000000000012,3,4,'Graca Vale',4,20,33);

INSERT INTO planograma
VALUES (2000000000012,4,4,'Graca Vale',2,20,44);

-- 5) MARIA

INSERT INTO planograma
VALUES (2000000000005,1,5,'Maria Domingas',10,21,11);

INSERT INTO planograma
VALUES (2000000000010,2,5,'Maria Domingas',9,23,12);

INSERT INTO planograma
VALUES (2000000000009,3,5,'Maria Domingas',8,27,13);

INSERT INTO planograma
VALUES (2000000000016,4,5,'Maria Domingas',6,28,14);

INSERT INTO planograma
VALUES (2000000000020,5,5,'Maria Domingas',4,29,15);

-- ##################### RETALHISTA #####################

INSERT INTO retalhista
VALUES (1,'Joel');

INSERT INTO retalhista
VALUES (2,'Lucas');

INSERT INTO retalhista
VALUES (3,'Fred');

INSERT INTO retalhista
VALUES (4,'Toulous');

INSERT INTO retalhista
VALUES (5,'Julio');

-- ##################### RESPONSAVEL POR #####################

-- 1) JOEL [CARNES]

INSERT INTO responsavel_por
VALUES ('Carnes',1,1,'Marta Linda');

INSERT INTO responsavel_por
VALUES ('Bolos',1,2,'Leonor Mais Linda');

-- 2) LUCAS [BOLOS]


INSERT INTO responsavel_por
VALUES ('Gomas',2,3,'Palmira Sequeira');


-- 3) FRED [GOMAS]


INSERT INTO responsavel_por
VALUES ('Frutas',3,4,'Graca Vale');

INSERT INTO responsavel_por
VALUES ('Pre-cozinhados',3,5,'Maria Domingas');


-- ##################### EVENTO DE REPOSICAO #####################

INSERT INTO evento_reposicao
VALUES(2000000000005,1,5,'Maria Domingas','1989-02-02 20:23:52',2,5);

INSERT INTO evento_reposicao
VALUES(2000000000005,1,5,'Maria Domingas','1992-03-02 21:10:10',2,5);

INSERT INTO evento_reposicao
VALUES(2000000000005,1,5,'Maria Domingas','1994-01-02 19:09:01',2,5);

INSERT INTO evento_reposicao
VALUES(2000000000005,1,5,'Maria Domingas','1994-01-02 19:14:54',2,5);

INSERT INTO evento_reposicao
VALUES (2000000000012,4,4,'Graca Vale','1995-01-03 17:12:32',2,3);

INSERT INTO evento_reposicao
VALUES (2000000000012,4,4,'Graca Vale','1996-02-04 13:11:22',2,3);

INSERT INTO evento_reposicao
VALUES (2000000000012,4,4,'Graca Vale','1996-01-03 17:12:02',2,3);

INSERT INTO evento_reposicao
VALUES (2000000000012,4,4,'Graca Vale','1996-01-03 19:12:02',2,5);

-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################
-- #################################################################################

-- PARTE 2: [AMOSTRAS]

-- Lets populate the table :) 
-- This fill up statements wont be generated randomly for debug porpuses 

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Categoria $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

--Bebidas e refrigerantes, aguas, bebidas alcolicas

INSERT INTO categoria
VALUES ('Bebidas');

INSERT INTO super_categoria
VALUES ('Bebidas');

INSERT INTO categoria
VALUES ('Refrigerantes');

INSERT INTO categoria_simples
VALUES ('Refrigerantes');

INSERT INTO tem_outra
VALUES ('Bebidas','Refrigerantes');

INSERT INTO categoria
VALUES ('Aguas');

INSERT INTO categoria_simples
VALUES ('Aguas');

INSERT INTO tem_outra
VALUES ('Bebidas','Aguas');

INSERT INTO categoria
VALUES ('Bebidas Alcolicas');

INSERT INTO categoria_simples
VALUES ('Bebidas Alcolicas');

INSERT INTO tem_outra
VALUES ('Bebidas','Bebidas Alcolicas');

--Snacks e Batatas Fritas,Docinhos,Sandes'
INSERT INTO categoria
VALUES ('Snacks');

INSERT INTO super_categoria
VALUES ('Snacks');

INSERT INTO categoria
VALUES ('Batatas Fritas');

INSERT INTO categoria_simples
VALUES ('Batatas Fritas');

INSERT INTO tem_outra
VALUES ('Snacks','Batatas Fritas');

INSERT INTO categoria
VALUES ('Docinhos');

INSERT INTO categoria_simples
VALUES ('Docinhos');

INSERT INTO tem_outra
VALUES ('Snacks','Docinhos');

INSERT INTO categoria
VALUES ('Sandes');

INSERT INTO super_categoria
VALUES ('Sandes');

INSERT INTO tem_outra
VALUES ('Snacks','Sandes');

INSERT INTO categoria
VALUES ('Sandes-Mista');

INSERT INTO categoria_simples
VALUES ('Sandes-Mista');

INSERT INTO tem_outra
VALUES ('Sandes','Sandes-Mista');

INSERT INTO categoria
VALUES ('Sandes-Atum');

INSERT INTO categoria_simples
VALUES ('Sandes-Atum');

INSERT INTO tem_outra
VALUES ('Sandes','Sandes-Atum');

INSERT INTO categoria
VALUES ('Sandes-Carne');

INSERT INTO categoria_simples
VALUES ('Sandes-Carne');

INSERT INTO tem_outra
VALUES ('Sandes','Sandes-Carne');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Produto $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- 1); Bebidas

INSERT INTO produto
VALUES (1000000000000,'Refrigerantes','Coca-Cola');

INSERT INTO produto
VALUES (1000000000001,'Refrigerantes','Ice-Tea');

INSERT INTO produto
VALUES (1000000000002,'Refrigerantes','Fanta');

INSERT INTO produto
VALUES (1000000000003,'Aguas','Agua do Luso');

INSERT INTO produto
VALUES (1000000000004,'Aguas','Agua do Monchique');

INSERT INTO produto
VALUES (1000000000005,'Bebidas Alcolicas','Cerveja');

INSERT INTO produto
VALUES (1000000000006,'Bebidas Alcolicas','Gin');

INSERT INTO produto
VALUES (1000000000007,'Bebidas Alcolicas','Vinho');

-- 2); Snacks

INSERT INTO produto
VALUES (1000000000008,'Batatas Fritas','Ruffles Normais');

INSERT INTO produto
VALUES (1000000000009,'Batatas Fritas','Ruffles Presunto');

INSERT INTO produto
VALUES (1000000000010,'Batatas Fritas','Lays');

INSERT INTO produto
VALUES (1000000000011,'Batatas Fritas','Doritos');

INSERT INTO produto
VALUES (1000000000012,'Docinhos','Palmiers');

INSERT INTO produto
VALUES (1000000000013,'Docinhos','Linguas de Veado');

INSERT INTO produto
VALUES (1000000000014,'Docinhos','Linguas de Gato');

INSERT INTO produto
VALUES (1000000000015,'Docinhos','Docinho dos Acores');

INSERT INTO produto
VALUES (1000000000016,'Docinhos','Meio Dedo');

INSERT INTO produto
VALUES (1000000000017,'Sandes-Mista','[MIS] Sandes Mista com manteiga');

INSERT INTO produto
VALUES (1000000000018,'Sandes-Mista','[MIS] Sandes Mista sem manteiga');

INSERT INTO produto
VALUES (1000000000019,'Sandes-Atum','[ATU] Sandes Atum com ovo');

INSERT INTO produto
VALUES (1000000000020,'Sandes-Atum','[ATU] Sandes Atum sem ovo');

INSERT INTO produto
VALUES (1000000000021,'Sandes-Carne','[CAR] Sandes Panado');

INSERT INTO produto
VALUES (1000000000022,'Sandes-Carne','[CAR] Sandes Carne-Assada');

INSERT INTO produto
VALUES (1000000000023,'Sandes-Carne','[CAR] Sandes Presunto');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ TEM CATEGORIA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- 1); Bebidas

INSERT INTO tem_categoria
VALUES (1000000000000,'Refrigerantes');

INSERT INTO tem_categoria
VALUES (1000000000001,'Refrigerantes');

INSERT INTO tem_categoria
VALUES (1000000000002,'Refrigerantes');

INSERT INTO tem_categoria
VALUES (1000000000003,'Aguas');

INSERT INTO tem_categoria
VALUES (1000000000004,'Aguas');

INSERT INTO tem_categoria
VALUES (1000000000005,'Bebidas Alcolicas');

INSERT INTO tem_categoria
VALUES (1000000000006,'Bebidas Alcolicas');

INSERT INTO tem_categoria
VALUES (1000000000007,'Bebidas Alcolicas');

-- 2); Snacks

INSERT INTO tem_categoria
VALUES (1000000000008,'Batatas Fritas');

INSERT INTO tem_categoria
VALUES (1000000000009,'Batatas Fritas');

INSERT INTO tem_categoria
VALUES (1000000000010,'Batatas Fritas');

INSERT INTO tem_categoria
VALUES (1000000000011,'Batatas Fritas');

INSERT INTO tem_categoria
VALUES (1000000000012,'Docinhos');

INSERT INTO tem_categoria
VALUES (1000000000013,'Docinhos');

INSERT INTO tem_categoria
VALUES (1000000000014,'Docinhos');

INSERT INTO tem_categoria
VALUES (1000000000015,'Docinhos');

INSERT INTO tem_categoria
VALUES (1000000000016,'Docinhos');

INSERT INTO tem_categoria
VALUES (1000000000017,'Sandes-Mista');

INSERT INTO tem_categoria
VALUES (1000000000018,'Sandes-Mista');

INSERT INTO tem_categoria
VALUES (1000000000019,'Sandes-Atum');

INSERT INTO tem_categoria
VALUES (1000000000020,'Sandes-Atum');

INSERT INTO tem_categoria
VALUES (1000000000021,'Sandes-Carne');

INSERT INTO tem_categoria
VALUES (1000000000022,'Sandes-Carne');

INSERT INTO tem_categoria
VALUES (1000000000023,'Sandes-Carne');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ IVM $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

INSERT INTO ivm
VALUES (69,'Zezinho');

INSERT INTO ivm
VALUES (70,'Goncalo o Hulk');

INSERT INTO ivm
VALUES (71,'Valadao Do Vale');

INSERT INTO ivm
VALUES (72,'Bernardo Acoreano');

INSERT INTO ivm
VALUES (73,'Francisco Delas');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ PONTO DE RETALHO $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

INSERT INTO ponto_de_retalho
VALUES ('Metro Moscavide', 'Lisboa', 'Loures'); 

INSERT INTO ponto_de_retalho
VALUES ('Praia da Falesia', 'Algarve', 'Albufeira');

INSERT INTO ponto_de_retalho
VALUES ('Ponte Velha', 'Viana do Castelo', 'Ponte de Lima');

INSERT INTO ponto_de_retalho
VALUES ('Associacao Agricula', 'Sao Miguel', 'Ribeira Grande');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ INSTALADA_EM $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

INSERT INTO instalada_em
VALUES (69,'Zezinho','Metro Moscavide');

INSERT INTO instalada_em
VALUES (70,'Goncalo o Hulk','Praia da Falesia');

INSERT INTO instalada_em
VALUES (71,'Valadao Do Vale','Ponte Velha');

INSERT INTO instalada_em
VALUES (72,'Bernardo Acoreano','Associacao Agricula');

INSERT INTO instalada_em
VALUES (73,'Francisco Delas','Praia da Falesia');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ PRATELEIRA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-------------------- ZEZINHO --------------------

INSERT INTO prateleira
VALUES (1,69,'Zezinho',5,'Refrigerantes');

INSERT INTO prateleira
VALUES (2,69,'Zezinho',4,'Refrigerantes');

INSERT INTO prateleira
VALUES (3,69,'Zezinho',4,'Refrigerantes');

INSERT INTO prateleira
VALUES (4,69,'Zezinho',3,'Refrigerantes');

INSERT INTO prateleira
VALUES (5,69,'Zezinho',5,'Aguas');

INSERT INTO prateleira
VALUES (6,69,'Zezinho',5,'Aguas');

INSERT INTO prateleira
VALUES (7,69,'Zezinho',3,'Aguas');

INSERT INTO prateleira
VALUES (8,69,'Zezinho',5,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (9,69,'Zezinho',5,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (10,69,'Zezinho',5,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (11,69,'Zezinho',5,'Bebidas Alcolicas');

-------------------- Goncalo O HULK --------------------

INSERT INTO prateleira
VALUES (1,70,'Goncalo o Hulk',5,'Batatas Fritas');

INSERT INTO prateleira
VALUES (2,70,'Goncalo o Hulk',4,'Batatas Fritas');

INSERT INTO prateleira
VALUES (3,70,'Goncalo o Hulk',4,'Batatas Fritas');

INSERT INTO prateleira
VALUES (4,70,'Goncalo o Hulk',3,'Batatas Fritas');

INSERT INTO prateleira
VALUES (5,70,'Goncalo o Hulk',5,'Docinhos');

INSERT INTO prateleira
VALUES (6,70,'Goncalo o Hulk',5,'Docinhos');

-------------------- VALADAO DO VALE --------------------

INSERT INTO prateleira
VALUES (1,71,'Valadao Do Vale',5,'Sandes-Carne');

INSERT INTO prateleira
VALUES (2,71,'Valadao Do Vale',4,'Sandes-Atum');

INSERT INTO prateleira
VALUES (3,71,'Valadao Do Vale',4,'Sandes-Mista');

INSERT INTO prateleira
VALUES (4,71,'Valadao Do Vale',3,'Sandes-Mista');

INSERT INTO prateleira
VALUES (5,71,'Valadao Do Vale',5,'Aguas');

INSERT INTO prateleira
VALUES (6,71,'Valadao Do Vale',5,'Aguas');

INSERT INTO prateleira
VALUES (7,71,'Valadao Do Vale',3,'Aguas');

INSERT INTO prateleira
VALUES (8,71,'Valadao Do Vale',4,'Batatas Fritas');

INSERT INTO prateleira
VALUES (9,71,'Valadao Do Vale',3,'Batatas Fritas');

INSERT INTO prateleira
VALUES (10,71,'Valadao Do Vale',5,'Docinhos');

INSERT INTO prateleira
VALUES (11,71,'Valadao Do Vale',5,'Docinhos');

-------------------- BERNARDO ACOREANO --------------------

INSERT INTO prateleira
VALUES (1,72,'Bernardo Acoreano',5,'Sandes-Carne');

INSERT INTO prateleira
VALUES (2,72,'Bernardo Acoreano',4,'Sandes-Atum');

INSERT INTO prateleira
VALUES (3,72,'Bernardo Acoreano',4,'Sandes-Mista');

INSERT INTO prateleira
VALUES (4,72,'Bernardo Acoreano',3,'Sandes-Mista');

INSERT INTO prateleira
VALUES (5,72,'Bernardo Acoreano',5,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (6,72,'Bernardo Acoreano',5,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (7,72,'Bernardo Acoreano',3,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (8,72,'Bernardo Acoreano',4,'Docinhos');

INSERT INTO prateleira
VALUES (9,72,'Bernardo Acoreano',3,'Docinhos');

INSERT INTO prateleira
VALUES (10,72,'Bernardo Acoreano',5,'Docinhos');

INSERT INTO prateleira
VALUES (11,72,'Bernardo Acoreano',5,'Docinhos');

-------------------- FRANCISCO DELAS --------------------

INSERT INTO prateleira
VALUES (1,73,'Francisco Delas',5,'Sandes-Carne');

INSERT INTO prateleira
VALUES (2,73,'Francisco Delas',4,'Sandes-Atum');

INSERT INTO prateleira
VALUES (3,73,'Francisco Delas',4,'Sandes-Mista');

INSERT INTO prateleira
VALUES (4,73,'Francisco Delas',3,'Sandes-Mista');

INSERT INTO prateleira
VALUES (5,73,'Francisco Delas',5,'Sandes-Carne');

INSERT INTO prateleira
VALUES (6,73,'Francisco Delas',5,'Sandes-Carne');

INSERT INTO prateleira
VALUES (7,73,'Francisco Delas',3,'Aguas');

INSERT INTO prateleira
VALUES (8,73,'Francisco Delas',4,'Batatas Fritas');

INSERT INTO prateleira
VALUES (9,73,'Francisco Delas',3,'Batatas Fritas');

INSERT INTO prateleira
VALUES (10,73,'Francisco Delas',5,'Refrigerantes');

INSERT INTO prateleira
VALUES (11,73,'Francisco Delas',5,'Refrigerantes');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ PLANOGRAMA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-------------------- ZEZINHO --------------------

INSERT INTO planograma 
VALUES (1000000000000,1,69,'Zezinho',4,22,1);

INSERT INTO planograma 
VALUES (1000000000001,2,69,'Zezinho',4,44,1);

INSERT INTO planograma 
VALUES (1000000000002,3,69,'Zezinho',4,53,1);

INSERT INTO planograma 
VALUES (1000000000000,4,69,'Zezinho',4,76,1);

INSERT INTO planograma 
VALUES (1000000000003,5,69,'Zezinho',4,84,1);

INSERT INTO planograma 
VALUES (1000000000003,6,69,'Zezinho',4,64,1);

INSERT INTO planograma 
VALUES (1000000000004,7,69,'Zezinho',4,255,1);

INSERT INTO planograma 
VALUES (1000000000005,8,69,'Zezinho',4,80,1);

INSERT INTO planograma 
VALUES (1000000000005,9,69,'Zezinho',4,6761,1);

INSERT INTO planograma 
VALUES (1000000000007,10,69,'Zezinho',4,640,1);

INSERT INTO planograma 
VALUES (1000000000006,11,69,'Zezinho',4,53,1);

-------------------- Goncalo O HULK --------------------

INSERT INTO planograma 
VALUES (1000000000008,1,70,'Goncalo o Hulk',3,150,2);

INSERT INTO planograma 
VALUES (1000000000010,2,70,'Goncalo o Hulk',3,1500,2);

INSERT INTO planograma 
VALUES (1000000000009,3,70,'Goncalo o Hulk',3,1590,2);

INSERT INTO planograma 
VALUES (1000000000011,3,70,'Goncalo o Hulk',3,590,2);

INSERT INTO planograma 
VALUES (1000000000012,3,70,'Goncalo o Hulk',3,490,2);

INSERT INTO planograma 
VALUES (1000000000015,3,70,'Goncalo o Hulk',3,990,2);

-------------------- VALADAO DO VALE --------------------

INSERT INTO planograma 
VALUES (1000000000021,1,71,'Valadao Do Vale',4,22,3);

INSERT INTO planograma 
VALUES (1000000000020,2,71,'Valadao Do Vale',4,44,3);

INSERT INTO planograma 
VALUES (1000000000018,3,71,'Valadao Do Vale',4,53,3);

INSERT INTO planograma 
VALUES (1000000000017,4,71,'Valadao Do Vale',4,76,3);

INSERT INTO planograma 
VALUES (1000000000003,5,71,'Valadao Do Vale',4,84,3);

INSERT INTO planograma 
VALUES (1000000000003,6,71,'Valadao Do Vale',4,64,3);

INSERT INTO planograma 
VALUES (1000000000004,7,71,'Valadao Do Vale',4,255,3);

INSERT INTO planograma 
VALUES (1000000000010,8,71,'Valadao Do Vale',4,80,3);

INSERT INTO planograma 
VALUES (1000000000011,9,71,'Valadao Do Vale',4,6761,3);

INSERT INTO planograma 
VALUES (1000000000013,10,71,'Valadao Do Vale',4,640,3);

INSERT INTO planograma 
VALUES (1000000000014,11,71,'Valadao Do Vale',4,53,3);

-------------------- BERNARDO ACOREANO --------------------

INSERT INTO planograma 
VALUES (1000000000022,1,72,'Bernardo Acoreano',4,22,4);

INSERT INTO planograma 
VALUES (1000000000019,1,72,'Bernardo Acoreano',2,24,4);

INSERT INTO planograma 
VALUES (1000000000018,1,72,'Bernardo Acoreano',2,53,4);

INSERT INTO planograma 
VALUES (1000000000017,1,72,'Bernardo Acoreano',2,76,4);

INSERT INTO planograma 
VALUES (1000000000005,1,72,'Bernardo Acoreano',2,82,4);

INSERT INTO planograma 
VALUES (1000000000006,1,72,'Bernardo Acoreano',2,62,4);

INSERT INTO planograma 
VALUES (1000000000007,1,72,'Bernardo Acoreano',2,255,4);

INSERT INTO planograma 
VALUES (1000000000013,1,72,'Bernardo Acoreano',2,80,4);

INSERT INTO planograma 
VALUES (1000000000014,1,72,'Bernardo Acoreano',2,6761,4);

INSERT INTO planograma 
VALUES (1000000000015,1,72,'Bernardo Acoreano',2,620,4);

INSERT INTO planograma 
VALUES (1000000000016,1,72,'Bernardo Acoreano',2,53,4);

-------------------- FRANCISCO DELAS --------------------

INSERT INTO planograma 
VALUES (1000000000022,1,73,'Francisco Delas',4,22,5);

INSERT INTO planograma 
VALUES (1000000000019,2,73,'Francisco Delas',2,24,5);

INSERT INTO planograma 
VALUES (1000000000018,3,73,'Francisco Delas',4,53,5);

INSERT INTO planograma 
VALUES (1000000000017,4,73,'Francisco Delas',2,76,5);

INSERT INTO planograma 
VALUES (1000000000022,5,73,'Francisco Delas',4,82,5);

INSERT INTO planograma 
VALUES (1000000000023,6,73,'Francisco Delas',2,62,5);

INSERT INTO planograma 
VALUES (1000000000004,7,73,'Francisco Delas',4,255,5);

INSERT INTO planograma 
VALUES (1000000000009,8,73,'Francisco Delas',2,80,5);

INSERT INTO planograma 
VALUES (1000000000010,9,73,'Francisco Delas',4,6761,5);

INSERT INTO planograma 
VALUES (1000000000000,10,73,'Francisco Delas',2,620,5);

INSERT INTO planograma 
VALUES (1000000000000,11,73,'Francisco Delas',4,53,5);

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ RETALHISTA $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

INSERT INTO retalhista
VALUES (6,'Katia');

INSERT INTO retalhista
VALUES (7,'Jessica');

INSERT INTO retalhista
VALUES (8,'Goncala');

INSERT INTO retalhista
VALUES (9,'Zezinha');

INSERT INTO retalhista
VALUES (10,'Michele');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ RESPONSAVEL_POR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-------------------- KATIA --------------------

INSERT INTO responsavel_por
Values ('Refrigerantes',6,69,'Zezinho');

-------------------- JESSICA --------------------

INSERT INTO responsavel_por
Values ('Aguas',7,70,'Goncalo o Hulk');

INSERT INTO responsavel_por
Values ('Bebidas Alcolicas',7,71,'Valadao Do Vale');

INSERT INTO responsavel_por
Values ('Bebidas Alcolicas',7,72,'Bernardo Acoreano');

-------------------- GONCALA --------------------

INSERT INTO responsavel_por
VALUES ('Batatas Fritas',8,73,'Francisco Delas');

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ EVENTO REPOSICAO $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

INSERT INTO evento_reposicao
VALUES(1000000000022,1,72,'Bernardo Acoreano','2000-10-07 21:50:52',2,7);

INSERT INTO evento_reposicao
VALUES(1000000000022,1,72,'Bernardo Acoreano','2001-10-07 15:50:52',2,7);

INSERT INTO evento_reposicao
VALUES(1000000000022,1,72,'Bernardo Acoreano','2002-10-07 08:50:52',2,7);

INSERT INTO evento_reposicao
VALUES(1000000000000,10,73,'Francisco Delas','1995-12-12 08:50:52',2,6);

------------------- ------------------- -------------------
------------------  RESPEITAR QUERY #2  -------------------
------------------- ------------------- -------------------

-- ############### IVMS ################

INSERT INTO prateleira
VALUES (1,6,'1',3,'Aguas');

INSERT INTO prateleira
VALUES (1,7,'2',3,'Batatas Fritas');

INSERT INTO prateleira
VALUES (1,8,'3',3,'Bebidas Alcolicas');

INSERT INTO prateleira
VALUES (1,9,'4',3,'Bolo-Cenoura');

INSERT INTO prateleira
VALUES (1,10,'5',3,'Carnes');

INSERT INTO prateleira
VALUES (1,11,'6',3,'Bolo-Chocolate');

INSERT INTO prateleira
VALUES (1,12,'7',3,'Bolo-Morango');

INSERT INTO prateleira
VALUES (1,13,'8',3,'Docinhos');

INSERT INTO prateleira
VALUES (1,14,'9',3,'Frutas');

INSERT INTO prateleira
VALUES (1,15,'10',3,'Gomas');

INSERT INTO prateleira
VALUES (1,16,'11',3,'Legumes');

INSERT INTO prateleira
VALUES (1,17,'12',3,'Pre-cozinhados');

INSERT INTO prateleira
VALUES (1,18,'13',3,'Refrigerantes');

INSERT INTO prateleira
VALUES (1,19,'14',3,'Sandes-Atum');

INSERT INTO prateleira
VALUES (1,20,'15',3,'Sandes-Carne');

INSERT INTO prateleira
VALUES (1,21,'16',3,'Sandes-Mista');


-- ###################################

INSERT INTO retalhista
VALUES (2048,'[TUDEIRO]');

INSERT INTO responsavel_por
VALUES ('Aguas',2048,6,'1');

INSERT INTO responsavel_por
VALUES ('Batatas Fritas',2048,7,'2');

INSERT INTO responsavel_por
VALUES ('Bebidas Alcolicas',2048,8,'3');

INSERT INTO responsavel_por
VALUES ('Bolo-Cenoura',2048,9,'4');

INSERT INTO responsavel_por
VALUES ('Bolo-Chocolate',2048,10,'5');

INSERT INTO responsavel_por
VALUES ('Bolo-Morango',2048,11,'6');

INSERT INTO responsavel_por
VALUES ('Carnes',2048,12,'7');

INSERT INTO responsavel_por
VALUES ('Docinhos',2048,13,'8');

INSERT INTO responsavel_por
VALUES ('Frutas',2048,14,'9');

INSERT INTO responsavel_por
VALUES ('Gomas',2048,15,'10');

INSERT INTO responsavel_por
VALUES ('Legumes',2048,16,'11');

INSERT INTO responsavel_por
VALUES ('Pre-cozinhados',2048,17,'12');

INSERT INTO responsavel_por
VALUES ('Refrigerantes',2048,18,'13');

INSERT INTO responsavel_por
VALUES ('Sandes-Atum',2048,19,'14');

INSERT INTO responsavel_por
VALUES ('Sandes-Carne',2048,20,'15');

INSERT INTO responsavel_por
VALUES ('Sandes-Mista',2048,21,'16');
