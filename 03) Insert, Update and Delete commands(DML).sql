/* INSERT STATEMENT 
	for auto-increment/default values use DEFAULT keyword
    (or simply dont consider it into tuple, mysql implicitely takes auto-incremented/default values)
    
    for multiple insertions, simply use comma after each value tuple and go on addding new values
    */
INSERT INTO customers
VALUES (DEFAULT,'Rhutvij','Chiplunkar','2000-12-10',DEFAULT,'Kaneri','Kolhapur','MH',3600);

INSERT INTO customers(first_name,last_name,birth_date,address,city,state)
VALUES ('Soham','Chiplunkar','1998-03-27','Vashi','Mumbai','MH');

/*	Multiple values 
	LAST_INSERT_ID()-->used to get the last inserted id
    */
INSERT INTO customers(first_name,last_name,birth_date,address,city,state)
VALUES ('X','Y','1998-02-27','mut','brb','KA'),
	   ('A','B','2008-12-27','mvrut','erbrb','AP');
       
/* INERTING HIERARCHIAL ROWS */
INSERT INTO orders(customer_id,order_date,status)
VALUES (1,'2010-11-29',1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(),1,2,2.63),
	   (LAST_INSERT_ID(),2,2,3.23);

/* CREATE COPY OF A TABLE 
	NOTE: primary key and auto_increment dont apear same in copied table
    */
CREATE TABLE orders_copy AS
select * from orders;		/* This is a sub-query */ 

/* truncate previous values and fill new values acc to select statement condition*/
TRUNCATE TABLE orders_copy;

INSERT INTO orders_copy
select * from orders
where status=1;

/* UPDATING A SINGLE ROW */
UPDATE invoices
SET payment_total=10.26,payment_date='2020-06-06'
WHERE invoice_id=1;

/* UPDATING MULTIPLE ROW */
UPDATE customers
SET points=points+100
WHERE birth_date<='1990-01-01';		/* (this does not executes in safe update mode as it affects mmultiple rows) */

/* SUBQUERIES IN UPDATE STATEMENT */
UPDATE orders
SET comments="Gold customer"
WHERE customer_id IN
			(SELECT customer_id
			from customers
			WHERE points>3000);		/* (this does not executes in safe update mode as it affects mmultiple rows) */
            
/* DELETING ROWS */
DELETE from order_items
where order_id=11;