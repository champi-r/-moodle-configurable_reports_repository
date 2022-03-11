SELECT co.id as courseid, co.fullname as Curso, u.id, u.username, u.firstname, u.lastname, u.email
FROM prefix_role_assignments ra
JOIN prefix_context con ON con.id=ra.contextid
JOIN prefix_course AS co ON co.id=con.instanceid
JOIN prefix_user AS u ON u.id=ra.userid
WHERE
con.contextlevel=50
AND ra.roleid=5
ORDER BY co.id
