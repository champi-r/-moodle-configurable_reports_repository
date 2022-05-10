SELECT
concat('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=',u.id,'">',u.username,'</a>') as "username",
u.firstname,
u.lastname,
u.email,
tk.cant as "tickets creados",
converaux.conversaciones as "conversaciones entabladas",
enviados.cant as "mensajes enviados",
recibidos.cant as "mensajes recibidos",
fcom1.cant as "foro comunidad - creados",
fcom2.cant as "foro comunidad - replicas",
fcur1.cant as "foro yoprogramo - creados",
fcur2.cant as "foro yoprogramo - replicas",
aux1.rol,
m.m1,
m.m2,
m.m3,
m.m4,
m.m5,
m.m6,
m.m7,
m.m8,
m.m9,
gr.grupo,
aux1.courseid as cursos

FROM prefix_user as u
JOIN (
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
LEFT JOIN (
  	SELECT 
    fp.userid,
    COUNT(fp.discussion) AS cant
    FROM prefix_forum_discussions AS fd
    JOIN prefix_forum_posts AS fp ON fp.discussion=fd.id
    WHERE fp.parent=0 AND fd.course IN (3,7)
    GROUP BY fp.userid
  ) as fcom1 ON fcom1.userid=u.id
LEFT JOIN (
    SELECT 
    fp.userid,
    COUNT(fp.discussion) AS cant
    FROM prefix_forum_discussions AS fd
    JOIN prefix_forum_posts AS fp ON fp.discussion=fd.id
    WHERE fp.parent!=0 AND fd.course IN (3,7)
    GROUP BY fp.userid
  ) as fcom2 ON fcom2.userid=u.id
LEFT JOIN (
  	SELECT 
    fp.userid,
    COUNT(fp.discussion) AS cant
    FROM prefix_forum_discussions AS fd
    JOIN prefix_forum_posts AS fp ON fp.discussion=fd.id
    WHERE fp.parent=0 AND fd.course IN (2,6)
    GROUP BY fp.userid
  ) as fcur1 ON fcur1.userid=u.id
LEFT JOIN (
    SELECT 
    fp.userid,
    COUNT(fp.discussion) AS cant
    FROM prefix_forum_discussions AS fd
    JOIN prefix_forum_posts AS fp ON fp.discussion=fd.id
    WHERE fp.parent!=0 AND fd.course IN (2,6)
    GROUP BY fp.userid
  ) as fcur2 ON fcur2.userid=u.id
LEFT JOIN (
	SELECT firstcontact AS userid, COUNT(*) AS cant
	FROM prefix_block_helpdesk_ticket
	GROUP BY firstcontact
  ) AS tk ON tk.userid=u.id
JOIN (
  	SELECT userid,MAX(module1) AS m1,
	MAX(module2) AS m2,MAX(module3) AS m3,
	MAX(module4) AS m4,MAX(module5) AS m5,
	MAX(module6) AS m6,MAX(module7) AS m7,
	MAX(module8) AS m8,MAX(module9) AS m9
	FROM prefix_local_reportinti
	WHERE courseid IN (2,6)
	GROUP BY userid) AS m ON m.userid=u.id
WHERE u.deleted=0 AND u.id IN (73,
18,
19,
21,
83,
26,
28,
33,
82,
74,
45,
46,
49,
51,
84,
57,
59,
61,
62,
63,
71,
65,
70,
66,
20,
22,
29,
34,
37,
39,
43,
52,
54,
60,
69,
24,
27,
30,
31,
35,
36,
38,
40,
41,
42,
47,
50,
58,
64,
67,
23,
72,
43,
6437,
6436,
6438,
6439,
6463,
6441,
6442,
6443,
6444,
6445,
6446,
1085,
2779,
6447,
6448,
6449,
6450,
64,
30,
6460,
6454,
6459,
6464,
6414,
6415,
6416,
6451,
6418,
6419,
6420,
6421,
6422,
2562,
6423,
6424,
6426,
6427,
6428,
6429,
6430,
6431,
5693,
6432,
6433,
6434,
6435,
47,
60,
22,
20,
6457,
6455,
6453,
6456,
6458,
6462,
15215
)
ORDER BY conversaciones DESC, enviados.cant DESC, recibidos.cant DESC
