-- TRIGGERS --> A block of SQL code that automatically gets executed before/after an insert,update or delete statement
DELIMITER $$
CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total + NEW.amount  -- or OLD
    WHERE invoice_id=NEW.invoice_id;
END $$
DELIMITER ;

/*NOTE:- We can modify data except for the table we define in trigger*/

-- When we insert the values as below trigger is fired and invoices table is updated automatically
INSERT into payments values
(default,5,3,'2019-01-01',10,1)

/*practice eg*/
DELIMITER $$
CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total - OLD.amount  -- subtract old amount
    WHERE invoice_id=OLD.invoice_id;
END $$
DELIMITER ;

DELETE from payments
where payment_id=2;

/* VIEWING the triggers*/
SHOW TRIGGERS;
SHOW TRIGGERS like 'p%';

/* DROPPING the triggers*/
DROP TRIGGER IF EXISTS abc;

/*Using triggers for AUDITING--keep log of which user inserted,deleted or updated the table*/
DELIMITER $$
CREATE TRIGGER payments_after_insert_audit
	AFTER INSERT ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total + NEW.amount  -- or OLD
    WHERE invoice_id=NEW.invoice_id;
    
    INSERT INTO payments_audit
    values(NEW.client_id,NEW.date,NEW.amount,'INSERT',NOW());
    
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER payments_after_delete_audit
	AFTER DELETE ON payments
	FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total=payment_total - OLD.amount  -- subtract old amount
    WHERE invoice_id=OLD.invoice_id;
    
	INSERT INTO payments_audit
    values(OLD.client_id,OLD.date,OLD.amount,'DELETE',NOW());
END $$
DELIMITER ;

/*payment_audit is updated after this*/
insert into payments
values(default,5,3,'2019-01-01',10,1);

/*EVENTS-->A task or block of code that gets executed according to schedule
Events are very important for automation-->eg. archieve,delete or upadte after certain period of time*/

SHOW VARIABLES;		-- All variables in MySql
SHOW VARIABLES like 'event%';	
SET global event_scheduler=ON -- or OFF

/*delete all the records older than 1 year*/
DELIMITER $$
CREATE EVENT yearly_delete_audit_rows
ON SCHEDULE
	-- AT '2021-07-15'
    EVERY 1 YEAR STARTS '2021-08-01' ENDS '2031-08-01'
DO BEGIN
	DELETE FROM payments_audit
    where action_date<NOW()-INTERVAL 1 year;
END$$
DELIMITER ;

/*view all the events*/
show events;
show events like 'yearly%';

/*drop events*/
DROP EVENT IF EXISTS ABC;

/*alter events-->same as create, only replace CREATE by ALTER
We can also use to enable or disable */
alter event yearly_delete_audit_rows DISABLE;
alter event yearly_delete_audit_rows ENABLE;

