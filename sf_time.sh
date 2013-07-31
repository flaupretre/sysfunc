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
# Section: Time/Data manipulation
#=============================================================================

##----------------------------------------------------------------------------
# Display normalized time string for current time (UTC)
#
# Format: DD-Mmm-YYYY HH:MM:SS (<Unix time>)
#
# Args: None
# Returns: 0
# Displays: Time string
#-----------------------------------------------------------------------------

sf_tm_now()
{
date -u '+%d-%b-%Y %H:%M:%S (%s)'
}

#=============================================================================
