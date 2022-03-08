SELECT
concat('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=',u.id,'">',u.username,'</a>') as "username",
u.firstname,
u.lastname,
u.email,
converaux.conversaciones as "conversaciones entabladas",
enviados.cant as "mensajes enviados",
recibidos.cant as "mensajes recibidos",
aux1.rol,
gr.grupo,
aux1.courseid as cursos

FROM prefix_user as u
LEFT JOIN (
    SELECT u1.id as userid, GROUP_CONCAT(co.id) as courseid, GROUP_CONCAT(DISTINCT r.shortname) as rol
    FROM prefix_user AS u1 
    JOIN prefix_role_assignments AS ra ON ra.userid=u1.id
    JOIN prefix_context AS con ON con.id=ra.contextid
    JOIN prefix_course AS co ON co.id=con.instanceid
    JOIN prefix_role AS r ON r.id=ra.roleid
    WHERE con.contextlevel=50 
  	GROUP BY u1.id
) AS aux1 ON aux1.userid=u.id
LEFT JOIN (
    SELECT GROUP_CONCAT(DISTINCT g.name) AS grupo, gm.userid, g.courseid
    FROM prefix_groups AS g
    JOIN prefix_groups_members AS gm ON gm.groupid=g.id
    GROUP BY gm.userid
) AS gr ON gr.userid=u.id AND (gr.courseid BETWEEN 2 AND 10)
LEFT JOIN (
    SELECT conver.useridfrom, count(conver.conversationid) as conversaciones
	FROM (SELECT useridfrom, conversationid
	    FROM prefix_messages
	    GROUP BY useridfrom, conversationid
        ) AS conver
    GROUP BY useridfrom
    ) AS converaux ON converaux.useridfrom=u.id
LEFT JOIN (
	SELECT useridfrom, count(id) AS cant
	FROM prefix_messages
	GROUP BY useridfrom
) AS enviados ON enviados.useridfrom=u.id
LEFT JOIN (
    SELECT mcm.userid, count(m.id) as cant
    FROM prefix_message_conversation_members AS mcm
    JOIN prefix_messages AS m ON m.conversationid=mcm.conversationid
	WHERE mcm.userid != m.useridfrom
	GROUP BY mcm.userid
) AS recibidos ON recibidos.userid=u.id

WHERE u.deleted=0
ORDER BY conversaciones DESC, enviados.cant DESC, recibidos.cant DESC
