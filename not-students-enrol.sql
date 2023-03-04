select co1.fullname, co1.shortname
from prefix_course co1
where id!=1 and id not in ((SELECT co.id
FROM prefix_role_assignments ra
JOIN prefix_context con ON con.id=ra.contextid
JOIN prefix_course AS co ON co.id=con.instanceid
WHERE
con.contextlevel=50
AND ra.roleid in (5)
GROUP BY co.id))
