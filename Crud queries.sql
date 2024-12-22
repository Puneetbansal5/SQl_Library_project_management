Select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
----Project Task

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
 insert into books(isbn,	book_title,	category	,rental_price,	status	,author,	publisher)
 values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

 --Task 2: Update an Existing Member's Address
 UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete from issued_status
where issued_id ='IS121'

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
 select * from issued_status
 where issued_emp_id = 'E101'

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select  count(*),issued_member_id 
from issued_status
group by 2
having count(*)>1

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - 
--each book and total book_issued_cnt**

create table book_counts as 
select i.issued_book_isbn,b.isbn, count(issued_id) as no_issued,b.book_title
from issued_status as i
join books as b
on i.issued_book_isbn=b.isbn
group by 1,2,4


---Task 7. Retrieve All Books in a Specific Category:
select * from books where category = 'Children'

--Task 8: Find Total Rental Income by Category:
 select sum(b.rental_price) as income,b.category,COUNT(*)
 from issued_status as i
 join books as b
 on i.issued_book_isbn=b.isbn
 group by 2

--Task9: List Members Who Registered in the Last 180 Days:

select * from members 
where reg_date<=current_date- interval '180 days'

--Task 10:List Employees with Their Branch Manager's Name and their branch details:

select e.emp_name,b.branch_address,e.position,e.salary,b.manager_id,e1.emp_name as manager
from  employees as e
join branch as b
on e.branch_id=b.branch_id   
join employees as e1
on e1.emp_id=b.manager_id

---Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive as
select * from books where  rental_price>7

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

