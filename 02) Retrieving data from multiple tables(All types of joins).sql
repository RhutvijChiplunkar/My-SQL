/* INNER JOIN */
select * 
from orders
JOIN customers
	ON orders.customer_id=customers.customer_id;
    
select order_id,orders.customer_id,first_name,last_name,shipped_date 
from orders
JOIN customers
	ON orders.customer_id=customers.customer_id;

/* Tabe name as alias */
select order_id,o.customer_id,first_name,last_name,shipped_date 
from orders o
JOIN customers c 	/* INNER JOIN can also be used*/
	ON o.customer_id=c.customer_id;
    
    
/* joining across DATABASES */
select * 
from order_items oi
JOIN sql_inventory.products p 			/* prefix with other database for table from other database */
	ON oi.product_id=p.product_id;

/* self join */
USE sql_hr;
select *
from employees e
JOIN employees m
	ON e.reports_to=m.employee_id;

USE sql_hr;
select 
	e.employee_id,
    e.first_name,
    m.first_name as manager
from employees e
JOIN employees m
	ON e.reports_to=m.employee_id;


/* Joining Multiple tables */
select *
from orders o 
JOIN customers c 
	ON o.customer_id=c.customer_id
JOIN order_statuses os
	ON o.status=os.order_status_id;
    
select 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
from 
	orders o
JOIN customers c 
	ON o.customer_id=c.customer_id
JOIN order_statuses os
	ON o.status=os.order_status_id;


/* Compound join conditions 
	composite primary key --> primary key combining more than 1 column
    */
select * 
from order_items oi
JOIN order_item_notes oin
	ON oi.order_id=oin.order_id
    AND oi.product_id=oin.product_id;


/* Implicit join syntax */
select *
from orders o,customers c
where o.customer_id=c.customer_id;

/* OUTER JOINS
	LEFT JOINS --> all records from left table are considered whether condition is satisfied or not
    RIGHT JOINS --> all records from right table are considered whether condition is satisfied or not
*/

select *
from customers c 
LEFT JOIN orders o		/* OR LEFT OUTER JOIN */
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;

select *
from customers c 
RIGHT JOIN orders o		/* OR RIGHT OUTER JOIN */
	ON c.customer_id=o.customer_id
ORDER BY c.customer_id;

select 
	p.product_id,
    p.name,
    o.quantity
from products p 
LEFT JOIN order_items o
	ON p.product_id=o.product_id
ORDER BY p.product_id;

/* OUTER JOIN between multiple tables */
select 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.shipper_id as Shipper
from customers c
LEFT JOIN orders o
	ON c.customer_id=o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id=sh.shipper_id
ORDER BY c.customer_id;

/* SELF OUTER JOIN */ 
use sql_hr;
select 
	e.employee_id,
    e.first_name,
    m.first_name as Manager
from employees e
LEFT JOIN employees m
	ON e.reports_to=m.employee_id;   /*(all employees have a manager)*/
    
/* USING operator 
	if we have exact same name for 2 columns then instead of 
    'ON' after JOIN we can use USING(column_name)
*/
select 
	o.order_id,
    c.first_name
from orders o 
JOIN customers c 
	USING(customer_id);


/* NATURAL JOIN --> implicitely join the table with common column names , common column is taken only once*/
select *
from orders o
NATURAL JOIN customers c;

select 
	o.order_id,
	c.first_name
from orders o
NATURAL JOIN customers c;

/* CROSS JOIN -->joins every record in first table with every record in second (cartesian product)*/
select *
from customers c
CROSS JOIN orders o;

select
	c.first_name,
    o.order_id
from customers c
CROSS JOIN orders o
ORDER BY c.first_name;

/* implicit syntax for CROSS JOIN */
select *
from customers c,orders o;

/* UNION operator --> combine records from multiple queries (maybe from same or different table)
   column name from 1st query is always considered
   ***UNION operation outputs only 1-COLUMN combining required columns ***
*/

select 
	o.order_id,o.shipper_id
from orders o 
where o.shipped_date IS NULL

UNION 

select 
	o.order_id,o.shipper_id
from orders o 
where o.shipped_date IS NOT NULL
ORDER BY order_id;

select o.status
from orders o
UNION
select c.city
from customers c;

select 
	c.customer_id,
    c.first_name,
    c.points,
    'BRONZE' AS medal
from customers c
where c.points<2000
UNION
select 
	c.customer_id,
    c.first_name,
    c.points,
    'SILVER' AS medal
from customers c
where c.points>2000 and c.points<3000
UNION
select 
	c.customer_id,
    c.first_name,
    c.points,
    'GOLD' AS medal
from customers c
where c.points>3000
ORDER BY customer_id;

select customer_id
from customers
UNION
select shipped_date
from orders