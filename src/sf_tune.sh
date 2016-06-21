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
# Section: Performance tuning
#=============================================================================

##----------------------------------------------------------------------------
# Get active tuning profile
#
# Args: None
# Returns: 0 if an active profile is set, !=0 if not
# Displays: Name of active profile
##----------------------------------------------------------------------------

function sf_tune_active_profile
{
[ -x /usr/sbin/tuned-adm ] || return 1

/usr/sbin/tuned-adm active | sed 's/^.*: //g'
}

##----------------------------------------------------------------------------
# Activate a tuning profile
#
# Args:
#	$1: Profile name
# Returns: Return code from tuned-adm
# Displays: Nothing
##----------------------------------------------------------------------------

function sf_tune_set_profile
{
[ -x /usr/sbin/tuned-adm ] || return 1

/usr/sbin/tuned-adm profile $1
}

##----------------------------------------------------------------------------
# Activate a tuning profile
#
# Args: None
# Returns: 0 if tuned-adm is present, !=0 if not
# Displays: List of defined profiles, 1 per line
##----------------------------------------------------------------------------

function sf_tune_profile_list
{
[ -x /usr/sbin/tuned-adm ] || return 1

/usr/sbin/tuned-adm list | grep '^-' | sed 's/^- //'
}

#=============================================================================
