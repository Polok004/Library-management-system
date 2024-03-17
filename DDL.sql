CREATE TABLE book_type (
  type_id number(20),
  type_name varchar2(50),
  no_of_books integer,
  primary key(type_id)
);



CREATE TABLE Author (
  author_id number(20),
  author_name varchar2(50),
  author_email varchar2(50),
  no_of_books integer,
  primary key(author_id)
);


CREATE TABLE Stuff (
  stuff_id number(20),
  stuff_name varchar2(50),
  stuff_email varchar2(50),
  stuff_phone varchar2(50),
  primary key(stuff_id)
);


CREATE TABLE Book (
 book_code number(20),
 book_name varchar2(50),
 author_id number(20),
 type_id number(20),
 book_description varchar2(100),
 status varchar2(20) CHECK (status IN ('available','rented')),
 primary key(book_code),
 foreign key(author_id) references Author(author_id),
 foreign key(type_id) references book_type(type_id)
);

CREATE TABLE Student (
 student_id number(20),
 student_name varchar2(50),
 student_email varchar2(50),
 student_phone varchar2(50),
 total_rented_books integer,
 primary key(student_id)
);

CREATE TABLE Operation (
 SL_no number(20),
 book_code number(20),
 student_id number(20),
 start_date DATE,
 end_date DATE ,
 total_days integer,
 issued_by number(20),
 CONSTRAINT check_date CHECK (end_date > start_date),
 primary key(SL_no),
 foreign key(book_code) references Book(book_code),
 foreign key(student_id) references Student(student_id),
 foreign key(issued_by) references Stuff(stuff_id)
);

