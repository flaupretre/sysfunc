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
# Utility functions
#=============================================================================

#-----------------------------------------------------------------------------
# Displays library version
#
# Args : none
# Returns : void
# Displays : Library version (string)
#-----------------------------------------------------------------------------

sf_version()
{
echo "%VERSION%"
return 0
}

#-----------------------------------------------------------------------------
# Retrieves executable data through an URL and executes it.
#
# Supports any URL accepted by wget.
# By default, the 'wget' command is used. If the $WGET environment variable is set, it is used instead (use, for instance, to
# specify a proxy or an alternate configuration file).
#
# Args :
#	$1 : Url
# Returns : the return code of the executed program
# Displays : data displayed by the executed program
#-----------------------------------------------------------------------------

sf_exec_url()
{
local wd tdir status

[ -n "$WGET" ] || WGET=wget

wd=`pwd`
tdir=`sf_get_tmp`

for i ; do
	create_dir $tdir
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
# Temporary file management
#=============================================================================

#-----------------------------------------------------------------------------
# Deletes all temporary files
#
# Args : none
# Returns : vois
# Displays : nothing
#-----------------------------------------------------------------------------

sf_cleanup()
{
\rm -rf $tmpfile*
}

#-----------------------------------------------------------------------------
# Returns an unused temporary path
#
# The returned path can then be used to create a directory or a file.
#
# Args : none
# Returns : void
# Displays : An unused temporary path
#-----------------------------------------------------------------------------

sf_get_tmp()
{
n=0
while true
	do
	f="$tmpfile._tmp.$n"
	[ -e $f ] || break
	n=`expr $n + 1`
done

echo $f
}

#=============================================================================
# Error handling
#=============================================================================

#-----------------------------------------------------------------------------
# Displays an error message and aborts execution
#
# Args :
#	$1 : message
#	$2 : Optional. Exit code.
# Returns : Does not return. Exits with the provided exit code if arg 2 set,
#	with 1 if not.
# Displays : Error and abort messages
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

#-----------------------------------------------------------------------------
# Fatal error on unsupported feature
#
# Call this function when a feature is not available on the current
# operating system (yet ?)
#
# Args :
#	$1 : feature name
# Returns : Does not return. Exits with code 2.
# Displays : Error and abort messages
#-----------------------------------------------------------------------------

sf_unsupported()
{
# $1: feature name

sf_fatal "$1: Feature not supported in this environment: $_os" 2
}

#-----------------------------------------------------------------------------
# Displays an error message
#
# If the ERRLOG environment variable is set, it is supposed to contain
# a path. The error message will be appnded to the file at this path. If
# the file does not exist, it will be created.
# Args :
#	$1 : Message
# Returns : void
# Displays : Error message
#-----------------------------------------------------------------------------

sf_error()
{
local msg

msg="*Error : $1"
sf_msg "$msg"
[ -n "$ERRLOG" ] && echo "$msg" >>$ERRLOG
}

#-----------------------------------------------------------------------------
# Displays a warning message
#
# Args :
#	$1 : message
# Returns : void
# Displays : Warning message
#-----------------------------------------------------------------------------

sf_warning()
{
sf_msg " *===* WARNING *===* : $1"
}

#=============================================================================
# User interaction
#=============================================================================

#-----------------------------------------------------------------------------
# Displays a message (string)
#
# If the $noexec environment variable is set, prefix the message with '(n)'
#
# Args :
#	$1 : message
# Returns : void
# Displays : Message
#-----------------------------------------------------------------------------

sf_msg()
{
local prefix

prefix=''
[ -n "$noexec" ] && prefix='(n)'
echo "$prefix$1"
}

#-----------------------------------------------------------------------------
# Display trace message
#
# If the $verbose environment variable is set, displays the message. If not,
# does not display anything.
#
# Args :
#	$1 : message
# Returns : void
# Displays : message if verbose mode is active, nothing if not
#-----------------------------------------------------------------------------

sf_trace()
{
[ -n "$verbose" ] && sf_msg1 ">>> $*"
}

#-----------------------------------------------------------------------------
# Displays a message prefixed with spaces
#
# Args :
#	$1 : message
# Returns : void
# Displays : message prefixed with spaces
#-----------------------------------------------------------------------------

sf_msg1()
{
sf_msg "        $*"
}

#-----------------------------------------------------------------------------
# Displays a 'section' message
#
# This is a message prefixed with a linefeed and some hyphens. 
# To be used as paragraph/section title.
#
# Args :
#	$1 : message
# Returns : void
# Displays : Message
#-----------------------------------------------------------------------------

sf_msg_section()
{
sf_msg ''
sf_msg "--- $1"
}

#-----------------------------------------------------------------------------
# Displays a 'banner' message
#
# The message is displayed with an horizontal separator line above and below
#
# Args :
#	$1 : message
# Returns : void
# Displays : message
#-----------------------------------------------------------------------------

sf_banner()
{
echo
echo "==================================================================="
echo " $1"
echo "==================================================================="
echo
}

#-----------------------------------------------------------------------------
# Ask a question to the user
#
#  This is a message without a terminating newline.
#
# Args :
#	$1 : message
# Returns : void
# Displays : message without terminating newline
#-----------------------------------------------------------------------------

sf_ask()
{
if [ "$_os" = Linux ] ; then
	echo -n "$1 "
else
	echo "$1 \c"
fi
}

#-----------------------------------------------------------------------------
# Asks a 'yes/no' question, gets answer, and return yes/no code
#
# Works at least for questions in english, french, and german :
#	- accepts 'Y', 'O', and 'J' for 'yes' (upper or lowercase)
#	- anything different is considered as 'no'
# If the $forceyes environment variable is set, the user is not asked
# and the 'yes' code is returned.
#
# Args :
#	$1 : Question string
# Returns : 0 for 'yes', 1 for 'no'
# Displays : Question and typed answer if $forceyes not set, nothing if
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
# File/dir management
#=============================================================================

#-----------------------------------------------------------------------------
# Recursively deletes a file or a directory.
#
# Returns without error if arg is a non-existent path
#
# Args :
#	$1 : Path to delete
# Returns : void
# Displays : info msg if deletion occurs
#-----------------------------------------------------------------------------

sf_delete()
{
local i

for i
	do
	if ls -d "$i" >/dev/null 2>&1 ; then
		sf_msg1 "Deleting $i"
		[ -z "$noexec" ] && \rm -rf $i
	fi
done
}

#-----------------------------------------------------------------------------
# Creates a directory
#
# If the given path argument corresponds to an already existing
# file (any type except directory or symbolic link to a directory), the
# program aborts with a fatal error. If you want to avoid
# this (if you want to create the directory, even if somathing else is
# already existing in this path), call sf_delete first.
# If the path given as arg contains a symbolic link pointing to an existing
# directory, it is left as-is.
#
# Args :
#	$1 : Path
#	$2 : Optional. Directory owner[:group]. Default: root
#	$3 : Optional. Directory mode in a format accepted by chmod. Default: 755
# Returns : void
# Displays : Info msg
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
	if [ -z "$noexec" ] ; then
		mkdir -p "$path"
		[ -d "$path" ] || sf_fatal "$path: Cannot create directory"
		chown $owner $path
		chmod $mode "$path"
	fi
fi
}

#-----------------------------------------------------------------------------
# Saves a file
#
# If the input arg is the path of an existing regular file, the file is copied
# to '$path.orig'
# TODO: improve save features (multiple numbered saved versions,...)
# Args :
#	$1 : Path
# Returns : void
# Displays : info msg
#-----------------------------------------------------------------------------

sf_save()
{
if [ -f "$1" -a ! -f "$1.orig" ] ; then
	sf_msg1 "Saving $1 to $1.orig"
	[ -z "$noexec" ] && cp -p "$1" "$1.orig"
fi
}

#-----------------------------------------------------------------------------
# Renames a file to '<dir>/old.<filename>
# 
# Args :
#	$1 : Path
# Returns : void
# Displays : info msg
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
if [ -z "$noexec" ] ; then
	sf_delete $of
	mv $f $of
fi
}

#-----------------------------------------------------------------------------
# Copy a file or the content of function's standard input to a target file
#
# The copy takes place only if the source and target files are different.
# If the target file is already existing, it is saved before being overwritten.
# If the target path directory does not exist, it is created.
#
# Args :
#	$1: Source path. Special value: '-' means that data to copy is read from
#		stdin, allowing to produce dynamic content without a temp file.
#	$2: Target path
#	$3: Optional. File creation mode. Default=644
# Returns : void
# Displays : info msg
#-----------------------------------------------------------------------------

sf_check_copy()
{
local mode source target

istmp=''
source="$1"

#-- Special case: source='-' => read data from stdin and create temp file

if [ "X$source" = 'X-' ] ; then
	source=$tmpfile._check_copy
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

if [ -z "$noexec" ] ; then
	\rm -rf "$target"
	sf_create_dir `dirname $target`
	cp "$source" "$target"
	chmod $mode "$target"
fi
}

#-----------------------------------------------------------------------------
# Replaces or prepends/appends a data block in a file
#
# The block is composed of entire lines and is surrounded by special comment
# lines when inserted in the target file. These comment lines identify the
# data block and allow the function to be called several times on the same
# target file with different data blocks. The block identifier is the
# base name of the source path.
# If the given block is not present in the target file, it is appended or
# prepended, depending on the flag argument. If the block is already
# present in the file (was inserted by a previous run of this function),
# its content is compared with the new data, and replaced if different.
# In this case, it is replaced at the exact place where the previous block
# lied.
# If the target file is existing, it is saved before being overwritten.
# If the target path directory does not exist, it is created.
#
# Args :
#	$1: If this arg starts with the '-' char, the data is to be read from
#		stdin and the string after the '-' is the block identifier. If
#		it does not start with '-', it is the path to the source file
#		(containing the data to insert)
#	$2: Target path
#	$3: Optional. Target file mode. Default=644
#	$4: Optional. Flag. Set to 'prepend' to add data at the beginning of
#		the file. Default mode: Append. Used only if data block is not
#		already present in the file. Can be set to '' (empty string) to mean
#		'default mode'.
#	$5: Optional. Comment character. This argument, if set, must contain only
#		one character. This character will be used as first char when building
#		the 'identifier' lines surrounding the data block. Default: '#'.
# Returns : void
# Displays : info msg
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
	tmpdir=$tmpfile._dir.check_block
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
		( [ $nstart != 1 ] && head -`expr $nstart - 1` "$target" ) >$tmpfile._start
		tail --lines=+`expr $nstart + 1` <"$target" >$tmpfile._2
		nend=`grep -n "^.#sysfunc_end/$fname##" "$tmpfile._2" | sed 's!:.*$!!'`
		if [ -z "$nend" ] ; then # Corrupt block
			fatal "check_block($1): Corrupt block detected - aborting"
			return
		fi
		( [ $nend != 1 ] && head -`expr $nend - 1` $tmpfile._2 ) >$tmpfile._block
		tail --lines=+`expr $nend + 1` <$tmpfile._2 >$tmpfile._end
		diff "$source" $tmpfile._block >/dev/null 2>&1 && return # Same block, no action
		action='Replacing'
	else
		if [ "$flag" = "prepend" ] ; then
			>$tmpfile._start
			cp $target $tmpfile._end
			action='Prepending'
		else
			cp $target $tmpfile._start
			>$tmpfile._end
			action='Appending'
		fi
	fi
	sf_save $target
else
	action='Creating from'
	>$tmpfile._start
	>$tmpfile._end
fi

sf_msg1 "$target: $action data block"

if [ -z "$noexec" ] ; then
	\rm -f "$target"
	sf_create_dir `dirname $target`
	(
	cat $tmpfile._start
	echo "$comment#sysfunc_start/$fname##------ Don't remove this line"
	cat $source
	echo "$comment#sysfunc_end/$fname##-------- DOn't remove this line"
	cat $tmpfile._end
	) >$target
	chmod $mode "$target"
fi
}

#-----------------------------------------------------------------------------
# Creates or modifies a symbolic link
#
# The target is saved before being modified.
# Note: Don't use 'test -h' (not portable)
# If the target path directory does not exist, it is created.
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# $1 = target du lien
# $2 = lien a creer

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

sf_msg1 "Mise a jour du lien symbolique $2"

if [ -z "$noexec" ] ; then
	\rm -rf "$2"
	sf_create_dir `dirname $2`
	ln -s "$1" "$2"
fi
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# $1 = file
# $2 = string
# $3 = car de commentaire (def=#)

sf_comment_out()
{
local com
/
if [ -z "$3" ] ; then com='#' ; else com="$3"; fi

grep -v "^[ 	]*$com" "$1" | grep "$2" >/dev/null 2>&1
if [ $? = 0 ] ; then
	sf_save "$1"
	sf_msg1 "Mise en commentaire de '$2' dans $1"
	if [ -z "$noexec" ] ; then
		ed $1 <<-EOF >/dev/null 2>&1
			?^[^$com]*$2?
			s?^?$com?
			w
			q
		EOF
	fi
fi
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# $1 = file
# $2 = string
# $3 = car de commentaire (def=#)

sf_uncomment()
{
local com

if [ -z "$3" ] ; then com='#' ; else com="$3"; fi

grep "$2" "$1" | grep "^[ 	]*$com" >/dev/null 2>&1
if [ $? = 0 ] ; then
	sf_save "$1"
	sf_msg1 "Suppression de la mise en commentaire de $2 dans $1"
	if [ -z "$noexec" ] ; then
		ed $1 <<-EOF >/dev/null 2>&1
			?^[ 	]*$com.*$2?
			s?^[ 	]*$com??g
			w
			q
		EOF
	fi
fi
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# Teste si un fichier contient une ligne donnee (avec pattern)
# $1 = file
# $2 = pattern
# $3 = contenu de la ligne

sf_check_line()
{
local file pattern line fline qpattern

file=$1
pattern=$2
line=$3

if [ ! -f $file ] ; then
	if [ -z "$noexec" ] ; then touch $file
	else
		sf_msg1 "Info: Le fichier $f n'existe pas"
		return
	fi
fi

fline=`grep "$pattern" $file | head -1`
[ "$fline" = "$line" ] && return
sf_save $file
sf_msg1 "Mise a jour du fichier $file"
if [ -n "$fline" ] ; then
	qpattern=`echo "$pattern" | sed 's!/!\\\\/!g'`
	[ -z "$noexec" ] && ed $file <<-EOF >/dev/null 2>&1
		/$qpattern/
		.c
		$line
		.
		w
		q
	EOF
else
	[ -z "$noexec" ] && echo "$line" >>$file
fi
}

#=============================================================================
# User/group management
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# TODO: Unifier avec AIX avec detection automatique du fichier passwd utilise
# (passwd/shadow).
# Pour HP, Sun, et Linux: change un mot de passe dans un fichier
# passwd ou shadow.
# $1 = file
# $2 = user
# $3 = password crypte

sf_set_passwd()
{
local qpass

qpass=`echo "$3" | sed 's!/!\\\\/!g'`

ed $1 <<EOF >/dev/null 2>&1
	/^$2:/
	s/^$2:[^:]*:/$2:$qpass:/
	w
	q
EOF
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# Specifique AIX: les mots de passe sont stockes differemment

sf_set_passwd_aix()
{
# $1 = user
# $2 = password crypte
local qpass

pwdadm -f NOCHECK $1	# pour le creer s'il n'existe pas

qpass=`echo "$2" | sed 's!/!\\\\/!g'`

ed /etc/security/passwd <<-EOF >/dev/null 2>&1
	/^$1:/
	/password =/
	s/=.*$/= $qpass/
	/flags =/
	s/=.*$/=/
	w
	q
	EOF
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_create_group()
{
# $1 = name
# $2 = gid

case $_os in
	AIX)
		lsgroup $1 >/dev/null 2>&1
		if [ $? != 0 ] ; then
			sf_msg1 "Creation du groupe $1"
			[ -z "$noexec" ] && mkgroup id=$2 $1
		fi
		;;

	*)
		grep "^$1:" /etc/group >/dev/null 2>&1
		if [ $? != 0 ] ; then
			sf_msg1 "Creation du groupe $1"
			[ -z "$noexec" ] && groupadd -g $2 $1
		fi
		;;
esac
return 0
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
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

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# Cree un user
# $1 = name
# $2 = uid
# $3 = gid
# $4 = description (gecos)
# $5 = home (peut etre egal a '' pour '/none')
# $6 = groupes suppl (separes par des ',')
# $7 = encrypted password (Linux)
# $8 = encrypted password (HP-UX & SunOS)
# $9 = encrypted password (AIX)
# Pour les comptes bloques, $7, $8, $9 ne sont pas fournis
# Changement de shell (initialiser variable CREATE_USER_SHELL)

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
if [ $_os = SunOS ] ; then
	echo $home | grep '^/home/' >/dev/null 2>&1 && home="/export$home"
fi

groups=$6

locked='y'
[ $# = 9 ] && locked=''

sf_msg1 "Creation du compte $1"
[ -n "$noexec" ] && return
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
# OS management
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
#-- Fabrique et affiche la chaine 'OS_ID' identifiant l'environnment courant.
#--
#-- Si l'environnement n'est pas supporte, sort avec un message d'erreur

sf_compute_os_id()
{
local id os frel rel sub

#-- Reconnait l'environnement

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
# Filesystem management
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_has_dedicated_fs()
{
# $1=directory

[ -d "$1" ] || return 1

[ "`sf_get_fs_mnt $1`" = "$1" ]
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_get_fs_mnt()
{
# $1=directory

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

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays : FS size in Mbytes
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

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_set_fs_space()
{
# $1=directory
# $2= taille en Mo (prefixe par + si taille a ajouter)
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

#-----------------------------------------------------------------------------
# Refuses existing directory as mount point (security)
#
# Args :
#	$1: Mount point
#	$2: device path
#	$3: FS type
#	$4: Optional. Mount point directory owner[:group]
# Returns : 0 if no error, 1 on error
# Displays : info msg
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

#-----------------------------------------------------------------------------
# Checks if a given logical volume exists
#
# Args :
#	$1: VG name
#	$2: LV name
# Returns : 0 if it exists, 1 if not
# Displays : Nothing
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

#-----------------------------------------------------------------------------
# Checks if a given volume group exists
#
# Args :
#	$1: VG name
# Returns : 0 if it exists, 1 if not
# Displays : Nothing
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

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
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

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
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
# Package management
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# Return a sorted list of installed packages
# Linux output: yum format (name-version-release.arch)

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
# Service management
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# $*: service names
# Enable service for state 2, 3, 4, and 5 (default for chkconfig)
sf_enable_service()
{
for service in $*
	do
	case "$_os" in
		Linux)
			[ -f /etc/init.d/$service ] || continue
			chkconfig --list $service 2>/dev/null | grep ':on' >/dev/null && continue
			msg1 "Enabling service $service"
			[ -z "$noexec" ] && /sbin/chkconfig $service on
			;;
		*)
			sf_unsupported enable_service
			;;
	esac
done
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# $*: service names

sf_disable_service()
{
for service in $*
	do
	case "$_os" in
		Linux)
			[ -f /etc/init.d/$service ] || continue
			chkconfig --list $service 2>/dev/null | grep ':on' >/dev/null || continue
			sf_msg1 "Disabling service $service"
			[ -z "$noexec" ] && /sbin/chkconfig --level 0123456 $service off
			;;
		*)
			sf_unsupported disable_service
			;;
	esac
done
}

#=============================================================================
# Network
#=============================================================================

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------
# Filtre: supprime le hostname

sf_domain_part()
{
sed 's/^[^\.]*\.//'
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_host_part()
{
# Filtre: supprime le domaine

sed 's/^\([^\.]*\)\..*$/\1/'
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_dns_addr_to_name()
{
# $1 = adresse
# $2 = DNS server (optional)
# Si non resolu, renvoie une chaine vide

( [ -n "$2" && echo "server $2"; echo "$1" ) \
	| nslookup 2>/dev/null | grep '^Name:' | head -1 \
	| sed -e 's/^Name:[ 	]*//g'
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
#-----------------------------------------------------------------------------

sf_dns_name_to_addr()
{
# $1 = nom
# $2 = DNS server (optional)
# Si non resolu, renvoie une chaine vide

( [ -n "$2" && echo "server $2"; echo "$1" ) \
	| nslookup 2>/dev/null \
	| grep '^Address:' | tail --lines=+2 | head -1 \
	| sed -e 's/^Address:[ 	]*//g'
}

#-----------------------------------------------------------------------------
#
#
# Args :
# Returns :
# Displays :
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

#-- Clear potentially conflicting aliases

for i in cp mv rm
	do
	unalias $i >/dev/null 2>&1 || :
done

#-- Variables

_os=`uname -s`
export _os

[ -z "$tmpfile" ] && tmpfile=/tmp/.conf$$.tmp
export tmpfile

#-- Path

for i in /usr/sbin /bin /usr/bin /etc /usr/ccs/bin
	do
	[ -d "$i" ] && PATH="$i:$PATH"
done
export PATH

sf_cleanup

#=============================================================================
