PROMPT CREATE OR REPLACE TYPE BODY plmarkdown
CREATE OR REPLACE TYPE BODY plmarkdown
IS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
constructor FUNCTION plmarkdown(p_prn BOOLEAN, p_toc BOOLEAN)
RETURN SELF AS RESULT IS
BEGIN
  self.prn := CASE WHEN p_prn THEN 1 ELSE 0 END;
  self.toc := CASE WHEN p_toc THEN 1 ELSE 0 END;
  self.toc_idx := 0;
  self.out := '';
  RETURN;
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
member PROCEDURE add2out(p_val VARCHAR2, p_eol BOOLEAN) IS
BEGIN
  self.out := self.out||p_val||CASE WHEN p_eol THEN Chr(10) END;
  IF self.prn = 1 THEN
    Dbms_Output.Put_Line(p_val);
  END IF;
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
member PROCEDURE h(p_val VARCHAR2, p_idx SIMPLE_INTEGER) IS
  l_toc VARCHAR2(64);
BEGIN
  IF p_idx > 6 THEN
    Raise_Application_Error (-20202, 'The maximum number is 6.');
  END IF;

  IF self.toc = 1 THEN
    self.toc_idx := self.toc_idx+1;
    l_toc := '<a name="'||LPad(self.toc_idx,3,'0')||'"></a>';
  END IF;

  add2out(CASE WHEN Length(self.out)>1 THEN Chr(10) END||LPad('#',p_idx,'#')||' '||l_toc||p_val);
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
member PROCEDURE lorem(p_words SIMPLE_INTEGER) IS
  l_lorem VARCHAR2(1024) := 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';
BEGIN
  IF p_words > 149 THEN
    Raise_Application_Error (-20201, 'The maximum number is 149.');
  END IF;
  add2out(SubStr(l_lorem,0,InStr(l_lorem, ' ', 1, p_words))||Chr(10));
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
member FUNCTION get
RETURN CLOB IS
  l_hit VARCHAR2(512);
  l_reg VARCHAR2(100) := '(#{1,6}\s.*)';
  l_i   SIMPLE_INTEGER := 1;
  l_flg VARCHAR2(10)  := 'imx';
  l_ind SIMPLE_INTEGER := 0;
  l_toc CLOB;
BEGIN
  IF self.toc = 1 THEN
    l_hit := Trim(REGEXP_SUBSTR(self.out, l_reg, 1, l_i, l_flg, 1));
    WHILE l_hit IS NOT NULL LOOP
      -- indentation
      l_ind := REGEXP_COUNT(
          REGEXP_SUBSTR(self.out, '(#{1,6}\s)', 1, l_i, l_flg, 1)
        , '#', 1, 'i');
      -- convert l_hit to toc entry
      l_toc := l_toc
        -- indent
        ||LPad(l_i,l_ind*3,' ')||'. '
        -- name
        ||'['||REGEXP_SUBSTR(Trim(l_hit), '</a>(.*)', 1, 1, l_flg, 1)||']'
        -- link
        ||'(#'||REGEXP_SUBSTR(Trim(l_hit), 'name="(\d*)"', 1, 1, l_flg, 1)||')'
        ||Chr(10);
      l_i := l_i + 1;
      l_hit := REGEXP_SUBSTR(self.out, l_reg, 1, l_i, l_flg, 1);
    END LOOP;

    RETURN l_toc||self.out;
  ELSE
    RETURN self.out;
  END IF;
END;
--------------------------------------------------------------------------------
member PROCEDURE save(p_loc VARCHAR2, p_file VARCHAR2) IS
  l_toc VARCHAR2(32767);
BEGIN
  dbms_xslprocessor.clob2file(
    cl        => self.get,
    flocation => p_loc,
    fname     => p_file
  );
END;
--------------------------------------------------------------------------------
member PROCEDURE sql2table(
  p_sql_statement IN VARCHAR,
  p_null_display  IN VARCHAR,
  p_date_format   IN VARCHAR,
  p_number_format IN VARCHAR
)
IS
  l_cursor SYS_REFCURSOR;
  l_cursor_int NUMBER;
  l_cursor_cols SIMPLE_INTEGER := 0;
  l_cursor_desc DBMS_SQL.DESC_TAB2;
  l_typ_number NUMBER;
  l_typ_date DATE;
  l_typ_varchar VARCHAR(32767);

BEGIN
  OPEN l_cursor FOR p_sql_statement;
  l_cursor_int := DBMS_SQL.TO_CURSOR_NUMBER(l_cursor);
  DBMS_SQL.DESCRIBE_COLUMNS2(l_cursor_int,l_cursor_cols,l_cursor_desc);

  FOR i IN 1..l_cursor_cols LOOP
    CASE
      WHEN l_cursor_desc(i).col_type IN (2,100,101) THEN
        DBMS_SQL.DEFINE_COLUMN(l_cursor_int,i,l_typ_number);
      WHEN l_cursor_desc(i).col_type IN (12,180,181,231) THEN
        DBMS_SQL.DEFINE_COLUMN(l_cursor_int,i,l_typ_date);
      ELSE
        DBMS_SQL.DEFINE_COLUMN(l_cursor_int,i,l_typ_varchar,32767);
    END CASE;
  END LOOP;

  -- write table header
  FOR i IN 1..l_cursor_desc.Count LOOP
    add2out('|'||l_cursor_desc(i).col_name, FALSE);
  END LOOP;
  add2out('|');

  -- format alignment according to datatype
  FOR i IN 1..l_cursor_desc.Count LOOP
    CASE
      WHEN l_cursor_desc(i).col_type IN (2,100,101) THEN
        add2out('|---:', FALSE);
      WHEN l_cursor_desc(i).col_type IN (12,180,181,231) THEN
        add2out('|:---:', FALSE);
      ELSE
        add2out('|:---', FALSE);
    END CASE;
  END LOOP;
  add2out('|');

  WHILE DBMS_SQL.FETCH_ROWS(l_cursor_int) > 0 LOOP
    FOR j IN 1..l_cursor_cols LOOP
      CASE
        WHEN l_cursor_desc(j).col_type IN (2,100,101) THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor_int,j,l_typ_number);
          add2out('|'||CASE WHEN l_typ_number IS NULL THEN p_null_display ELSE To_Char(l_typ_number, p_number_format) END, FALSE);
        WHEN l_cursor_desc(j).col_type IN (12,180,181,231) THEN
          DBMS_SQL.COLUMN_VALUE(l_cursor_int,j,l_typ_date);
          add2out('|'||CASE WHEN l_typ_date IS NULL THEN p_null_display ELSE TO_CHAR(l_typ_date,p_date_format) END, FALSE);
        ELSE
          DBMS_SQL.COLUMN_VALUE(l_cursor_int,j,l_typ_varchar);
          add2out('|'||CASE WHEN l_typ_varchar IS NULL THEN p_null_display ELSE l_typ_varchar END, FALSE);
      END CASE;
    END LOOP;
    add2out('|');
  END LOOP;

  DBMS_SQL.CLOSE_CURSOR(l_cursor_int);
END;
--------------------------------------------------------------------------------
member PROCEDURE p(p_val VARCHAR2) IS
BEGIN
  add2out(p_val);
END;
--------------------------------------------------------------------------------
member PROCEDURE h1(p_val VARCHAR2) IS
BEGIN
  h(p_val, 1);
END;
--------------------------------------------------------------------------------
member PROCEDURE h2(p_val VARCHAR2) IS
BEGIN
  h(p_val, 2);
END;
--------------------------------------------------------------------------------
member PROCEDURE h3(p_val VARCHAR2) IS
BEGIN
  h(p_val, 3);
END;
--------------------------------------------------------------------------------
member PROCEDURE h4(p_val VARCHAR2) IS
BEGIN
  h(p_val, 4);
END;
--------------------------------------------------------------------------------
member PROCEDURE h5(p_val VARCHAR2) IS
BEGIN
  h(p_val, 5);
END;
--------------------------------------------------------------------------------
member PROCEDURE h6(p_val VARCHAR2) IS
BEGIN
  h(p_val, 6);
END;
--------------------------------------------------------------------------------
member PROCEDURE b(p_val VARCHAR2) IS
BEGIN
  add2out('> '||REPLACE(p_val,Chr(10),Chr(10)||'> '));
END;
--------------------------------------------------------------------------------
member PROCEDURE ul(p_val VARCHAR2, p_idx SIMPLE_INTEGER) IS
BEGIN
  add2out(lPad('* ',p_idx+1,' ')||p_val);
END;
--------------------------------------------------------------------------------
member PROCEDURE ol(p_val VARCHAR2, p_idx SIMPLE_INTEGER) IS
BEGIN
  add2out(lPad('1. ',p_idx+2,' ')||p_val);
END;
--------------------------------------------------------------------------------
member PROCEDURE img(p_lnk VARCHAR2, p_val VARCHAR2 DEFAULT NULL) IS
BEGIN
  add2out('!['||Nvl(p_val,'image')||']('||p_lnk||' "'||p_val||'")'||Chr(10));
END;
--------------------------------------------------------------------------------
member PROCEDURE c(p_val VARCHAR2) IS
BEGIN
  add2out(Chr(10)||'    '||REPLACE(p_val,Chr(10),Chr(10)||'    '));
END;
--------------------------------------------------------------------------------
END;
/

