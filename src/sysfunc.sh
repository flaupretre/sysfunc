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

#-----------------------------------------------------------------------------
# All the functions must have a name starting with '_' (no publicly
# accessible function here).
#-----------------------------------------------------------------------------

##----------------------------------------------------------------------------
# Display error message, usage, and exit
#
# Args:
#	$*: Error message
# Returns: No return
# Displays: Message
#-----------------------------------------------------------------------------

function _sf_fatal
{
sf_error "$*"
echo
_sf_usage
exit 1
}

##----------------------------------------------------------------------------
# Display usage and defined commands
#
# Args: None
# Returns: No return
# Displays: Message
#-----------------------------------------------------------------------------

function _sf_usage
{
sf_msg 'Usage: sysfunc <cmd> [args]'
echo
echo "Defined commands :"
echo
typeset -F | sed 's/^declare -f //' | grep '^sf_' | sed 's/^sf_//' \
	| grep -v '^loaded$'
}


#=============================================================================
# MAIN
#=============================================================================

#-- Clear potentially conflicting f...ing aliases

for i in cp mv rm
	do
	unalias $i >/dev/null 2>&1 || :
done

#-- Path
# Using XPG-compliant commands first is mandatory on Solaris, as the
# default syntax is not always compatible with Linux ('tail -n +<number>' for
# instance).

for i in /usr/sbin /bin /usr/bin /sbin /etc /usr/ccs/bin /usr/xpg4/bin /usr/xpg6/bin
	do
	[ -d "$i" ] && PATH="$i:$PATH"
done
export PATH

#-- Variables

[ -z "$sf_install_dir" ] && sf_install_dir="%INSTALL_DIR%"

export sf_install_dir

#-- Find utilities

if [ -z "$sf_yum" ] ; then
	sf_yum=`sf_find_executable yum`
	[ -n "$sf_yum" ] && sf_yum="$sf_yum -y -t -d 1"
fi
export sf_yum

if [ -z "$sf_rpm" ] ; then
	sf_rpm=`sf_find_executable rpm`
	[ -n "$sf_rpm" ] && sf_rpm="$sf_rpm --nosignature"
fi
export sf_rpm

#-- Check if sourced or executed

echo "$0" | grep sysfunc >/dev/null 2>&1
if [ $? = 0 ] ; then	# Executed
	_cmd="$1"
	[ "$_cmd" = '' ] && _sf_fatal 'No command'
	_func="sf_$_cmd"
	shift
	type "$_func" >/dev/null 2>&1 || _sf_fatal "$_cmd: Unknown command"
	cmd="$_func"
	for arg ; do	# Preserve potential empty strings
		cmd="$cmd '$arg'"
	done
	eval "$cmd ; _rc=\$?"
	exit $_rc
fi

#=============================================================================
