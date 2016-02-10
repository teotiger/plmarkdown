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
  self.out := ' ';
  RETURN;
END;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
member PROCEDURE add2out(p_val VARCHAR2) IS
BEGIN
  self.out := self.out||p_val||Chr(10);
  IF self.prn = 1 THEN
    Dbms_Output.Put_Line(p_val);
  END IF;
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
  l_reg VARCHAR2(100) := '(#{1,6}.*)';
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
          REGEXP_SUBSTR(self.out, '(#{1,6})', 1, l_i, l_flg, 1)
        , '#', 1, 'i');
      -- convert l_hit to toc entry
      l_toc := l_toc
        -- indent
        ||LPad(l_i,l_ind,' ')||'. '
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
member PROCEDURE p(p_val VARCHAR2) IS
BEGIN
  add2out(p_val||Chr(10));
END;
--------------------------------------------------------------------------------
member PROCEDURE h(p_val VARCHAR2, p_idx SIMPLE_INTEGER) IS
BEGIN
  IF p_idx > 6 THEN
    Raise_Application_Error (-20202, 'The maximum number is 6.');
  END IF;

  IF self.toc = 1 THEN
    self.toc_idx := self.toc_idx+1;
    add2out(LPad('#',p_idx,'#')||' '||'<a name="'||LPad(self.toc_idx,3,'0')||'"></a>'||p_val);
  ELSE
    add2out(LPad('#',p_idx,'#')||' '||p_val);
  END IF;
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
  add2out('    '||REPLACE(p_val,Chr(10),Chr(10)||'    '));
END;
--------------------------------------------------------------------------------
END;
/

