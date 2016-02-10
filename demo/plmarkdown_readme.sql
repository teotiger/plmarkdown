DECLARE
  l_md PLMarkdown := PLMarkdown(TRUE, FALSE);
BEGIN
  l_md.h('PLMarkdown');

  l_md.h('Introduction', 2);
  l_md.p('PLMarkdown is a PL/SQL Object Type to create simple Markdown text and/or files.');
  l_md.p('For more information on Markdown see [http://daringfireball.net/projects/markdown](http://daringfireball.net/projects/markdown/)');
  -- TODO script
  l_md.h('Installation', 2);
  l_md.p('Simply run the install script from the setup folder inside SQL*Plus.');

  l_md.h('Usage', 2);
  l_md.p('First of all you have to declare and initialize a variable. In the block below, you declare object l_md
  of type PLMarkdown. Then, you call the constructor for object type PLMarkdown to initialize the object. The call
  assign the values TRUE and TRUE to the attributes prn and toc inside the object. With prn you can set if you want
  to read your input to the object in DBMS_OUTPUT (default is FALSE). With toc you set whether a table of content at
  the beginning of the document is generated from all headers (default is FALSE).');
  l_md.c('DECLARE
   l_md PLMarkdown();
BEGIN
   l_md := PLMarkdown(true, true);
   ...
   ');
  l_md.h('PLMarkdown procedures/functions', 3);
  l_md.ul('`p(p_val VARCHAR2)`<br>A normal paragraph. You can write inside the paragraph specific markup like `**` for **bold**,
  `*` for *italic* or `(link)[https://github.com/)` for a (link)[https://github.com/] as well as valid html code like `<hr>`.');
  l_md.ul('`h(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A header text.');
  l_md.ul('`b(p_val VARCHAR2)`<br>A blockquote.');
  l_md.ul('`ul(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A unordered list.');
  l_md.ul('`ol(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A ordered list.');
  l_md.ul('`img(p_lnk VARCHAR2, p_val VARCHAR2 DEFAULT NULL)`<br>An image, the title on mouseover is optional.');
  l_md.ul('`c(p_val VARCHAR2)`<br>A code block.');

  l_md.h('Special procedures/functions', 3);
  l_md.ul('`lorem(p_words SIMPLE_INTEGER)`<br>Adds a specific number of  words (max 149) from the lorem ipsum text.');
  l_md.ul('`get RETURN CLOB`<br>Returns all content from the object.');
  l_md.ul('`save(p_loc VARCHAR2, p_file VARCHAR2)`<br>Writes the content to a filename in a specified location.');

  -- TODO link setzen und kopie von license einbauen
  -- https://atom.io/packages/markdown-preview-plus   bzw.
  -- https://github.com/Galadirith/markdown-preview-plus/blob/v2.2.2/LICENSE.md bzw.
  l_md.h('License', 2);
  l_md.p('Markdown Preview Plus (MPP) is released under the MIT license.');

  l_md.h('Version History', 2);
  -- TODO datum
  l_md.p('Version 1.0 - February 22, 2016');
  l_md.ul('Initial release');
END;