--insertion
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

select * from student;


--
--renting book

set serveroutput on

-- Create or replace the procedure updateBook
CREATE OR REPLACE PROCEDURE updateBook(
  p_book_code IN NUMBER
)
AS
BEGIN
  UPDATE book SET status = 'rented' WHERE book_code = p_book_code;
  -- Add error handling and logging
  dbms_output.put_line('Book updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error updating book: ' || SQLERRM);
END;
/

-- Create or replace the function incrementRentedBooks
CREATE OR REPLACE FUNCTION incrementRentedBooks(p_student_id IN NUMBER) RETURN NUMBER AS
  v_total_rented_books Student.total_rented_books%TYPE;
BEGIN
  SELECT total_rented_books + 1 INTO v_total_rented_books FROM Student WHERE student_id = p_student_id; 
  RETURN v_total_rented_books;
END;
/

DECLARE 
  v_book_code Book.book_code%TYPE := 3;
  v_student_id Student.student_id%TYPE := 1;
  v_status Book.status%TYPE;
  v_total_books Student.total_rented_books%TYPE;
  v_max_sl_no Operation.sl_no%TYPE;
BEGIN
  -- Get the maximum SL_no value from the Operation table
  SELECT MAX(sl_no) INTO v_max_sl_no FROM Operation;
  
  -- Increment the maximum SL_no value by 1 to get the current SL_no value
  v_max_sl_no := v_max_sl_no + 1;
  
  -- Fetching status of the book
  SELECT status INTO v_status FROM Book WHERE book_code = v_book_code;
    
  IF v_status = 'rented' THEN
    dbms_output.put_line('This book is not available right now');
  ELSE 
    -- Inserting into Operation table with the current SL_no value
    INSERT INTO Operation(SL_no, book_code, student_id, start_date, end_date, total_days, issued_by) 
    VALUES (v_max_sl_no, v_book_code, v_student_id, TO_DATE('03-NOV-2023', 'DD-MON-YYYY'), TO_DATE('03-DEC-2023', 'DD-MON-YYYY'), 30, 1);
    
    -- Updating the book status
    updateBook(v_book_code);
    
    -- Incrementing the total rented books for the student
    v_total_books := incrementRentedBooks(v_student_id);
    
    -- Updating the total rented books for the student
    UPDATE Student SET total_rented_books = v_total_books WHERE student_id = v_student_id;
    
    -- Displaying updated student information
    FOR student_rec IN (SELECT * FROM Student WHERE student_id = v_student_id) LOOP
      dbms_output.put_line(student_rec.student_id || ' ' || student_rec.total_rented_books);
    END LOOP;
  END IF;   
END;
/
