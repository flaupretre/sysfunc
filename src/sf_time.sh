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
# Section: Time and date
#=============================================================================

##----------------------------------------------------------------------------
# Display normalized time string for current time (local or UTC)
#
# Local time is the default. If the SF_TM_UTC environment variable is set to a
# non empty value, UTC time is displayed.
#
# Default format: DD-Mmm-YYYY HH:MM:SS (<Unix time>)
#
# Args:
#	$1: Optional. Date format (without the leading '+'). See date(1) man page
#		for more details on macros supported in format string.
# Returns: date command return code (!=0 if syntax error in format)
# Displays: Time string
#-----------------------------------------------------------------------------

function sf_tm_now
{
typeset opt format

opt=''
[ "X${SF_TM_UTC:-}" = X ] || opt='-u'

format='%d-%b-%Y %H:%M:%S (%s)'
[ "X$1" = X ] || format="$1"

date $opt "+$format"
}

##----------------------------------------------------------------------------
# Display Unix current time (Seconds since Epoch)
#
# Args: None
# Returns: 0
# Displays: Time string
#-----------------------------------------------------------------------------

function sf_tm_timestamp
{
sf_tm_now '%s'
}

##----------------------------------------------------------------------------
# Display current date as 'DD-Mmm-YYYY'
#
# Local time is the default. If the SF_TM_UTC environment variable is set to a
# non empty value, UTC time is displayed. This will change date if time is near
# midnight and local/utc times correspond to different dates.
#
# Args: None
# Returns: 0
# Displays: Time string
#-----------------------------------------------------------------------------

function sf_tm_date
{
sf_tm_now '%d-%b-%Y'
}

#=============================================================================
