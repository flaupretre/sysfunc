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
# Section: IP address manipulation (V 4 only)
#=============================================================================

##----------------------------------------------------------------------------
# Checks if the input string is a valid IP address
#
# Args:
#		$1: IP address to check
# Returns: 0 if address is valid, !=0 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_ip4_is_valid_ip
{
typeset ip a bip

ip="$1"
bip="`echo $ip | sed 's,\., ,g'`"
if [ -n "$BASH" ] ; then
	a=($bip)
else
	set -A a $bip
fi
[ ${#a[*]} = 4 ] || return 1
[ -n "`echo $ip | sed 's,[\.0-9],,g'`" ] && return 1
[ "${a[0]}" -eq 0 ] && return 1
return 0
}

##----------------------------------------------------------------------------
# Checks if the input string is a valid IP address and aborts if not
#
# Args:
#		$1: IP address to check
# Returns: only if address is valid
# Displays: Nothing if OK. Error if not
#-----------------------------------------------------------------------------

function sf_ip4_validate_ip
{
sf_ip4_is_valid_ip "$1" || sf_fatal "$1: Invalid IP address"
}

##----------------------------------------------------------------------------
# Compute network from IP and netmask
#
# Args:
#		$1: IP
#		$2: Netmask
# Returns: 0
# Displays: Network
#-----------------------------------------------------------------------------

function sf_ip4_network
{
typeset ip aip bip mask amask bmask

ip="$1"
sf_ip4_validate_ip "$ip"
mask="$2"
sf_ip4_validate_ip "$mask"

bip="`echo $ip | sed 's,\., ,g'`"
bmask="`echo $mask | sed 's,\., ,g'`"
if [ -n "$BASH" ] ; then
	aip=($bip)
	amask=($bmask)
else
	set -A aip $bip
	set -A amask $bmask
fi

for n in 0 1 2 3
	do
	net[$n]=$((${aip[$n]} & ${amask[$n]}))
done
echo ${net[*]} | sed 's, ,.,g'
}

#=============================================================================
