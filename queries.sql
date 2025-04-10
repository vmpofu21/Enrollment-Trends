use prj_iccs_enrollments;

-- For those who graduated with CS majors, how many of them had taken and completed Comp 110 (course_ID - 20300) as their first CS course
-- join the students_courses table with the student table then Filter all students who took course_ID - 20300 
-- then filter all students whose Major1_ID = 38 
-- and expgrad_year_ID = (140,141,184,164)
-- Then make sure course_ID - 20300 was the first CS they took (CAN ACHIEVE THIS BY JOINING semester with sections, 
-- then sections with students_courses).
-- For instance, if they took the course in semester 2, but also took another cs course in semster 1, then they wouldnt qualify

-- ENGLISH VERSION OF THE QUESTION
-- For those who graduated with CS majors, how many of them had taken Comp 105 
-- (course_ID - 20000) as their first CS course?

-- SQL VERSION OF THE QUESTION
 create view CS_Graduates as(
 select s.student_ID, s.email
 from student s
 where s.Major1_ID = 38
  and s.expgrad_year_ID in (196,140,141,184,164,123,155,134,185,137,199,153,162,126,120,104)
 );

 create view CSMajors_WebDev_First as(
  select COUNT(csg.student_ID)
  from CS_Graduates csg
  join students_courses sc
  on sc.student_ID = csg.student_ID
  where course_ID = 20000
  and (sc.withdrew_status = 'completed')
   and not exists (
      select 1
      from students_courses sc2
      where sc2.student_ID = sc.student_ID
        and sc2.course_ID != 20000
        and sc2.semester_ID < sc.semester_ID
    )
 );

 create view CSMajors_CS1_First as(
  select distinct csg.student_ID, csg.email
  from CS_Graduates csg
  join students_courses sc
  on sc.student_ID = csg.student_ID
  where course_ID = 20400
   and not exists (
      select 1
      from students_courses sc2
      where sc2.student_ID = sc.student_ID
        and sc2.course_ID != 20400
        and sc2.semester_ID < sc.semester_ID
    )
 );

 

 -- ---------------------------------------------------------------- --------------------------------------------------------------
 
 
-- WHAT IS THE MOST COMMON PATHWAY OF STUDENTS PURSUING COMPUTER SCIENCE AS A MINOR?
-- Filter for CS Minors: Identify students with minor_ID corresponding to CS.
-- Extract Course Sequences: For each student, get the list of courses in the order they were taken (based on semester_ID).
-- Group and Count Pathways: Group the sequences into common patterns and count the occurrences.


-- Filter for CS Minors: Identify students with minor_ID corresponding to CS.
create view cs_students AS (
    SELECT
        s.student_ID,
        s.email
    from student s
    join minors m
    on s.Minor1_ID = m.minor_ID
    where s.Minor1_ID = 85
        
);

-- Get all the courses taken by CS minors

create view CS_Minor_Student_Courses AS (
	select DISTINCT
        sc.student_ID,
        sc.course_ID
    from students_courses sc
    join cs_students cs
    on sc.student_ID = cs.student_ID
    join sections  s2
    on sc.course_ID = s2.course_ID
);



-- WHen were the above courses taken



-- ---------------------------------------------------------------- --------------------------------------------------------------
-- WHAT IS THE LIKELIHOOD THAT A STUDENT WHO ENROLLED AND COMPLETED COMP 110 WILL PROCEED TO ENROLL IN COMP 220?
-- Use conditional probability:
 	-- Use the students_courses table to filter for students who completed COMP 110 --> 20300
 	-- Use the same table to find students who enrolled in COMP 220 --->20700
 	-- Perform a JOIN between the two groups of students to find those who took both COMP 110 and COMP 220.
 	-- Divide the number of students who took both courses by the number of students who took COMP 110.
 
-- Use the students_courses table to filter for students who completed COMP 110 --> 20300
create view compltdCOMP110 as(
select s.student_ID, s.email,c.title,  sc.withdrew_status
from student s
join students_courses sc 
on sc.student_ID = s.student_ID
join courses c
on sc.course_ID = c.course_ID
where sc.course_ID = 20300
  and (sc.withdrew_status != 'withdrew');
);

select  count(*) as total_count_CMPLT110
from student s
join students_courses sc 
on sc.student_ID = s.student_ID
join courses c
on sc.course_ID = c.course_ID
where sc.course_ID = 20300
  and (sc.withdrew_status != 'withdrew');



-- Use the same table to find students who enrolled in COMP 220 --->20700
create view compltdCOMP220 as(
select s.student_ID, s.email,c.title, sc.withdrew_status 
from student s
join students_courses sc 
on sc.student_ID = s.student_ID
join courses c
on sc.course_ID = c.course_ID
where sc.course_ID = 20700
  and (sc.withdrew_status != 'withdrew')
);


select count(*) as total_count_CMPLT220
from student s
join students_courses sc 
on sc.student_ID = s.student_ID
join courses c
on sc.course_ID = c.course_ID
where sc.course_ID = 20700
  and (sc.withdrew_status != 'withdrew');

 -- Perform a JOIN between the two groups of students to find those who took both COMP 110 and COMP 220.
create view compltd220_110 as (
select c1.student_ID, c1.email,c1.title, c1.withdrew_status 
from compltdCOMP110 c1
join compltdCOMP220 c2
on c1.student_ID = c2.student_ID
where c1.student_ID = c2.student_ID
);


select count(*) as total_count_BOTH
from compltdCOMP110 c1
join compltdCOMP220 c2
on c1.student_ID = c2.student_ID
where c1.student_ID = c2.student_ID;



-- ---------------------------------------------------------------- --------------------------------------------------------------
-- ARE STUDENTS WHO WITHDRAW FROM COMP 105 ---> 20000 LESS LIKELY TO ENROlL IN SUBSEQUENT CS CLASSES?
-- filter students who have withdrawn from COMP 105, make them distinct,
-- check if they ever took a course the semester after they had withdrew from 105, and that course shouldnt be 105
-- Compare their likelihood of continuing with those who completed COMP 105.

-- STUDNETS WHO WITHDREW ---
create view Withdrawn_Comp105 as (
    select distinct sc.student_ID, sc.semester_ID, s.email, sc.withdrew_status
    from students_courses sc
    join student s
    on s.student_ID = sc.student_ID
    where sc.course_ID = 20000 -- COMP 105
      and sc.withdrew_status = 'withdrew'
);

create view Subsequent_Enrollment as (
    select distinct w.student_ID, sc.course_ID, sc.semester_ID, w.email
    from Withdrawn_Comp105 w
    join students_courses sc
      on w.student_ID = sc.student_ID
    where sc.course_ID != 20000 -- Exclude COMP 105
      and sc.semester_ID > w.semester_ID -- Enrollments in later semesters;
);

-- how many students who withdrew from COMP 105 enrolled in subsequent courses - 8
select 
    count(distinct student_ID) as withdrew_and_enrolled_count
from Subsequent_Enrollment;




-- STUDENTS WHO COMPLETED --

create view Completed_Comp105 as (
    select distinct sc.student_ID, sc.semester_ID, s.email, sc.withdrew_status
    from students_courses sc
    join student s
    on s.student_ID = sc.student_ID
    where sc.course_ID = 20000 -- COMP 105
      and (sc.withdrew_status != 'withdrew')
);

create view Subsequent_Enrollment_Completed as (
    select distinct c.student_ID, sc.course_ID,  sc.semester_ID, c.email
    from Completed_Comp105 c
    join students_courses sc
      on c.student_ID = sc.student_ID
    where sc.course_ID != 20000 -- Exclude COMP 105
      and sc.semester_ID > c.semester_ID 
);

-- how many students who didint withdraw from COMP 105 enrolled in subsequent courses - 180
select 
    count(distinct student_ID) as completed_and_enrolled_count
from Subsequent_Enrollment_Completed;


-- LIKELYHOOD OF STUDENTS WHO WITHDREW FROM COMP 105 IS 13.8%
select 
    (withdrew_and_enrolled_count * 100.0) / (select count(distinct student_ID) 
                                             from Withdrawn_Comp105) as withdrew_likelihood
from (select count(distinct student_ID) as withdrew_and_enrolled_count
      from Subsequent_Enrollment) t;
   
-- LIKELYHOOD OF STUDENTS WHO COMPLETED  COMP 105 IS 22.4%
 select 
    (completed_and_enrolled_count * 100.0) / (select count(distinct student_ID) 
                                              from Completed_Comp105) as completed_likelihood
from (select count(distinct student_ID) as completed_and_enrolled_count
      from Subsequent_Enrollment_Completed) t;


 
-- ---------------------------------------------------------------- --------------------------------------------------------------

-- Was there a percentage increase or decrease in overall enrollment in CS 171 post-COVID compared to COVID years?

-- filter enrollments for post covid semester (2023 - 2024)
-- filter enrollments for  covid semester (2020 - 2021 - 2022)
-- convert to percentage and drwa conclusion
     
select 
    c.course_ID,
    c.title,
    count(distinct sc.student_ID) as total_enrollments
from students_courses sc
join courses c 
    on sc.course_ID = c.course_ID
group by c.course_ID, c.title
order by total_enrollments desc;


-- count is 213
select count(*) as COVID_enrolmnts
from students_courses sc
where semester_ID in (2, 3, 4, 5,6)
and course_ID = 20400;

-- count is 224
select count(*) as postCOVID_enrolmnts
from students_courses sc
where semester_ID in (7, 8, 9,10,11)
and course_ID = 20400;



   


-- ---------------------------------------------------------------- --------------------------------------------------------------
-- WHAT IS THE MAXIMUM NUMBER OF COMPLETED CS COURSES TAKEN BY NON-CS MAJORS/MINORS, SHOW THE STUDENTS MAJORS AND MINORS?
     
-- filter students who are not CS majors/minors
create view NON_CSmajorsORminors as (
select distinct s.student_ID, s.email, pm.program_majors_name, m.minor_name
from students_courses sc
join student s
on sc.student_ID = s.student_ID
left join program_majors pm
on s.Major1_ID = pm.program_majors_ID
left join minors m
on s.Minor1_ID = m.minor_ID
  WHERE 
        (s.Major1_ID IS NULL OR s.Major1_ID != 38)
        AND (s.Major2_ID IS NULL OR s.Major2_ID != 38)
        AND (s.Minor1_ID IS NULL OR s.Minor1_ID != 85)
        AND (s.Minor2_ID IS NULL OR s.Minor2_ID != 85)
        AND (s.Minor3_ID IS NULL OR s.Minor3_ID != 85)
);



-- count the number of courses taken by each student

SELECT n.student_ID, n.email, COUNT(sc.course_ID) AS course_count
FROM NON_CSmajorsORminors n
JOIN students_courses sc 
ON n.student_ID = sc.student_ID
where  (sc.withdrew_status != 'withdrew')
GROUP BY n.student_ID, n.email
ORDER BY course_count DESC;

-- get the maximum number
-- they should have completed the course

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     