USE store;

/* SELECT Statements */
select * 
from customers
where points>2000
order by last_name;

select first_name,last_name,points
from customers;

select first_name,last_name,points,points+100
from customers;

/* ALIAS operator "AS"*/
select 
	first_name,
	last_name,
    points,
    (points+10)*2 AS modified_points
from customers;

/*
unique row from the table
*/
SELECT DISTINCT order_id
from order_items;

select * from customers
where birth_date>'1992-01-01';

select * from orders
where order_date>'2018-01-01';

/*Logical operator*/

select * from customers
where birth_date>'1992-01-01' and points>500;

select * from customers
where birth_date>'1992-01-01' or points>1500 and state='MA';

select * from customers
where (birth_date>'1992-01-01' or points>1500) and state='MA';

/*after a value is modified*/
select * from customers
where first_name='amber';

/* IN/NOT IN  operator*/
select * from customers
where state IN ('MA','VA','CA');

select * from customers
where state NOT IN ('MA','VA','CA');

/*	BETWEEN operator*/

select * from customers
where birth_date BETWEEN '1990-01-01' and '2010-01-01'; 

select * from customers
where points BETWEEN 1000 and 2500; 

/* 	LIKE operator 
	% - any no of characters
    _ - exact no of characters
*/
select * from customers
where last_name LIKE 'b%';		/*start with b */

select * from customers
where last_name LIKE '%b%';		/* b anywhere */

select * from customers
where last_name LIKE '%y';	    /* end with y */

select * from customers
where last_name LIKE '_____y';	 /* underscore matches exact no of characters*/

select * from customers
where last_name LIKE 'b____y';

select * from customers
where last_name NOT LIKE 'b____y';

/* REGEXP operator	
	^ - Starts with
    $ - ends with
	[] - character matching (input range or characters)
    | -  logical OR
    */
select * from customers
where last_name 
REGEXP 'field';

select * from customers
where last_name 
REGEXP 'field|mac|rose';

select * from customers
where last_name 
REGEXP 'field';

select * from customers
where last_name 
REGEXP '[rigs]e';		/* r,i,g,s before e*/

select * from customers
where last_name 
REGEXP 'b[rouy]';		/* r,o,u,y after b*/

select * from customers
where last_name 
REGEXP 'b[a-w]';		/* any character between a-w after b*/

/* IS NULL operator*/
select * from customers
where phone IS NULL;

select * from orders
where shipped_date IS NULL;

/* ORDER BY operator 
	DESC for descending order
*/
select * from customers
ORDER BY first_name;

select * from customers
ORDER BY last_name DESC;

select * from customers
ORDER BY first_name,city DESC;

select customer_id,birth_date from customers
ORDER BY points;					/*  In MYSQL even if column is not present, it can sort the data */

select first_name,last_name,birth_date from customers
ORDER BY 2,1;						/* order by using column numbers*/	

select *
from orders
where customer_id=2
ORDER BY order_date DESC;

/* LIMIT operator */
select * from customers
LIMIT 2;			/* limit to 2 records */

select * from customers
LIMIT 6,2;			/* skip first 6 and limit 2 after it*/

select * from customers
ORDER BY points DESC
LIMIT 5;			/* 5 people with most points */
