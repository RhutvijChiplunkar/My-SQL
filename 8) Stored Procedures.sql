/* STORED PROCEDURES-->contain a block of SQL code
A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.
You can also pass parameters to a stored procedure, so that the stored procedure can act based on the parameter value(s) that is passed.*/

/*Creating STORED PROCEDURES*/
DELIMITER $$	/*change the default delimiter*/
CREATE PROCEDURE get_clients()
BEGIN
	select * from clients;
END$$
DELIMITER ;
/*(above part is executed by doing Stored procedures->right click->create stored procedure & write further query*/

/*Call the created stored procedure */
CALL get_clients();

/*practice eg(copied from stored procedure)*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_invoices_with_balance`()
BEGIN
	select *
	from invoices_with_balance		/*we make use of view here*/
	where balance>100;
END$$
DELIMITER ;

CALL get_invoices_with_balance;

/*Dropping STORED PROCEDURES*/
DROP PROCEDURE test_me;
DROP PROCEDURE IF EXISTS test_me;

/*STORED PROCEDURES with parameters-->All parameters are required in MYSQL, else we get an error*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clients_by_state`(state CHAR(2))
BEGIN
	select *
	from clients c
	where c.state=state;
END$$
DELIMITER ;

/*calling stored procedures with parameters*/
CALL get_clients_by_state('CA');
CALL get_clients_by_state('NY');

/*STORED PROCEDURES-parameters with default value-->we give condition for parameters if user passes NULL argument*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clients_by_state_default_params`(state CHAR(2))
BEGIN
	IF state IS NULL THEN
		SET state='CA';		/*if parameter is null, it will consider state as CA*/
	END IF;		/*Imp to end if condition*/
	select *
	from clients c
	where c.state=state;
END$$
DELIMITER ;

CALL get_clients_by_state_default_params(NULL);

/*OR->use if-else condition*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clients_by_state_default_params1`(state CHAR(2))
BEGIN
	IF state IS NULL THEN
		select * from clients;		/*if parameter is null, it will consider all entries*/
	ELSE
		select * from clients c
		where c.state=state;
	END IF;		/*Imp to end if condition*/
END$$
DELIMITER ;

CALL get_clients_by_state_default_params1(NULL);
CALL get_clients_by_state_default_params1('CA');

/*OR->smart function rather than if-else condition*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_clients_by_state_default_params2`(state CHAR(2))
BEGIN
	select * from clients c
	where c.state=IFNULL(state,c.state);
END$$
DELIMITER ;

CALL get_clients_by_state_default_params2(NULL);
CALL get_clients_by_state_default_params2('CA');

/*practice eg*/
DELIMITER $$
USE `sql_invoicing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_payments`(client_id INT,payment_method_id TINYINT)
BEGIN
	select *
    from payments p
    where (p.client_id=IFNULL(client_id,p.client_id) and p.payment_method=IFNULL(payment_method,p.payment_method));
END$$
DELIMITER ;

/*calling with diff test cases*/
CALL get_payments(NULL,NULL);		/*selects all*/
CALL get_payments(5,NULL);
CALL get_payments(NULL,1);
CALL get_payments(3,1);

/*Parameter validation in stored procedure*/
/*This should not be done as payment is negative. Hence validation is necessary-->error is shoen in OUTPUT below*/
call make_payment(2,-100,'2018-06-05');
call make_payment(3,100,'2020-06-05'); 

/*output parameters*/
call get_unpaid_invoices_for_client(3);
/*The output below is generated in output*/
set @invoices_count = 0;		/*These are VARIABLES that are used when we use output parameters */
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;

/*VARIABLES*/
-- User or session variables
set @invoices_count = 0;
-- Local session variables ->only meaningful inside stored procedures, available when we declare them and cleared when execution is over
call sql_invoicing.get_risk_factor(); -- local variables used inside this procedure

/*Functions-->functions return only a single value
  **Attriutes
	DETERMINISTIC --> returns same value iresepective of inputs
	READS SQL DATA
	MODIFIES SQL DATA
*/

USE `sql_invoicing`;
DROP function IF EXISTS `get_risk_factor_for_client`;

DELIMITER $$
USE `sql_invoicing`$$
CREATE FUNCTION `get_risk_factor_for_client` (client_id INT)
RETURNS INTEGER
-- DETERMINISTIC
READS SQL DATA
-- MODIFIES SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoices_count INT;
    
    select COUNT(*),SUM(invoice_total)
    INTO invoices_count,invoices_total
    from invoices i
    where i.client_id=client_id;
    
    SET risk_factor=invoices_total / invoices_count *5;
RETURN risk_factor;
END$$

DELIMITER ;

/*calling function -->similar to using in-built functions*/
select
	client_id,
    name,
    get_risk_factor_for_client(client_id) as risk_factor
from clients;

/*Dropping a function */
DROP function IF EXISTS `get_risk_factor_for_client`;