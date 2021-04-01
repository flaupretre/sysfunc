**SysFunc** is a shell library primarily intended for Unix sysadmins.

It provides a set of portable shell functions including features such as :

- file copy,
- symbolic link management,
- file/directory deletion,
- user/group management,
- data block or line replacement in a file,
- commenting/uncommenting a line,
- service management,
- volume group/logical volume/file system creation
- and much more...

Up to version 2.2.10, the library was tested on Linux, Solaris, HP-UX, and AIX. Actually, it
should run on any Unix/Linux system.

Versions 2.2.11 and up were tested on bash only, as I don't use other environments anymore. Anyway,
issues and PR for non-bash shells are still welcome.

Note that, unfortunately, the code was not developed with the 'set -e' (fail on 1st failing command)
nor 'set -u' (fail on unbound variable) modes activated. I am currently fixing these failures when I
meet them but I cannot guarantee a correct behavior when one of those modes is active.

The project home page is [http://sysfunc.tekwire.net](http://sysfunc.tekwire.net).