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
# Check if a parameter is not set (default value)
#
# Args:
#	$1: Parameter
# Returns: 0 if parameter is not set (default value), 1 if set
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_cfg_is_default
{
sf_db_isset "$1" && return 1
return 0
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

if sf_cfg_is_default "$var" ; then
	sf_cfg_get_default "$var"
else
	sf_db_get "$var"
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
# Display a list of parameters along with default and actual values
#
# Args: None
# Returns: Only if parameter is valid
# Displays: Nothing
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
	sf_cfg_is_default "$var" || prefix="$enhanced"
	printf "%-23s  $prefix%-20s$normal  %-20s\n" $var "$value" \
		"`sf_cfg_get_default $var`"
done
}


#=============================================================================

[ "X$SF_CFG_DEF_DIR" = X ] && SF_CFG_DEF_DIR=/etc/sysfunc/cfg/defaults

export SF_CFG_DEF_DIR

#=============================================================================
