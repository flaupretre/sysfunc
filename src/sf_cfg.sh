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
# Section: Configuration parameters
#=============================================================================

##----------------------------------------------------------------------------
# Run an 'sf_db' command on default values
#
# Args:
#	$*: An sf_db command along with its arguments
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

function _sf_cfg_def_exec
{
cat $SF_CFG_DEF_DIR/* 2>/dev/null | SF_DB_PATH='<stdin>' $*
}

##----------------------------------------------------------------------------
# Check that the given parameter is a valid one
#
# Actually, parameter is valid if a default value is registered for this param.
#
# Args:
#	$1: Parameter
# Returns: 0 if parameter exists, =!0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_cfg_exists
{
_sf_cfg_def_exec sf_db_isset "$1"
}

##----------------------------------------------------------------------------
# Check if a parameter is explicitely set (not default)
#
# Args:
#	$1: Parameter
# Returns: 0 if parameter is set (not default value), 1 if not set
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_cfg_isset
{
sf_cfg_check "$1"
sf_db_isset "$1"
}

##----------------------------------------------------------------------------
# Aborts if the given parameter is not a valid one
# 
# Args:
#	$1: Parameter
# Returns: Only if parameter is valid
# Displays: If parameter is invalid, aborts with error message
#-----------------------------------------------------------------------------

function sf_cfg_check
{
sf_cfg_exists "$1" || sf_fatal "Invalid configuration parameter: $1"
}

##----------------------------------------------------------------------------
# List defined configuration parameters
# 
# Args: None
# Returns: 0
# Displays: Defined parameters, one by line
#-----------------------------------------------------------------------------

function sf_cfg_list
{
_sf_cfg_def_exec sf_db_list
}

##----------------------------------------------------------------------------
# Get parameter default value
# 
# Args:
#	$1: Parameter
# Returns: Only if parameter is valid
# Displays: Parameter default value
#-----------------------------------------------------------------------------

function sf_cfg_get_default
{
_sf_cfg_def_exec sf_db_get "$1"
}

##----------------------------------------------------------------------------
# Get parameter value
#
# If parameter is set, returns set value. Else, returns default value.
# 
# Args:
#	$1: Parameter
# Returns: Only if parameter is valid
# Displays: Parameter value
#-----------------------------------------------------------------------------

function sf_cfg_get
{
typeset var
var=$1
sf_cfg_check "$var"

if sf_db_isset "$var" ; then
	sf_db_get "$var"
else
	sf_cfg_get_default "$var"
fi
}

##----------------------------------------------------------------------------
# Set an explicit parameter value
#
# To reset a parameter to its default value, see [function:cfg_unset]
# 
# Args:
#	$1: Parameter
#	$2: Value
# Returns: Only if parameter is valid
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_cfg_set
{
sf_cfg_check "$1"
sf_db_set "$1" "$2"
}

##----------------------------------------------------------------------------
# Reset a parameter to its default value
#
# Args:
#	$1: Parameter
# Returns: Only if parameter is valid
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_cfg_unset
{
sf_cfg_check "$1"
sf_db_unset "$1"
}

##----------------------------------------------------------------------------
# Display the parameters along with their default and actual values
#
# Args: None
# Returns: 0
# Displays: Parameters
#-----------------------------------------------------------------------------

function sf_cfg_display
{
typeset var value enhanced normal prefix

enhanced="`tput rev`"
normal="`tput sgr0`"

echo "Name                     Actual value          Default value"
echo "-----------------------  --------------------  --------------------"
sf_cfg_list | while read var ; do
	value="`sf_cfg_get $var`"
	prefix=''
	sf_db_isset "$var" && prefix="$enhanced"
	printf "%-23s  $prefix%-20s$normal  %-20s\n" $var "$value" \
		"`sf_cfg_get_default $var`"
done
}

##----------------------------------------------------------------------------
# Display parameters with actual value in raw format
#
# Format of each line : <parameter><space><value>
#
# The output of this function does not allow to say if a value is the default
# one or not.
#
# Args: None
# Returns: 0
# Displays: List of '<parameter><space><value>' lines
#-----------------------------------------------------------------------------

function sf_cfg_dump
{
typeset var value

sf_cfg_list | while read var ; do
	echo "$var `sf_cfg_get $var`"
done
}

##----------------------------------------------------------------------------
# Display parameter information
#
# Args:
#	$*: Optional. List of parameters. If empty, display every defined parameters
# Returns: 0
# Displays: Parameters and related information
#-----------------------------------------------------------------------------

function sf_cfg_info
{
typeset tmp var
#tmp=`sf_tmpfile`
tmp=/tmp/az

[ -n "$1" ] || set -- `sf_cfg_list`
for var ; do
	>$tmp
	#set -x
	cat $SF_CFG_DEF_DIR/* 2>/dev/null | awk "
		BEGIN	{ c=0; reset=0; }
		/^#/	{
				if (reset==1) {
					delete a;
					c=0;
					reset=0;
					}
				a[c++]=\$0;
				next;
				}
				{
				if (\$1==\"$var\") {
					print \"*\",\$1;
					for (i=0;i<c;i++) {	print \"   \",gensub(/^# +/,\"\",1,a[i]); }
					print \"    Default value: `sf_cfg_get_default $var`\";
					print \"\";
					exit;
					}
				else { reset=1;	}
				}"
done
rm -f $tmp
}

#=============================================================================

[ -z "${SF_CFG_DEF_DIR:+}" ] && SF_CFG_DEF_DIR=/etc/sysfunc/cfg/defaults

export SF_CFG_DEF_DIR

#=============================================================================
