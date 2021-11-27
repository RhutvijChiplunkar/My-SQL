/*DATA TYPES IN MYSQL
	- String
    - Numeric
    - Date and Time
    - blob type
    -spatial type
*/

/*STRING data type
CHAR(X) -->fixed-length
VARCHAR(X)-->variable-length (max-length=65535 characters)
TINYTEXT-->MAX 255 Bytes
TEXT-->MAX 64KB
MEDIUMTEXT-->MAX 16MB
LONGTEXT-->MAX 4GB
*/

/*INTEGER data type
TINYINT-->1 Byte  [-128,127]
UNSIGNED TINYINT-->1 Byte  [0,255]
SMALLINT-->2 Bytes	[-32K,32K]
MEDIUMINT-->3 Bytes  [-8M,8M]
INT-->4 Bytes 	[-2B.2B]
BIGINT-->8 Bytes   [-9Z,9Z]
*/

/*RATIONALS
DECIMAL(p,s) -->DECIMAL(precision,scale) 
-- used for storing fixed point numbers
DECIMAL(9,2) eg: 1234567.89
DEC
NUMERIC
FIXED 
are also used to denote

FLOAT-> 4 Bytes
DOUBLE-> 8 Bytes 
float and double gives approximate values, used in scientific calculations
*/

/*BOOLEAN/BOOL data type
BOOL
BOOLEAN 
TRUE(1) & FALSE(0)
*/

/*DATE & TIME data types
DATE
TIME
DATETIME  8 Bytes
TIMESTAMP  4 Bytes(upto year 2038)
YEAR
*/

/* BLOB-->Binary Large Object  data type
Used to store audios,videos,images,etc

TINYBLOB	255 Bytes
BLOB		65 KB
MEDIUMBLOB	16 MB
LONGBLOB	4 GB 
*/

/*ENUM datatype
restrict the values in the column
eg: ALTER table table_name
	ADD column 'size' enum('small','medium','large')
    
NOTE: lookup tables-->used for dropdown list(multiple values)

SET() can be used for similar purpose
*/


/*JSON Type
JSON_SET --> update existing properties or add new ones
JSON_REMOVE --> remove existing properties*/
create table json_table_eg(id int,properties JSON);
insert into json_table_eg values
(1,'{"name":"rpc","surname":"xyz"}');

insert into json_table_eg values
(2,'{"name":"spc","surname":"pqr"}');

/*Other ways/syntax to use JSON object type*/
UPDATE json_table_eg
SET properties=JSON_OBJECT(
	'name','rhutvij',
    'surname','chiplunkar',
    'marks',JSON_ARRAY(10,20,30,40,50),
    'city',JSON_OBJECT('kolhapur','Maharashtra')
)
where id=1;

insert into json_table_eg(2,JSON_OBJECT(
	'name','rhutvij',
    'surname','chiplunkar',
    'marks',JSON_ARRAY(10,20,30,40,50),
    'city',JSON_OBJECT('kolhapur','Maharashtra')
));

/*Getting the data from JSON object*/
-- Method 1
select id,JSON_EXTRACT(properties,'$.name') as nm
from json_table_eg;

-- Method 2 ( using -> i.e column pass operator)
select id,properties->'$.name' as nm
from json_table_eg;

-- use ->> to get rid of quotes
select id,properties->>'$.name' as nm
from json_table_eg;