--insertion a new student
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




