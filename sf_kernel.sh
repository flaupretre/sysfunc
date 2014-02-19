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
# Section: Kernel
#=============================================================================

##----------------------------------------------------------------------------
# Check if a kernel module is loaded
#
# Args:
#	$1: Module name
# Returns: 0 if module is loaded, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_krn_module_is_loaded
{
case "`uname -s`" in
	Linux)
		lsmod | awk "(\$1==\"$1\") { exit 1; }" && return 1
		;;
	*)
		sf_unsupported sf_krn_module_is_loaded
		;;
esac

return 0
}

#=============================================================================
