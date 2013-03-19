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
# Section: System database
#=============================================================================

##----------------------------------------------------------------------------
# Clear the whole database
#
# Args: None
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_clear()
{
\rm -rf "$SF_DB_PATH" "$SF_DB_TMP_PATH"
}

##----------------------------------------------------------------------------
# Check if the database file exists
#
# Args: None
# Returns: 0 if file exists - <> 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

_sf_db_exists()
{
[ -f "$SF_DB_PATH" ]
}

##----------------------------------------------------------------------------
# Build a key (regexp usable in grep) from a variable name
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Key string
##----------------------------------------------------------------------------

_sf_db_key()
{
typeset name

name="$1"

key=`echo "$name" | sed -e 's,\.,\.,g'`
echo "^$key "
}

##----------------------------------------------------------------------------
# Replace the DB file with the temp DB file
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Key string
##----------------------------------------------------------------------------

_sf_db_tmp_replace()
{
\rm -rf "$SF_DB_PATH"
\mv "$SF_DB_TMP_PATH" "$SF_DB_PATH"
}

##----------------------------------------------------------------------------
# Unset a variable
#
# No error if variable was not present in DB
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_unset()
{
typeset key name

name="$1"

_sf_db_exists || return 0

key=`_sf_db_key "$name"`
grep -v "$key" $SF_DB_PATH >$SF_DB_TMP_PATH
_sf_db_tmp_replace
}

##----------------------------------------------------------------------------
# Set a variable
#
# Args:
#	$1: Variable name
#	$2+: Value
# Returns: 
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_set()
{
typeset name value

name="$1"
shift
value="$*"

sf_db_unset "$name"
echo "$name $value" >>$SF_DB_PATH
}

##----------------------------------------------------------------------------
# Check if a variable is set
#
# Args:
#	$1: Variable name
# Returns: 0 if variable is set, <> 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_isset()
{
typeset key name

name="$1"

_sf_db_exists || return 1

key=`_sf_db_key "$name"`
grep "$key" $SF_DB_PATH >/dev/null
}

##----------------------------------------------------------------------------
# Get a variable value
#
# If variable is not set, return an empty string (no error)
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Value or empty string if var not set
#-----------------------------------------------------------------------------

sf_db_get()
{
typeset key name

name="$1"
key=`_sf_db_key "$name"`

grep "$key" $SF_DB_PATH 2>/dev/null | sed 's,^[^ ]* ,,'
}

##----------------------------------------------------------------------------
# Dump the database
#
# Output format (each line) : <name><space><value><EOL>
#
# Args: None
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_dump()
{
_sf_db_exists && sort <$SF_DB_PATH
return 0
}

##----------------------------------------------------------------------------
# Import variables in dump format (one per line)
#
# Lines are read from stdin
#
# Args: None
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_import()
{
typeset line

while read line
	do
	sf_db_set $line
done
return 0
}

##----------------------------------------------------------------------------
# 
#
# Args:
#	$1: 
# Returns: 
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_expand()
{
:
// TODO
}

#=============================================================================

[ "X$SF_DB_PATH" = X ] && SF_DB_PATH=/etc/sysfunc.db
[ "X$SF_DB_TMP_PATH" = X ] && SF_DB_TMP_PATH=/etc/sysfunc.db.tmp

export SF_DB_PATH SF_DB_TMP_PATH

#=============================================================================
