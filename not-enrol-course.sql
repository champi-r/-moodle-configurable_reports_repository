SELECT 
u.username as "usuario",
u.firstname as "nombre", 
u.lastname as "apellido",
u.email as "correo"

from prefix_user as u
where id not 
in (
select u.id
from prefix_user as u
join prefix_role_assignments as r on u.id = r.userid
and r.roleid =1
)
and id not in (select userid from prefix_role_assignments )
and deleted <> 1
and u.id <>1
and u.id <>2
and u.id <>3
order by  u.lastname,u.firstname
