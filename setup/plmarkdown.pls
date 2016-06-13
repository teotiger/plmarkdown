PROMPT CREATE OR REPLACE TYPE plmarkdown
CREATE OR REPLACE type plmarkdown
--------------------------------------------------------------------------------
--    ______ _     ___  ___  ___  ______ _   _______ _____  _    _ _   _
--    | ___ \ |    |  \/  | / _ \ | ___ \ | / /  _  \  _  || |  | | \ | |
--    | |_/ / |    | .  . |/ /_\ \| |_/ / |/ /| | | | | | || |  | |  \| |
--    |  __/| |    | |\/| ||  _  ||    /|    \| | | | | | || |/\| | . ` |
--    | |   | |____| |  | || | | || |\ \| |\  \ |/ /\ \_/ /\  /\  / |\  |
--    \_|   \_____/\_|  |_/\_| |_/\_| \_\_| \_/___/  \___/  \/  \/\_| \_/
--
--------------------------------------------------------------------------------
-- This type has usefull member functions to generate markdown text.
-- For more information see https://github.com/teotiger/plmarkdown
--------------------------------------------------------------------------------
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
    member PROCEDURE add2out(p_val VARCHAR2, p_eol BOOLEAN DEFAULT TRUE),
    member PROCEDURE h(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE lorem(p_words SIMPLE_INTEGER),
    member FUNCTION get RETURN CLOB,
    member PROCEDURE save(p_loc VARCHAR2, p_file VARCHAR2),
    member PROCEDURE sql2table(
      p_sql_statement IN VARCHAR,
      p_null_display  IN VARCHAR DEFAULT '--',
      p_date_format   IN VARCHAR DEFAULT SYS_CONTEXT ('USERENV', 'NLS_DATE_FORMAT'),
      p_number_format IN VARCHAR DEFAULT 'FM9G999G999G999G990D00'
    ),
    /**/
    member PROCEDURE p(p_val VARCHAR2),/* italic, strong, links */
    member PROCEDURE h1(p_val VARCHAR2),
    member PROCEDURE h2(p_val VARCHAR2),
    member PROCEDURE h3(p_val VARCHAR2),
    member PROCEDURE h4(p_val VARCHAR2),
    member PROCEDURE h5(p_val VARCHAR2),
    member PROCEDURE h6(p_val VARCHAR2),
    member PROCEDURE b(p_val VARCHAR2),
    member PROCEDURE ul(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE ol(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1),
    member PROCEDURE img(p_lnk VARCHAR2, p_val VARCHAR2 DEFAULT NULL),
    member PROCEDURE c(p_val VARCHAR2)
  );
/