-- CREATE TABLES SCRIPT ---

use prj_iccs_enrollments;

CREATE TABLE instructors (
	instructors_ID INT PRIMARY KEY,
	first_name varchar(80),
	last_name varchar(80)
);

CREATE TABLE class_year (
	class_year_ID INT PRIMARY KEY,
	class_year_name varchar(80)
);

-- drop table semester;

CREATE TABLE expgrad_year (
	expgrad_year_ID INT PRIMARY KEY,
	expgrad_year_name varchar(80)
);


CREATE TABLE semester (
	semester_ID INT PRIMARY KEY,
	semester_name varchar(80)
);

CREATE TABLE schedule_type (
	sched_ID INT PRIMARY KEY,
	sched_name varchar(80)
);


CREATE TABLE program_majors (
	program_majors_ID INT PRIMARY KEY,
	program_majors_name varchar(80)
);

CREATE TABLE minors (
	minor_ID INT PRIMARY KEY,
	minor_name varchar(80)
);



CREATE TABLE courses (
	course_ID INT PRIMARY KEY,
	title varchar(80),
	credits INT
);

-- drop table sections;
CREATE TABLE sections (
	section_ID INT PRIMARY KEY,
	section_title varchar(80),
	course_ID INT,
	instructors_ID INT,
	semester_ID INT,
	block varchar(80),
	FOREIGN KEY (semester_ID) REFERENCES semester(semester_ID),
	FOREIGN KEY (course_ID) REFERENCES courses(course_ID),
    FOREIGN KEY (instructors_ID) REFERENCES instructors(instructors_ID)
);

CREATE TABLE withdrewST (
	withdrew_ID INT PRIMARY KEY,
	student_ID INT,
	section_ID INT,
	instructors_ID INT,
	semester_ID INT,
	course_ID INT,
	FOREIGN KEY (student_ID) REFERENCES student(student_ID),
	FOREIGN KEY (section_ID) REFERENCES sections(section_ID),
	FOREIGN KEY (semester_ID) REFERENCES semester(semester_ID),
	FOREIGN KEY (course_ID) REFERENCES courses(course_ID),
    FOREIGN KEY (instructors_ID) REFERENCES instructors(instructors_ID));

-- drop table student;
CREATE TABLE student (
	student_ID INT PRIMARY KEY,
	ICID INT,
	email varchar(80),
	Major1_ID INT,
	Major2_ID INT,
	Minor1_ID INT,
    Minor2_ID INT,
    Minor3_ID INT,
    class_year_ID INT,
    expgrad_year_ID INT,
    FOREIGN KEY (Major1_ID) REFERENCES program_majors(program_majors_ID),
    FOREIGN KEY (Major2_ID) REFERENCES program_majors(program_majors_ID),
    FOREIGN KEY (Minor1_ID) REFERENCES minors(minor_ID),
    FOREIGN KEY (Minor2_ID) REFERENCES minors(minor_ID),
    FOREIGN KEY (Minor3_ID) REFERENCES minors(minor_ID),
	FOREIGN KEY (class_year_ID) REFERENCES class_year(class_year_ID),
    FOREIGN KEY (expgrad_year_ID) REFERENCES expgrad_year(expgrad_year_ID));
    
   
   create table Courses_Instructors(
   ID INT primary key,
   course_ID INT,
   instructors_ID INT,
   FOREIGN KEY (instructors_ID) REFERENCES instructors(instructors_ID),
   FOREIGN KEY (course_ID) REFERENCES courses(course_ID));
  
 
  -- drop table Students_Courses;
   create table Students_Courses(
   ID INT primary key,
   student_ID INT,
   course_ID INT,
   withdrew_status varchar(80),
   semester_ID INT,
   FOREIGN KEY (semester_ID) REFERENCES semester(semester_ID),
   FOREIGN KEY (course_ID) REFERENCES courses(course_ID),
   FOREIGN KEY (student_ID) REFERENCES student(student_ID));
   
   
   
   
   