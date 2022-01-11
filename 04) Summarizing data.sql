/*AGGREGATE FUNCTIONS -> Used to perform some mathematical calculation and give result
	***Also works for dates and strings***
	MAX() -->returns maximum value
    MIN() -->returns minimum value
    AVG() -->returns average value
	SUM() -->returns sum of the values
	COUNT() -->returns count of values for given condition
*/
USE sql_invoicing;

/*Numerical values*/
select 
	MAX(invoice_total) as Maximum,
	MIN(invoice_total) as Minimum,
    AVG(invoice_total) as Average,
    SUM(invoice_total) as total_sum,
	COUNT(invoice_total) as no_of_invoices,
    COUNT(payment_date) as count_of_payments,
    /* If there is NULL value then it is not considered, hence we use (*)  */
    COUNT(*) as total_records 
from invoices;

/*Date values*/
select 
	MAX(invoice_date) as Maximum,	/*latest date*/
	MIN(invoice_date) as Minimum	/*earliest date*/
from invoices;

/*One can also perform math calculations along with the table data */
select 
	SUM(invoice_total*10) as total_sum,
	COUNT(DISTINCT client_id) as total_clients
from invoices
where invoice_date>='2018-01-01';

/*practice eg*/
select 
	'First_half' as Duration,
    SUM(invoice_total) as total_sale,
    SUM(payment_total) as total_payment,
    SUM(invoice_total-payment_total) as left_payment
from invoices
where invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
select 
	'Second_half' as Duration,
    SUM(invoice_total) as total_sale,
    SUM(payment_total) as total_payment,
    SUM(invoice_total-payment_total) as left_payment
from invoices
where invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
select 
	'Yearly' as Duration,
    SUM(invoice_total) as total_sale,
    SUM(payment_total) as total_payment,
    SUM(invoice_total-payment_total) as left_payment
from invoices
where invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

/* GROUP BY Clause-->The GROUP BY statement groups rows that have the same values into summary rows */
/*Single column*/
SELECT 
	client_id,
    SUM(invoice_total) as total_sales
from invoices
GROUP BY client_id;

/* using more precise queries */
SELECT 
	client_id,
    SUM(invoice_total) as total_sales
from invoices
where invoice_date>='2019-07-01'
GROUP BY client_id
ORDER BY total_sales DESC
LIMIT 2;

/* Multiple columns */
select
	state,
    city,
    SUM(invoice_total) as total_sales
from invoices
JOIN clients USING(client_id)
GROUP BY state,city;		/* contains single entry with state,city combination*/

/*practice eg*/
select
	payments.date,
    payment_methods.name as payment_method,
    SUM(amount) as amount
from payments
JOIN payment_methods
	ON payment_method=payment_method_id
GROUP BY date,payment_method
ORDER BY payments.date;

/* HAVING --> used to specify condition after GROUP BY clause,****column must be present in SELECT clause of the query*****
	WHERE --> used to filter data before grouping,****column not necessarily present in SELECT clause of the query,it can be from table******/
SELECT 
	client_id,
    SUM(invoice_total) as total_sales,
    COUNT(*) as number_of_invoices
from invoices
GROUP BY client_id
HAVING total_sales>500;

/* Further filteration */
SELECT 
	client_id,
    SUM(invoice_total) as total_sales,
    COUNT(*) as number_of_invoices
from invoices
GROUP BY client_id
HAVING total_sales>50 AND number_of_invoices>5;

/*practice eg*/
use sql_store;
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity*oi.unit_price) as total_amount
FROM customers c
JOIN orders o
	USING(customer_id)
JOIN order_items oi
	USING(order_id)
WHERE state="VA"
GROUP BY c.customer_id,
    c.first_name,
    c.last_name
HAVING total_amount>100;

/* WITH ROLLUP operator --> It applies to columns that have aggregate values(only available in MYsql) */
/* single tables-->It calculates the summary for the column*/
SELECT 
	client_id,
    SUM(invoice_total) as total_sales
from invoices
GROUP BY client_id WITH ROLLUP;

/* multiple tables -->It calculates the summary for each group as well as entire result set*/
SELECT 
	state,
    city,
    SUM(invoice_total) as total_sales
from invoices
JOIN clients 
	USING(client_id)
GROUP BY state,city WITH ROLLUP;

/*practice eg*/
SELECT 
	name,
    SUM(amount) as total
FROM payment_methods
JOIN payments 
	ON payment_method_id=payment_method
GROUP BY name WITH ROLLUP;