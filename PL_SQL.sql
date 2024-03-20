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
-- Enabling server output
SET SERVEROUTPUT ON;

-- Creating the updateBook procedure
CREATE OR REPLACE PROCEDURE updateBook(
  book_code2 IN NUMBER
)
AS
BEGIN
  UPDATE book SET status = 'rented' WHERE book_code = book_code2;
  -- Use dbms_output.put_line or any desired logging mechanism to provide feedback
  dbms_output.put_line('Book updated successfully.');
END;
/

-- Creating the fun function
CREATE OR REPLACE FUNCTION fun(student_id2 IN NUMBER) RETURN NUMBER AS
  value student.total_rented_books%TYPE;
BEGIN
  SELECT total_rented_books INTO value FROM student WHERE student_id = student_id2; 
  RETURN value + 1;
END;
/

-- Declaring variables
DECLARE 
  counter NUMBER := 0;
  book_code1 Book.book_code%TYPE := 3;
  student_id1 STUDENT.STUDENT_ID%TYPE := 1;
  status1 Book.status%TYPE;
  totalBooks STUDENT.TOTAL_RENTED_BOOKS%TYPE;
  operation_cursor SYS_REFCURSOR;
  operation_row OPERATION%ROWTYPE;
BEGIN
  -- Opening cursor
  OPEN operation_cursor FOR
    SELECT * FROM operation;
  
  -- Fetching rows
  LOOP
    FETCH operation_cursor INTO operation_row;
    EXIT WHEN operation_cursor%NOTFOUND;
    
    counter := counter + 1;
    
    -- Retrieving book status
    SELECT status INTO status1 FROM book WHERE book_code = book_code1;
    
    IF status1 = 'rented' THEN
      dbms_output.put_line('This book is not available right now');
    ELSE 
      -- Inserting into Operation table
      INSERT INTO Operation(SL_no, book_code, student_id, start_date, end_date, total_days, issued_by) 
      VALUES (counter + 1, book_code1, student_id1, TO_DATE('03-NOV-2023', 'DD-MON-YYYY'), TO_DATE('03-DEC-2023', 'DD-MON-YYYY'), 30, 1);
      
      -- Calling the updateBook procedure
      updateBook(book_code1);
      
      -- Calling the fun function to update totalBooks
      totalBooks := fun(student_id1);
      
      -- Updating student table
      UPDATE student SET TOTAL_RENTED_BOOKS = totalBooks WHERE student_id = student_id1;
      
      -- Displaying updated student information
      FOR student_rec IN (SELECT * FROM student WHERE student_id = student_id1) LOOP
        dbms_output.put_line(student_rec.student_id || ' ' || student_rec.total_rented_books);
      END LOOP;
    END IF;
  END LOOP;
  
  -- Closing cursor
  CLOSE operation_cursor;
END;
/
