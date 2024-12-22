--Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period).
--Display the member's_id, member's name, book title, issue date, and days overdue.

 with cte1 as (select m.member_id,m.member_name,b.book_title,
 i.issued_date,current_date-i.issued_date as overdue_days
 from members as m
 join issued_status as i
 on m.member_id=i.issued_member_id
 join books as b
 on b.isbn=i.issued_book_isbn
 left join return_status as rs
 on i.issued_id=rs.issued_id
 where return_date is null)
select * from cte1 where overdue_days>30

--Task 14: Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes" 
--when they are returned (based on entries in the return_status table).

select * from issued_status, 
select * from books
update books
set status ='no'
where isbn ='978-0-451-52994-2', select * from return_status

insert into return_status (return_id,issued_id,return_date,book_quality)
values('RS125','IS130', Current_date,'Good')

update books
set status ='yes'
where isbn ='978-0-451-52994-2' select * from return_status

--Stored Procedures 

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$
-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');  

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

select count(ist.issued_id) as total_book_issued,count(rs.return_date) as book_return,
sum(bo.rental_price) as total_revenue,b.manager_id,
b.branch_id
from branch as b
join employees as e
on b.branch_id = e.branch_id
join issued_status  as ist
on ist.issued_emp_id=e.emp_id
join books as bo
on bo.isbn = ist.issued_book_isbn
left join return_status as rs
on rs.issued_id=ist.issued_id
group by 4,5
order by 1 desc

--Task 16: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who 
--have issued at least one book in the last 2 months.

create table  active_members as  (
select * from (select  distinct issued_member_id from issued_status
where issued_date >= current_date -interval '2 month' ) as active_members
join members as m
on m.member_id= active_members.issued_member_id)

select * from active_members 

--Task 17: Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. 
--Display the employee name, number of books processed, and their branch.

select  e.emp_name,b.* ,count(ist.issued_id)
from issued_status as ist
join employees as e            
on ist.issued_emp_id= e.emp_id
join branch as b
on e.branch_id=b.branch_id
group by 1,2


Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library 
system. Description: Write a stored procedure that updates the status of a book
in the library based on its issuance. The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. The procedure should first check if
the book is available (status = 'yes'). If the book is available, it should be issued, 
and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), 
the procedure should return an error message indicating that the book is currently not available.

create or replace procedure updated_issue_status(p_issued_id varchar(30), p_issued_member_id varchar(30), 
p_issued_book_isbn varchar(80),p_issued_emp_id varchar(30))

Language plpgsql
as $$
declare
 var_status varchar(80);

begin
 select status into var_status 
 from books
 where isbn= p_issued_book_isbn;

 if 
  var_status = 'yes' then

  insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn,issued_emp_id)
  values (p_issued_id, p_issued_member_id, current_date,p_issued_book_isbn,p_issued_emp_id);

			update books
			set status='no'
			where isbn=p_issued_book_isbn;

			 raise notice  'congratulation, the book has been issued for:% ',p_issued_book_isbn;
else
	 raise notice'Apologies, the book is not available for : %',p_issued_book_isbn;		
end if;

end ;
$$

drop Procedure updated_issue_status
call updated_issue_status('IS156','C119','978-0-553-29698-2','E109')  select * from issued_status, select * from books --"978-0-553-29698-2",
"978-0-7432-7357-1"


