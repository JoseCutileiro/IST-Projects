DROP TRIGGER IF EXISTS verify_max_units_trigger ON evento_reposicao;
DROP TRIGGER IF EXISTS verify_category_trigger ON tem_outra;
DROP TRIGGER IF EXISTS verify_event_repo_trigger ON evento_reposicao;


-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Trigger RI-4 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

CREATE OR REPLACE FUNCTION verify_max_units()
RETURNS TRIGGER AS
$$
DECLARE 
	max_unidades INT;
BEGIN

	-- First we need to get the max units
    SELECT planograma.unidades INTO max_unidades 
    FROM planograma
    WHERE (planograma.ean = NEW.ean 
           AND planograma.nro = NEW.nro 
           AND planograma.num_serie = NEW.num_serie
           AND planograma.fabricante = NEW.fabricante);
    
    IF NEW.unidades > max_unidades THEN
    	RAISE EXCEPTION 'Demasiada areia para o meu camiao';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Trigger RI-1 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

CREATE OR REPLACE FUNCTION verify_category()
RETURNS TRIGGER AS
$$
DECLARE 
	categoria_primaria VARCHAR(25);
	categoria_secundaria VARCHAR(25);
BEGIN
    
    -- Traverse DB to check match
    categoria_secundaria := NEW.nome_super_categoria;
    
   	WHILE categoria_secundaria <> '' LOOP
    
      SELECT DISTINCT tem_outra.nome_super_categoria 
      INTO categoria_primaria
      FROM tem_outra
      WHERE tem_outra.nome_categoria = categoria_secundaria;
        
      IF categoria_primaria = NEW.nome_categoria THEN
          RAISE EXCEPTION 'Uma categoria nao pode estar contida em si propria';
      END IF;

      categoria_secundaria := categoria_primaria;
      
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Trigger RI-5 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

CREATE OR REPLACE FUNCTION verify_event_repo()
RETURNS TRIGGER AS
$$
DECLARE
    categoria_prateleira VARCHAR(25);
    categoria_produto VARCHAR(25);
    pai VARCHAR(25);
BEGIN

    -- 1) ENCONTRAR A CATEGORIA DA PRATELEIRA
    SELECT DISTINCT prateleira.nome INTO categoria_prateleira
    FROM prateleira
    WHERE (prateleira.nro = NEW.nro AND
          prateleira.num_serie = NEW.num_serie AND
          prateleira.fabricante = NEW.fabricante);
    
    -- 2) ENCONTRAR A CATEGORIA DO PRODUTO
    SELECT DISTINCT produto.cat INTO categoria_produto
    FROM produto
    WHERE (produto.ean = NEW.ean);

    -- 3) SUBIR PELA CATEGORIA PRODUTO VENDO SE CORRESPONDE A DA PRATELEIRA
    WHILE categoria_produto <> '' LOOP
        IF categoria_produto = categoria_prateleira THEN
            RETURN NEW;
        END IF;

        SELECT DISTINCT tem_outra.super_categoria INTO pai
        FROM tem_outra
        WHERE tem_outra.categoria = categoria_produto;

        categoria_produto := pai;
    
    END LOOP;

    RAISE EXCEPTION '[ARDEU]: Categoria produto não corresponde à da prateleira';

END;
$$ LANGUAGE plpgsql;


-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Instalar triggers $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- 1) RI-4
CREATE TRIGGER verify_max_units_trigger
BEFORE UPDATE OR INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE verify_max_units();

-- 2) RI-1
CREATE TRIGGER verify_category_trigger
BEFORE UPDATE OR INSERT ON tem_outra
FOR EACH ROW EXECUTE PROCEDURE verify_category();

-- 3) RI-5
CREATE TRIGGER verify_event_repo_trigger
BEFORE UPDATE OR INSERT ON evento_reposicao
FOR EACH ROW EXECUTE PROCEDURE verify_event_repo();