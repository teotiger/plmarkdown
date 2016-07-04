# Oracle Database Sample Schemas

## Human Resources (HR)

### Data
The HR schema consists of several objects. With the following query...

    SELECT * FROM user_objects
...you can select these objects from the data dictionary. An overview of the amount of each object is shown in the following table.


|Index|Procedure|Sequence|Table|Trigger|View|
|---:|---:|---:|---:|---:|---:|
|19|2|3|7|2|1|
The same looks much better in a chart.
![Chart from Chartspree.io](http://chartspree.io/pie.png?Sequence=3&Procedure=2&Trigger=2&Index=19&View=1&Table=7&_show_legend=true&_height=300px "Chart from Chartspree.io")


### Interpretation
If you analyze the data, you can for example compare the salaries in different departments with a query like this:


      SELECT InitCap(department_name) as "Department",
             Ceil(Min(salary)) AS "Minimum",
             Ceil(Avg(salary)) AS "Average",
             Ceil(Max(salary)) AS "Maximum"
        FROM emp_details_view
       WHERE department_name IN ('IT', 'Sales','Finance','Marketing','Shipping')
    GROUP BY department_name
    ORDER BY 1
And then display the result in a big bar chart.
![Chart from Chartspree.io](http://chartspree.io/bar.png?Minimum=6900,4200,6000,6100,2100&Average=8602,5760,9500,8956,3476&Maximum=12008,9000,13000,14000,8200&_labels=Finance,It,Marketing,Sales,Shipping&_show_legend=true&_height=500px "Chart from Chartspree.io")

