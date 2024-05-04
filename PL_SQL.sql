--insertion of a new student
set serveroutput on
declare 
student_id Student.student_id%type:=9;
student_name Student.student_name%type:='Akash Chowdhury';
student_email Student.student_email%type:='akas@gmail.com';
student_phone Student.student_phone%type:=0753579859;
total_rented_books Student.total_rented_books%type:=0;
begin
insert into Student values(student_id,student_name,student_email,student_phone,total_rented_books);
end;
/
select * from student;

--all the details of operation table using cursor and rowtype
set serveroutput on;

declare
  cursor operation_cursor is
    select * from operation;
  operation_row operation%rowtype;
begin
  open operation_cursor;
  fetch operation_cursor into operation_row.sl_no, operation_row.book_code, operation_row.student_id, operation_row.start_date, operation_row.end_date, operation_row.total_days, operation_row.issued_by;
  
  while operation_cursor%found loop
    dbms_output.put_line('SL No: ' || operation_row.sl_no || ' Book Code: ' || operation_row.book_code || ' Student Id: ' || operation_row.student_id || ' Start Date: ' || operation_row.start_date || ' End Date: ' || operation_row.end_date || ' Renting Days: ' || operation_row.total_days || ' Stuff ID: ' || operation_row.issued_by);

    fetch operation_cursor into operation_row.sl_no, operation_row.book_code, operation_row.student_id, operation_row.start_date, operation_row.end_date, operation_row.total_days, operation_row.issued_by;
  end loop;
  
  close operation_cursor;
end;
/


--finding book details of a particular student using array and loop

set serveroutput on;

declare 
  v_student_id student.student_id%type := 3; -- Student ID to search for
  type bookcodearray is varray(500) of operation.book_code%type;
  type booknamearray is varray(500) of book.book_name%type;
  type startdatearray is varray(500) of operation.start_date%type;
  type enddatearray is varray(500) of operation.end_date%type;
  type totaldaysarray is varray(500) of operation.total_days%type;
  v_book_codes bookcodearray := bookcodearray();
  v_book_names booknamearray := booknamearray();
  v_start_dates startdatearray := startdatearray();
  v_end_dates enddatearray := enddatearray();
  v_total_days totaldaysarray := totaldaysarray();
  v_books_rented boolean := false; -- Flag to track if books are rented
begin
  -- Retrieve book codes, names, start dates, end dates, and total days rented by the specified student
  for op in (select o.book_code, b.book_name, o.start_date, o.end_date, o.total_days
              from operation o
              join book b on o.book_code = b.book_code
              where o.student_id = v_student_id) 
  loop
    -- Store book code, name, start date, end date, and total days in the arrays
    v_book_codes.extend;
    v_book_codes(v_book_codes.count) := op.book_code;
    v_book_names.extend;
    v_book_names(v_book_names.count) := op.book_name;
    v_start_dates.extend;
    v_start_dates(v_start_dates.count) := op.start_date;
    v_end_dates.extend;
    v_end_dates(v_end_dates.count) := op.end_date;
    v_total_days.extend;
    v_total_days(v_total_days.count) := op.total_days;
    v_books_rented := true; -- Set flag to indicate books are rented
  end loop;

  -- Output the rented book details or a message if no books are rented
  if v_books_rented then
    dbms_output.put_line('Books rented by student with ID ' || v_student_id || ':');
    for i in 1 .. v_book_codes.count loop
      dbms_output.put_line('Book Code: ' || v_book_codes(i) || ', Book Name: ' || v_book_names(i) || ', Start Date: ' || v_start_dates(i) || ', End Date: ' || v_end_dates(i) || ', Total Days: ' || v_total_days(i));
    end loop;
  else
    dbms_output.put_line('Student with ID ' || v_student_id || ' has not rented any books.');
  end if;
end;
/

 

  

--trigger for counting total days
CREATE OR REPLACE TRIGGER calculate_total_days
BEFORE INSERT OR UPDATE ON Operation
FOR EACH ROW
BEGIN
  :NEW.total_days := TRUNC(:NEW.end_date) - TRUNC(:NEW.start_date);
END;
/
insert into Operation (SL_no, book_code, student_id, start_date, end_date, issued_by) values (4,1 , 1,'03-NOV-2023','03-DEC-2023', 2);
select * from Operation;



--renting book

set serveroutput on

-- Create or replace the procedure updateBook status
CREATE OR REPLACE PROCEDURE updateBook(
  p_book_code IN NUMBER
)
AS
BEGIN
  update book set status = 'rented' where book_code = p_book_code;
  dbms_output.put_line('Book status updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error updating book: ' || SQLERRM);
END;
/

-- Create or replace the function incrementRentedBooks in the student table
CREATE OR REPLACE FUNCTION incrementRentedBooks(p_student_id IN NUMBER) RETURN NUMBER AS
  v_total_rented_books Student.total_rented_books%TYPE;
BEGIN
  select total_rented_books + 1 into v_total_rented_books from Student where student_id = p_student_id; 
  return v_total_rented_books;
END;
/

DECLARE 
  v_book_code Book.book_code%TYPE := 3;
  v_student_id Student.student_id%TYPE := 1;
  v_status Book.status%TYPE;
  v_total_books Student.total_rented_books%TYPE;
  v_max_sl_no Operation.sl_no%TYPE;
  v_start_day Operation.start_date%TYPE:='01-JAN-2024';
  v_end_day Operation.end_date%TYPE:='26-FEB-2024';
  v_stuff Operation.issued_by%TYPE:= 3;
BEGIN
  -- Get the maximum SL_no value from the Operation table
  select MAX(sl_no) into v_max_sl_no from Operation;
  
  -- Increment the maximum SL_no value by 1 to get the current SL_no value
  v_max_sl_no := v_max_sl_no + 1;
  
  -- Fetching status of the book
  select status into v_status from Book where book_code = v_book_code;
    
  IF v_status = 'rented' THEN
    dbms_output.put_line('This book is not available right now');
  ELSE 
    -- Inserting into Operation table with the current SL_no value
    insert into Operation(SL_no, book_code, student_id, start_date, end_date, issued_by) 
    values (v_max_sl_no, v_book_code, v_student_id, v_start_day, v_end_day, v_stuff);
    
    -- Updating the book status
    updateBook(v_book_code);
    
    -- Incrementing the total rented books for the student
    v_total_books := incrementRentedBooks(v_student_id);
    
    -- Updating the total rented books for the student
    update Student set total_rented_books = v_total_books where student_id = v_student_id;
    
   
  END IF;   
END;
/
select * from Book;
select * from Student;
select * from Operation;


--trigger for inserting book table
-- Create the trigger to update no_of_books when a new book is added
CREATE OR REPLACE TRIGGER increase_no_of_books
AFTER INSERT ON Book
FOR EACH ROW
BEGIN
  -- Increment no_of_books for the corresponding author
  UPDATE Author SET no_of_books = no_of_books + 1 WHERE author_id = :NEW.author_id;

  -- Increment no_of_books for the corresponding book_type
  UPDATE book_type SET no_of_books = no_of_books + 1 WHERE type_id = :NEW.type_id;
END;
/

insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(7,'GOT',3,3,'This book is GOT','available');
select * from Book;
select * from Author;
select * from book_type;

--trigger for deleting a book row

CREATE OR REPLACE TRIGGER decrease_no_of_books
AFTER DELETE ON Book
FOR EACH ROW
BEGIN
  -- Decrement no_of_books for the corresponding author
  UPDATE Author SET no_of_books = no_of_books - 1 WHERE author_id = :OLD.author_id;

  -- Decrement no_of_books for the corresponding book_type
  UPDATE book_type SET no_of_books = no_of_books - 1 WHERE type_id = :OLD.type_id;
END;
/
delete from book where book_code=7;
select * from book;
select * from author;
select * from book_type;




