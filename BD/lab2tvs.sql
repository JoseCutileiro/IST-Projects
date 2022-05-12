-- a)
SELECT customer_name 
FROM depositor inner join account on (depositor.account_number = account.account_number) 
WHERE account.balance > 500;

-- b)
SELECT customer_city
FROM customer inner join borrower on (customer.customer_name = borrower.customer_name) inner join loan on (borrower.loan_number = loan.loan_number)
WHERE amount BETWEEN 1000 and 2000;

-- c)
SELECT balance * 1.1
FROM account
WHERE branch_name = 'Downtown';

-- d)
SELECT balance
FROM account inner join depositor on (account.account_number = depositor.account_number) inner join borrower on (depositor.customer_name=borrower.customer_name)
WHERE loan_number = 'L-15';

-- e) 
SELECT branch_name
FROM account inner join depositor on (account.account_number = depositor.account_number)
WHERE customer_name LIKE 'J%n';

-- f)
SELECT amount
FROM loan inner join borrower on (loan.loan_number = borrower.loan_number) inner join customer on (borrower.customer_name = customer.customer_name)
WHERE Length(customer_city) = 6;

-- g)
SELECT amount
FROM loan inner join borrower on (loan.loan_number = borrower.loan_number) inner join customer on (borrower.customer_name = customer.customer_name)
WHERE customer_city LIKE '% %';

-- h)
SELECT assets
FROM depositor inner join account on (depositor.account_number = account.account_number) inner join branch on (account.branch_name = branch.branch_name)
WHERE customer_name = 'Johnson';

-- i)
SELECT customer.customer_name
FROM customer inner join borrower on (customer.customer_name = borrower.customer_name) inner join loan on (borrower.loan_number = loan.loan_number) inner join branch on (loan.branch_name = branch.branch_name)
WHERE branch_city = customer_city;

-- j)
SELECT SUM(balance)
FROM account inner join branch on (account.branch_name = branch.branch_name)
WHERE branch_city = 'Lisbon';

-- k)
SELECT DISTINCT customer_name
FROM customer inner join branch on (customer.customer_city = branch.branch_city);
