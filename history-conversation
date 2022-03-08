SELECT
from_unixtime(m.timecreated) AS "fecha",
m.conversationid,
m.subject AS "Asunto",
m.fullmessage AS "mensaje",
u.username,
u.firstname,
u.lastname,
u.email,
aux1.rol,
gr.grupo,
aux1.courseid as cursos,
recepcion.receptor

FROM prefix_messages AS m
JOIN prefix_user AS u ON u.id=m.useridfrom %%FILTER_SEARCHTEXT:m.conversationid:=%%
JOIN (
	SELECT mcm.conversationid, mcm.userid, concat(u2.firstname," ",u2.lastname) as receptor
  	FROM prefix_message_conversation_members AS mcm
  	JOIN prefix_user AS u2 ON u2.id=mcm.userid
) as recepcion ON recepcion.conversationid=m.conversationid AND recepcion.userid!=u.id
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
    SELECT GROUP_CONCAT(DISTINCT g.name) as grupo, gm.userid, g.courseid
    FROM prefix_groups AS g
    JOIN prefix_groups_members AS gm ON gm.groupid=g.id
    GROUP BY gm.userid
) AS gr ON gr.userid=u.id AND (gr.courseid BETWEEN 2 AND 10)
