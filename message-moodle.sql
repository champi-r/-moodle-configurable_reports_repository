SELECT
m.conversationid as "ID Conversacion",
concat(u.firstname," ",u.lastname) as "De",
(
SELECT concat(u2.firstname," ",u2.lastname)
  FROM prefix_message_conversation_members AS mcm
  JOIN prefix_user AS u2 ON u2.id=mcm.userid
  WHERE mcm.conversationid=m.conversationid
  AND mcm.userid!=u.id
) as "Para",
m.subject as "Asunto",
m.fullmessage as "Mensaje",
from_unixtime(m.timecreated,'%d-%m-%Y %h:%m:%s') as "Creado"

FROM prefix_messages AS m
JOIN prefix_user AS u ON u.id=m.useridfrom
