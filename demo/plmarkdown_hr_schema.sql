-- The following block must be executed in the default HR schema
DECLARE
  l_md PLMarkdown:= PLMarkdown();--TRUE, FALSE);
  l_sql VARCHAR2(4000);
BEGIN
  l_md.h1('Oracle Database Sample Schemas');
  l_md.h2('Human Resources (HR)');

  l_md.h3('Data');
  -- table and pie chart
  l_md.p('The HR schema consists of several objects. With the following query...');
  l_sql := 'SELECT * FROM user_objects';
  l_md.c(l_sql);
  l_md.p('...you can select these objects from the data dictionary. An overview of the amount of each object is shown in the following table.');
  l_sql := q'~
  SELECT * FROM (
  SELECT object_name, object_type
    FROM user_objects
)
PIVOT (Count(object_name) FOR object_type IN (
  'INDEX' AS "Index",
  'PROCEDURE' AS "Procedure",
  'SEQUENCE' AS "Sequence",
  'TABLE' AS "Table",
  'TRIGGER' AS "Trigger",
  'VIEW' AS "View")
)~';
  l_md.sql2table(p_sql_statement => l_sql, p_number_format => 'FM90');
  l_md.p('The same looks much better in a chart.');
  l_sql := 'SELECT InitCap(object_type), Count(object_name) FROM user_objects GROUP BY object_type';
  l_md.sql2chart(l_sql, 'pie', TRUE);

  -- bar chart
  l_md.h3('Interpretation');
  l_md.p('If you analyze the data, you can for example compare the salaries in different departments with a query like this:');
  l_sql := q'~
  SELECT InitCap(department_name) as "Department",
         Ceil(Min(salary)) AS "Minimum",
         Ceil(Avg(salary)) AS "Average",
         Ceil(Max(salary)) AS "Maximum"
    FROM emp_details_view
   WHERE department_name IN ('IT', 'Sales','Finance','Marketing','Shipping')
GROUP BY department_name
ORDER BY 1~';
  l_md.c(l_sql);
  l_md.p('And then display the result in a big bar chart.');
  l_md.height:='500px';
  l_md.sql2chart(l_sql, 'bar', TRUE);
  Dbms_Output.Put_Line(l_md.get);
END;