/*  TRANSACTIONS-->A group of SQL statements that represent a single unit of work
	Group of statements work successfully or fail together
    A transaction is a logical unit of work that contains one or more SQL statements. Transactions are atomic units of work that can be committed 
    or rolled back. When a transaction makes multiple changes to the database, either all the changes succeed when the transaction is committed, 
    or all the changes are undone when the transaction is rolled back
    
	ACID PROPERTIES:-
    -Atomicity
    -Consistency 
    -Isolation
    -Durability
*/

/*Creating TRANSACTIONS*/
-- The changes are reflected in respective tables
use sql_store;

START TRANSACTION;

insert into orders(customer_id,order_date,status) 
values(1,'2019-01-01',1);

insert into order_items
values(last_insert_id(),1,1,1);

COMMIT ;		-- Very important to end the transaction

/*UNSUCCESSFUL TRANSACTION--> Execute only start and 1st statement*/
-- The changes are NOT reflected in respective tables
START TRANSACTION;

insert into orders(customer_id,order_date,status) 
values(1,'2019-01-01',1);

insert into order_items
values(last_insert_id(),1,1,1);

COMMIT ;		-- Very important to end the transaction

/*ROLLBACK A TRANSACTION-->Manually check and rollback a transaction, use ROLLBACK instead of COMMIT*/
-- The changes are NOT reflected in respective tables
START TRANSACTION;

insert into orders(customer_id,order_date,status) 
values(1,'2019-01-01',1);

insert into order_items
values(last_insert_id(),1,1,1);

ROLLBACK ;		-- Rollback the transaction manually and undo all the changes

/*MySQL automatically converts your DML statements(Insert,Update,Delete) to TRANSACTIONS & COMMIT them if there are NO ERRORS*/
SHOW variables like 'autocommit%';


/*Concurrency and Locking
Concurrency Control. Anytime more than one query needs to change data at the same time, the problem of concurrency control arises*/
-- We can check this by simultaneously executing below queries into 2 diffrent SQL query windows
START TRANSACTION;

insert into orders(customer_id,order_date,status) 
values(1,'2019-01-01',1);

insert into order_items
values(last_insert_id(),1,1,1);

COMMIT ;	

/*Concurrency problems:
  - Lost Updates --> Two transaction try to update same data and we dont use locks. Last done later overrides the changes
  Can be solved by using locks. My SQL uses locks by default
  - Dirty reads --> Transaction reads data that has not been committed yet.
  Can be solved by providing isolation(use READ COMMITTED)
  - Non-repeating reads->inconsistent read of the data
  Can be solved by providing isolation(use REAPEATABLE COMMITTED)
  - Phantom(meaning is ghost) reads-->Data suddenly appears and transaction misses them
  Can be solved by providing isolation(use SERIAIZABLE)-->makes transaction aware of other data changes done at same time
  */

/* ************** FOUR TRANSACTION ISOLATION LEVELS ************** 
                      Lost Updates 	 Dirty reads	Non-repeating reads 	Phantom reads
1) READ UNCOMMITTED			-				      -					      -				              	-
2) READ COMITTED			  -			      	Y					      -				              	-	
3) REPEATABLE READ			Y				      Y				      	Y				              	-
4) SERIALIZABLE			  	Y				      Y					      Y				              	Y

** The more we increase the isolation level, more we have scalability & performance problems **
**NOTE: default isolation level in MYSQL is REPETABLE READS ***
		Non-repeating reads ==> reads same data differently
*/

SHOW VARIABLES LIKE 'transaction_isolation'; -- REPETABLE READS
-- To set new transaction isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- For any particular session
-- **** Very important for developers ******
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- For ALL sessions
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;

/*READ UNCOMMITTED TRANSACTION ISOLATION LEVEL*/
-- Instance 1
use sql_store;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- The below statement is executed as transaction by defualt in My-SQL
select points
from customers
where customer_id=1;
-- Instance 2
use sql_store;
START TRANSACTION;
UPDATE customers
SET points=20
where customer_id=1;
COMMIT; -- This statement is never committed


/*READ COMMITTED TRANSACTION ISOLATION LEVEL*/
-- Instance 1
use sql_store;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
select points
from customers
where customer_id=1;
-- The below statement is executed as transaction by defualt in My-SQL
select points
from customers
where customer_id=1;
COMMIT;

-- Instance 2
use sql_store;
START TRANSACTION;
UPDATE customers
SET points=4500
where customer_id=1;
COMMIT;


/*REPEATABLE READ TRANSACTION ISOLATION LEVEL*/
-- Instance 1
use sql_store;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;
select points
from customers
where customer_id=1;
-- The below statement is executed as transaction by defualt in My-SQL
select points
from customers
where customer_id=1;
COMMIT;

-- Instance 2
use sql_store;
START TRANSACTION;
UPDATE customers
SET points=5000
where customer_id=1;
COMMIT;


/*SERIALIZABLE TRANSACTION ISOLATION LEVEL*/
-- Instance 1
use sql_store;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;
select *
from customers
where state='VA';
COMMIT;

-- Instance 2
use sql_store;
START TRANSACTION;
UPDATE customers
SET state='VA'
where customer_id=3;
COMMIT;

/* DEADLOCKS --> Deadocks occurs when each transaction cannot complete
	eg. Two transaction keep waiting for each other and never release the lock*/
 -- Instance 1
 use sql_store;
START TRANSACTION;
UPDATE customers SET state='VA' where customer_id=1;
UPDATE orders SET status=1 where order_id=1;
COMMIT;
 -- Instance 2
 use sql_store;
START TRANSACTION;
UPDATE orders SET status=1 where order_id=1;
UPDATE customers SET state='VA' where customer_id=1;
COMMIT;