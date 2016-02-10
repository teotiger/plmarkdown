CREATE OR REPLACE type plmarkdown
AS
  object
  (
    /* ATTRIBUTES */
    prn           INTEGER,
    toc           INTEGER,
    toc_idx       INTEGER,
    out           CLOB,
    /* CONSTRUCTOR FUNCTION */
    constructor FUNCTION plmarkdown(
      p_prn BOOLEAN DEFAULT FALSE,
      p_toc BOOLEAN DEFAULT FALSE)
    RETURN self AS result,
    /* MEMBER FUNCTIONS/PROCEDURES */
    member PROCEDURE add2out(p_val VARCHAR2),
    member PROCEDURE lorem(p_words SIMPLE_INTEGER),
    -- TODO table(s)
    member FUNCTION get RETURN CLOB,
    member PROCEDURE save(p_loc VARCHAR2, p_file VARCHAR2),
    /**/
    member PROCEDURE p(p_val VARCHAR2), /* italic, strong, links */
    member PROCEDURE h(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE b(p_val VARCHAR2),
    member PROCEDURE ul(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE ol(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE img(p_lnk VARCHAR2, p_val VARCHAR2 DEFAULT NULL),
    member PROCEDURE c(p_val VARCHAR2)
  );
/