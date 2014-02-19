# System database #
## sf\_db\_clear ##
**Clear the whole database**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_normalize ##
**Filter a name, leaving authorized chars only**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Normalized name</td></tr>
</table>
## sf\_db\_key ##
**Build a key (regexp usable in grep) from a variable name**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Key string</td></tr>
</table>
## sf\_db\_unset ##
**Unset a variable**

No error if variable was not present in DB

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>Variable names</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_set ##
**Set a variable**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
<tr><td width=20 align=center>$2</td><td>Value</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_copy ##
**Duplicate a variable (copy content)**

If the source variable is not set, target is created with an empty value

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Source variable name</td></tr>
<tr><td width=20 align=center>$2</td><td>Target variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_rename ##
**Rename a variable (keep content)**

If the source variable is not set, target is created with an empty value

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Source variable name</td></tr>
<tr><td width=20 align=center>$2</td><td>Target variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_set\_timestamp ##
**Set a variable with the "sf\_now" timestamp value**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_isset ##
**Check if a variable is set**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if variable is set, &lt;&gt; 0 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_get ##
**Get a variable value**

If variable is not set, return an empty string (no error)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Variable name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Value or empty string if var not set</td></tr>
</table>
## sf\_db\_dump ##
**Dump the database**

Output format (each line) : &lt;name>&lt;space>&lt;value>&lt;EOL>

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>DB content</td></tr>
</table>
## sf\_db\_list ##
**List DB keys alphabetically, one per line**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>DB keys</td></tr>
</table>
## sf\_db\_import ##
**Import variables in dump format (one per line)**

Lines are read from stdin

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_db\_expand ##
**Replaces patterns in the form '{{%&lt;variable name>%}}' by their value.**

Allows nested substitutions (ex: {{%interface{{%hcfg:icount%}}/network%}}).

Patterns which do not correspond to an existing variable are replaced by an empty string.

Input: stdin, output: stdout.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td></td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Output</td></tr>
</table>

# File/dir management #
## sf\_delete ##
**Recursively deletes a file or a directory**

Returns without error if arg is a non-existent path

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path to delete</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_find\_executable ##
**Find an executable file**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Executable name</td></tr>
<tr><td width=20 align=center>$2</td><td>Optional. List of directories to search. If not search, use PATH</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Absolute path if found, nothing if not found</td></tr>
</table>
## sf\_create\_dir ##
**Creates a directory**

If the given path argument corresponds to an already existing file (any type except directory or symbolic link to a directory), the program aborts with a fatal error. If you want to avoid this (if you want to create the directory, even if something else is already existing in this path), call sf\_delete first.

If the path given as arg contains a symbolic link pointing to an existing directory, it is left as-is.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path</td></tr>
<tr><td width=20 align=center>$2</td><td>Optional. Directory owner[:group]. Default: root</td></tr>
<tr><td width=20 align=center>$3</td><td>Optional. Directory mode in a format accepted by chmod. Default: 755</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_save ##
**Saves a file**

No action if the 'sf\_nosave' environment variable is set to a non-empty string.

If the input arg is the path of an existing regular file, the file is copied to '$path.orig'

TODO: improve save features (multiple numbered saved versions,...)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_rename\_to\_old ##
**Renames a file to '&lt;dir>/old.&lt;filename>**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_check\_copy ##
**Copy a file or the content of function's standard input to a target file**

The copy takes place only if the source and target files are different.

If the target file is already existing, it is saved before being overwritten.

If the target path directory does not exist, it is created.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Source path. Special value: '-' means that data to copy is read from stdin, allowing to produce dynamic content without a temp file.</td></tr>
<tr><td width=20 align=center>$2</td><td>Target path</td></tr>
<tr><td width=20 align=center>$3</td><td>Optional. File creation mode. Default=644</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_check\_block ##
**Replaces or prepends/appends a data block in a file**

The block is composed of entire lines and is surrounded by special comment lines when inserted in the target file. These comment lines identify the data block and allow the function to be called several times on the same target file with different data blocks. The block identifier is the base name of the source path.

If the given block is not present in the target file, it is appended or prepended, depending on the flag argument. If the block is already present in the file (was inserted by a previous run of this function), its content is compared with the new data, and replaced if different. In this case, it is replaced at the exact place where the previous block lied.

If the target file exists, it is saved before being overwritten.

If the target path directory does not exist, it is created.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>If this arg starts with the '-' char, the data is to be read from stdin and the string after the '-' is the block identifier.</p><p>If it does not start with '-', it is the path to the source file (containing the data to insert).</td></tr>
<tr><td width=20 align=center>$2</td><td>Target path</td></tr>
<tr><td width=20 align=center>$3</td><td>Optional. Target file mode.</p><p>Default=644</td></tr>
<tr><td width=20 align=center>$4</td><td>Optional. Flag. Set to 'prepend' to add data at the beginning of the file.</p><p>Default mode: Append.</p><p>Used only if data block is not already present in the file.</p><p>Can be set to '' (empty string) to mean 'default mode'.</td></tr>
<tr><td width=20 align=center>$5</td><td>Optional. Comment character.</p><p>This argument, if set, must contain only one character. This character will be used as first char when building the 'identifier' lines surrounding the data block.</p><p>Default: '#'.</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_contains\_block ##
**Checks if a file contains a block inserted by sf\_check\_block**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>The block identifier or source path</td></tr>
<tr><td width=20 align=center>$2</td><td>File path</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if the block is in the file, !=0 if not.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_chown ##
**Change the owner of a set of files/dirs**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>owner[:group]</td></tr>
<tr><td width=20 align=center>$2+</td><td>List of paths</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>chown status code</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_chmod ##
**Change the mode of a set of files/dirs**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>mode as accepted by chmod</td></tr>
<tr><td width=20 align=center>$2+</td><td>List of paths</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>chmod status code</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_check\_link ##
**Creates or modifies a symbolic link**

The target is saved before being modified.

If the target path directory does not exist, it is created.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Link target</td></tr>
<tr><td width=20 align=center>$2</td><td>Link path</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_comment\_out ##
**Comment one line in a file**

The first line containing the (grep) pattern given in argument will be commented out by prefixing it with the comment character. If the pattern is not contained in the file, the file is left unchanged.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>File path</td></tr>
<tr><td width=20 align=center>$2</td><td>Pattern to search (grep regex syntax)</td></tr>
<tr><td width=20 align=center>$3</td><td>Optional. Comment char (one char string). Default='#'</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_uncomment ##
**Uncomment one line in a file**

The first commented line containing the (grep) pattern given in argument will be uncommented by removing the comment character. If the pattern is not contained in the file, the file is left unchanged.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>File path</td></tr>
<tr><td width=20 align=center>$2</td><td>Pattern to search (grep regex syntax)</td></tr>
<tr><td width=20 align=center>$3</td><td>Optional. Comment char (one char string). Default='#'</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_check\_line ##
**Checks if a given line is contained in a file**

Takes a pattern and a string as arguments. The first line matching the pattern is compared with the string. If they are different, the string argument replaces the line in the file. If they are the same, the file is left unchanged. If the pattern is not found, the string arg is appended to the file. If the file does not exist, it is created.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>File path</td></tr>
<tr><td width=20 align=center>$2</td><td>Pattern to search</td></tr>
<tr><td width=20 align=center>$3</td><td>Line string</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>

# Filesystem/Volume management #
## sf\_has\_dedicated\_fs ##
**Checks if a directory is a file system mount point**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Directory to check</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if true, !=0 if false</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_get\_fs\_mnt ##
**Gets the mount point of the filesystem containing a given path**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path (must correspond to an existing element)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>The mount directory of the filesystem containing the element</td></tr>
</table>
## sf\_get\_fs\_size ##
**Get the size of the filesystem containing a given path**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Path (must correspond to an existing element)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>FS size in Mbytes</td></tr>
</table>
## sf\_set\_fs\_space ##
**Extend a file system to a given size**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>A path contained in the file system to extend</td></tr>
<tr><td width=20 align=center>$2</td><td>The new size in Mbytes, or the size to add if prefixed with a '+'</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_create\_fs ##
**Create a file system, mount it, and set system configuration to mount it**

at system start Refuses existing directory as mount point (security)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Mount point</td></tr>
<tr><td width=20 align=center>$2</td><td>device path</td></tr>
<tr><td width=20 align=center>$3</td><td>FS type</td></tr>
<tr><td width=20 align=center>$4</td><td>Optional. Mount point directory owner[:group]</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if no error, 1 on error</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_lv\_exists ##
**Checks if a given logical volume exists**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>VG name</td></tr>
<tr><td width=20 align=center>$2</td><td>LV name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if it exists, 1 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_vg\_exists ##
**Checks if a given volume group exists**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>VG name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if it exists, 1 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_create\_lv ##
**Create a logical volume**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Logical volume name</td></tr>
<tr><td width=20 align=center>$2</td><td>Volume group name</td></tr>
<tr><td width=20 align=center>$3</td><td>Size (Default: megabytes, optional suffixes: [kmgt]. Special value: 'all' takes the whole free size in the VG.</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0: OK, !=0: Error</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_create\_vg ##
**Create a volume group**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>volume group name</td></tr>
<tr><td width=20 align=center>$2</td><td>PE size (including optional unit, default=Mb)</td></tr>
<tr><td width=20 align=center>$3</td><td>Device path, without the /dev prefix</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0: OK, !=0: Error</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_fs\_default\_type ##
**Returns default FS type for current environment**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Type</td></tr>
</table>
## sf\_create\_lv\_fs ##
**Create a logical volume and a filesystem on it**

Combines sf\_create\_lv and sf\_create\_fs

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Mount point (directory)</td></tr>
<tr><td width=20 align=center>$2</td><td>Logical volume name</td></tr>
<tr><td width=20 align=center>$3</td><td>Volume group name</td></tr>
<tr><td width=20 align=center>$4</td><td>File system type</td></tr>
<tr><td width=20 align=center>$5</td><td>Size in Mbytes</td></tr>
<tr><td width=20 align=center>$6</td><td>Optional. Directory owner[:group]</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0: OK, !=0: Error</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>

# IP address manipulation (V 4 only) #
## sf\_ip4\_is\_valid\_ip ##
**Checks if the input string is a valid IP address**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>IP address to check</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if address is valid, !=0 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_ip4\_validate\_ip ##
**Checks if the input string is a valid IP address and aborts if not**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>IP address to check</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>only if address is valid</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing if OK. Error if not</td></tr>
</table>
## sf\_ip4\_network ##
**Compute network from IP and netmask**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>IP</td></tr>
<tr><td width=20 align=center>$2</td><td>Netmask</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Network</td></tr>
</table>

# Utility functions #
## sf\_loaded ##
**Checks if the library is already loaded**

Of course, if it can run, the library is loaded. So, it always returns 0.

Allows to support the 'official' way to load sysfunc : sf\_loaded 2>/dev/null || . sysfunc.sh

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_version ##
**Displays library version**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Library version (string)</td></tr>
</table>
## sf\_exec\_url ##
**Retrieves executable data through an URL and executes it.**

Supports any URL accepted by wget.

By default, the 'wget' command is used. If the $WGET environment variable is set, it is used instead (use, for instance, to specify a proxy or an alternate configuration file).

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Url</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>the return code of the executed program</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>data displayed by the executed program</td></tr>
</table>
## sf\_cleanup ##
**Cleanup at exit**

This function discards every allocated resources (tmp files,...)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_finish ##
**Finish execution**

This function discards every allocated resources (tmp files,...)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Ooptional. Exit code. Default: 0</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Never returns. Exits from program.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>

# Message/Error handling #
## sf\_fatal ##
**Displays an error message and aborts execution**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
<tr><td width=20 align=center>$2</td><td>Optional. Exit code.</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Does not return. Exits with the provided exit code if arg 2 set, with 1 if not.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Error and abort messages</td></tr>
</table>
## sf\_unsupported ##
**Fatal error on unsupported feature**

Call this function when a feature is not available on the current operating system (yet ?)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>feature name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Does not return. Exits with code 2.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Error and abort messages</td></tr>
</table>
## sf\_error ##
**Displays an error message**

If the SF\_ERRLOG environment variable is set, it is supposed to contain a path. The error message will be appended to the file at this path. If the file does not exist, it will be created.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Error message</td></tr>
</table>
## sf\_error\_import ##
**Import errors into the error system**

This mechanism is generally used in conjunction with the $SF\_ERRLOG variable. This variable is used to temporarily distract errors from the normal flow. Then, this function can be called to reinject errors into the default error repository.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Optional. File to import (1 error per line). If not set, takes input from stdin.</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_show\_errors ##
**Display a list of errors detected so far**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>List of error messages, one by line</td></tr>
</table>
## sf\_error\_count ##
**Display a count of errors detected so far**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Error count</td></tr>
</table>
## sf\_warning ##
**Displays a warning message**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Warning message</td></tr>
</table>
## sf\_msg ##
**Displays a message (string)**

If the $sf\_noexec environment variable is set, prefix the message with '(n)'

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Message</td></tr>
</table>
## sf\_trace ##
**Display trace message**

If the $sf\_verbose environment variable is set or $sf\_verbose\_level >= 1, displays the message.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>message if verbose mode is active, nothing if not</td></tr>
</table>
## sf\_debug ##
**Display debug message**

If $sf\_verbose\_level >= 2, displays the message.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>message if verbose level set to debug (2) or more</td></tr>
</table>
## sf\_msg1 ##
**Displays a message prefixed with spaces**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>message prefixed with spaces</td></tr>
</table>
## sf\_msg\_section ##
**Displays a 'section' message**

This is a message prefixed with a linefeed and some hyphens. To be used as paragraph/section title.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Message</td></tr>
</table>
## sf\_separator ##
**Displays a separator line**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>separator line</td></tr>
</table>
## sf\_newline ##
**Display a new line**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>new line</td></tr>
</table>
## sf\_banner ##
**Displays a 'banner' message**

The message is displayed with an horizontal separator line above and below

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>message</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>message</td></tr>
</table>

# User interaction #
## sf\_ask ##
**Ask a question to the user**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Question</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>message to stderr, answer to stdout</td></tr>
</table>
## sf\_yn\_question ##
**Asks a 'yes/no' question, gets answer, and return yes/no code**

Works at least for questions in english, french, and german : Accepts 'Y', 'O', and 'J' for 'yes' (upper or lowercase), and anything different is considered as 'no'

If the $sf\_forceyes environment variable is set, the user is not asked and the 'yes' code is returned.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Question string</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 for 'yes', 1 for 'no'</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Question and typed answer if $sf_forceyes not set, nothing if $sf_forceyes is set.</td></tr>
</table>

# Network #
## sf\_domain\_part ##
**Suppresses the host name part from a FQDN**

Displays the input string without the beginning up to and including the first '.'.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Input FQDN</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>truncated string</td></tr>
</table>
## sf\_host\_part ##
**Extracts a hostname from an FQDN**

Removes everything from the first dot up to the end of the string

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Input FQDN</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>truncated string</td></tr>
</table>
## sf\_dns\_addr\_to\_name ##
**Resolves an IP address through the DNS**

If the address cannot be resolved, displays nothing

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>IP address</td></tr>
<tr><td width=20 align=center>$2</td><td>Optional. DNS server to ask</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Host name as returned by the DNS or nothing if address could not be resolved.</td></tr>
</table>
## sf\_dns\_name\_to\_addr ##
**Resolves a host name through the DNS**

If the name cannot be resolved, displays nothing

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Host name to resolve</td></tr>
<tr><td width=20 align=center>$2</td><td>Optional. DNS server to ask</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>IP address as returned by the DNS or nothing if name could not be resolved.</td></tr>
</table>
## sf\_primary\_ip\_address ##
**Get the primary address of the system**

This is an arbitrary choice, such as the address assigned to the first network nterface. Feel free to improve !

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>IP address or nothing if no address was found</td></tr>
</table>

# OS management #
## sf\_os\_id ##
**Computes and displays a string defining the curent system environment**

The displayed string is a combination of the OS name, version, system architecture and may also depend on other parameters like, for instance, the RedHat ES/AS branches. It is an equivalent of the 'channel' concept used by RedHat. I personnally call it 'OS ID' for 'OS IDentifier' and use it in every script where I need a single string to identify the system environment the script is currently running on.

If the current system is not recognized, the program aborts.

By convention, environments recognized by this function support the rest of the library.

Contributors welcome ! Feel free to enhance this function with additional recognized systems, especially with other Linux distros, and send me your patches.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS ID string</td></tr>
</table>
## sf\_compute\_os\_id ##
**Alias of sf\_os\_id() (obsolete - for compatibility only)**

Other info: see sf\_os\_id()

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS ID string</td></tr>
</table>
## sf\_os\_distrib ##
**Display the current OS distribution**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS distrib</td></tr>
</table>
## sf\_os\_family ##
**Display the current OS family (Linux, SunOS,...)**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS distrib</td></tr>
</table>
## sf\_os\_version ##
**Display the current OS version**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS distrib</td></tr>
</table>
## sf\_os\_arch ##
**Display the current OS architecture (aka 'hardware platform')**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>OS distrib</td></tr>
</table>
## sf\_reboot ##
**Shutdown and restart the host**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>does not return</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_shutdown ##
**Shutdown and halt the host**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>does not return</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_poweroff ##
**Shutdown and poweroff the host**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>does not return</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_find\_posix\_shell ##
**Find a Posix-compatible shell on the current host**

Search a bash shell first, then ksh

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Shell path if found, nothing if not found</td></tr>
</table>

# Software management #
## sf\_soft\_exists ##
**Check if software exist (installed or available for installation)**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>A list of software names to check</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>The number of software from the input list which DON'T exist</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_soft\_list ##
**List installed software**

Returns a sorted list of installed software

Linux output: (name-version-release.arch)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>software list</td></tr>
</table>
## sf\_soft\_is\_installed ##
**Check if software is installed**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if every argument software are installed. 1 if at least one of them is not.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_soft\_is\_upgradeable ##
**Check if a newer version of a software is available**

Note : if the software is not installed, it is not considered as updateable

Note : yum returns 0 if no software are available for update

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if at least one of the given software(s) can be updated.</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_soft\_is\_up\_to\_date ##
**Check if a software is installed and the latest version**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if every argument software are installed and up to date (for yum)</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_soft\_install ##
**Install a software if not already present**

Install or updates a software depending on its presence on the host

If the software is installed but not up to date, no action.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_soft\_install\_upgrade ##
**Install or upgrade a software**

Install or updates a software depending on its presence on the host

If the software is up to date, no action.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_soft\_uninstall ##
**Uninstall a software (including dependencies)**

Return without error if the software is not installed

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_soft\_remove ##
**Uninstall a software (ignoring dependencies)**

Return without error if the software is not installed

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_soft\_reinstall ##
**Reinstall a software, even at same version**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>software name(s)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_soft\_clean\_cache ##
**Clean the software installation cache**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>

# Service management #
## sf\_svc\_enable ##
**Enable service start/stop at system boot/shutdown**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>Service names</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_svc\_disable ##
**Disable service start/stop at system boot/shutdown**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$*</td><td>Service names</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_svc\_install ##
**Install a service script (script to start/stop a service)**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Source script</td></tr>
<tr><td width=20 align=center>$2</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_svc\_uninstall ##
**Uninstall a service script (script to start/stop a service)**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_svc\_is\_installed ##
**Check if a service script is installed**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 is installed, 1 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_svc\_start ##
**Start a service**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Return code from script execution</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Output from service script</td></tr>
</table>
## sf\_svc\_stop ##
**Stop a service**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Return code from script execution</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Output from service script</td></tr>
</table>
## sf\_svc\_base ##
**Display the base directory of service scripts**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>String</td></tr>
</table>
## sf\_svc\_script ##
**Display the full path of the script corresponding to a given service**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Service name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Script path</td></tr>
</table>

# Time/Date manipulation #
## sf\_tm\_now ##
**Display normalized time string for current time (UTC)**

Format: DD-Mmm-YYYY HH:MM:SS (&lt;Unix time>)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Time string</td></tr>
</table>

# Temporary file management #
## sf\_get\_tmp ##
**Returns an unused temporary path**

The returned path can then be used to create a directory or a file. ** This function is deprecated. Please use sf\_tmpfile or sf\_tmpdir instead.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>An unused temporary path</td></tr>
</table>
## sf\_tmpfile ##
**Creates an empty temporary file and returns its path**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Temporary file path</td></tr>
</table>
## sf\_tmpdir ##
**Creates an empty temporary dir and returns its path**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td>None</td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Temporary dir path</td></tr>
</table>

# User/group management #
## sf\_set\_passwd ##
**Change a user's password**

Works on HP-UX, Solaris, and Linux.

Replaces an encrypted passwd in /etc/passwd or /etc/shadow.

TODO: Unify with AIX and autodetect the file to use (passwd/shadow)

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Username</td></tr>
<tr><td width=20 align=center>$2</td><td>Encrypted password</td></tr>
<tr><td width=20 align=center>$3</td><td>File path</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Nothing</td></tr>
</table>
## sf\_set\_passwd\_aix ##
**Set an AIX password**

TODO: Unify with other supported OS

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Username</td></tr>
<tr><td width=20 align=center>$2</td><td>Encrypted password</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_create\_group ##
**Create a user group**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Group name</td></tr>
<tr><td width=20 align=center>$2</td><td>Group Id</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>
## sf\_delete\_group ##
**Remove a group**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>Group name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Status from system command</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_user\_exists ##
**Checks if a given user exists on the system**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>User name to check</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>0 if user exists; != 0 if not</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_delete\_user ##
**Remove a user account**



<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>User name</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Status from system command</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>nothing</td></tr>
</table>
## sf\_create\_user ##
**Create a user**

To set the login shell, initialize the CREATE\_USER\_SHELL variable before calling the function.

For accounts with no access allowed (blocked accounts), $7, $8, and $9 are not set.

<table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%>
<tr><td align=center width=50><b><i>Args</i></b></td><td style="padding: 0;"><table border=1 cellpadding=5 style="border-collapse: collapse;" width=100%><tr><td width=20 align=center>$1</td><td>User name</td></tr>
<tr><td width=20 align=center>$2</td><td>uid</td></tr>
<tr><td width=20 align=center>$3</td><td>gid</td></tr>
<tr><td width=20 align=center>$4</td><td>description (gecos)</td></tr>
<tr><td width=20 align=center>$5</td><td>home dir (can be '' for '/none')</td></tr>
<tr><td width=20 align=center>$6</td><td>Additional groups (separated with ',')</td></tr>
<tr><td width=20 align=center>$7</td><td>encrypted password (Linux)</td></tr>
<tr><td width=20 align=center>$8</td><td>encrypted password (HP-UX &amp; SunOS)</td></tr>
<tr><td width=20 align=center>$9</td><td>encrypted password (AIX)</td></tr>
</table></td></tr>
<tr><td align=center width=50><b><i>Returns</i></b></td><td>Always 0</td></tr>
<tr><td align=center width=50><b><i>Displays</i></b></td><td>Info msg</td></tr>
</table>


