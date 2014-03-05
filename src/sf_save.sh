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
# Section: File backup
#----------------------------------------------------------------------------
# This feature is still under development: so far, only regular files and symbolic
# links are supported. Other file types are ignored and not saved.
#=============================================================================

##----------------------------------------------------------------------------
# Ensure save system is operational.
#
# This function must be called before any action upon the save db.
#
# If initialization fails, the program is aborted
#
# Args: None
# Returns: Always 0
# Displays: Nothing
#----------------------------------------------------------------------------

function _sf_sav_init
{
if [ ! -d $_sf_save_tree ] ; then
	/bin/rm -rf $_sf_save_tree
	mkdir -p $_sf_save_tree
	chown root $_sf_save_tree
	chmod 700 $_sf_save_tree
fi

[ -d $_sf_save_tree ] \
	|| sf_fatal "Sysfunc error - Cannot initialize save system (cannot create file tree)"

# No need to create $_sf_save_base dir explicitely, as it is done when creating
# $_sf_save_tree.

if [ ! -f $_sf_save_index ] ; then
	touch $_sf_save_index
	chown root $_sf_save_index
	chmod 600 $_sf_save_index
fi
[ -f $_sf_save_index ] \
	|| sf_fatal "Sysfunc error - Cannot initialize save system (cannot create index file)"

}

##----------------------------------------------------------------------------
# Delete eveything that was saved on this host
#
# Args: None
# Returns: Always 0
# Displays: Nothing
#----------------------------------------------------------------------------

function sf_sav_zap
{
/bin/rm -rf $_sf_save_base
}

##----------------------------------------------------------------------------
# Saves a file
#
# No action if the *$sf_nosave* environment variable is set to a non-empty string.
#
# If the input arg is the path of an existing regular file or symbolic link,
# the file is saved.
#
# Args:
#	$1 : Path. Beware! Arg can contain any char (including blanks)
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_save
{
typeset type source tbase target n mode owner group mtime size sum line tpath
source="$1"

_sf_sav_init

[ "X$sf_nosave" = X ] || return

type=`sf_file_type "$source"` || return
source="`sf_file_realpath \"$source\"`" # Convert $source to absolute path
case "$type" in
	R)	# Regular file
		sf_msg1 "$source: Saving regular file"
		tbase="$source"
		target="$tbase"
		n=0
		while true; do
			tpath="$_sf_save_tree$target"
			if [ -f "$tpath" ] ; then
				if diff "$source" "$tpath" >/dev/null 2>&1 ; then
					# If same content
					break
				else
					n=`$n + 1`
					target="$tbase.$n"
				fi
			else
				mkdir -p "`dirname \"$tpath\"`" >/dev/null 2>&1
				cp "$source" "$tpath"
				chown root "$tpath"
				chmod 600 "$tpath"
				break
			fi
		done
		mode=`sf_file_mode "$source"`
		owner=`sf_file_owner "$source"`
		group=`sf_file_group "$source"`
		mtime=`sf_file_mtime "$source"`
		size=`sf_file_size "$tpath"`
		sum=`sf_file_checksum "$tpath"`
		line="$target|$size|$sum|$mode|$owner|$group|$mtime"
		;;

	L)	# Symbolic link
		sf_msg1 "$source: Saving symbolic link"
		target="`sf_file_readlink \"$source\"`"
		line="$target"
		;;

	*)	return ;; # Ignore other types
esac

#-- Record in index file

echo "$type|$source|`sf_tm_timestamp`|$line" >>$_sf_save_index
}

#-----------------------------------------------------------------------------

_sf_save_base=/var/sysfunc.save
_sf_save_index=$_sf_save_base/index.dat
_sf_save_tree=$_sf_save_base/tree

export _sf_save_base _sf_save_index _sf_save_tree

#=============================================================================
