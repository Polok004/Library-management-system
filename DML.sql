insert into book_type(type_id,type_name,no_of_books) values(1,'Computer Science',2);
insert into book_type(type_id,type_name,no_of_books) values(2,'Matarial Science',1);
insert into book_type(type_id,type_name,no_of_books) values(3,'Mathematics',2);
insert into book_type(type_id,type_name,no_of_books) values(4,'Fictional',1);


insert into Author(author_id,author_name,author_email,no_of_books) values(1,'Dr. Hasan','hasan55@gmail.com',1);
insert into Author(author_id,author_name,author_email,no_of_books) values(2,'Dr. Kamal','kamal35@gmail.com',1);
insert into Author(author_id,author_name,author_email,no_of_books) values(3,'Dr. Rafi','rafi@gmail.com',2);
insert into Author(author_id,author_name,author_email,no_of_books) values(4,'Dr. Sho0hag','shohag@gmail.com',2);


insert into Stuff(stuff_id,stuff_name,stuff_email,stuff_phone) values(1,'Prokas','prokash0@gmail.com','018347373');
insert into Stuff(stuff_id,stuff_name,stuff_email,stuff_phone) values(2,'Doya','doya240@gmail.com','0145347373');
insert into Stuff(stuff_id,stuff_name,stuff_email,stuff_phone) values(3,'Avijit','avijit0@gmail.com','0198347373');


insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(1,'Database Management',2,1,'This book is for CSE students','available');
insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(2,'Web development',1,1,'This book is for CSE students','rented');
insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(3,'Statistics and Probability',4,3,'This book is for Math students','available');
insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(4,'Furier Series',3,3,'This book is for Math students','available');
insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(5,'Natural Resourse',3,2,'This book is for Matarial students','rented');
insert into Book(book_code,book_name,author_id,type_id,book_description,status) values(6,'Naruto',4,4,'This book is fictional','rented');


insert into Student(student_id,student_name,student_email,student_phone,total_rented_books) values(1,'Arnob Sarkar','sarkar420@gmail.com','01927834346',0);
insert into Student(student_id,student_name,student_email,student_phone,total_rented_books) values(2,'Arko Sarkar','ark420@gmail.com','01927834344',1);
insert into Student(student_id,student_name,student_email,student_phone,total_rented_books) values(3,'Rittik Saha','saha420@gmail.com','0192783345',2);
insert into Student(student_id,student_name,student_email,student_phone,total_rented_books) values(4,'Amit Roy','roy420@gmail.com','0192783422',0);


insert into Operation(SL_no,book_code,student_id,start_date,end_date,total_days,issued_by) values(1,5,3,'03-NOV-2023','03-DEC-2023',30,1);
insert into Operation(SL_no,book_code,student_id,start_date,end_date,total_days,issued_by) values(2,2,2,'05-DEC-2023','03-JAN-2024',32,2);
insert into Operation(SL_no,book_code,student_id,start_date,end_date,total_days,issued_by) values(3,4,3,'03-NOV-2023','03-DEC-2023',30,3);
