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

function sf_domain_part
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

function sf_host_part
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

function sf_dns_addr_to_name
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

function sf_dns_name_to_addr
{
( [ -n "$2" && echo "server $2"; echo "$1" ) \
	| nslookup 2>/dev/null \
	| grep '^Address:' | tail -n +2 | head -1 \
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

function sf_primary_ip_address
{
typeset ifname

case "`sf_os_family`" in
	linux)
		ifname=`ls -1 /sys/class/net | grep -v '^lo$' | head -1`
		[ -z "$ifname" ] && return
		if [ /usr/sbin/ip ] ; then
			ip -4 addr show dev $ifname | grep inet | sed 's,^.*inet \([^/]*\)/.*$,\1,'
		else
			ifconfig $ifname | grep 'inet addr:' | sed 's/^.*inet addr:\([^ ]*\) .*$/\1/'
		fi
		;;
	*)
		sf_unsupported primary_ip_address
		;;
esac
}

##------------------------------------------------
# Check connectivity with a host
#
# Args:
#	$1: Hostname
#	$2: Optional. String to use in error message - host function
# Returns: 0 if OK, 1 if KO
# Displays: Nothing
#------------------------------------------------

function sf_net_host_is_reachable
{
typeset host desc

host="$1"
if [ -z "$host" ] ; then
	sf_warning "ms_host_is_reachable: host parameter not set"
	return 1
fi

desc="$2"
[ -z "$desc" ] && desc="$host"

sf_trace "Checking connectivity with $desc ($host)"

#---

ping -c 1 "$host" >/dev/null 2>&1
if [ $? != 0 ] ; then
	sf_warning "Cannot ping $desc ($host)"
	return 1
fi
sf_trace "$desc is reachable"
	
#---

return 0
}

#=============================================================================
