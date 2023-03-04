SELECT 
f.filearea as area, 
#f.source as recurso,
#f.contenthash as contenthash,
#co.path as path,
CASE co.contextlevel 
	WHEN 30 THEN (SELECT concat('<a target="_new" href="%%WWWROOT%%/user/view.php?id=',u.id,'">',u.lastname,' ',u.firstname,'</a>') FROM prefix_user as u  WHERE u. id = co.instanceid)
	WHEN 50 THEN (SELECT concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',c.id,'">',c.fullname,'</a>') FROM prefix_course as c  WHERE c. id = co.instanceid)
	#ELSE CONCAT('/filedir/', LEFT(f.contenthash,2), "/",SUBSTRING(f.contenthash,3,2),'/', f.contenthash)
	ELSE '-'
 END AS 'curso / usuario',
f.filename as 'nombre archivo', 
(f.filesize/1000/1000) as 'tamaño (MB)' , 
from_unixtime(f.timecreated) as 'fecha de creación', 
from_unixtime(f.timemodified) as 'fecha de modificación'
FROM {files} f
join {context} co on co.id = f.contextid
WHERE mimetype LIKE 'application/vnd.moodle.backup'
