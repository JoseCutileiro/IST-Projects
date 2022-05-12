-- LAB 2 (um compilado de todas as alineas)
---------------------------------------------------------------------------------------
--  LAB 2: Query a) Quem são os clientes que têm contas com saldo superior a 500€?
-- Author: José Cutileiro

SELECT DISTINCT
	depositor.customer_name,
    account.balance
 FROM
 	(depositor INNER JOIN account ON depositor.account_number = account.account_number)
    
 -- FROM 
    -- depositor NATURAL JOIN account
 WHERE
 	account.balance > 500;
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query b) Em que cidades moram os clientes que têm empréstimos entre 1000€ e 2000€?
-- Author: José Cutileiro

SELECT DISTINCT
	customer_city

FROM
    (Customer INNER JOIN Borrower ON Customer.customer_name = Borrower.customer_name)
    								INNER JOIN
                Loan ON Borrower.loan_number = Loan.loan_number
WHERE
	 Loan.amount BETWEEN 1000 AND 2000 
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query c)  Quais seriam os novos saldos das contas na agência 
--                  de ‘Downtown’, se esta
--                  oferecesse um bónus de 10% sobre o saldo atual
-- Author: José Cutileiro

SELECT 
	account.account_number,account.balance * 1.1
FROM 
	account
WHERE
	branch_name = 'Downtown' 
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query d) Qual é o saldo de todas as contas do 
--                 cliente que tem o empréstimo L-15?
-- Author: José Cutileiro

SELECT 
	account.balance

FROM
	account account NATURAL JOIN depositor NATURAL JOIN Customer NATURAL JOIN BORROWER

WHERE
	borrower.loan_number='L-15'
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query e) Quais são as agências onde têm conta 
--                 os clientes cujo nome começa por ‘J’ e acaba em ‘n’?
-- Author: José Cutileiro


SELECT 
	Account.branch_name
FROM
	Account NATURAL JOIN Depositor
WHERE
	Depositor.customer_name LIKE 'J%n'

  ---------------------------------------------------------------------------------------
  -- LAB 2: Query f) Quais são as quantias dos empréstimos de todos 
--                 os clientes que moram numa
--                 cidade cujo nome tem exatamente 6 caracteresexatamente 6 caracteres?
-- Author: José Cutileiro

SELECT 
	loan.amount
FROM
	loan NATURAL JOIN borrower NATURAL JOIN customer
WHERE
	LENGTH(Customer.customer_city) = 6
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query g) Quais são as quantias dos 
--                 empréstimos de todos os clientes que moram numa
--                 cidade cujo nome tem pelo menos um 
--                 espaço no meio (e não no início nem no
-- 				   final)?
-- Author: José Cutileiro


SELECT
	loan.amount
FROM 
	loan NATURAL JOIN borrower NATURAL JOIN customer
WHERE
	customer.customer_city LIKE '% %'
  ---------------------------------------------------------------------------------------
  -- LAB 2: Query h) Quais os ativos (“assets”) das
--                 agências onde o Johnson temleiro

SELECT 
	branch.assets
FROM
	branch NATURAL JOIN account NATURAL JOIN depositor
WHERE
	customer_name = 'Johnson'
  ---------------------------------------------------------------------------------------
-- LAB 2: Query i) Quem sãos que têm 
--                 um empréstimo numa agência da mesma cidade
--                 onde moram?
-- Author: José Cutileiro

SELECT 
	customer.customer_name

FROM 
	customer NATURAL JOIN borrower NATURAL JOIN loan NATURAL JOIN branch

WHERE
	customer.customer_city = branch.branch_city
  ----------------------------------------------------------------------------------------
  --LAB 2: Query j) Qual é a quantia total em saldos de contas
--                existentes em agências da cidade de
--				  Lisboa (‘Lisbon’)?
-- Author: José Cutileiro


SELECT
	SUM(account.balance)

FROM 
	Account NATURAL JOIN BRANCH

WHERE
	branch.branch_city = 'Lisbon';
-----------------------------------------------------------------------------------------
-- LAB 2 (k) Quem são os clientes que moram em cidades 
--           onde existem agências do banco?
-- Author: José Cutileiro

SELECT DISTINCT 
customer_name
FROM 
customer inner join branch on (customer.customer_city = branch.branch_city);
