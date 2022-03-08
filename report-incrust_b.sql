SELECT 
coc.name as "Categoria",
co.fullname as "Curso", 
u.username as "Usuario",
u.firstname as "Nombre", 
u.lastname as "Apellido", 
u.email as "Correo",
(CASE
   WHEN u.firstaccess=0 THEN 'Nunca'
   WHEN u.firstaccess=u.firstaccess THEN from_unixtime(u.firstaccess,'%d-%m-%Y %h:%m:%s')
 END) as "1er Acceso Campus",
(CASE
   WHEN u.lastaccess=0 THEN 'Nunca'
   WHEN u.lastaccess=u.lastaccess THEN from_unixtime(u.lastaccess,'%d-%m-%Y %h:%m:%s')
 END) as "Ultimo Acceso Campus",
from_unixtime(ue.timemodified, "%d-%m-%Y") as "Matriculacion",
(SELECT from_unixtime(ua1.timeaccess, "%d-%m-%Y") 
 FROM prefix_user_lastaccess ua1 
 WHERE ua1.userid = u.id 
 AND ua1.courseid=co.id) as "Ultimo acceso al curso",
(IF (cc.timecompleted, "Finalizado","")) as "Estado Curso",
from_unixtime(cc.timecompleted, "%d-%m-%Y") as "Fecha finalizado",
(
 	SELECT ROUND(gg.finalgrade,2)
	FROM prefix_grade_grades gg
	JOIN prefix_grade_items gi on gi.id = gg.itemid
	WHERE gi.itemtype='course'
	AND gi.courseid=co.id
	AND gg.userid=u.id
) as "nota curso"

FROM prefix_role_assignments ra
JOIN prefix_context con ON con.id=ra.contextid
JOIN prefix_course AS co ON co.id=con.instanceid %%FILTER_COURSES:co.id%%
JOIN prefix_user AS u ON u.id=ra.userid 
JOIN prefix_role AS r ON r.id=ra.roleid
JOIN prefix_enrol AS e ON e.courseid=co.id
JOIN prefix_user_enrolments AS ue ON ue.enrolid=e.id and ue.userid=u.id
LEFT JOIN prefix_course_completions AS cc ON cc.userid=u.id AND cc.course=co.id
JOIN prefix_course_categories AS coc ON coc.id=co.category %%FILTER_CATEGORIES:coc.id%%
%%FILTER_STARTTIME:cc.timecompleted:>%%
%%FILTER_ENDTIME:cc.timecompleted:<%%
WHERE 
co.id= "%%FILTER_VAR%%"
AND con.contextlevel=50
AND ra.roleid in (5)
%%FILTER_SEARCHTEXT:u.username:~%%
ORDER BY co.id
