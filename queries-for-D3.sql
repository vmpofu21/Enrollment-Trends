use prj_iccs_enrollments;

select DISTINCT courses.title, courses.course_ID, students_courses.semester_ID
from students_courses 
  join courses 
  on students_courses.course_ID = courses.course_ID
where semester_ID = 8;

select DISTINCT s.student_ID
from students_courses sc
join student s 
  on s.student_ID = sc.student_ID
join courses c
  on c.course_ID = sc.course_ID
where sc.semester_ID = 8
  and sc.withdrew_status = 'Completed'
  and sc.course_ID in (20000, 20300, 21800, 20400, 20500, 23100,22100,22200,22400,21100, 21500, 23800)
group by s.student_ID;



SELECT s.student_ID, c.course_ID
FROM students_courses sc
JOIN student s ON s.student_ID = sc.student_ID
JOIN courses c ON c.course_ID = sc.course_ID
WHERE sc.semester_ID = 8
  AND sc.withdrew_status = 'Completed'
  AND sc.course_ID IN (20000, 20300, 21800, 20400, 20500, 23100, 22100, 22200, 22400, 21100, 21500, 23800)
  AND sc.student_ID IN (
      SELECT student_ID
      FROM students_courses
      WHERE semester_ID = 8
      AND withdrew_status = 'Completed'
      GROUP BY student_ID
      HAVING COUNT(course_ID) >= 2
  )
ORDER BY s.student_ID;


SELECT c1.course_ID AS source_ID, c2.course_ID AS target_ID
FROM courses c1
JOIN courses c2
  ON c1.course_ID < c2.course_ID  -- Ensures each pair appears only once
WHERE c1.course_ID IN (20000, 20300, 21800, 20400, 20500, 23100, 22100, 22200, 22400, 21100, 21500, 23800)
  AND c2.course_ID IN (20000, 20300, 21800, 20400, 20500, 23100, 22100, 22200, 22400, 21100, 21500, 23800)
ORDER BY c1.course_ID, c2.course_ID;
