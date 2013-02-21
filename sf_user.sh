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
typeset file user pass qpass

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
typeset user pass qpass

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

case `uname -s` in
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
# Remove a group
#
# Args:
#	$1: Group name
# Returns: Status from system command
# Displays: nothing
#-----------------------------------------------------------------------------

sf_delete_group()
{

typeset status

case `uname -s` in
	Linux|SunOS)
		groupdel "$1"
		status=$?
		;;

	*)
		sf_unsupported sf_delete_group
		;;
esac
return $status
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
typeset status

case `uname -s` in
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
# Remove a user account
#
# Args:
#	$1: User name
# Returns: Status from system command
# Displays: nothing
#-----------------------------------------------------------------------------

sf_delete_user()
{

typeset status

case `uname -s` in
	Linux|SunOS)
		userdel "$1"
		status=$?
		;;

	*)
		sf_unsupported sf_delete_user
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

case `uname -s` in
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
		[ `uname -s` = HP-UX ] && passwd_file=/etc/passwd
		[ -z "$locked" ] && sf_set_passwd $name "$8" $passwd_file
		;;
esac
return 0
}

#=============================================================================
