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
# Section: Utility functions
#=============================================================================

##----------------------------------------------------------------------------
# Checks if the library is already loaded
#
#- Of course, if it can run, the library is loaded. So, it always returns 0.
#- Allows to support the 'official' way to load sysfunc :
#	sf_loaded 2>/dev/null || . sysfunc.sh
#
# Args: none
# Returns: Always 0
# Displays: Nothing
##----------------------------------------------------------------------------

function sf_loaded
{
return 0
}

##----------------------------------------------------------------------------
# Displays library version
#
# Args: none
# Returns: Always 0
# Displays: Library version (string)
#-----------------------------------------------------------------------------

function sf_version
{
. $sf_install_dir/util/config.sh
echo "$VERSION-$RELEASE"
return 0
}

##----------------------------------------------------------------------------
# Retrieves executable data through an URL and executes it.
#
#- Supports any URL accepted by wget.
#- By default, the 'wget' command is used. If the $WGET environment variable
#  is set, it is used instead (use, for instance, to
#  specify a proxy or an alternate configuration file).
#
# Args:
#	$1 : Url
# Returns: the return code of the executed program
# Displays: data displayed by the executed program
#-----------------------------------------------------------------------------

function sf_exec_url
{
typeset wd tdir status

[ -n "$WGET" ] || WGET=wget

wd=`pwd`
tdir=`sf_get_tmp`

for i ; do
	sf_create_dir $tdir
	cd $tdir

	$WGET $i
	sf_chmod +x *
	./*
	status=$?

	cd $wd
	/bin/rm -rf $tdir
done

return $status
}

#=============================================================================
# Section: Temporary file management
#=============================================================================

##----------------------------------------------------------------------------
# Deletes all temporary files
#
# Args: none
# Returns: Always 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_cleanup
{
\rm -rf $sf_tmpfile*
}

##----------------------------------------------------------------------------
# Returns an unused temporary path
#
# The returned path can then be used to create a directory or a file.
#
# Args: none
# Returns: Always 0
# Displays: An unused temporary path
#-----------------------------------------------------------------------------

function sf_get_tmp
{
n=0
while true
	do
	f="$sf_tmpfile._tmp.$n"
	[ -e $f ] || break
	n=`expr $n + 1`
done

echo $f
}

#=============================================================================
