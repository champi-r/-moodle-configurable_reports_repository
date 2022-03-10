SELECT
f.course,
f.name AS forum,
fp.discussion,
fp.subject,
g.name AS grupo,
IF(fp.parent = 0, 'P', 'R') AS tipo,
concat(u.firstname,' ', u.lastname) as createdby, 
r.shortname as createdrole, 
from_unixtime(fp.created,"%d-%m-%Y %H:%i") AS created,
intervention.person,
intervention.role,
from_unixtime(intervention.created,"%d-%m-%Y %h:%i") as timeanswer,
concat(round((intervention.created-fp.created)/3600,2),' hs') as dif,
concat('<a href="%%ROOT%%/mod/forum/discuss.php?d=',fd.id,'" target="_blank">',CONCAT('https://argentinaprograma.inti.gob.ar/mod/forum/discuss.php?d=',fd.id),'</a>') AS URL

FROM prefix_forum_posts AS fp
JOIN prefix_forum_discussions AS fd ON fd.id=fp.discussion
JOIN prefix_forum AS f ON f.id=fd.forum
LEFT JOIN prefix_groups AS g ON g.id=fd.groupid
JOIN prefix_context AS con ON con.instanceid=f.course
LEFT JOIN prefix_role_assignments AS ra ON ra.contextid=con.id AND ra.userid=fp.userid
LEFT JOIN prefix_user AS u ON u.id=ra.userid
LEFT JOIN prefix_role AS r ON r.id=ra.roleid
JOIN prefix_course AS co ON co.id=f.course
LEFT JOIN (
  SELECT concat(u.firstname,' ', u.lastname) as person, r.shortname as role, fp.parent, fp.created
    FROM prefix_forum_posts AS fp
    JOIN prefix_forum_discussions AS fd ON fd.id=fp.discussion
    JOIN prefix_forum AS f ON f.id=fd.forum
    JOIN prefix_context AS con ON con.instanceid=f.course
    LEFT JOIN prefix_role_assignments AS ra ON ra.contextid=con.id AND ra.userid=fp.userid
    LEFT JOIN prefix_user AS u ON u.id=ra.userid
    LEFT JOIN prefix_role AS r ON r.id=ra.roleid
    WHERE con.contextlevel=50 AND fp.parent!=0 AND r.id IN (12,13,14,15)
  ) AS intervention ON intervention.parent=fp.id 
WHERE con.contextlevel=50
AND f.type='general'
AND co.fullname like '%yoprogramo%'
AND IF(fp.parent!=0, r.id=5,r.id)
ORDER BY f.course, f.id, fd.groupid, fp.discussion, fp.created, fp.parent
