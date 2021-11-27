/*Creating a user*/

CREATE USER rpc IDENTIFIED BY '1234'; -- Access from anywhere
CREATE USER rpc@localhost IDENTIFIED BY '1234';
CREATE USER rpc1@127.0.0.1 IDENTIFIED BY '1234';
CREATE USER rpc@pict.com IDENTIFIED BY '1234';	-- Using only domain
CREATE USER rpc@'%.pict.com' IDENTIFIED BY '1234';	-- Wildcard for sub domain

/*Viewing Users*/
select * 
from mysql.USER;

/*Dropping Users*/
DROP user rpc;

/*Changing passwords*/
-- For other users
SET PASSWORD for rpc1='9876';
-- For current user-> maybe root or other user
SET PASSWORD='9876';

/*Granting priveleges
1) Web/Desktop Application
2) Admin
*/

-- for Web/Desktop Application
-- ***** NEW CONNECTION IS CREATED ON HOME PAGE *****
CREATE USER user_1 IDENTIFIED BY '1234';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE 
ON sql_store.*
TO user_1;

-- for Admin
-- ***** NEW CONNECTION IS CREATED ON HOME PAGE *****
CREATE USER admin_1 IDENTIFIED BY '1234';
GRANT ALL
ON *.*  		-- All tables in all databases
TO admin_1;

/*Viewing priveleges
ROOT has highest number of priveleges*/
SHOW GRANTS FOR admin_1;
SHOW GRANTS;  -- For current user

/*Revoking priveleges*/
GRANT CREATE VIEW
ON sql_store.*
TO user_1;
SHOW GRANTS FOR user_1;
-- To revoke above
REVOKE CREATE VIEW
ON sql_store.*
FROM user_1;