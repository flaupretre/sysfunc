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
#- If the current system is not recognized, the program aborts.
#- By convention, environments recognized by this function support
# the rest of the library.
#
#- Contributors welcome ! Feel free to enhance this function with additional
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

if [ "$distrib" = RHEL ] ; then		# Special case for RHEL
	[ `uname -i` = x86_64 ] && res="${res}_64"
	if [ "$version" -lt 5 ] ; then
		sub=`sed 's/^.* Linux \(.S\).*$/\1/' </etc/redhat-release`
		res="${res}_$sub"
	fi
fi

echo $res
}

##----------------------------------------------------------------------------
# Alias of sf_os_id() (obsolete - for compatibility only)
#
# Other info: see sf_os_id()
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
	HP-UX)
		res=HPUX ;;
	Linux)
		[ -f /etc/redhat-release ] && res=RHEL ;;
	SunOS)
		res=SOLARIS ;;
	AIX)
		res=AIX ;;
esac

[ -z "$res" ] && sf_unsupported sf_os_distrib

echo $res
}

##----------------------------------------------------------------------------
# Display the current OS family (Linux, SunOS,...)
#
# Args: None
# Returns: 0
# Displays: OS distrib
#-----------------------------------------------------------------------------

function sf_os_family
{
uname -s
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
	HP-UX)
		res="`uname -r | sed 's/^B\.//'`"
		;;
	Linux)
		frel=/etc/redhat-release
		[ -f $frel ] && res=`sed 's/^.* release \(.\).*$/\1/' <$frel`
		;;
	SunOS)
		res=`uname -r | sed 's/^5\.//'`
		;;
	AIX)
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
# Shutdown and restart the host
#
# Args: None
# Returns: does not return
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_reboot
{
case "`uname -s`" in
	Linux)
		[ -z "$sf_noexec" ] && shutdown -r now
		;;
	SunOS)
		[ -z "$sf_noexec" ] && init 6
		;;
	*)
		sf_unsupported reboot
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
case "`uname -s`" in
	Linux)
		[ -z "$sf_noexec" ] && shutdown -h now
		;;
	SunOS)
		[ -z "$sf_noexec" ] && shutdown -y -i0 -g0
		;;
	*)
		sf_unsupported shutdown
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
case "`uname -s`" in
	Linux)
		[ -z "$sf_noexec" ] && shutdown -h now
		;;
	SunOS)
		[ -z "$sf_noexec" ] && shutdown -y -i5 -g0
		;;
	*)
		sf_unsupported poweroff
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
