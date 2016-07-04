-- The following block must be executed in the default HR schema
DECLARE
  l_md PLMarkdown:= PLMarkdown(TRUE, FALSE);
  l_sql VARCHAR2(4000);
BEGIN
  l_md.h1('Oracle Database Sample Schemas');
  l_md.h2('Human Resources (HR)');
  -- pie
  l_md.p('The HR schema has several tables.');
  l_sql := 'SELECT InitCap(table_name), num_rows FROM user_tables ORDER BY 1';
  l_md.sql2chart(l_sql, 'pie', TRUE);
  -- bar
  l_md.p('You can analyze the data, e.g. compare the salaries in different departments.');
  l_sql := q'~
  SELECT department_name as "Department",
         Ceil(Min(salary)) AS "Minimum",
         Ceil(Avg(salary)) AS "Average",
         Ceil(Max(salary)) AS "Maximum"
    FROM emp_details_view
   WHERE department_name IN ('IT', 'Sales','Finance','Marketing','Shipping')
GROUP BY department_name
ORDER BY 1~';
  l_md.sql2chart(l_sql, 'bar', TRUE);
  -- change size and smooth options via properties...
  l_md.height:='500px';
  l_md.smooth:=1;
  l_sql := 'SELECT table_name, num_rows, avg_row_len FROM user_tables ORDER BY 1';
  --... and image type via parameter
  l_md.sql2chart(l_sql, 'line', FALSE, 'SVG');
END;