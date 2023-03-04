SELECT 
concat('<a href="%%ROOT%%/course/view.php?id=',c.id,'" target="_blank">',c.fullname,'</a>') as Curso, 
c.shortname as Nombre_Corto, 
(from_unixtime(c.timecreated, '%d-%m-%Y')) as fecha_creacion,
(from_unixtime(c.timemodified, '%d-%m-%Y')) as fecha_modificacion,
(SELECT
count(cm1.module)
from prefix_course co1
join prefix_course_modules cm1 on cm1.course=co1.id
join prefix_modules m on m.id=cm1.module
where co1.id=co.id
and cm1.deletioninprogress!=1
group by co1.id) as actividades,

sum(f.filesize)/1000000 as MB 

FROM prefix_files f 
JOIN prefix_context co ON f.contextid = co.id 
JOIN prefix_course_modules cm ON cm.id = co.instanceid 
JOIN prefix_course c ON cm.course = c.id 

WHERE filesize <>0 AND filearea <>  'draft' 
AND co.contextlevel =70 

GROUP BY Curso,Nombre_Corto 

ORDER BY MB DESC
