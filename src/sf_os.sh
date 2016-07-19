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
# Section: OS
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
#
# If the current system is not recognized, the program aborts.
#
# By convention, environments recognized by this function support
# the rest of the library.
#
# **Contributors welcome !** Feel free to enhance this function with additional
# recognized systems, especially with other Linux distros, and send me your
# patches.
#
# Args: None
# Returns: Always 0
# Displays: OS ID string
#-----------------------------------------------------------------------------

function sf_os_id
{
typeset sub version distrib res

#-- Recognizes the current environment

res=''
version=`sf_os_version`
distrib=`sf_os_distrib`

res="${distrib}_${version}"

if [ -f /etc/redhat-release ] ; then		# Special case for RHEL/CentOS
	[ `sf_os_arch` = x86_64 ] && res="${res}_64"
	if [ "$version" -lt 5 ] ; then # AS/ES
		sub=`sed 's/^.* Linux \(.S\).*$/\1/' </etc/redhat-release`
		res="${res}_$sub"
	fi
fi

echo $res
}

##----------------------------------------------------------------------------
# Alias of [function:os_id]
#
# ### This function is deprecated. Please use [function:os_id]
#
# Args: None
# Returns: Always 0
# Displays: OS ID string
#-----------------------------------------------------------------------------

function sf_compute_os_id
{
sf_os_id
}

##----------------------------------------------------------------------------
# Display the current OS distribution
#
# Args: None
# Returns: 0
# Displays: OS distrib
#-----------------------------------------------------------------------------

function sf_os_distrib
{
typeset res

res=''
case "`sf_os_family`" in
	hp-ux)
		res=hpux ;;
	linux)
		res=linux
		[ -f /etc/redhat-release ] && res=rhel
		[ -f /etc/centos-release ] && res=centos
		[ -f /etc/SuSE-release ] && res=suse
		;;
	sunos)
		res=solaris ;;
	aix)
		res=aix ;;
esac

[ -z "$res" ] && sf_unsupported sf_os_distrib

echo $res
}

##----------------------------------------------------------------------------
# Display the mixed case name of the current distrib
#
# Args: None
# Returns: 0
# Displays: OS distrib in mixed case
#-----------------------------------------------------------------------------

function sf_os_distrib_mixed
{
typeset distrib

distrib=`sf_os_distrib`
case "$distrib" in
	aix)    echo AIX;;
	hpux)   echo HPUX;;
	sunos)  echo SunOS;;
	rhel)   echo RHEL;;
	centos) echo CentOS;;
	suse)   echo SuSE;;
	*) echo $distrib
esac
}

##----------------------------------------------------------------------------
# Display the current OS family in lowercase (linux, sunos,...)
#
# Args: None
# Returns: 0
# Displays: OS family
#-----------------------------------------------------------------------------

function sf_os_family
{
uname -s | tr [:upper:] [:lower:]
}

##----------------------------------------------------------------------------
# Display the current OS version
#
# Args: None
# Returns: 0
# Displays: OS distrib
#-----------------------------------------------------------------------------

function sf_os_version
{
typeset frel res

res=''
case "`sf_os_family`" in
	hp-ux)
		res="`uname -r | sed 's/^B\.//'`"
		;;
	linux)
		frel=/etc/redhat-release
		[ -f $frel ] && res=`sed 's/^.* release \(.\).*$/\1/' <$frel`
		frel=/etc/SuSE-release
		[ -f $frel ] && res=`grep "^VERSION = " $frel | sed 's/^.* //g'`
		;;
	sunos)
		res=`uname -r | sed 's/^5\.//'`
		;;
	aix)
		res="`uname -v`.`uname -r`"
		;;
esac

[ -z "$res" ] && sf_unsupported sf_os_version

echo $res
}

##----------------------------------------------------------------------------
# Display the current OS architecture (aka 'hardware platform')
#
# Args: None
# Returns: 0
# Displays: OS distrib
#-----------------------------------------------------------------------------

function sf_os_arch
{
uname -i
}

##----------------------------------------------------------------------------
# Display the value to use for the 'dist' macro in rpm build
#
# This script is needed because, unlike RHEL 6, RHEL 4 & 5 don't provide
# this value in their rpm build system
# Centos also appends a '.centos' suffix we want to avoid
#
# Args: None
# Returns: 0
# Displays: OS distrib
#-----------------------------------------------------------------------------

function sf_os_dist_macro
{
if [ -f /etc/redhat-release ] ; then
        echo ".el`sf_os_version`"
fi
}

##----------------------------------------------------------------------------
# Shutdown and restart the host
#
# Args: None
# Returns: does not return
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_reboot
{
case "`sf_os_family`" in
	sunos)
		[ -z "$sf_noexec" ] && init 6
		;;
	*)
		[ -z "$sf_noexec" ] && shutdown -r now
esac

while true; do sleep 10; done	# Endless loop
}

##----------------------------------------------------------------------------
# Shutdown and halt the host
#
# Args: None
# Returns: does not return
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_shutdown
{
case `sf_os_family` in
	sunos)
		[ -z "$sf_noexec" ] && shutdown -y -i0 -g0
		;;
	*)
		[ -z "$sf_noexec" ] && shutdown -h now
esac

while true; do sleep 10; done	# Endless loop
}

##----------------------------------------------------------------------------
# Shutdown and poweroff the host
#
# Args: None
# Returns: does not return
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_poweroff
{
case `sf_os_family` in
	sunos)
		[ -z "$sf_noexec" ] && shutdown -y -i5 -g0
		;;
	*)
		[ -z "$sf_noexec" ] && shutdown -h now
esac

while true; do sleep 10; done	# Endless loop
}

##----------------------------------------------------------------------------
# Find a Posix-compatible shell on the current host
#
# Search a bash shell first, then ksh
#
# Args: None
# Returns: Always 0
# Displays: Shell path if found, nothing if not found
#-----------------------------------------------------------------------------

function sf_find_posix_shell
{
typeset s d

for s in bash ksh
	do
	for d in /bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin
		do
		if [ -x $d/$s ] ; then
			echo $d/$s
			return
		fi
	done
done
}

#=============================================================================
