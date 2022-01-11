/* VIEWS-->  views are virtual tables, but VIEWS DONT STORE DATA.
		ADVANTAGES OF VIEWS
		Simplify queries
		Reduce the impact of change
		Restrict access to the data*/
USE sql_invoicing;

CREATE VIEW sales_by_client AS
SELECT 
	client_id,
    name,
    SUM(invoice_total) as total_sales
from clients
JOIN invoices
	USING(client_id)
Group by client_id,name;

/*practice eg*/
CREATE VIEW Balance AS
select 
	client_id,
    name,
    SUM(invoice_total)-SUM(payment_total) as balance
from clients
JOIN invoices Using(client_id)
Group by client_id,name;

/*altering or dropping views*/
DROP VIEW sales_by_client;

/*creates view or replaces if already exists*/
CREATE OR REPLACE VIEW sales_by_client AS
SELECT 
	client_id,
    name,
    SUM(invoice_total) as total_sales
from clients
JOIN invoices
	USING(client_id)
Group by client_id,name;

/*Updatable VIEWS-->possible if view doesnt have Distinct,aggregate functions, group by/having & UNION operators
  One can upadate,insert,delete rows in a view when we dont have direct access to table*/
CREATE OR REPLACE VIEW invoices_with_balance AS 
select 
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_date,
    due_date,
    payment_date,
    invoice_total-payment_total as balance
from invoices
where (invoice_total-payment_total)>0
WITH CHECK OPTION;

DELETE from invoices_with_balance
where invoice_id=1;

UPDATE invoices_with_balance
SET due_date= date_add(due_date,interval 2 day)
where invoice_id=2;

/* The WITH OPTION CHECK clause-->sometimes during updaate,delete row may get deleted,this statement prevents from deleting rows in above condition*/
UPDATE invoices_with_balance
SET payment_total=invoice_total
where invoice_id=3;

