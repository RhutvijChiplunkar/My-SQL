/* numerical functions 
	ROUND-->used to get rounded off value
    TRUNCATE-->keep required no of digits and remove other excess digits
    CEILING-->smallest int greater than or equal to given number
    FLOOR-->greatest int less than or equal to given number
    ABS-->returns mod value 
    RAND-->random float no from 0 to 1
    */

select ROUND(10.73);
select ROUND(10.48);
select ROUND(10.48176,3);
select TRUNCATE(10.48076,3);
select CEILING(10.48146);
select FLOOR(10.48146);
select ABS(10.48146);
select ABS(-10.48146);
select RAND(2)*100;
select conv(1059,10,2);

/*String functions*/
select LENGTH('RHUTVIJ');
select UPPER('rhutvij');
select LOWER('RHUTVIJ');
select LTRIM('      RHUTVIJ');
select RTRIM('RHUTVIJ       ');
select TRIM('    RHUTVIJ       ');
select LEFT('RHUTVIJ Chiplunkar',5);
select RIGHT('RHUTVIJ Chiplunkar',5);
select SUBSTRING('RHUTVIJ Chiplunkar',3,11);
select LOCATE('d','ABCDCBA');
select LOCATE('w','ABCDCBA');			/*if not present we get 0*/
select LOCATE('gar','kindergarden');			
select REPLACE('Rhutvij Chiplunkar','Rhutvij','Soham');
select CONCAT('Rhutvij',' ','Chiplunkar');

/*date and time functions*/
select NOW();		/*current date and time*/
select CURDATE();		/*current date */
select CURTIME();		/*current time*/

/*ALL INDIVIDUAL COMPONENTS OF THE YEAR AND DATE(returns int)*/
select YEAR(NOW());
select MONTH(NOW());
select DAY(NOW());
select HOUR(NOW());
select MINUTE(NOW());
select SECOND(NOW());

/* THESE 2 FUNCTIONS RETURN STRINGS*/
select DAYNAME(NOW());
select MONTHNAME(NOW());

/*EXTRACT function*/
select EXTRACT(DAY from NOW());
select EXTRACT(YEAR from NOW());

/*prctice eg*/
use sql_store;
select *
from orders
where year(order_date)<=year(now());

/*formatting date and time
default format-->YYYY-MM-DD
%d->digits of date, %D-> digit with 'th','st',etc
%m->digits of month, %D-> name in string eg-March
%y->2 digits of year, %D->4 digits of year
*/ 
SELECT DATE_FORMAT(NOW(),'%D %M %Y');
SELECT DATE_FORMAT(NOW(),'%d/%m/%y');
SELECT DATE_FORMAT(NOW(),'%d-%m-%Y');
SELECT TIME_FORMAT(NOW(),'%h:%i:%s %p');

/*calculating dates and times*/
/*add to current date*/
SELECT DATE_ADD(NOW(),INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(),INTERVAL 1 MONTH);
SELECT DATE_ADD(NOW(),INTERVAL 1 YEAR);

/*subtract from current date*/
SELECT DATE_ADD(NOW(),INTERVAL -1 DAY);
/* OR */
SELECT DATE_SUB(NOW(),INTERVAL 1 DAY);

/*difference in days-->returns diff in days*/
SELECT DATEDIFF('2021-07-10','2020-12-10');
SELECT DATEDIFF('2021-07-10 9:00','2020-12-10 23:00');

SELECT TIME_TO_SEC('23:59');	/*returns seconds passed since midnight*/
SELECT TIME_TO_SEC('23:00')-TIME_TO_SEC('13:00');

/* IFNULL and COALESCE functions
	IFNULL--> used to replace null values with other value
    COALESCE-->It returns first non-null value in the list
*/
use sql_store;
SELECT 
	order_id,
    IFNULL(shipper_id,'Not assigned') as shipper
from orders;

SELECT 
	order_id,
    COALESCE(shipper_id,comments,'Not assigned') as shipper
from orders;

/*pracrice eg*/
select 
	concat(first_name,' ',last_name) as customer,
    IFNULL(phone,'Unknown') as phone
from customers;

/* IF function ->used to check an expression and return value acc to condition
IF(test expression,first,second)
*/
use sql_store;
SELECT 
	order_id,
    order_date,
    IF(YEAR(order_date)=2019,'Active','Archive') as category
from orders;

/*practice eg*/
select 
	product_id,
    name,
    COUNT(*) AS orders,
    IF(COUNT(*)=1,'Once','Multiple times') as frequency
from products
JOIN order_items 
	USING(product_id)
group by product_id,name;

/*CASE -->used to check multiple expressions and return value acc to condition*/
select 
	order_id,
    CASE 
		WHEN YEAR(order_date)=2019 THEN 'active'
        WHEN YEAR(order_date)=2018 THEN 'inactive'
        WHEN YEAR(order_date)<2018 THEN 'archived'
		ELSE 'future'
	END as category
from orders;

/*practice eg*/
select 
	CONCAT(first_name,' ',last_name) as customer,
    points,
	CASE 
		WHEN points>3000 THEN 'Gold'
        WHEN points>=2000 THEN 'Silver'
        WHEN points<2000 THEN 'Bronze'
        ELSE 'No grade'
	END as category
from customers
order by points desc;