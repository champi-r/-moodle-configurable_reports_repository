SELECT
f.course,
f.name as forum,
fd.name as posts,
g.name as grupo,
createdby.person as createdby,
createdby.role,
from_unixtime(createdby.created,"%d-%m-%Y %H:%i") as created,
replicas.cant as replicas,
intervention.cant as interventionprof,
ultimated.person as ult_user,
ultimated.role as ult_role,
ultimated.created as ult_fecha,
concat('<a href="%%ROOT%%/mod/forum/discuss.php?d=',fd.id,'" target="_blank">',CONCAT('https://argentinaprograma.inti.gob.ar/mod/forum/discuss.php?d=',fd.id),'</a>') AS URL

FROM prefix_forum AS f
JOIN prefix_forum_discussions AS fd ON fd.forum=f.id
LEFT JOIN (
  	SELECT discussion, count(id) as cant
  	FROM prefix_forum_posts AS fp
  	WHERE fp.parent!=0
  	GROUP BY fp.discussion
	) as replicas ON replicas.discussion=fd.id
LEFT JOIN (
  SELECT co.id as courseid, u.id as userid, concat(u.firstname,' ', u.lastname) as person, r.shortname as role, fp.discussion, fp.created
	FROM prefix_role_assignments ra
	JOIN prefix_context con ON con.id=ra.contextid
	JOIN prefix_course AS co ON co.id=con.instanceid
	JOIN prefix_user AS u ON u.id=ra.userid
	JOIN prefix_role AS r ON r.id=ra.roleid
	JOIN prefix_forum_posts AS fp ON fp.userid=u.id
	WHERE con.contextlevel=50 AND fp.parent=0
  ) as createdby ON createdby.courseid=f.course AND createdby.userid=fd.userid AND createdby.discussion=fd.id
LEFT JOIN (
  SELECT co.id as courseid, fp.discussion, count(*) as cant
	FROM prefix_role_assignments ra
	JOIN prefix_context con ON con.id=ra.contextid
	JOIN prefix_course AS co ON co.id=con.instanceid
	JOIN prefix_user AS u ON u.id=ra.userid
	JOIN prefix_role AS r ON r.id=ra.roleid
	JOIN prefix_forum_posts AS fp ON fp.userid=u.id
	WHERE con.contextlevel=50 AND fp.parent!=0 AND r.id!=5
	GROUP BY co.id, fp.discussion
  ) AS intervention ON intervention.courseid=f.course AND intervention.discussion=fd.id
LEFT JOIN (
  SELECT co.id as courseid, u.id as userid, concat(u.firstname,' ', u.lastname) as person, r.shortname as role, fp.discussion, max(from_unixtime(fp.created,"%d-%m-%Y %H:%i")) as created
	FROM prefix_role_assignments ra
	JOIN prefix_context con ON con.id=ra.contextid
	JOIN prefix_course AS co ON co.id=con.instanceid
	JOIN prefix_user AS u ON u.id=ra.userid
	JOIN prefix_role AS r ON r.id=ra.roleid
	JOIN prefix_forum_posts AS fp ON fp.userid=u.id
	WHERE con.contextlevel=50 AND fp.parent!=0
	GROUP BY co.id, fp.discussion
	ORDER BY co.id, fp.discussion, fp.created DESC
  ) as ultimated ON ultimated.courseid=f.course AND ultimated.discussion=fd.id
JOIN prefix_groups AS g ON g.id=fd.groupid
JOIN prefix_course AS co ON co.id=f.course
WHERE f.type='general'
AND co.fullname like '%yoprogramo%'
ORDER BY createdby.created
