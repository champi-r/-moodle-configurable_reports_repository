SELECT
co.id,
    co.fullname as curso,
    co.shortname as nombrecorto,
    concat('<a href="%%ROOT%%/blocks/configurable_reports/viewreport.php?id=37&filter_var=',co.id,'" target="_blank">', 'Ver','</a>') as participantes
FROM prefix_course as co
