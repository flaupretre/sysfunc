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
# Section: Users and groups
#=============================================================================

##----------------------------------------------------------------------------
# Change a user's password
#
# Works on HP-UX, Solaris, and Linux.
#
# Replaces an encrypted passwd in /etc/passwd or /etc/shadow.
#
# TODO: Unify with AIX and autodetect the file to use (passwd/shadow)
#
# Args:
#	$1: Username
#	$2: Encrypted password
#	$3: File path
# Returns: Always 0
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_set_passwd
{
typeset file user pass qpass

user="$1"
pass="$2"
file="$3"

qpass=`echo "$pass" | sed 's!/!\\\\/!g'`

if [ -z "$sf_noexec" ] ; then
	ed $file <<EOF >/dev/null 2>&1
		/^$user:/
		s/^$user:[^:]*:/$user:$qpass:/
		w
		q
EOF
fi
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

function sf_set_passwd_aix
{
typeset user pass qpass

user="$1"
pass="$2"
qpass=`echo "$pass" | sed 's!/!\\\\/!g'`

if [ -z "$sf_noexec" ]; then
	pwdadm -f NOCHECK $user	# to create the account if needed

	ed /etc/security/passwd <<-EOF >/dev/null 2>&1
		/^$user:/
		/password =/
		s/=.*$/= $qpass/
		/flags =/
		s/=.*$/=/
		w
		q
EOF
fi
}

##----------------------------------------------------------------------------
# Create a user group
#
# If the group does already exist, nothing is done, even if existing members
# differ from the supplied list.
#
# Args:
#	$1: Group name
#	$2: Group Id
#	$3: Optional. Group members, separated by commas
# Returns: Status from system command
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_group
{
typeset rc i
rc=0

case `sf_os_family` in
	aix)
		if ! lsgroup $1 >/dev/null 2>&1 ; then
			sf_msg1 "Creating $1 group"
			if [ -z "$sf_noexec" ] ; then
				opt=""
				[ -n "$3" ] && opt="users=$3"
				mkgroup id=$2 $1 $opt
				rc=$?
			fi
		fi
		;;

	*)
		if ! grep "^$1:" /etc/group >/dev/null 2>&1 ; then
			sf_msg1 "Creating $1 group"
			if [ -z "$sf_noexec" ] ; then
				groupadd -g $2 $1
				rc=$?
			fi
			if [ -n "$3" ] ; then
				for i in `echo $3 | sed 's/,/ /g'` ; do
					sf_msg1 "Adding user $i to group $1"
					if [ -z "$sf_noexec" ] ; then
						usermod -a -G $1 $i
						rc=`expr $rc + $?`
					fi
				done
			fi
		fi
		;;
esac
return $rc
}

##----------------------------------------------------------------------------
# Remove a group
#
# Args:
#	$1: Group name
# Returns: Status from system command
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_delete_group
{
typeset rc
rc=0

case `sf_os_family` in
	linux|sunos)
		if grep "^$1:" /etc/group >/dev/null 2>&1 ; then
			sf_msg1 "Deleting $1 group"
			if [ -z "$sf_noexec" ] ; then
				groupdel "$1"
				rc=$?
			fi
		fi
		;;

	*)
		sf_unsupported sf_delete_group
		;;
esac
return $rc
}

##----------------------------------------------------------------------------
# Return an unused group ID
#
# Args: None
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_unused_group_id
{
typeset i

i=1001
while true ; do
	grep ":$i:" /etc/group >/dev/null || break
	i=`expr $i + 1`
done

echo $i
}

##----------------------------------------------------------------------------
# Return an unused user ID
#
# Args: None
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_unused_user_id
{
typeset i

i=1001
while true ; do
	grep ":$i:" /etc/passwd >/dev/null || break
	i=`expr $i + 1`
done

echo $i
}

##----------------------------------------------------------------------------
# Checks if a given user exists on the system
#
# Args:
#	$1: User name to check
# Returns: 0 if user exists; != 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_user_exists
{
typeset status

case `sf_os_family` in
	aix)
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
# Remove a user account
#
# Args:
#	$1: User name
# Returns: Status from system command
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_delete_user
{
typeset rc
rc=0

if sf_user_exists "$1" ; then
	case `sf_os_family` in
		linux|sunos)
			sf_msg1 "Deleting $1 user"
			if [ -z "$sf_noexec" ] ; then
				userdel "$1"
				rc=$?
			fi
			;;

		*)
			sf_unsupported sf_delete_user
			;;
	esac
fi

return $rc
}

##----------------------------------------------------------------------------
# Return UID of a given user
#
# Args:
#	$1: User name
# Returns: 0 if user exists, 1 if not
# Displays: UID if user exists, nothing if not
#-----------------------------------------------------------------------------

function sf_user_uid
{
typeset res
res=''

case `sf_os_family` in
	linux)
		res=`awk -F: -vUSER=${user} '$1==USER {print $3}' /etc/passwd`
		;;
	*)
		sf_unsupported sf_user_uid
		;;
esac
[ -z "$res" ] && return 1
echo $res
return 0
}

##----------------------------------------------------------------------------
# Return GID of a given user
#
# Args:
#	$1: User name
# Returns: 0 if user exists, 1 if not
# Displays: Primary GID if user exists, nothing if not
#-----------------------------------------------------------------------------

function sf_user_gid
{
typeset res
res=''

case `sf_os_family` in
	linux)
		res=`awk -F: -vUSER=${user} '$1==USER {print $4}' /etc/passwd`
		;;
	*)
		sf_unsupported sf_user_gid
		;;
esac
[ -z "$res" ] && return 1
echo $res
return 0
}

##----------------------------------------------------------------------------
# Create a user
#
# To set the login shell, initialize the CREATE_USER_SHELL variable before
# calling the function.
#
# For accounts with no access allowed (blocked accounts), $7, $8, and $9 are
# not set.
#
# Args:
#	$1: User name
#	$2: uid
#	$3: gid
#	$4: description (gecos)
#	$5: home dir (can be '' for '/none')
#	$6: Additional groups (separated with ',')
#	$7: encrypted password (Linux)
#	$8: encrypted password (HP-UX & SunOS)
#	$9: encrypted password (AIX)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_user
{
typeset name uid gid gecos home groups locked add_cmd shell passwd_file

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

sf_msg1 "Creating $1 user"
[ -n "$sf_noexec" ] && return
sf_create_dir `dirname $home`

add_cmd=''

case `sf_os_family` in
	aix)
		[ -n "$groups" ] && add_cmd="$add_cmd groups=$groups"

		[ -n "$locked" ] && add_cmd="$add_cmd login=false"

		mkuser gecos="$gecos" pgrp=$gid id=$uid home=$home $add_cmd $name

		[ -z "$locked" ] && sf_set_passwd_aix $name "$9"
		;;

	linux)
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

		[ -z "$locked" ] && sf_set_passwd $name "$7" /etc/shadow
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
		[ `sf_os_family` = hp-ux ] && passwd_file=/etc/passwd
		[ -z "$locked" ] && sf_set_passwd $name "$8" $passwd_file
		;;
esac
return 0
}

#=============================================================================
