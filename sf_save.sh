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
# Section: File backup
#=============================================================================

##----------------------------------------------------------------------------
# Saves a file
#
# No action if the 'sf_nosave' environment variable is set to a non-empty string.
#
#-If the input arg is the path of an existing regular file, the file is copied
# to '$path.orig'
#
#- TODO: improve save features (multiple numbered saved versions,...)
#
# Args:
#	$1 : Path
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_save
{
[ "X$sf_nosave" = X ] || return
if [ -f "$1" -a ! -f "$1.orig" ] ; then
	sf_msg1 "Saving $1 to $1.orig"
	[ -z "$sf_noexec" ] && cp -p "$1" "$1.orig"
fi
}

#=============================================================================
