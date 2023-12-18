-- the basics
use bank;
select * from trans;
select * from bank.trans;

/* another way 
to coment */

-- to select some columns instead of all
select trans_id, account_id, date, type
from bank.trans;

select bank.trans.trans_id, bank.trans.account_id, bank.trans.date, bank.trans.type
from bank.trans;

-- aliasing columns
select trans_id as Transaction_ID, account_id as Account_ID, date as Date, type as Type_of_account
from bank.trans;

select *, amount-payments as balance
from bank.loan;

-- aliasing columns and table
select bt.trans_id as Transaction_ID, bt.account_id as Account_ID, bt.date as Date, bt.type as Type
from bank.trans as bt;

-- limiting the number of rows in the results
select bt.trans_id as Transaction_ID, bt.account_id as Account_ID, bt.date as Date, bt.type as Type
from bank.trans as bt
limit 10;

-- ordering and getting only most/least
select * from bank.account
order by account_id desc   -- or asc
limit 10;

-- distinct
select distinct frequency, account_id from bank.account
order by frequency asc;

-- printing stuff
select 5*10; 
select 'Hello World';


-- the where clause
select * from bank.order
where amount > 1000
order by amount asc;

select * from bank.order
where k_symbol = 'SIPO';

select order_id, account_id, bank_to, amount from bank.order
where k_symbol = 'SIPO';

select order_id as "OrderID", account_id as `AccountID`, bank_to as 'DestinationBank', amount  as 'Amount'
from bank.order
where k_symbol = 'SIPO';

-- where clause - multiple conditions
select * from bank.loan
where amount > 100000 and (status = 'B' or status = 'C')
order by amount; 
-- where status in ('B', 'C') and amount > 100000; 

select *
from bank.loan
where status = 'B' or status = 'D';
-- where status in ('B', 'D');

select *
from bank.loan
where (status = 'B' or status ='D') and not amount > 200000
order by amount desc;

-- basic arithmetic operations
select loan_id, account_id, date, duration, status, amount-payments as balance
from bank.loan;

select loan_id, account_id, date, duration, status, (amount-payments)/1000 as 'balance in Thousands'
from bank.loan;

-- this is the modulus operator that gives the remainder
select duration%2
from bank.loan;
-- where duration%2 = 1;


-- more cool stuff:

-- rounding
select order_id, round(amount/1000,2)
from bank.order;

select floor(avg(amount)) from bank.order;

select ceiling(avg(amount)) from bank.order;

-- checking the number of rows in the table, both methods give the same result
-- given that there are no nulls in the column in the second case:
select count(*) from bank.order;
select count(order_id) from bank.order;

-- max/min
select max(amount) from bank.order;
select min(amount) from bank.order;

-- 'string' operations
select *, length(k_symbol) as 'Symbol_length' from bank.order;
select *, concat('$', amount, ' ', k_symbol) as 'concat' from bank.order;

-- formats the number to a form with commas,
-- 2 is the number of decimal places, converts numeric to string as well
select *, format(amount, 2) from bank.loan;

select *, lower(A2), upper(A3) from bank.district;
-- It is interesting to note that select lower(A2), upper(A3), * from bank.district; doesn't work

select A2, left(A2,5), A3, ltrim(A3) from bank.district;
-- Similar to ltrim() there is rtrim() and trim() (to remove spaces). And similar to left() there is right() (to crop the value)

select *, substr(A2,3,6) from bank.district;

-- position
select A3, left(A3, position(' ' in A3)) as bla from district;

select position('-' in 'a-b');


-- converting to date type
select account_id, district_id, frequency, date, convert(date,date) from bank.account; -- cast(date as date)
select account_id, district_id, frequency, convert(date,datetime) from bank.account;
-- the first argument is the column name and the second is the type you want to convert

select issued, convert(substring_index(issued, ' ', 1), date) from bank.card;   -- left(issued, position(' ' in issued))  instead of substring_index


-- converting the original format to the date format that we need:
select date_format(convert(date,date), '%Y-%M-%D') from bank.loan;

-- if we just want to extract some specific part of the date
select date_format(convert(date,date), '%y') from bank.loan; 

-- extract
SELECT EXTRACT(DAY from CAST(date as date)) AS day from loan;

/* Order of Processing
FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE/ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY
TOP/LIMIT
OFFSET/FETCH

read more at: https://www.sqlservercentral.com/blogs/sql-server-logical-query-processing
*/


-- Nulls
select isnull(card_id) from bank.card; -- 0 means not null, 1 means null

-- this is used to check all the elements of a column.
select sum(isnull(card_id)) from bank.card;

select * from bank.order
where k_symbol is not null;

select * from bank.order
where k_symbol is not null and k_symbol = ' '; 

-- to check, replace nulls
select *, coalesce(amount, 0) from bank.order
where amount = 1000;


-- case/when
select loan_id, account_id,
case
when status = 'A' then 'Good - Contract Finished'
when status = 'B' then 'Defaulter - Contract Finished'
when status = 'C' then 'Good - Contract Running'
else 'In Debt - Contract Running'
end as 'Status_Description'
from bank.loan;