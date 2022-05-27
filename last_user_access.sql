SELECT 
u.id,
u.username AS usuario,
u.firstname AS nombre,
u.lastname AS apellido,
u.email AS correo,
IF(lastaccess=0, 'nunca ingreso',from_unixtime(u.lastaccess)) AS ultimo_acceso
FROM prefix_user AS u
WHERE u.deleted=0 AND u.username!='guest' AND u.id!=2
AND FROM_UNIXTIME(u.lastaccess)< (DATE_SUB(NOW(), interval 5 year))
