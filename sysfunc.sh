#
# Copyright 2010 - Francois Laupretre <francois@tekwire.net>
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
# Section: Utility functions
#=============================================================================

##----------------------------------------------------------------------------
# Checks if the library is already loaded
#
#- Of course, if it can run, the library is loaded. So, it always returns 0.
#- Allows to support the 'official' way to load sysfunc :
#	sf_loaded 2>/dev/null || . /opt/sysfunc/sysfunc.sh
#
# Args: none
# Returns: Always 0
# Displays: Nothing
##----------------------------------------------------------------------------

sf_loaded()
{
return 0
}

##----------------------------------------------------------------------------
# Displays library version
#
# Args: none
# Returns: Always 0
# Displays: Library version (string)
#-----------------------------------------------------------------------------

sf_version()
{
echo "%VERSION%"
return 0
}

##----------------------------------------------------------------------------
# Retrieves executable data through an URL and executes it.
#
#- Supports any URL accepted by wget.
#- By default, the 'wget' command is used. If the $WGET environment variable
#  is set, it is used instead (use, for instance, to
#  specify a proxy or an alternate configuration file).
#
# Args:
#	$1 : Url
# Returns: the return code of the executed program
# Displays: data displayed by the executed program
#-----------------------------------------------------------------------------

sf_exec_url()
{
local wd tdir status

[ -n "$WGET" ] || WGET=wget

wd=`pwd`
tdir=`sf_get_tmp`

for i ; do
	sf_create_dir $tdir
	cd $tdir

	$WGET $i
	chmod +x *
	./*
	status=$?

	cd $wd
	/bin/rm -rf $tdir
done

return $status
}

#=============================================================================
# Section: Temporary file management
#=============================================================================

##----------------------------------------------------------------------------
# Deletes all temporary files
#
# Args: none
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_cleanup()
{
\rm -rf $sf_tmpfile*
}

##----------------------------------------------------------------------------
# Returns an unused temporary path
#
# The returned path can then be used to create a directory or a file.
#
# Args: none
# Returns: Always 0
# Displays: An unused temporary path
#-----------------------------------------------------------------------------

sf_get_tmp()
{
n=0
while true
	do
	f="$sf_tmpfile._tmp.$n"
	[ -e $f ] || break
	n=`expr $n + 1`
done

echo $f
}

#=============================================================================
# Section: Error handling
#=============================================================================

##----------------------------------------------------------------------------
# Displays an error message and aborts execution
#
# Args:
#	$1 : message
#	$2 : Optional. Exit code.
# Returns: Does not return. Exits with the provided exit code if arg 2 set,
#	with 1 if not.
# Displays: Error and abort messages
#-----------------------------------------------------------------------------

sf_fatal()
{
local rc

rc=1
[ -n "$2" ] && rc=$2

sf_error "$1"
echo
echo "******************* Abort *******************"
exit $rc
}

##----------------------------------------------------------------------------
# Fatal error on unsupported feature
#
# Call this function when a feature is not available on the current
# operating system (yet ?)
#
# Args:
#	$1 : feature name
# Returns: Does not return. Exits with code 2.
# Displays: Error and abort messages
#-----------------------------------------------------------------------------

sf_unsupported()
{
# $1: feature name

sf_fatal "$1: Feature not supported in this environment: $_os" 2
}

##----------------------------------------------------------------------------
# Displays an error message
#
# If the ERRLOG environment variable is set, it is supposed to contain
# a path. The error message will be appnded to the file at this path. If
# the file does not exist, it will be created.
# Args:
#	$1 : Message
# Returns: Always 0
# Displays: Error message
#-----------------------------------------------------------------------------

sf_error()
{
local msg

msg="*Error : $1"
sf_msg "$msg"
[ -n "$ERRLOG" ] && echo "$msg" >>$ERRLOG
}

##----------------------------------------------------------------------------
# Displays a warning message
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Warning message
#-----------------------------------------------------------------------------

sf_warning()
{
sf_msg " *===* WARNING *===* : $1"
}

#=============================================================================
# Section: User interaction
#=============================================================================

##----------------------------------------------------------------------------
# Displays a message (string)
#
# If the $sf_noexec environment variable is set, prefix the message with '(n)'
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Message
#-----------------------------------------------------------------------------

sf_msg()
{
local prefix

prefix=''
[ -n "$sf_noexec" ] && prefix='(n)'
echo "$prefix$1"
}

##----------------------------------------------------------------------------
# Display trace message
#
# If the $sf_verbose environment variable is set, displays the message. If not,
# does not display anything.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message if verbose mode is active, nothing if not
#-----------------------------------------------------------------------------

sf_trace()
{
[ -n "$sf_verbose" ] && sf_msg1 ">>> $*"
}

##----------------------------------------------------------------------------
# Displays a message prefixed with spaces
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message prefixed with spaces
#-----------------------------------------------------------------------------

sf_msg1()
{
sf_msg "        $*"
}

##----------------------------------------------------------------------------
# Displays a 'section' message
#
# This is a message prefixed with a linefeed and some hyphens. 
# To be used as paragraph/section title.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Message
#-----------------------------------------------------------------------------

sf_msg_section()
{
sf_msg ''
sf_msg "--- $1"
}

##----------------------------------------------------------------------------
# Displays a 'banner' message
#
# The message is displayed with an horizontal separator line above and below
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message
#-----------------------------------------------------------------------------

sf_banner()
{
echo
echo "==================================================================="
echo " $1"
echo "==================================================================="
echo
}

##----------------------------------------------------------------------------
# Ask a question to the user
#
#  This is a message without a terminating newline.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message without terminating newline
#-----------------------------------------------------------------------------

sf_ask()
{
if [ "$_os" = Linux ] ; then
	echo -n "$1 "
else
	echo "$1 \c"
fi
}

##----------------------------------------------------------------------------
# Asks a 'yes/no' question, gets answer, and return yes/no code
#
# Works at least for questions in english, french, and german :
# Accepts 'Y', 'O', and 'J' for 'yes' (upper or lowercase), and
# anything different is considered as 'no'
#- If the $forceyes environment variable is set, the user is not asked
# and the 'yes' code is returned.
#
# Args:
#	$1 : Question string
# Returns: 0 for 'yes', 1 for 'no'
# Displays: Question and typed answer if $forceyes not set, nothing if
#            $forceyes is set.
#-----------------------------------------------------------------------------

sf_yn_question()
{
local answer

if [ -n "$forceyes" ] ; then
	# sf_trace "Forcing answer to 'yes'"
	return 0
fi

sf_ask "$1"

read answer
echo
[ "$answer" != o -a "$answer" != O \
	-a "$answer" != y -a "$answer" != Y \
	-a "$answer" != j -a "$answer" != J ] \
	&& return 1

return 0
}

#=============================================================================
# Section: File/dir management
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

sf_delete()
{
local i

for i
	do
	if ls -d "$i" >/dev/null 2>&1 ; then
		sf_msg1 "Deleting $i"
		[ -z "$sf_noexec" ] && \rm -rf $i
	fi
done
}

##----------------------------------------------------------------------------
# Creates a directory
#
# If the given path argument corresponds to an already existing
# file (any type except directory or symbolic link to a directory), the
# program aborts with a fatal error. If you want to aAlways 0
# this (if you want to create the directory, even if somathing else is
# already existing in this path), call sf_delete first.
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

sf_create_dir()
{

local path owner mode

path=$1
owner=$2
mode=$3

[ -z "$owner" ] && owner=root
[ -z "$mode" ] && mode=755

if [ ! -d "$path" ] ; then
	sf_msg1 "Creating directory: $path"
	if [ -z "$sf_noexec" ] ; then
		mkdir -p "$path"
		[ -d "$path" ] || sf_fatal "$path: Cannot create directory"
		chown $owner $path
		chmod $mode "$path"
	fi
fi
}

##----------------------------------------------------------------------------
# Saves a file
#
# If the input arg is the path of an existing regular file, the file is copied
# to '$path.orig'
# TODO: improve save features (multiple numbered saved versions,...)
# Args:
#	$1 : Path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_save()
{
if [ -f "$1" -a ! -f "$1.orig" ] ; then
	sf_msg1 "Saving $1 to $1.orig"
	[ -z "$sf_noexec" ] && cp -p "$1" "$1.orig"
fi
}

##----------------------------------------------------------------------------
# Renames a file to '<dir>/old.<filename>
# 
# Args:
#	$1 : Path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_rename_to_old()
{
local dir base of f

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

sf_check_copy()
{
local mode source target

istmp=''
source="$1"

#-- Special case: source='-' => read data from stdin and create temp file

if [ "X$source" = 'X-' ] ; then
	source=$sf_tmpfile._check_copy
	dd of=$source 2>/dev/null
fi

target="$2"

mode="$3"
[ -z "$mode" ] && mode=644

[ -f "$source" ] || return

if [ -f "$target" ] ; then
	diff "$source" "$target" >/dev/null 2>&1 && return
	sf_save $target
fi

sf_msg1 "Updating file $target"

if [ -z "$sf_noexec" ] ; then
	\rm -rf "$target"
	sf_create_dir `dirname $target`
	cp "$source" "$target"
	chmod $mode "$target"
fi
}

##----------------------------------------------------------------------------
# Replaces or prepends/appends a data block in a file
#
# The block is composed of entire lines and is surrounded by special comment
# lines when inserted in the target file. These comment lines identify the
# data block and allow the function to be called several times on the same
# target file with different data blocks. The block identifier is the
# base name of the source path.
#- If the given block is not present in the target file, it is appended or
# prepended, depending on the flag argument. If the block is already
# present in the file (was inserted by a previous run of this function),
# its content is compared with the new data, and replaced if different.
# In this case, it is replaced at the exact place where the previous block
# lied.
#- If the target file exists, it is saved before being overwritten.
#- If the target path directory does not exist, it is created.
#
# Args:
#	$1: If this arg starts with the '-' char, the data is to be read from
#		stdin and the string after the '-' is the block identifier.
#-		If it does not start with '-', it is the path to the source file
#		(containing the data to insert).
#	$2: Target path
#	$3: Optional. Target file mode.
#-		Default=644
#	$4: Optional. Flag. Set to 'prepend' to add data at the beginning of
#		the file.
#-		Default mode: Append.
#-		Used only if data block is not already present in the file.
#-		Can be set to '' (empty string) to mean 'default mode'.
#	$5: Optional. Comment character.
#-		This argument, if set, must contain only one character.
#		This character will be used as first char when building
#		the 'identifier' lines surrounding the data block.
#-		Default: '#'.
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_check_block()
{
local mode source target flag comment nstart nend fname tmpdir

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
	tmpdir=$sf_tmpfile._dir.check_block
	\rm -rf $tmpdir
	mkdir -p $tmpdir
	source=$tmpdir/$fname
	dd of=$source 2>/dev/null
else
	fname=`basename $source`
fi

[ -f "$source" ] || return

#-- Extrait bloc

if [ -f "$target" ] ; then
	nstart=`grep -n "^.#sysfunc_start/$fname##" "$target" | sed 's!:.*$!!'`
	if [ -n "$nstart" ] ; then
		( [ $nstart != 1 ] && head -`expr $nstart - 1` "$target" ) >$sf_tmpfile._start
		tail --lines=+`expr $nstart + 1` <"$target" >$sf_tmpfile._2
		nend=`grep -n "^.#sysfunc_end/$fname##" "$sf_tmpfile._2" | sed 's!:.*$!!'`
		if [ -z "$nend" ] ; then # Corrupt block
			fatal "check_block($1): Corrupt block detected - aborting"
			return
		fi
		( [ $nend != 1 ] && head -`expr $nend - 1` $sf_tmpfile._2 ) >$sf_tmpfile._block
		tail --lines=+`expr $nend + 1` <$sf_tmpfile._2 >$sf_tmpfile._end
		diff "$source" $sf_tmpfile._block >/dev/null 2>&1 && return # Same block, no action
		action='Replacing'
	else
		if [ "$flag" = "prepend" ] ; then
			>$sf_tmpfile._start
			cp $target $sf_tmpfile._end
			action='Prepending'
		else
			cp $target $sf_tmpfile._start
			>$sf_tmpfile._end
			action='Appending'
		fi
	fi
	sf_save $target
else
	action='Creating from'
	>$sf_tmpfile._start
	>$sf_tmpfile._end
fi

sf_msg1 "$target: $action data block"

if [ -z "$sf_noexec" ] ; then
	\rm -f "$target"
	sf_create_dir `dirname $target`
	(
	cat $sf_tmpfile._start
	echo "$comment#sysfunc_start/$fname##------ Don't remove this line"
	cat $source
	echo "$comment#sysfunc_end/$fname##-------- Don't remove this line"
	cat $sf_tmpfile._end
	) >$target
	chmod $mode "$target"
fi
}

##----------------------------------------------------------------------------
# Checks if a file contains a block inserted by sf_check_block
#
#
# Args:
#       $1: The block identifier or source path
#       $2: File path
# Returns: 0 if the block is in the file, !=0 if not.
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_contains_block()
{
local id target

id="`basename $1`"
target="$2"

grep "^.#sysfunc_start/$id##" "$target" >/dev/null 2>&1
}

##----------------------------------------------------------------------------
# Creates or modifies a symbolic link
#
# The target is saved before being modified.
# Note: Don't use 'test -h' (not portable)
# If the target path directory does not exist, it is created.
#
# Args:
#	$1: Link target
#	$2: Link path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_check_link()
{
local link_target

\ls -ld "$2" >/dev/null 2>&1
if [ $? = 0 ] ; then
	\ls -ld "$2" | grep -- '->' >/dev/null 2>&1
	if [ $? = 0 ] ; then
		link_target=`\ls -ld "$2" | sed 's/^.*->[ 	]*//'`
		[ "$link_target" = "$1" ] && return
	fi
	sf_save "$2"
fi

sf_msg1 "$2: Updating symbolic link"

if [ -z "$sf_noexec" ] ; then
	\rm -rf "$2"
	sf_create_dir `dirname $2`
	ln -s "$1" "$2"
fi
}

##----------------------------------------------------------------------------
# Comment one line in a file
#
# The first line containing the (grep) pattern given in argument will be commented
# out by prefixing it with the comment character.
# If the pattern is not contained in the file, the file is left unchanged.
#
# Args:
#	$1 = File path
#	$2 = Pattern to search (grep regex syntax)
#	$3 = Optional. Comment char (one char string). Default='#'
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_comment_out()
{
local com
/
if [ -z "$3" ] ; then com='#' ; else com="$3"; fi

grep -v "^[ 	]*$com" "$1" | grep "$2" >/dev/null 2>&1
if [ $? = 0 ] ; then
	sf_save "$1"
	sf_msg1 "$1: Commenting out '$2'"
	if [ -z "$sf_noexec" ] ; then
		ed $1 <<-EOF >/dev/null 2>&1
			?^[^$com]*$2?
			s?^?$com?
			w
			q
		EOF
	fi
fi
}

##----------------------------------------------------------------------------
# Uncomment one line in a file
#
# The first commented line containing the (grep) pattern given in argument
# will be uncommented by removing the comment character.
# If the pattern is not contained in the file, the file is left unchanged.
#
# Args:
#	$1 = File path
#	$2 = Pattern to search (grep regex syntax)
#	$3 = Optional. Comment char (one char string). Default='#'
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_uncomment()
{
local com

if [ -z "$3" ] ; then com='#' ; else com="$3"; fi

grep "$2" "$1" | grep "^[ 	]*$com" >/dev/null 2>&1
if [ $? = 0 ] ; then
	sf_save "$1"
	sf_msg1 "$1: Uncommenting '$2'"
	if [ -z "$sf_noexec" ] ; then
		ed $1 <<-EOF >/dev/null 2>&1
			?^[ 	]*$com.*$2?
			s?^[ 	]*$com??g
			w
			q
		EOF
	fi
fi
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

sf_check_line()
{
local file pattern line fline qpattern

file=$1
pattern=$2
line=$3

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
	sf_msg1 "$1: Appending '$2' line"
	[ -z "$sf_noexec" ] && echo "$line" >>$file
fi
}

#=============================================================================
# Section: User/group management
#=============================================================================

##----------------------------------------------------------------------------
# Change a user's password
#
# Works on HP-UX, Solaris, and Linux.
# Replaces an encrypted passwd in /etc/passwd or /etc/shadow.
# TODO: Unify with AIX and autodetect the file to use (passwd/shadow)
#
# Args:
#	$1: Username
#	$2: Encrypted password
#	$3: File path
# Returns: Always 0
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_set_passwd()
{
local file user pass qpass

user="$1"
pass="$2"
file="$3"

qpass=`echo "$pass" | sed 's!/!\\\\/!g'`

ed $file <<EOF >/dev/null 2>&1
	/^$user:/
	s/^$user:[^:]*:/$user:$qpass:/
	w
	q
EOF
}

##----------------------------------------------------------------------------
# Set an AIX password
#
# TODO: Unify with other supported OS
#
# Args:
#	$1: Username
#	$2: Encrypted password
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_set_passwd_aix()
{
local user pass qpass

user="$1"
pass="$2"

pwdadm -f NOCHECK $user	# to create the account if needed

qpass=`echo "$pass" | sed 's!/!\\\\/!g'`

ed /etc/security/passwd <<-EOF >/dev/null 2>&1
	/^$user:/
	/password =/
	s/=.*$/= $qpass/
	/flags =/
	s/=.*$/=/
	w
	q
	EOF
}

##----------------------------------------------------------------------------
# Create a user group
#
# Args:
#	$1 = Group name
#	$2 = Group Id
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_group()
{

case $_os in
	AIX)
		lsgroup $1 >/dev/null 2>&1
		if [ $? != 0 ] ; then
			sf_msg1 "Creating $1 group"
			[ -z "$sf_noexec" ] && mkgroup id=$2 $1
		fi
		;;

	*)
		grep "^$1:" /etc/group >/dev/null 2>&1
		if [ $? != 0 ] ; then
			sf_msg1 "Creating $1 group"
			[ -z "$sf_noexec" ] && groupadd -g $2 $1
		fi
		;;
esac
return 0
}

##----------------------------------------------------------------------------
# Checks if a given user exists on the system
#
# Args:
#	$1: User name to check
# Returns: 0 if user exists; != 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

sf_user_exists()
{
local status

case $_os in
	AIX)
		lsuser $1 >/dev/null 2>&1
		status=$?
		;;

	*)
		grep "^$1:" /etc/passwd >/dev/null 2>&1
		status=$?
		;;
esac
return $status
}

##----------------------------------------------------------------------------
# Create a user
#
# To set the login shell, initialize the CREATE_USER_SHELL variable before
# calling the function.
# For accounts with no access allowed (blocked accounts), $7, $8, and $9 are
# not set.
#
# Args:
#	$1 = User name
#	$2 = uid
#	$3 = gid
#	$4 = description (gecos)
#	$5 = home dir (can be '' for '/none')
#	$6 = Additional groups (separated with ',')
#	$7 = encrypted password (Linux)
#	$8 = encrypted password (HP-UX & SunOS)
#	$9 = encrypted password (AIX)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_user()
{
local name uid gid gecos home groups locked add_cmd shell passwd_file

sf_user_exists $1 && return

name=$1
uid=$2
gid=$3
gecos=$4

home=$5
[ -z "$home" ] && home='/none'

groups=$6

locked='y'
[ $# = 9 ] && locked=''

sf_msg1 "Creating account $1"
[ -n "$sf_noexec" ] && return
sf_create_dir `dirname $home`

add_cmd=''

case $_os in
	AIX)
		[ -n "$groups" ] && add_cmd="$add_cmd groups=$groups"

		[ -n "$locked" ] && add_cmd="$add_cmd login=false"

		mkuser gecos="$gecos" pgrp=$gid id=$uid home=$home $add_cmd $name

		[ -z "$locked" ] && sf_set_passwd_aix $name "$9"
		;;

	Linux)
		shell=/bin/bash
		#[ -n "$locked" ] && shell=/bin/false
		[ -n "$CREATE_USER_SHELL" ] && shell="$CREATE_USER_SHELL"

		[ -n "$groups" ] && add_cmd="-G $groups"

		if [ "$home" = /none ] ; then
			add_cmd="$add_cmd -M"
		else
			add_cmd="$add_cmd -m"
		fi
			
		useradd -c "$gecos" -o -g $gid -u $uid -d $home -s $shell $add_cmd $name

		[ -z "$locked" ] && sf_set_passwd /etc/shadow $name "$7"
		;;

	*)
		shell=/bin/sh
		[ -x /bin/ksh ] && shell=/bin/ksh
		#[ -n "$locked" ] && shell=/bin/false

		[ -n "$groups" ] && add_cmd="-G $groups"

		[ "$home" != /none ] && add_cmd="$add_cmd -m"

		useradd -c "$gecos" -g $gid -u $uid -d $home -s $shell $add_cmd $name \
			>/dev/null

		passwd_file=/etc/shadow
		[ $_os = HP-UX ] && passwd_file=/etc/passwd
		[ -z "$locked" ] && sf_set_passwd $passwd_file $name "$8"
		;;
esac
return 0
}

#=============================================================================
# Section: OS management
#=============================================================================

##----------------------------------------------------------------------------
# Computes and displays a string defining the curent system environment
#
# The displayed string is a combination of the OS name, version, system
# architecture and may also depend on other parameters like, for instance,
# the RedHat ES/AS branches. It is an equivalent of the 'channel' concept
# used by RedHat. I personnally call it 'OS ID' for 'OS IDentifier' and use
# it in every script where I need a single string to identify the system
# environment the script is currently running on.
# If the current system is not recognized, the program aborts.
#By convention, environments recognized by this function must support
# the rest of the library.
#
# Contributors welcome ! Feel free to enhance this function with additional
# recognized systems, especially with other Linux distros, and send your
# patches.
#
# Args: None
# Returns: Always 0
# Displays: OS ID
#-----------------------------------------------------------------------------

sf_compute_os_id()
{
local id os frel rel sub

#-- Recognizes the current environment

id=''
case "$_os" in
	HP-UX)
		id="HPUX_`uname -r | sed 's/^B\.//'`"
		;;

	Linux)
		frel=/etc/redhat-release
		if [ -f $frel ] ; then
			rel=`sed 's/^.* release \(.\).*$/\1/' <$frel`
			id="RHEL_$rel"
			[ `uname -i` = x86_64 ] && id="${id}_64"
			if [ "$rel" -lt 5 ] ; then
				sub=`sed 's/^.* Linux \(.S\).*$/\1/' <$frel`
				id="${id}_$sub"
			fi
		fi
		;;

	SunOS)
		rel=`uname -r | sed 's/^5\.//'`
		id="SOLARIS_$rel"
		;;

	AIX)
		id="${_os}_`uname -v`.`uname -r`"
		;;
esac

[ -z "$id" ] &&	sf_unsupported sf_compute_os_id

echo $id
}

#=============================================================================
# Section: Filesystem management
#=============================================================================

##----------------------------------------------------------------------------
# Checks if a directory is a file system mount point
#
# Args:
#	$1: Directory to check
# Returns: 0 if true, !=0 if false
# Displays: nothing
#-----------------------------------------------------------------------------

sf_has_dedicated_fs()
{
[ -d "$1" ] || return 1

[ "`sf_get_fs_mnt $1`" = "$1" ]
}

##----------------------------------------------------------------------------
# Gets the mount point of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The mount directory of the filesystem containing the element
#-----------------------------------------------------------------------------

sf_get_fs_mnt()
{
case "$_os" in
	Linux)
		df -kP "$1" | tail -1 | awk '{ print $6 }'
		;;
	SunOS)
		/usr/bin/df -k "$1" | tail -1 | awk '{ print $6 }'
		;;
	AIX)
		df -k "$1" | tail -1 | awk '{ print $7 }'
		;;
	*)
		sf_unsupported sf_get_fs_mnt
		;;
esac
}

##----------------------------------------------------------------------------
# Get the size of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: FS size in Mbytes
#-----------------------------------------------------------------------------

sf_get_fs_size()
{
# $1=directory

case "$_os" in
	Linux)
		sz=`df -kP "$1" | tail -1 | awk '{ print $2 }'`
		;;
	SunOS)
		sz=`/usr/bin/df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	AIX)
		sz=`df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	*)
		sf_unsupported sf_get_fs_mnt
		;;
esac

echo `expr $sz / 1024`
}

##----------------------------------------------------------------------------
# Extend a file system to a given size
#
# Args:
#	$1: A path contained in the file system to extend
#	$2: The new size in Mbytes, or the size to add if prefixed with a '+'
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_set_fs_space()
{
local fs size newsize rc

fs=`sf_get_fs_mnt $1`
size=`sf_get_fs_size $1`
newsize=$2
echo "$newsize" | grep '^+' >/dev/null 2>&1
if [ $? = 0 ] ; then
	newsize=`echo $newsize | sed 's/^.//'`
	newsize=`expr $size + $newsize`
fi

if [ "$newsize" -gt "$size" ] ; then
	sf_msg1 "Extending $fs filesystem to $newsize Mb"
	case "$_os" in
		AIX)
			chfs -a size=${newsize}M $fs
			rc=$?
			;;
		*)
			sf_unsupported sf_set_fs_space
			;;
	esac
fi

return $rc
}

##----------------------------------------------------------------------------
# Create a file system, mount it, and set system configuration to mount it
# at system start
#
# Refuses existing directory as mount point (security)
#
# Args:
#	$1: Mount point
#	$2: device path
#	$3: FS type
#	$4: Optional. Mount point directory owner[:group]
# Returns: 0 if no error, 1 on error
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_fs()
{
local mnt dev type owner opts

mnt=$1
dev=$2
type=$3
owner=$4
[ -z "$owner" ] && owner=root

sf_has_dedicated_fs $mnt && return
sf_msg1 "$mnt: Creating file system"

if [ -d $mnt ] ; then # Securite
	sf_error "$mnt: Cannot create FS on an existing directory"
	return 1
else
	mkdir -p $mnt
fi

[ $? = 0 ] || return 1

case "$_os" in
	Linux)
		opts=''
		# When supported, set filesystem label
		echo $type | grep '^ext' >/dev/null && opts="-L `basename $dev`"
		mkfs -t $type $opts $dev
		[ $? = 0 ] || return 1
		echo "$dev $mnt $type defaults 1 2" >>/etc/fstab
		;;
	*)
		sf_unsupported sf_create_fs
		;;
esac

mount $dev $mnt
[ $? = 0 ] || return 1

chown $owner $mnt
[ $? = 0 ] || return 1

return 0
}

##----------------------------------------------------------------------------
# Checks if a given logical volume exists
#
# Args:
#	$1: VG name
#	$2: LV name
# Returns: 0 if it exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_lv_exists()
{
local vg lv rc

vg=$1
lv=$2

case "$_os" in
	Linux)
		lvs $vg/$lv >/dev/null 2>&1
		rc=$?
		;;
	*)
		sf_unsupported sf_lv_exists
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Checks if a given volume group exists
#
# Args:
#	$1: VG name
# Returns: 0 if it exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_vg_exists()
{
local vg rc

vg=$1

case "$_os" in
	Linux)
		vgs $vg >/dev/null 2>&1
		rc=$?
		;;
	*)
		sf_unsupported sf_lv_exists
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Create a logical volume
#
# Args:
#	$1: Logical volume name
#	$2: Volume group name
#	$3: Size in Mbytes
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_lv()
{
local lv vg size

lv=$1
vg=$2
size=$3

if ! sf_vg_exists $vg ; then
	sf_error "VG $vg does not exist"
	return 1
fi

sf_lv_exists $vg $lv && return

sf_msg1 "Creating LV $lv on VG $vg"

case "$_os" in
	Linux)
		lvcreate --size ${size}M -n $lv $vg
		rc=$?
		;;
	*)
		sf_unsupported sf_create_fs
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Create a logical volume and a filesystem on it
#
# Combines sf_create_lv and sf_create_fs
#
# Args:
#	$1: Mount point (directory)
#	$2: Logical volume name
#	$3: Volume group name
#	$4: File system type
#	$5: Size in Mbytes
#	$6: Optional. Directory owner[:group]
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_lv_fs()
{
local mnt lv vg type size owner

mnt=$1
lv=$2
vg=$3
type=$4
size=$5
owner=$6

sf_create_lv $lv $vg $size || return 1
sf_create_fs $mnt /dev/$vg/$lv $type $owner || return 1
}

#=============================================================================
# Section: Package management
#=============================================================================

##----------------------------------------------------------------------------
# List installed packages
#
# Returns a sorted list of installed packages
# Linux output: yum format (name-version-release.arch)
#
# Args: none
# Returns: Always 0
# Displays: package list
#-----------------------------------------------------------------------------

sf_package_list()
{
case "$_os" in
	Linux)
		rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort
		;;
	*)
		sf_unsupported package_list
		;;
esac
}

#=============================================================================
# Section: Service management
#=============================================================================

##----------------------------------------------------------------------------
# Enable service start/stop at system boot/shutdown
#
# Enable service for state 2, 3, 4, and 5 (default for chkconfig)
#
# Args:
#	$*: Service names
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_enable_service()
{
for service in $*
	do
	case "$_os" in
		Linux)
			[ -f /etc/init.d/$service ] || continue
			chkconfig --list $service 2>/dev/null | grep ':on' >/dev/null && continue
			msg1 "Enabling service $service"
			[ -z "$sf_noexec" ] && /sbin/chkconfig $service on
			;;
		*)
			sf_unsupported enable_service
			;;
	esac
done
}

##----------------------------------------------------------------------------
# Disable service start/stop at system boot/shutdown
#
# Disable service for every states
#
# Args:
#	$*: Service names
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_disable_service()
{
for service in $*
	do
	case "$_os" in
		Linux)
			[ -f /etc/init.d/$service ] || continue
			chkconfig --list $service 2>/dev/null | grep ':on' >/dev/null || continue
			sf_msg1 "Disabling service $service"
			[ -z "$sf_noexec" ] && /sbin/chkconfig --level 0123456 $service off
			;;
		*)
			sf_unsupported disable_service
			;;
	esac
done
}

#=============================================================================
# Section: Network
#=============================================================================

##----------------------------------------------------------------------------
# Suppresses the host name part from a FQDN
#
# Displays the input string without the beginning up to and including the
# first '.'.
#
# Args:
#	$1: Input FQDN
# Returns: Always 0
# Displays: truncated string
#-----------------------------------------------------------------------------

sf_domain_part()
{
sed 's/^[^\.]*\.//'
}

##----------------------------------------------------------------------------
# Extracts a hostname from an FQDN
#
# Removes everything from the first dot up to the end of the string
#
# Args:
#	$1: Input FQDN
# Returns: Always 0
# Displays: truncated string
#-----------------------------------------------------------------------------

sf_host_part()
{
sed 's/^\([^\.]*\)\..*$/\1/'
}

##----------------------------------------------------------------------------
# Resolves an IP address through the DNS
#
# If the address cannot be resolved, displays nothing
#
# Args:
#	$1: IP address
#	$2: Optional. DNS server to ask
# Returns: Always 0
# Displays: Host name as returned by the DNS or nothing if address could
# not be resolved.
#-----------------------------------------------------------------------------

sf_dns_addr_to_name()
{
( [ -n "$2" && echo "server $2"; echo "$1" ) \
	| nslookup 2>/dev/null | grep '^Name:' | head -1 \
	| sed -e 's/^Name:[ 	]*//g'
}

##----------------------------------------------------------------------------
# Resolves a host name through the DNS
#
# If the name cannot be resolved, displays nothing
#
# Args:
#	$1: Host name to resolve
#	$2: Optional. DNS server to ask
# Returns: Always 0
# Displays: IP address as returned by the DNS or nothing if name could
# not be resolved.
#-----------------------------------------------------------------------------

sf_dns_name_to_addr()
{
( [ -n "$2" && echo "server $2"; echo "$1" ) \
	| nslookup 2>/dev/null \
	| grep '^Address:' | tail --lines=+2 | head -1 \
	| sed -e 's/^Address:[ 	]*//g'
}

##----------------------------------------------------------------------------
# Get the primary address of the system
#
# This is an arbitrary choice, such as the address assigned to the first
# network nterface.
# Feel free to improve !
#
# Args: none
# Returns: Always 0
# Displays: IP address or nothing if no address was found
#-----------------------------------------------------------------------------

sf_primary_ip_address()
{
case "$_os" in
	Linux)
		ifconfig eth0 | grep 'inet addr:' \
			| sed 's/^.*inet addr:\([^ ]*\) .*$/\1/'
		;;
	*)
		sf_unsupported primary_ip_address
		;;
esac
}

#=============================================================================
# MAIN
#=============================================================================

#-- Clear potentially conflicting f...ing aliases

for i in cp mv rm
	do
	unalias $i >/dev/null 2>&1 || :
done

#-- Variables

_os=`uname -s`
export _os

[ -z "$sf_tmpfile" ] && sf_tmpfile=/tmp/.conf$$.tmp
export sf_tmpfile

#-- Path

for i in /usr/sbin /bin /usr/bin /etc /usr/ccs/bin
	do
	[ -d "$i" ] && PATH="$i:$PATH"
done
export PATH

sf_cleanup

#=============================================================================
