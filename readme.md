# PLMarkdown                                                                                                                   

## Introduction                                                                                                                
PLMarkdown is a PL/SQL Object Type to create simple Markdown text and/or files.                                                 
For more information on Markdown see [http://daringfireball.net/projects/markdown](http://daringfireball.net/projects/markdown/)

## Installation                                                                                                                
Simply run the install script from the setup folder inside SQL*Plus.                                                            

## Usage                                                                                                                       
First of all you have to declare and initialize a variable. In the block below, you declare object l_md
  of type PLMarkdown. Then, you call the constructor for object type PLMarkdown to initialize the object. The call
  assign the values TRUE and TRUE to the attributes prn and toc inside the object. With prn you can set if you want
  to read your input to the object in DBMS_OUTPUT (default is FALSE). With toc you set whether a table of content at
  the beginning of the document is generated from all headers (default is FALSE).

    DECLARE
       l_md PLMarkdown();
    BEGIN
       l_md := PLMarkdown(true, true);
       ...
                             

### PLMarkdown procedures/functions                                                                                            
* `p(p_val VARCHAR2)`<br>A normal paragraph. You can write inside the paragraph specific markup like `**` for **bold**,
  `*` for *italic* or `(link)[https://github.com/)` for a (link)[https://github.com/] as well as valid html code like `<hr>`.
* `h(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A header text.                                                         
* `b(p_val VARCHAR2)`<br>A blockquote.                                                                                          
* `ul(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A unordered list.                                                     
* `ol(p_val VARCHAR2, p_idx SIMPLE_INTEGER DEFAULT 1)`<br>A ordered list.                                                       
* `img(p_lnk VARCHAR2, p_val VARCHAR2 DEFAULT NULL)`<br>An image, the title on mouseover is optional.                           
* `c(p_val VARCHAR2)`<br>A code block.                                                                                          

### Special procedures/functions                                                                                               
* `lorem(p_words SIMPLE_INTEGER)`<br>Adds a specific number of  words (max 149) from the lorem ipsum text.                      
* `get RETURN CLOB`<br>Returns all content from the object.                                                                     
* `save(p_loc VARCHAR2, p_file VARCHAR2)`<br>Writes the content to a filename in a specified location.                          

## License                                                                                                                     
Markdown Preview Plus (MPP) is released under the MIT license.                                                                  

## Version History                                                                                                             
Version 1.0 - February 10, 2016                                                                                                 
* Initial release                                                                                                               