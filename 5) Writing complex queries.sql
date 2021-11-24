/* subqueries-->Query inside a sql query
At first subqury is executed and then it is used in query*/
use sql_store;
SELECT *
from products
WHERE unit_price>(
	SELECT unit_price
    from products
    where product_id=3
);

/*practice eg*/
use sql_hr;
select *
from employees
where salary>(
	select 
		AVG(salary)
	from employees
);

/* the IN opertor*/
use sql_store;
Select *
from products
where product_id NOT IN(
	SELECT Distinct product_id
	from order_items
);

/*practice eg*/ 
use sql_invoicing;
select *
from clients
where client_id NOT IN(
	select client_id 
    from invoices
);

/*subqueries v/s joins*/
/*above query using join*/
select *
from clients
LEFT JOIN invoices
	USING(client_id)
WHERE invoice_id is NULL;

/*practice eg*/
/*using subqury*/
use sql_store;
select 
	customer_id,
    first_name,
    last_name
from customers
where customer_id IN(
	select orders.customer_id
    from order_items
    JOIN orders
		USING(order_id)
    where product_id=3
);

/*using join*/
select 
	DISTINCT customer_id,
    first_name,
    last_name
from customers
JOIN orders
	USING(customer_id)
JOIN order_items
	USING(order_id)
WHERE order_items.product_id=3;

/*ALL keyword-->The ALL command returns true if all of the subquery values meet the condition
It compares with the list of values*/
use sql_invoicing;
select *
from invoices
where invoice_total>(
	select MAX(invoice_total)
	from invoices
	where client_id=3
);

select *
from invoices
where invoice_total>ALL(
	select invoice_total
	from invoices
	where client_id=3
);

/*	ANY keyword -->ANY means that the condition will be true if the operation is true for any of the values in the range.
	=any <--> IN		**any of the two can be used**
*/
select *
from invoices
where invoice_total>ANY(
	select invoice_total
	from invoices
	where client_id=3
);

select *
from clients
where client_id IN(
	select client_id
	from invoices
	GROUP BY client_id
	HAVING COUNT(*)>=2
);
/*Equivalent query using ANY*/
select *
from clients
where client_id =ANY(
	select client_id
	from invoices
	GROUP BY client_id
	HAVING COUNT(*)>=2
);

/*corelated subqueries-->query and subquery has coorelation among them*/
use sql_hr;
SELECT *
from employees e
where salary>(
	select AVG(salary)
    from employees
    WHERE office_id=e.office_id
);

/*practice eg*/
use sql_invoicing;
SELECT *
from invoices i 
where invoice_total>(
	select AVG(invoice_total)
    from invoices
    where i.client_id=client_id
    group by client_id
);

/*The EXISTS operator*/
SELECT *
from clients c
where EXISTS(
	select client_id
    from invoices
    where client_id=c.client_id
);

/*practice eg*/
use sql_store;
select *
from products p
where NOT EXISTS(
	select product_id
    from order_items
    WHERE product_id=p.product_id
);

/*subqueries in SELECT statement*/
use sql_invoicing;
SELECT 
	invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total)
		from invoices) as invoice_average,
	invoice_total-(select invoice_average) as diff
from invoices;

/*practice eg*/
select 
	client_id,
    name,
	(select sum(invoice_total)
    from invoices
    where c.client_id=client_id) as total_sales,
    (SELECT AVG(invoice_total)
	from invoices) as average,
    (select total_sales)-(select average) as Difference
from clients c;

/*subqueries in FROM statement*/
select *
from(
select 
	client_id,
    name,
	(select sum(invoice_total)
    from invoices
    where c.client_id=client_id) as total_sales,
    (SELECT AVG(invoice_total)
	from invoices) as average,
    (select total_sales)-(select average) as Difference
	from clients c
) as total_summary
where total_sales is NOT NULL;
