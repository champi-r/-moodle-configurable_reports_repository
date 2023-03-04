SELECT 
f.id, cm.id as cmid, f.component as Componente, f.filearea as Area, c.fullname as Curso, 
c.shortname as Nombre_Corto,f.filename as Archivo, (f.filesize/1048576) as MB 

FROM
prefix_files f 
JOIN prefix_context co ON f.contextid = co.id
JOIN prefix_course_modules cm ON cm.id = co.instanceid 
JOIN prefix_course c ON cm.course = c.id %%FILTER_COURSES:c.id%%
WHERE filesize <>0 AND filearea <>  'draft' 
AND co.contextlevel =70 
