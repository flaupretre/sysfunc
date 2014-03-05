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
# Section: Error handling
#=============================================================================

#-----------------------------------------------------------------------------
# Cleanup error file
#
# Called by sf_finish
#-----------------------------------------------------------------------------

function _sf_error_cleanup
{
\rm -rf $_sf_error_list
}

##----------------------------------------------------------------------------
# Displays an error message and aborts execution
#
# Args:
#	$1 : message
#	$2 : Optional. Exit code.
# Returns: Does not return. Exits with the provided exit code if arg 2 set,
#	with 1 if not.
# Displays: Error and abort messages
#-----------------------------------------------------------------------------

function sf_fatal
{
typeset rc

rc=1
[ -n "$2" ] && rc=$2

sf_error "$1"
sf_newline >&2
__msg "************ Fatal error - Aborting ************" >&2
sf_finish $rc
}

##----------------------------------------------------------------------------
# Fatal error on unsupported feature
#
# Call this function when a feature is not available on the current
# operating system (yet ?)
#
# Args:
#	$1 : feature name
# Returns: Does not return. Exits with code 2.
# Displays: Error and abort messages
#-----------------------------------------------------------------------------

function sf_unsupported
{
# $1: feature name

sf_fatal "$1: Feature not supported in this environment" 2
}

##----------------------------------------------------------------------------
# Displays an error message
#
# If the SF_ERRLOG environment variable is set, it is supposed to contain
# a path. The error message will be appended to the file at this path. If
# the file does not exist, it will be created.
# Args:
#	$1 : Message
# Returns: Always 0
# Displays: Error message
#-----------------------------------------------------------------------------

function sf_error
{
typeset errfile

sf_msg "***ERROR: $1" >&2

errfile=$_sf_error_list
[ -n "$SF_ERRLOG" ] && errfile="$SF_ERRLOG"
echo "$1" >>$errfile
}

##----------------------------------------------------------------------------
# Import errors into the error system
#
# This mechanism is generally used in conjunction with the $SF_ERRLOG variable.
# This variable is used to temporarily distract errors from the normal flow.
# Then, this function can be called to reinject errors into the default error
# repository.
#
# Args:
#	$1 : Optional. File to import (1 error per line). If not set, takes input
#        from stdin.
# Returns: Always 0
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_error_import
{
cat $1 >>$_sf_error_list
}

##----------------------------------------------------------------------------
# Display a list of errors detected so far
#
# Args: None
# Returns: Always 0
# Displays: List of error messages, one by line
#-----------------------------------------------------------------------------

function sf_show_errors
{
sort -u $_sf_error_list 2>/dev/null
}

##----------------------------------------------------------------------------
# Display a count of errors detected so far
#
# Args: None
# Returns: Always 0
# Displays: Error count
#-----------------------------------------------------------------------------

function sf_error_count
{
sf_show_errors | wc -l
}

#=============================================================================

# File containing error messages. Does not exist before first error is raised.

_sf_error_list=/tmp/._sf.errors.$$

export _sf_error_list
