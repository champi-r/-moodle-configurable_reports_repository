SELECT 
cc.name AS "Categoría", 
concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',co.id,'">',co.fullname,'</a>') as "Curso",
prof.profesores,
u.department	as "Departamento",
concat('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=',u.id,'">',concat(u.lastname, ', ', u.firstname),'</a>') as "Estudiante",
u.username as "Usuario",
preg1.content as "pregunta 1",
preg2.content as "pregunta 2",
preg3.content as "pregunta 3",
preg4.content as "pregunta 4",
preg5.content as "pregunta 5",
preg6.content as "pregunta 6",
preg7.response as "pregunta 7"

FROM prefix_role_assignments ra
JOIN prefix_context con ON con.id=ra.contextid
JOIN prefix_course AS co ON co.id=con.instanceid %%FILTER_COURSES:co.id%% 
JOIN prefix_course_categories AS cc ON cc.id=co.category %%FILTER_SUBCATEGORIES:cc.path%%
JOIN prefix_user AS u ON u.id=ra.userid %%FILTER_SEARCHTEXT_users:u.username:~%%
LEFT JOIN prefix_questionnaire AS q ON q.course=co.id
LEFT JOIN prefix_questionnaire_response AS qr1 ON qr1.questionnaireid=q.id AND qr1.userid=u.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='Los contenidos de la actividad' 
) as preg1 ON preg1.questionnaireid=q.id AND preg1.userid=u.id AND preg1.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='La extensión horaria asignada' 
) as preg2 ON preg2.questionnaireid=q.id AND preg2.userid=u.id AND preg2.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='¿Exisitió claridad en las expl' 
) as preg3 ON preg3.questionnaireid=q.id AND preg3.userid=u.id AND preg3.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='La plataforma utilizada, ¿Le r' 
) as preg4 ON preg4.questionnaireid=q.id AND preg4.userid=u.id AND preg4.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='La conexión a la plataforma, ¿' 
) as preg5 ON preg5.questionnaireid=q.id AND preg5.userid=u.id AND preg5.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qqc.content
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_resp_multiple AS qrm ON qrm.response_id=qr.id AND qrm.question_id=qq.id
    JOIN prefix_questionnaire_quest_choice AS qqc ON qqc.question_id=qrm.question_id AND qqc.id=qrm.choice_id
    WHERE qq.name='La conexión a la plataforma, ¿' 
) as preg6 ON preg6.questionnaireid=q.id AND preg6.userid=u.id AND preg6.id=qr1.id
LEFT JOIN (
    SELECT  qr.id, qr.questionnaireid, qr.userid, qrt.response
    FROM prefix_questionnaire_question AS qq 
    JOIN prefix_questionnaire_response AS qr ON qr.questionnaireid=qq.surveyid
    JOIN prefix_questionnaire_response_text AS qrt ON qrt.response_id=qr.id AND qrt.question_id=qq.id
    WHERE qq.name='Le invitamos a escribir coment' 
) as preg7 ON preg7.questionnaireid=q.id AND preg7.userid=u.id AND preg7.id=qr1.id
LEFT JOIN (
    SELECT 
    co.id as courseid,
    GROUP_CONCAT(DISTINCT concat('<a target="_new" href="%%WWWROOT%%/user/profile.php?id=',u.id,'">',concat(u.lastname, ' ', u.firstname),'</a>')) as profesores

    FROM prefix_role_assignments ra
    JOIN prefix_context con ON con.id=ra.contextid
    JOIN prefix_course AS co ON co.id=con.instanceid
    JOIN prefix_user AS u ON u.id=ra.userid 
    WHERE 
    con.contextlevel=50
    AND ra.roleid in (3,4)
    GROUP BY co.id
) as prof ON prof.courseid = co.id 
WHERE 
cc.path LIKE '/33/36/%'
AND con.contextlevel=50
AND ra.roleid=5
ORDER BY co.id
