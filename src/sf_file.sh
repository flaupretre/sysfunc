#
# Copyright 2009-2014 - Francois Laupretre <francois@tekwire.net>
#
#=============================================================================
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License (LGPL) as
# published by the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#=============================================================================

#=============================================================================
# Section: File manipulation
#=============================================================================

##----------------------------------------------------------------------------
# Recursively deletes a file or a directory
#
# Returns without error if arg is a non-existent path
#
# Args:
#	$1 : Path to delete
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_delete
{
typeset i

for i
	do
	if ls -d "$i" >/dev/null 2>&1 ; then
		sf_msg1 "Deleting $i"
		sf_save "$i"
		[ -z "$sf_noexec" ] && \rm -rf "$i"
	fi
done
}

##----------------------------------------------------------------------------
# Find an executable file
#
# Args:
#	$1 : Executable name
#	$2 : Optional. List of directories to search (separated by ':' chars).
#	     If not set, use PATH
# Returns: 0 if executable was found, 1 if not
# Displays: Absolute path if found, nothing if not found
#-----------------------------------------------------------------------------

function sf_find_executable
{
typeset file dirs dir f

file="$1"
shift
dirs="$*"
[ -z "$dirs" ] && dirs="$PATH"
dirs="`echo $dirs | sed 's/:/ /g'`"

for dir in $dirs
	do
	f="$dir/$file"
	if [ -f "$f" -a -x "$f" ] ; then
		echo "$f"
		return 0
	fi
done
return 1
}

##----------------------------------------------------------------------------
# Creates a directory
#
# If the given path argument corresponds to an already existing
# file (any type except directory or symbolic link to a directory), the
# program aborts with a fatal error. If you want to avoid
# this (if you want to create the directory, even if something else is
# already existing in this path), call [function:delete] first.
# If the path given as arg contains a symbolic link pointing to an existing
# directory, it is left as-is.
#
# Args:
#	$1 : Path
#	$2 : Optional. Directory owner[:group]. Default: root
#	$3 : Optional. Directory mode in a format accepted by chmod. Default: 755
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_dir
{

typeset path owner mode

path=$1
owner=$2
mode=$3

[ -z "$owner" ] && owner=root
[ -z "$mode" ] && mode=755

if [ ! -d "$path" ] ; then
	sf_msg1 "Creating directory: $path"
	sf_save "$path"
	if [ -z "$sf_noexec" ] ; then
		mkdir -p "$path"
		[ -d "$path" ] || sf_fatal "$path: Cannot create directory"
		sf_chown $owner $path
		sf_chmod $mode "$path"
	fi
fi
}

##----------------------------------------------------------------------------
# Renames a file to '<dir>/old.<filename>
#
# ### This function is deprecated. Please use [function:save] instead.
#
# Args:
#	$1 : Path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_rename_to_old
{
typeset dir base of f

f="$1"
[ -f "$f" ] || return
dir="`dirname $f`"
base="`basename $f`"
of="$dir/old.$base"
sf_msg1 "Renaming $f to old.$base"
if [ -z "$sf_noexec" ] ; then
	sf_delete $of
	mv $f $of
fi
}

##----------------------------------------------------------------------------
# Copy a file or the content of function's standard input to a target file
#
# The copy takes place only if the source and target files are different.
# If the target file is already existing, it is saved before being overwritten.
# If the target path directory does not exist, it is created.
#
# Args:
#	$1: Source path. Special value: '-' means that data to copy is read from
#		stdin, allowing to produce dynamic content without a temp file.
#	$2: Target path
#	$3: Optional. File creation mode. Default=644
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_check_copy
{
typeset mode source target tmpsource
tmpsource=
source="$1"

#-- Special case: source='-' => read data from stdin and create temp file

if [ "X$source" = 'X-' ] ; then
	tmpsource=y
	source=`sf_tmpfile`
	dd of=$source 2>/dev/null
fi

target="$2"

mode="$3"
[ -z "$mode" ] && mode=644

[ -f "$source" ] || return

if [ -f "$target" ] ; then
	diff "$source" "$target" >/dev/null 2>&1
	if [ $? = 0 ] ; then
		[ -n "$tmpsource" ] && \rm $source
		return
	fi
fi

sf_msg1 "Updating file $target"

sf_save $target
if [ -z "$sf_noexec" ] ; then
	\rm -rf "$target"
	sf_create_dir `dirname $target`
	cp "$source" "$target"
	sf_chmod $mode "$target"
fi

[ -n "$tmpsource" ] && \rm $source
}

##----------------------------------------------------------------------------
# Replaces or prepends/appends a data block in a file
#
# The block is composed of entire lines and is surrounded by special comment
# lines when inserted in the target file. These comment lines identify the
# data block and allow the function to be called several times on the same
# target file with different data blocks. The block identifier is the
# base name of the source path.
#
# If the given block is not present in the target file, it is appended or
# prepended, depending on the flag argument. If the block is already
# present in the file (was inserted by a previous run of this function),
# its content is compared with the new data, and replaced if different.
# In this case, it is replaced at the exact location where the previous block
# lied.
#
# If the target file exists, it is saved before being overwritten.
#
# If the target path directory does not exist, it is created.
#
# Args:
#	$1: If this arg starts with the '-' char, the data is to be read from
#		stdin and the string after the '-' is the block identifier.  
#		If it does not start with '-', it is the path to the source file
#		(containing the data to insert).
#	$2: Target path
#	$3: Optional. Target file mode.
#
# 	Default=644
#	$4: Optional. Flag. Set to 'prepend' to add data at the beginning of
#		the file. Default mode: Append.  
#	 	Used only if data block is not already present in the file.  
#		Can be set to '' (empty string) to mean 'default mode'.
#	$5: Optional. Comment character.  
#	 	This argument, if set, must contain only one character.  
#		This character will be used as first char when building
#		the 'identifier' lines surrounding the data block.  
#	 	Default: '#'.
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_check_block
{
typeset mode source target flag comment nstart nend fname tmp_dir action tmp_start tmp_end tmp_2 tmp_block

source="$1"
target="$2"
mode="$3"
[ -z "$mode" ] && mode=644
flag="$4"
comment="$5"
[ -z "$comment" ] && comment='#'

# Special case: data read from stdin. Create file in temp dir (id taken from
# the base name)

echo "X$source" | grep '^X-' >/dev/null 2>&1
if [ $? = 0 ] ; then
	fname="`echo "X$source" | sed 's/^..//'`"
	fname=`basename $fname`
	tmp_dir=`sf_tmpdir`
	source=$tmp_dir/$fname
	dd of=$source 2>/dev/null
else
	fname=`basename $source`
fi

[ -f "$source" ] || return

#-- Extrait bloc

tmp_start=`sf_tmpfile`
tmp_end=`sf_tmpfile`
tmp_2=`sf_tmpfile`
tmp_block=`sf_tmpfile`

if [ -f "$target" ] ; then
	nstart=`grep -n "^.#sysfunc_start/$fname##" "$target" | sed 's!:.*$!!'`
	if [ -n "$nstart" ] ; then
		( [ $nstart != 1 ] && head -`expr $nstart - 1` "$target" ) >$tmp_start
		tail -n +`expr $nstart + 1` <"$target" >$tmp_2
		nend=`grep -n "^.#sysfunc_end/$fname##" "$tmp_2" | sed 's!:.*$!!'`
		if [ -z "$nend" ] ; then # Corrupt block
			sf_fatal "check_block($1): Corrupt block detected - aborting"
			return
		fi
		( [ $nend != 1 ] && head -`expr $nend - 1` $tmp_2 ) >$tmp_block
		tail -n +`expr $nend + 1` <$tmp_2 >$tmp_end
		diff "$source" $tmp_block >/dev/null 2>&1 && return # Same block, no action
		action='Replacing'
	else
		if [ "$flag" = "prepend" ] ; then
			>$tmp_start
			cp $target $tmp_end
			action='Prepending'
		else
			cp $target $tmp_start
			>$tmp_end
			action='Appending'
		fi
	fi
else
	action='Creating from'
	>$tmp_start
	>$tmp_end
fi

sf_msg1 "$target: $action data block"

sf_save $target
if [ -z "$sf_noexec" ] ; then
	\rm -f "$target"
	sf_create_dir `dirname $target`
	(
	cat $tmp_start
	echo "$comment#sysfunc_start/$fname##------ Don't remove this line"
	cat $source
	echo "$comment#sysfunc_end/$fname##-------- Don't remove this line"
	cat $tmp_end
	) >$target
	sf_chmod $mode "$target"
fi

\rm -rf $tmp_dir $tmp_start $tmp_end $tmp_2 $tmp_block
}

##----------------------------------------------------------------------------
# Checks if a file contains a block inserted by [function:check_block]
#
#
# Args:
#       $1: The block identifier or source path
#       $2: File path
# Returns: 0 if the block is in the file, !=0 if not.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_contains_block
{
typeset id target

id="`basename $1`"
target="$2"

grep "^.#sysfunc_start/$id##" "$target" >/dev/null 2>&1
}

##----------------------------------------------------------------------------
# Change the owner of a set of files/dirs
#
# Args:
#       $1: owner[:group]
#       $2+: List of paths
# Returns: chown status code
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_chown
{
typeset status owner

status=0
owner=$1
shift
if [ -z "$sf_noexec" ] ; then
	chown "$owner" $*
	status=$?
fi
return $status
}

##----------------------------------------------------------------------------
# Change the mode of a set of files/dirs
#
# Args:
#       $1: mode as accepted by chmod
#       $2+: List of paths
# Returns: chmod status code
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_chmod
{
typeset status mode

status=0
mode=$1
shift
if [ -z "$sf_noexec" ] ; then
	chmod "$mode" $*
	status=$?
fi
return $status
}

##----------------------------------------------------------------------------
# Creates or modifies a symbolic link
#
# The target is saved before being modified.
#
# If the target path directory does not exist, it is created.
#
# Args:
#	$1: Link target
#	$2: Link path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_check_link
{
typeset link_target

\ls -ld "$2" >/dev/null 2>&1
if [ $? = 0 ] ; then
	if sf_file_is_link "$2" ; then
		link_target=`sf_file_readlink "$2"`
		[ "$link_target" = "$1" ] && return
	fi
fi

sf_msg1 "$2: Updating symbolic link"

sf_save "$2"
if [ -z "$sf_noexec" ] ; then
	\rm -rf "$2"
	sf_create_dir `dirname $2`
	ln -s "$1" "$2"
fi
}

##----------------------------------------------------------------------------
# Comment lines in a file
#
# The lines containing the (grep) pattern given in argument will be commented
# out by prefixing them with the comment string.
# If the pattern is not contained in the file, the file is left unchanged.
#
# Args:
#	$1: File path
#	$2: Pattern to search (grep regex syntax)
#	$3: Optional. Comment prefix string. Default='#'
#	$4: Number of lines to comment (''=all). Default: ''
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_comment_out
{
typeset file pattern com cnb tmp lnum line
file="$1"
pattern="$2"
com="$3"
[ "X$com" = X ] && com='#'
cnb=$4

tmp=`sf_tmpfile`
lnum=0
while read line ; do
	lnum=`expr $lnum + 1`
	if [ "$cnb" != 0 ] ; then
		echo "$line" | grep "$pattern" >/dev/null
		if [ $? = 0 ] ; then
			sf_msg "$file: Commenting out line $lnum"
			line="$com$line"
			[ -n "$cnb" ] && cnb=`expr $cnb - 1`
		fi
	fi
	echo "$line" >>$tmp
done <$file

if ! diff $file $tmp >/dev/null 2>&1 ; then
	sf_save $file
	cp $tmp $file
fi

/bin/rm -f $tmp
}

##----------------------------------------------------------------------------
# Uncomment lines in a file
#
# The commented lines containing the (grep) pattern given in argument
# will be uncommented by removing the comment string.
# If the pattern is not contained in the file, the file is left unchanged.
#
# Args:
#	$1: File path
#	$2: Pattern to search (grep regex syntax)
#	$3: Optional. Comment prefix string. Default='#'
#	$4: Number of lines to uncomment (''=all). Default: ''
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_uncomment
{
typeset file pattern com cnb tmp lnum line l2
file="$1"
pattern="$2"
com="$3"
[ "X$com" = X ] && com='#'
cnb=$4

tmp=`sf_tmpfile`
lnum=0
while read line ; do
	lnum=`expr $lnum + 1`
	if [ "$cnb" != 0 ] ; then
		echo "$line" | grep "^[ 	]*$com" >/dev/null
		if [ $? = 0 ] ; then
			l2=`echo "$line" | sed "s,^[ 	]*$com,,"`
			echo "$l2" | grep "$pattern" >/dev/null
			if [ $? = 0 ] ; then
				sf_msg "$file: Uncommenting line $lnum"
				line="$l2"
				[ -n "$cnb" ] && cnb=`expr $cnb - 1`
			fi
		fi
	fi
	echo "$line" >>$tmp
done <$file

if ! diff $file $tmp >/dev/null 2>&1 ; then
	sf_save $file
	cp $tmp $file
fi

/bin/rm -f $tmp
}

##----------------------------------------------------------------------------
# Checks if a given line is contained in a file
#
# Takes a pattern and a string as arguments. The first line matching the
# pattern is compared with the string. If they are different, the string
# argument replaces the line in the file. If they are the same, the file
# is left unchanged.
# If the pattern is not found, the string arg is appended to the file.
# If the file does not exist, it is created.
#
# Args:
#	$1: File path
#	$2: Pattern to search
#	$3: Line string
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_check_line
{
typeset file pattern line fline qpattern

file="$1"
pattern="$2"
line="$3"

fline=`grep "$pattern" $file 2>/dev/null | head -1`
[ "$fline" = "$line" ] && return
sf_save $file
if [ -n "$fline" ] ; then
	sf_msg1 "$1: Replacing '$2' line"
	qpattern=`echo "$pattern" | sed 's!/!\\\\/!g'`
	[ -z "$sf_noexec" ] && ed $file <<-EOF >/dev/null 2>&1
		/$qpattern/
		.c
		$line
		.
		w
		q
	EOF
else
	sf_msg1 "$1: Appending '$3' line"
	[ -z "$sf_noexec" ] && echo "$line" >>$file
fi
}

##------------------------------------------------
# Sort a file in-place
#
# Args:
#	$1: Path
#	$2-*: Optional. Sort options
# Returns: Sort return code
# Displays: Info msg
#------------------------------------------------

function sf_sort_file
{
typeset file tmp rc
file="$1"
shift
rc=0

if [ -z "$sf_noexec" ] ; then
	tmp=`sf_tmpfile`
	cp "$file" $tmp
	sf_save "$file"
	sort $* <$tmp >"$file"
	rc=$?
	rm -f $tmp
fi

return $rc
}

##------------------------------------------------
# Get the type of a file
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: - Nothing if file does not exist,
#	- R: Regular file,
#	- L: Symbolic link,
#	- D: Directory,
#	- C: Character device
#	- B: Block device
#	- P: Named pipe (fifo)
#------------------------------------------------

function sf_file_type
{
typeset source
source="$1"

[ -e "$source" ] || return 1

[ -b "$source" ] && echo B && return 0
[ -c "$source" ] && echo C && return 0
sf_file_is_link "$source" && echo L && return 0
[ -d "$source" ] && echo D && return 0
[ -p "$source" ] && echo P && return 0
[ -f "$source" ] && echo R && return 0
}

##------------------------------------------------
# Portable way to check if a file is a symbolic link
#
# Note: Don't use 'test -h' (not portable)
#
# Args:
#	$1: Path
# Returns: 0 if file exists and is a symbolic link, 1 if not
# Displays: Nothing
#------------------------------------------------

function sf_file_is_link
{
typeset source
source="$1"

\ls -ld "$source" | grep -- '->' >/dev/null 2>&1 
}

##------------------------------------------------
# Return age of a file (since last modification) in seconds
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: Time in seconds since last modification of file
#------------------------------------------------

function sf_file_age
{
typeset source ftime
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_age

ftime=`stat -c "%Y" "$source"`
expr `date +%s` - $ftime

return 0
}

##------------------------------------------------
# Return mode of a file in octal
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: File mode (nothing if file does not exist)
#------------------------------------------------

function sf_file_mode
{
typeset source
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_mode

stat -c "%a" "$source"
return 0
}

##------------------------------------------------
# Return owner of a file (numeric)
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: File owner in numeric form (nothing if file does not exist)
#------------------------------------------------

function sf_file_owner
{
typeset source
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_owner

stat -c "%u" "$source"
return 0
}

##------------------------------------------------
# Return group of a file (numeric)
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: File group in numeric form (nothing if file does not exist)
#------------------------------------------------

function sf_file_group
{
typeset source
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_group

stat -c "%g" "$source"
return 0
}

##------------------------------------------------
# Return last modification time of a file (Unix format)
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: File last modification time in Unix format (Seconds since Epoch),
#           nothing if file does not exist.
#------------------------------------------------

function sf_file_mtime
{
typeset source
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_mtime

stat -c "%Y" "$source"
return 0
}

##------------------------------------------------
# Return size of a file (in bytes)
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: File size (in bytes), nothing if file does not exist.
#------------------------------------------------

function sf_file_size
{
typeset source
source="$1"

[ -e "$source" ] || return 1

stat=`sf_find_executable stat`
[ -z "$stat" ] && sf_unsupported sf_file_size

stat -c "%s" "$source"
return 0
}

##------------------------------------------------
# Compute the checksum of a file
#
# Computed checksum depends on the OS and software available. It is prefixed
# with a string giving the format, followed by a ':' and the chacksum in
# readable form.
#
#
# Possible format strings, in preference order: SHA1, MD5, CKS, SUM.
#
#
# Generate a fatal error if none of these mechanisms is found.
#
# Args:
#	$1: Path
# Returns: 0 if file exists, 1 if not
# Displays: Checksum, nothing if file does not exist.
#------------------------------------------------

function sf_file_checksum
{
typeset source
source="$1"

[ -e "$source" ] || return 1

sf_find_executable sha1sum >/dev/null \
	&& echo SHA1:`sha1sum "$source" | awk '{ print $1 }'` && return

sf_find_executable openssl >/dev/null \
	&& echo SHA1:`openssl dgst -sha1 -hex "$source" | awk '{ print $NF }'` && return

sf_find_executable md5sum >/dev/null \
	&& echo MD5:`md5sum "$source" | awk '{ print $1 }'` && return

sf_find_executable cksum >/dev/null \
	&& echo CKS:`cksum "$source" | awk '{ print $1 }'` && return

sf_find_executable sum >/dev/null \
	&& echo SUM:`sum "$source" | awk '{ print $1 }'` && return

sf_fatal "Cannot find a way to compute a file checksum"
}

##------------------------------------------------
# Get the link target of a symbolic link
#
# Args:
#	$1: Path
# Returns: 0 if file exists and is a symbolic link, 1 if not
# Displays: Link target if file exists and is a symbolic link, nothing otherwise
#------------------------------------------------

function sf_file_readlink
{
typeset source
source="$1"

sf_file_is_link "$source" || return 1

sf_find_executable readlink >/dev/null && readlink "$source" && return

# Old way, when readlink is not available

ls -ld "$source" | sed 's/^.*->[ 	]*//'
}

##------------------------------------------------
# Canonicalize a file path
#
# The input path must correspond to an existing item (file or dir, any type)
# Every directories leading to the source item must be readable by the current
# user.
#
#
# This function preserves the current directory.
#
# Args:
#	$1: Path
# Returns: 0 if canonical path could be determined, 1 if not
# Displays: Canonical path, nothing if path does not exist or access denied
#------------------------------------------------

function sf_file_realpath
{
typeset source dir base swd rc
source="$1"
rc=0

[ -e "$source" ] || return 1

swd="`pwd`"
if [ -d "$source" ] ; then
	cd "$source" || return 1
	/bin/pwd 2>/dev/null || rc=1
else
	base="`basename \"$source\"`"
	dir="`dirname \"$source\"`"
	cd "$dir"  || return 1
	dir="`/bin/pwd 2>/dev/null`" || rc=1
	[ "X$dir" = X/ ] && dir=''
	[ $rc = 0 ] && echo "$dir/$base"
fi
cd "$swd"

return $rc
}

#=============================================================================
