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
typeset id os frel rel sub

#-- Recognizes the current environment

id=''
case "`uname -s`" in
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

##----------------------------------------------------------------------------
# Shutdown and restart the host
#
# Args: None
# Returns: does not return
# Displays: nothing
#-----------------------------------------------------------------------------

sf_reboot()
{
case "`uname -s`" in
	Linux)
		shutdown -r now
		;;
	SunOS)
		init 6
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

sf_shutdown()
{
case "`uname -s`" in
	Linux)
		shutdown -h now
		;;
	SunOS)
		shutdown -y -i0 -g0
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

sf_poweroff()
{
case "`uname -s`" in
	Linux)
		shutdown -h now
		;;
	SunOS)
		shutdown -y -i5 -g0
		;;
	*)
		sf_unsupported poweroff
esac

while true; do sleep 10; done	# Endless loop
}

#=============================================================================
