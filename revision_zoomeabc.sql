SELECT 
cc.name as categoria,
co.id as cursoid,
concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',co.id,'">',co.fullname,'</a>') AS curso,
z.meeting_id as id_meet,
z.join_url as url_meet,
z.created_at as fecha_creacion,
z.name,
cm.id as idmodulezoom,
cm.deletioninprogress as del_progres,
from_unixtime((z.start_time),'%d-%m-%Y %hh:%mm') as start_time,
from_unixtime((z.timemodified), '%d-%m-%Y %hh:%mm') as timemodified,
z.host_id,
z.recurring,
z.webinar,
z.duration,
z.password
from prefix_zoomeabc z
JOIN prefix_course co ON co.id = z.course %%FILTER_COURSES:co.id%%
JOIN prefix_course_categories cc ON cc.id = co.category %%FILTER_CATEGORIES:cc.id%%
JOIN prefix_course_modules cm ON cm.course=co.id AND cm.instance=z.id

#filtros: sacar hashtags para descomentar codigo
WHERE
co.id=128 #Buscar por ID curso
#AND 
#cm.id = 8937 #Buscar por ID modulo actividad
#AND 
#z.meeting_id = 96914816321 #Buscar por ID meet Zoom
#AND 
#z.name like '%clase 13%' #Buscar por nombre reunión '%NOMBRE REUNION%'
