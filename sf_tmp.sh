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
# Section: Temporary file management
#=============================================================================

##----------------------------------------------------------------------------
# Deletes all temporary files
#
# This function is automatically called by sf_cleanup()
#
# Args: none
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

function _sf_tmp_cleanup
{
if [ -f "$_sf_tmpfile_list" ] ; then
	\rm -rf `cat $_sf_tmpfile_list` $_sf_tmpfile_list
fi
}

##----------------------------------------------------------------------------
# Returns an unused temporary path
#
# The returned path can then be used to create a directory or a file.
#
# ** This function is deprecated. Please use sf_tmpfile or sf_tmpdir instead.
#
# Args: none
# Returns: Always 0
# Displays: An unused temporary path
#-----------------------------------------------------------------------------

function sf_get_tmp
{
typeset n f

n=0
while true
	do
	f="$_sf_tmpfile_prefix.$n"
	[ -e $f ] || break
	n=`expr $n + 1`
done

echo $f
echo $f >>$_sf_tmpfile_list
}

##----------------------------------------------------------------------------
# Creates an empty temporary file and returns its path
#
# Args: none
# Returns: Always 0
# Displays: Temporary file path
#-----------------------------------------------------------------------------

function sf_tmpfile
{
typeset f

f=`sf_get_tmp`
touch $f
echo $f
}

##----------------------------------------------------------------------------
# Creates an empty temporary dir and returns its path
#
# Args: none
# Returns: Always 0
# Displays: Temporary dir path
#-----------------------------------------------------------------------------

function sf_tmpdir
{
typeset f

f=`sf_get_tmp`
mkdir $f
echo $f
}

#=============================================================================

[ -z "$_sf_tmpfile_prefix" ] && _sf_tmpfile_prefix=/tmp/sf.$$.tmp
[ -z "$_sf_tmpfile_list" ] && _sf_tmpfile_list="/tmp/._sf.tmpfiles.$$"

export _sf_tmpfile_prefix _sf_tmpfile_list