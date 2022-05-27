SELECT 
u.id,
u.username AS usuario,
u.firstname AS nombre,
u.lastname AS apellido,
u.email AS correo,
FROM_UNIXTIME(u.timecreated) AS creado,
u.lastaccess AS ultimo_acceso
FROM prefix_user AS u
WHERE u.deleted=0 AND u.username!='guest' AND u.id!=2
AND FROM_UNIXTIME(u.timecreated)< (DATE_SUB(NOW(), interval 1 year))
AND u.lastaccess=0
