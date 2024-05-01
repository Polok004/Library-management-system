
--show tables
select * from Author;
select * from book_type;
select * from Stuff;
select * from Book;
select * from Student;
select * from Operation;


--new column add
alter table Author add Prefered_type char(20);
select * from Author;

--modify column type
alter table Author modify Prefered_type varchar(23);
select * from Author;

--renamin column
alter table Author rename column Prefered_type to Prefered_typeName;
select * from Author;

--drop a column
alter table Author drop column Prefered_typeName;
select * from Author;


--update rent time
update Operation set end_date='23-DEC-2023' where SL_no=1;
update Operation set total_days=50 where SL_no=1;
select * from Operation;

--deleting a row which holds the rent details when returns the book
update Book set status='available' where book_code=(select book_code from Operation where SL_no=2);
update Student set total_rented_books = total_rented_books - 1
where student_id = (select student_id from Operation where SL_no = 2);
delete from Operation where SL_no=2;
select * from Book;
select * from Student;
select * from Operation;

--aggregate functions of the tables
select count(*) from Book;
select count(*) from Operation;
select count(*) from book_type;
select count(*) from Student;
select count(*) from Stuff;
select count(*) from Author;

--avg and total days of renting books
select avg(total_days) from Operation;
select sum(total_days) from Operation;

--student max and min book renting
select max(total_rented_books) from Student;
select min(total_rented_books) from Student;


--names of the students whoose name start with 'A' or end with 'r'
select student_name from student where student_name like 'A%' union select student_name from student where student_name like '%r';

----names of the students whoose name start with 'A' and end with 'r'
select student_name from student where student_name like 'A%' intersect select student_name from student where student_name like '%r';

--the information about the author who have most number of the books
with max_books(val) as (select max(no_of_books) from Author)
select * from Author,max_books where Author.no_of_books=max_books.val;


-- information about the students who rented books
select student_name,avg(total_rented_books) from student group by student_name having avg(total_rented_books)>0;

-- information about the book types who have more than one book
select type_name,avg(no_of_books) from book_type group by type_name having avg(no_of_books)>1;

-- information about the authors who have more than one book
select author_name,avg(no_of_books) from Author group by author_name having avg(no_of_books)>1;


--example of author details from rented books
select * from Author where author_id=(select author_id from Book where book_code=(select book_code from Operation where SL_no=1));

--example of book types of a particular author
select type_name from book_type where type_id IN (select type_id from Book where author_id=3);

--
select * from Student where student_id=(select student_id from Operation where book_code IN (select book_code from Book where type_id=4));

--membership
select * from book where book_code> some(select book_code from book where book_code>=2);
select * from operation where total_days >31 AND end_date > '01-JAN-2024';

--string operation
SELECT * FROM Book WHERE Book_name LIKE '%N%';
SELECT * FROM Book WHERE Book_name LIKE '______' or Book_name LIKE '______________' or Book_name LIKE '___________________';

--join operation
select * from operation natural join book;
select stuff_name,stuff_phone from stuff left outer join operation on operation.issued_by=Stuff.stuff_id;
select student_name,total_rented_books from student right outer join operation using(student_id);
select book_name,book_description,status from book full outer join author using(author_id);

--views

create view rent as select * from book where status='rented';
select * from rent;


create view available as select * from book where status='available';
select * from available;

