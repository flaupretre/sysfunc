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
# Section: Software packages
#=============================================================================

##----------------------------------------------------------------------------
# Check if software exists (installed or available for installation)
#
# Args:
#	$1: Software name
# Returns: 0 if software exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_exists
{
[ -z "$sf_yum" ] && sf_unsupported sf_soft_exists

$sf_yum list $1 >/dev/null 2>&1 || return 1
return 0
}

##----------------------------------------------------------------------------
# List installed software
#
# Returns a sorted list of installed software
#
# Linux output: (name-version-release.arch)
#
# Args: none
# Returns: Always 0
# Displays: software list
#-----------------------------------------------------------------------------

function sf_soft_list
{
(
if [ -n "$sf_rpm" ] ; then
	$sf_rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n'
fi
) | sort
}

##----------------------------------------------------------------------------
# Check if a software is installed
#
# Args:
#	$1: Software name
# Returns: 0 if software is installed, 1 if not.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_installed
{
[ -z "$sf_rpm" ] && sf_unsupported sf_soft_is_installed

$sf_rpm -q "$1" >/dev/null 2>&1 || return 1
return 0
}

##----------------------------------------------------------------------------
# Check if a newer version of a software is available
#
# Note : if the software is not installed, it is not considered as upgradeable
#
# Args:
#	$1: Software name
# Returns: 0 if the software is upgradeable, !=0 if not.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_upgradeable
{
sf_soft_available_version "$1" >/dev/null 2>&1
}

##----------------------------------------------------------------------------
# Check if a software is installed and the latest version
#
# Args:
#	$1: Software name
# Returns: 0 if software is up-to-date, 1 if not installed, 2 if upgradeable.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_up_to_date
{
sf_soft_is_installed $1 || return 1
sf_soft_is_upgradeable $1 && return 2
return 0
}

##----------------------------------------------------------------------------
# Get the available version of an upgradeable package
#
# Args:
#	$1: Software name
# Returns: 0 if an update is available, 1 if not installed, 2 if up-to-date
# Displays: Available version if one exists, nothing if not
#-----------------------------------------------------------------------------

function sf_soft_available_version
{
typeset buf

[ -z "$sf_yum" ] && sf_unsupported sf_soft_available_version

sf_soft_is_installed $1 || return 1
buf="`$sf_yum list available $1 2>/dev/null`"

# We need to check for an 'Available Packages' string because output can contain
# messages issued when reloading metadata.

echo "$buf" | grep '^Available Packages$' >/dev/null || return 2
echo "$buf" | tail -1 | awk '{ print $2 }'
}

##----------------------------------------------------------------------------
# Install software(s) if not already present on the host
#
# If a software is installed but not up to date, it is not upgraded.
#
# Args:
#	$*: Software name(s)
# Returns: Return code from yum command
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_install
{
typeset _pkg _to_install ret

[ -z "$sf_yum" ] && sf_unsupported sf_soft_install

_to_install=''

for _pkg
	do
	if ! sf_soft_is_installed "$_pkg" ; then
		_to_install="$_to_install $_pkg"
	fi
done

if [ -n "$_to_install" ] ; then
	sf_msg1 "Installing $_to_install ..."
	if [ -z "$sf_noexec" ] ; then
		$sf_yum install $_to_install
		ret=$?
	fi
fi

return $ret
}

##----------------------------------------------------------------------------
# Install or upgrade software(s)
#
# For each of the software names supplied as arguments :
#
#	- if the software is not installed, install it,
#	- if the software is installed and upgradeable, upgrade it,
#	- if the software is up-to-date, do nothing.
#
# Args:
#	$*: Software name(s)
# Returns: 0 if OK. !=0 if not
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_install_upgrade
{
typeset _pkg _to_install _to_update ret

[ -z "$sf_yum" ] && sf_unsupported sf_soft_install_upgrade

_to_install=''
_to_update=''

for _pkg
	do
	if ! sf_soft_is_installed "$_pkg" ; then
		_to_install="$_to_install $_pkg"
	else
		if sf_soft_is_upgradeable "$_pkg" ; then
			_to_update="$_to_update $_pkg"
		fi
	fi
done

if [ -n "$_to_update" ] ; then
	sf_msg1 "Upgrading $_to_update ..."
	if [ -z "$sf_noexec" ] ; then
		$sf_yum upgrade $_to_update
		ret=$?
	fi
fi

if [ -n "$_to_install" ] ; then
	sf_msg1 "Installing $_to_install ..."
	if [ -z "$sf_noexec" ] ; then
		$sf_yum install $_to_install
		ret=`expr $ret + $?`
	fi
fi

return $ret
}

##----------------------------------------------------------------------------
# Uninstall software(s) (including dependencies)
#
# Nothing is done for softwares which are not present on the host.
#
# Args:
#	$*: Software name(s)
# Returns: Return code from yum command
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_uninstall
{
typeset _pkg ret

[ -z "$sf_yum" ] && sf_unsupported sf_soft_uninstall

for _pkg ; do
	if sf_soft_is_installed "$_pkg" ; then
		sf_msg1 "Uninstalling $_pkg ..."
		if [ -z "$sf_noexec" ] ; then
			$sf_yum remove "$_pkg"
			ret=$?
		fi
	fi
done

return $ret
}

##----------------------------------------------------------------------------
# Uninstall software(s) (ignoring and bypassing dependencies)
#
# Nothing is done for softwares which are not present on the host.
#
# Args:
#	$*: Software name(s)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_remove
{
typeset _pkg

[ -z "$sf_rpm" ] && sf_unsupported sf_soft_remove

for _pkg ; do
	if sf_soft_is_installed "$_pkg" ; then
		sf_msg1 "Uninstalling $_pkg ..."
		[ -z "$sf_noexec" ] && $sf_rpm -e --nodeps "$_pkg"
	fi
done

return 0
}

##----------------------------------------------------------------------------
# Reinstall software(s), even at same version
#
# Args:
#	$*: Software name(s)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_reinstall
{
typeset _pkg

for _pkg ; do
	sf_soft_remove "$_pkg"
	sf_soft_install_upgrade "$_pkg"
done

return 0
}

##----------------------------------------------------------------------------
# get version of an installed software
#
# Args:
#	$1: Software name
# Returns: 0 if software is installed, 1 otherwise.
# Displays: Software version (nothing if soft is not installed)
#-----------------------------------------------------------------------------

function sf_soft_version
{
typeset _pkg
_pkg=$1

[ -z "$sf_rpm" ] && sf_unsupported sf_soft_version

sf_soft_is_installed "$_pkg" || return 1

$sf_rpm -q --qf '%{VERSION}-%{RELEASE}\n' $_pkg 2>/dev/null

return 0
}

##----------------------------------------------------------------------------
# Clean the software installation cache
#
# Args: None
# Returns: Always 0
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_clean_cache
{
[ -d /var/cache/yum ] && \rm -rf /var/cache/yum/*
}

##----------------------------------------------------------------------------
# List defined software repository names
#
# Args: None
# Returns: Always 0
# Displays: List of software repositories, one per line
#-----------------------------------------------------------------------------
# Note: we prefer parsing the yum config instead of using the 'repolist' cmd
# because: 1. 'repolist' does not exist in yum v2 (RHEL 4), and 2. repolist
# refreshes the cache, which fails if the repo is not reachable. The '-C' option
# can disable the cache refresh but will cause the cmd to fail if the cache is
# empty.
# So, in short, this is the only way I found to list enabled repositories when
# the cache is empty (after a clean).
#-----------------------------------------------------------------------------

function sf_soft_repo_list
{
[ -z "$sf_yum" ] && sf_unsupported sf_soft_repo_list

cat /etc/yum.conf /etc/yum.repos.d/* 2>/dev/null \
	| sf_txt_cleanup \
	| awk '
		BEGIN	{ repo=""; }
		/^enabled=1/	{ print repo; }
		/^\[/			{ repo=substr($1,2,length($1)-2); }'
}

#=============================================================================
