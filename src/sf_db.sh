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
# Section: System database
#=============================================================================

##----------------------------------------------------------------------------
# Clear the whole database
#
# Args: None
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_db_clear
{
\rm -rf "$SF_DB_PATH"
}

##----------------------------------------------------------------------------
# Check if the database file exists
#
# Args: None
# Returns: 0 if file exists - <> 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

function _sf_db_exists
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
#----------------------------------------------------------------------------

function sf_db_normalize
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
#----------------------------------------------------------------------------

function sf_db_key
{
sf_db_normalize "$1" | sed -e 's,\.,\.,g'
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

function sf_db_unset
{
typeset key name tmp

_sf_db_exists || return 0

tmp=`sf_tmpfile`
for name
	do
	[ -z "$name" ] && break
	key=`sf_db_key "$name"`
	grep -v "^$key " $SF_DB_PATH >$tmp
	cat $tmp >$SF_DB_PATH
done
/bin/rm -f $tmp
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

function sf_db_set
{
typeset name value

name=`sf_db_normalize "$1"`
value="$2"

sf_db_unset "$name"
echo "$name $value" >>$SF_DB_PATH
}

##----------------------------------------------------------------------------
# Duplicate a variable (copy content)
#
# If the source variable is not set, target is created with an empty value
#
# Args:
#	$1: Source variable name
#	$2: Target variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_db_copy
{
typeset source target

source=`sf_db_normalize "$1"`
target=`sf_db_normalize "$2"`

sf_db_set $target "`sf_db_get $source`"
}

##----------------------------------------------------------------------------
# Rename a variable (keep content)
#
# If the source variable is not set, target is created with an empty value
#
# Args:
#	$1: Source variable name
#	$2: Target variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_db_rename
{
sf_db_copy "$1" "$2"
sf_db_unset "$1"
}

##----------------------------------------------------------------------------
# Set a variable with the value returned by [function:tm_now]
#
# Args:
#	$1: Variable name
# Returns: 0
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_db_set_timestamp
{
sf_db_set "$1" "`sf_tm_now`"
}

##----------------------------------------------------------------------------
# Check if a variable is set
#
# If global variable SF_DB_PATH contains '<stdin>', DB content is read from
# standard input.
# 
# Args:
#	$1: Variable name
# Returns: 0 if variable is set, <> 0 if not
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_db_isset
{
typeset key

key=`sf_db_key "$1"`
_sf_get_clean_db | grep "^$key " >/dev/null
}

##----------------------------------------------------------------------------
# Get a variable value
#
# If variable is not set, return an empty string (no error)
#
# If global variable SF_DB_PATH contains '<stdin>', DB content is read from
# standard input.
# 
# Args:
#	$1: Variable name
# Returns: 0
# Displays: Value or empty string if var not set
#-----------------------------------------------------------------------------

function sf_db_get
{
typeset key

key=`sf_db_key "$1"`

# 'head -1' by security (should never be used)

_sf_get_clean_db | grep "^$key " | sed 's,^[^ ][^ ]* ,,' | head -1
}

##----------------------------------------------------------------------------
# Provides a database whose comments and empty lines are removed
#
# Exists because sf_db can be used to read from a handcrafted DB file
# (by overriding $SF_DB_PATH) or from standard input. Such content can contain
# comments and empty lines.
#
# Standard input is read when $SF_DB_PATH contains '<stdin>'.
#
# Args: None
# Returns: 0
# Displays: Input with comments and empty lines removed
#-----------------------------------------------------------------------------

function _sf_get_clean_db
{
typeset dbpath

if [ "X$SF_DB_PATH" = 'X<stdin>' ] ; then
	dbpath=''
else
	dbpath="$SF_DB_PATH"
	_sf_db_exists || return
fi

sed -e 's/		*/ /g' -e 's/   */ /g' -e 's/^  *//g' -e 's/^#.*$//g' \
	$dbpath | grep -v '^$'
}

##----------------------------------------------------------------------------
# Dump the database
#
# Output format (each line) : <name><space><value><EOL>
#
# The output is sorted alphabetically.
#
# Args: None
# Returns: 0
# Displays: DB content
#-----------------------------------------------------------------------------

function sf_db_dump
{
_sf_get_clean_db | sort
}

##----------------------------------------------------------------------------
# List DB keys alphabetically, one per line
#
# Args: None
# Returns: 0
# Displays: DB keys
#-----------------------------------------------------------------------------

function sf_db_list
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

function sf_db_import
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
#
# Allows nested substitutions (ex: {{%interface{{%hcfg:icount%}}/network%}}).
#
# Patterns which do not correspond to an existing variable are replaced with an
# empty string.
#
# Input: stdin, output: stdout.
#
# Args:
#	$1: 
# Returns: 0
# Displays: Output
#-----------------------------------------------------------------------------

function sf_db_expand
{
typeset name value esc_val _tmp1 _tmp2 _tmp

_tmp1=`sf_tmpfile`
_tmp2=`sf_tmpfile`
_tmp=`sf_tmpfile`

sf_db_dump | while read name value
	do
	esc_val=`echo "$value" | sed -e 's!,!\,!g'`
	echo "s,{{%$name%}},$esc_val,g"
done >$_tmp

cat >$_tmp1

while true
	do
	sed -f $_tmp <$_tmp1 >$_tmp2
	diff $_tmp1 $_tmp2 >/dev/null && break
	cp $_tmp2 $_tmp1
done

sed 's,{{%[^%]*%}},,g' <$_tmp2 # Suppress unresolved patterns

\rm -rf $_tmp1 $_tmp2 $_tmp
}

#=============================================================================

[ -z "${SF_DB_DEF_PATH:+}" ] && SF_DB_DEF_PATH=/etc/sysfunc.db
[ -z "${SF_DB_PATH:+}" ] && SF_DB_PATH="$SF_DB_DEF_PATH"

export SF_DB_DEF_PATH SF_DB_PATH

#=============================================================================
