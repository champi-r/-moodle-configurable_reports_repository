SELECT 
tk.id AS ID,
tag.name AS Tag,
tag.value AS TagInfo,
sta.name AS Estado,
concat(u.firstname, ' ', u.lastname) as profesor,
FROM_UNIXTIME(tk.timecreated,'%d-%m-%Y %h:%m:%s') as Creado,
FROM_UNIXTIME(tk.timemodified,'%d-%m-%Y %h:%m:%s') as Modificado,
tk.summary AS Resumen,
tk.detail AS Detalle,
#concat('<a href="%%ROOT%%/blocks/helpdesk/view.php?id=',tk.id,'" target="_blank">',"Ver Ticket",'</a>') AS Detalle,
concat('<a href="%%ROOT%%/blocks/helpdesk/view.php?id=',tk.id,'" target="_blank">',CONCAT('https://argentinaprograma.inti.gob.ar/blocks/helpdesk/view.php?id=',tk.id),'</a>') AS URL
FROM prefix_block_helpdesk_ticket AS tk
JOIN prefix_block_helpdesk_status AS sta ON sta.id=tk.status %%FILTER_SEARCHTEXT_sta:sta.name:~%%
LEFT JOIN prefix_block_helpdesk_ticket_tag AS tag ON tag.ticketid=tk.id
JOIN prefix_user AS u ON u.id=tk.firstcontact
ORDER BY tk.timecreated DESC
