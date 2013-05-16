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
# Filter a name, leaving authorized chars only
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Normalized name
##----------------------------------------------------------------------------

sf_db_normalize()
{
echo "$1" | tr -cd 'a-zA-Z0-9:_./()-'
echo
}

##----------------------------------------------------------------------------
# Build a key (regexp usable in grep) from a variable name
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Key string
##----------------------------------------------------------------------------

sf_db_key()
{
sf_db_normalize "$1" | sed -e 's,\.,\.,g'
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
#	$*: Variable names
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_unset()
{
typeset key name

_sf_db_exists || return 0

for name
	do
	[ -z "$name" ] && break
	key=`sf_db_key "$name"`
	grep -v "^$key " $SF_DB_PATH >$SF_DB_TMP_PATH
	_sf_db_tmp_replace
done
}

##----------------------------------------------------------------------------
# Set a variable
#
# Args:
#	$1: Variable name
#	$2: Value
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_set()
{
typeset name value

name=`sf_db_normalize "$1"`
value="$2"

sf_db_unset "$name"
echo "$name $value" >>$SF_DB_PATH
}

##----------------------------------------------------------------------------
# Duplicate a variable (copy content)
# If the source variable is not set, target is created with an empty value
#
# Args:
#	$1: Source variable name
#	$2: Target variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_copy()
{
typeset source target

source=`sf_db_normalize "$1"`
target=`sf_db_normalize "$2"`

sf_db_set $target "`sf_db_get $source`"
}

##----------------------------------------------------------------------------
# Rename a variable (keep content)
# If the source variable is not set, target is created with an empty value
#
# Args:
#	$1: Source variable name
#	$2: Target variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_rename()
{
sf_db_copy "$1" "$2"
sf_db_unset "$1"
}

##----------------------------------------------------------------------------
# Set a variable with the "sf_now" timestamp value
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

sf_db_set_timestamp()
{
sf_db_set "$1" "`sf_tm_now`"
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
typeset key

_sf_db_exists || return 1

key=`sf_db_key "$1"`
grep "^$key " $SF_DB_PATH >/dev/null
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
key=`sf_db_key "$1"`

# 'head -1' by security (should never be used)

grep "^$key " $SF_DB_PATH 2>/dev/null | sed 's,^[^ ][^ ]* ,,' | head -1
}

##----------------------------------------------------------------------------
# Dump the database
#
# Output format (each line) : <name><space><value><EOL>
#
# Args: None
# Returns: 0
# Displays: DB content
#-----------------------------------------------------------------------------

sf_db_dump()
{
_sf_db_exists && sort <$SF_DB_PATH
return 0
}

##----------------------------------------------------------------------------
# List DB keys alphabetically, one per line
#
# Args: None
# Returns: 0
# Displays: DB keys
#-----------------------------------------------------------------------------

sf_db_list()
{
sf_db_dump | awk '{ print $1 }'
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
# Replaces patterns in the form '{{%<variable name>%}}' by their value.
# Allows nested substitutions (ex: {{%interface{{%hcfg:icount%}}/network%}}).
# Patterns which do not correspond to an existing variable are replaced by an
# empty string.
# Input: stdin, output: stdout.
#
# Args:
#	$1: 
# Returns: 0
# Displays: Output
#-----------------------------------------------------------------------------

sf_db_expand()
{
typeset name value esc_val _tmp1 _tmp2

_tmp1=/tmp/.sf_db_expand.tmp1.$$
_tmp2=/tmp/.sf_db_expand.tmp2.$$

sf_db_dump | while read name value
	do
	esc_val=`echo "$value" | sed -e 's!,!\,!g'`
	echo "s,{{%$name%}},$esc_val,g"
done >$SF_DB_TMP_PATH

\rm -rf $_tmp1 $_tmp2
cat >$_tmp1

while true
	do
	sed -f $SF_DB_TMP_PATH <$_tmp1 >$_tmp2
	diff $_tmp1 $_tmp2 >/dev/null && break
	cp $_tmp2 $_tmp1
done

sed 's,{{%[^%]*%}},,g' <$_tmp2 # Suppress unresolved patterns

\rm -rf $_tmp1 $_tmp2 $SF_DB_TMP_PATH
}

#=============================================================================

[ "X$SF_DB_PATH" = X ] && SF_DB_PATH=/etc/sysfunc.db
[ "X$SF_DB_TMP_PATH" = X ] && SF_DB_TMP_PATH=/etc/sysfunc.db.tmp

export SF_DB_PATH SF_DB_TMP_PATH

#=============================================================================
