/*  Indexes->speed up our queries
	Note:Indexes are internally stored as binary trees
*/
-- The statement below goes through all entries (type column has "ALL")    
EXPLAIN select * from customers
where state='CA';

-- Creating an index
CREATE INDEX idx_state ON customers(state);

-- The statement below goes through selected entries wrt index(type column has "res")  
EXPLAIN select * from customers
where state='CA';

/*	Viewing the indexes
	Note:PRIMARY KEY is also called as CLUSTERED INDEX-->automatically done by my-sql
    
    SECONDARY INDEXES-->The indexes which we create
    Note:Primary key column is automatically added to the index by the my-sql
		 When we create relations using foreign keys, my-sql automatically creates indexes on foreign key column 
*/
SHOW INDEXES IN customers;

ANALYZE table customers;

SHOW INDEXES IN orders;

/*Prefix indexes
text and blob table_name(column(no of characters)) is compulsory*/
CREATE  INDEX idx_lastname ON customers(last_name(20));

/*FULL TEXT INDEXES-->used to make fast search engines
These include entire string columns
They include a relevance score-->number betn 0 to 1 */
use sql_blog;
-- Below query is not recommended
select *
from posts
where title like '%react%' or body like '%react redux%';

-- This is fulltext index
CREATE FULLTEXT INDEX idx_title_body ON posts(title,body);

select *
from posts
where MATCH(title,body) AGAINST ('react redux');
-- the match..against statements matches any 1,both the words in any order(similar to google)

-- for relevancy score
select *,MATCH(title,body) AGAINST ('react redux')
from posts
where MATCH(title,body) AGAINST ('react redux');

-- Boolean mode-->match and exclude particular characters(not necessarily in same order)
select *,MATCH(title,body) AGAINST ('react redux')
from posts
where MATCH(title,body) AGAINST ('react -redux +form' in BOOLEAN MODE);

-- for exact match
select *,MATCH(title,body) AGAINST ('react redux')
from posts
where MATCH(title,body) AGAINST ('"handling a form"' in BOOLEAN MODE);

-- Composite indexes--> create indexes including more than 1 column
/*note:Mysql will always pick maximum of 1 idex for a query
** More the indexes, slower will be the write operation*/
use sql_store;
show indexes in customers;

create index idx_state_points ON customers(state,points);
explain select customer_id
from customers
where state='CA' and points>1000;

/*Dropping an index*/
DROP INDEX idx_state ON customers;

/*ORDER OF COLUMNS in the composite indexes
	Put most frequently used columns first
    Put columns with high cardinality first*/
CREATE INDEX idx_lastname_state ON customers(last_name,state);

EXPLAIN select *
from customers
where state='CA' and last_name like 'A%';

-- More efficient composite index
CREATE INDEX idx_state_lastname ON customers(state,last_name);

/*When indexes are ignored*/
EXPLAIN select *
from customers
where state='CA' or last_name like 'A%';

-- We will optimize above query such that indexes are used
CREATE INDEX idx_points ON customers(points);

EXPLAIN 
	select customer_id from customers
	where state='CA'
    UNION
    select customer_id from customers
    where points>1000;

-- Note: To optimize query using indexes, avoid using expressions

/*Using indexes for sorting
	
    recommended ways
    Sort by:- (a)
			  (a,b)
              (a DESC,b DESC)
	Note: (a DESC,b) or (a,b DESC) or (a,c,b){column between} increases the cost
*/
SHOW INDEXES IN customers;

EXPLAIN select * from customers order by first_name;
-- this uses FILESORT which is an expensive operation
EXPLAIN select * from customers order by state;
SHOW STATUS like 'last_query_cost';

EXPLAIN select * 
from customers 
order by state,points DESC;

EXPLAIN select * 
from customers 
order by state DESC ,points DESC;

/*Covering indexes-->My sql can execute queries that contain column that contain index faster
	We can narrow down searches by creating indexes on appropriate columns*/
    
    
/*Index maintainence-->
  Avoid duplicate indexes-->(a,b,c) & (a,b,c)
  Avoid redundent indexes-->(a,b) & (a)*/