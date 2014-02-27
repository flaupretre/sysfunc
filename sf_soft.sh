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
# Section: Software management
#=============================================================================

##----------------------------------------------------------------------------
# Check if software exist (installed or available for installation)
#
# Args:
#	$*: A list of software names to check
# Returns: The number of software from the input list which DON'T exist
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_exists
{
typeset soft rc
rc=0

for soft in $*
	do
	$sf_yum list $1 >/dev/null 2>&1 || rc=`expr $rc + 1`
done

return $rc
}

##----------------------------------------------------------------------------
# List installed software
#
# Returns a sorted list of installed software
#- Linux output: (name-version-release.arch)
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
# Check if software is installed
#
# Args:
#	$*: software name(s)
# Returns: 0 if every argument software are installed. 1 if at least one of them
# is not.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_installed
{
typeset _pkg

[ -z "$sf_rpm" ] && sf_unsupported sf_soft_is_installed

for _pkg ; do
	$sf_rpm -q "$_pkg" >/dev/null 2>&1 || return 1
done
return 0
}

##----------------------------------------------------------------------------
# Check if a newer version of a software is available
#
#  Note : if the software is not installed, it is not considered as updateable
#- Note : yum returns 0 if no software are available for update
#
# Args:
#	$*: software name(s)
# Returns: 0 if at least one of the given software(s) can be updated.
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_upgradeable
{
[ -z "$sf_yum" ] && sf_unsupported sf_soft_is_upgradeable

$sf_yum check-update $* >/dev/null 2>&1 || return 0
return 1
}

##----------------------------------------------------------------------------
# Check if a software is installed and the latest version
#
# Args:
#	$*: software name(s)
# Returns: 0 if every argument software are installed and up to date (for yum)
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_soft_is_up_to_date
{
sf_soft_is_installed $* || return 1
sf_soft_is_upgradeable $* && return 1
return 0
}

##----------------------------------------------------------------------------
# Get the version of the available package, if any
#
# Args:
#	$*: software name
# Returns: 0 if an update is available, 1 if no update available, 2 if not installed
# Displays: Available version if one exists, nothing if not
#-----------------------------------------------------------------------------

function sf_soft_available_version
{
typeset pkg avail tmp
pkg=$1

[ -z "$sf_yum" ] && sf_unsupported sf_soft_available_version

tmp=`yum check-update $pkg 2>/dev/null`
[ $? = 0 ] && return 1
echo "$tmp" | tail -1 | awk '{ print $2 }'
}

##----------------------------------------------------------------------------
# Install a software if not already present
#
# Install or updates a software depending on its presence on the host
#- If the software is installed but not up to date, no action.
#
# Args:
#	$*: software name(s)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_install
{
typeset _pkg _to_install

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
	[ -z "$sf_noexec" ] && $sf_yum install $_to_install
fi

return 0
}

##----------------------------------------------------------------------------
# Install or upgrade a software
#
# Install or updates a software depending on its presence on the host
#- If the software is up to date, no action.
#
# Args:
#	$*: software name(s)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_install_upgrade
{
typeset _pkg _to_install _to_update

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
	[ -z "$sf_noexec" ] && $sf_yum upgrade $_to_update
fi

if [ -n "$_to_install" ] ; then
	sf_msg1 "Installing $_to_install ..."
	[ -z "$sf_noexec" ] && $sf_yum install $_to_install
fi

return 0
}

##----------------------------------------------------------------------------
# Uninstall a software (including dependencies)
#
# Return without error if the software is not installed
#
# Args:
#	$*: software name(s)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_soft_uninstall
{
typeset _pkg

[ -z "$sf_yum" ] && sf_unsupported sf_soft_uninstall

for _pkg ; do
	if sf_soft_is_installed "$_pkg" ; then
		sf_msg1 "Uninstalling $_pkg ..."
		[ -z "$sf_noexec" ] && $sf_yum remove "$_pkg"
	fi
done

return 0
}

##----------------------------------------------------------------------------
# Uninstall a software (ignoring dependencies)
#
# Return without error if the software is not installed
#
# Args:
#	$*: software name(s)
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
# Reinstall a software, even at same version
#
# Args:
#	$*: software name(s)
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
#	$*: software name
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

#=============================================================================
