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
# Section: Filesystem management
#=============================================================================

##----------------------------------------------------------------------------
# Checks if a directory is a file system mount point
#
# Args:
#	$1: Directory to check
# Returns: 0 if true, !=0 if false
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_has_dedicated_fs
{
[ -d "$1" ] || return 1

[ "`sf_get_fs_mnt $1`" = "$1" ]
}

##----------------------------------------------------------------------------
# Gets the mount point of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The mount directory of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_get_fs_mnt
{
case "`uname -s`" in
	Linux)
		df -kP "$1" | tail -1 | awk '{ print $6 }'
		;;
	SunOS)
		/usr/bin/df -k "$1" | tail -1 | awk '{ print $6 }'
		;;
	AIX)
		df -k "$1" | tail -1 | awk '{ print $7 }'
		;;
	*)
		sf_unsupported sf_get_fs_mnt
		;;
esac
}

##----------------------------------------------------------------------------
# Gets the device of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The normalized device of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_get_fs_device
{
typeset disk

[ -e "$1" ] || return

case "`uname -s`" in
	Linux)
		disk=`df -kP "$1" | tail -1 | awk '{ print $1 }'`
		;;
	*)
		sf_unsupported sf_get_fs_mnt
		;;
esac

sf_disk_normalize_device $disk
}

##----------------------------------------------------------------------------
# Get the size of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: FS size in Mbytes
#-----------------------------------------------------------------------------

function sf_get_fs_size
{
# $1=directory

case "`uname -s`" in
	Linux)
		sz=`df -kP "$1" | tail -1 | awk '{ print $2 }'`
		;;
	SunOS)
		sz=`/usr/bin/df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	AIX)
		sz=`df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	*)
		sf_unsupported sf_get_fs_mnt
		;;
esac

echo `expr $sz / 1024`
}

##----------------------------------------------------------------------------
# Extend a file system to a given size
#
# Args:
#	$1: A path contained in the file system to extend
#	$2: The new size in Mbytes, or the size to add if prefixed with a '+'
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_set_fs_space
{
typeset fs size newsize rc
rc=0

fs=`sf_get_fs_mnt $1`
size=`sf_get_fs_size $1`
newsize=$2
echo "$newsize" | grep '^+' >/dev/null 2>&1
if [ $? = 0 ] ; then
	newsize=`echo $newsize | sed 's/^.//'`
	newsize=`expr $size + $newsize`
fi

if [ "$newsize" -gt "$size" ] ; then
	sf_msg1 "Extending $fs filesystem to $newsize Mb"
	case "`uname -s`" in
		AIX)
			if [ -z "$sf_noexec" ] ; then
				chfs -a size=${newsize}M $fs
				rc=$?
			fi
			;;
		*)
			sf_unsupported sf_set_fs_space
			;;
	esac
fi

return $rc
}

##----------------------------------------------------------------------------
# Create a file system, mount it, and set system configuration to mount it
# at system start
#
# Refuses existing directory as mount point (security)
#
# Args:
#	$1: Mount point
#	$2: device path
#	$3: FS type
#	$4: Optional. Mount point directory owner[:group]
# Returns: 0 if no error, 1 on error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_fs
{
typeset mnt dev type owner opts

mnt=$1
dev=$2
type=$3
owner=$4
[ -z "$owner" ] && owner=root

sf_has_dedicated_fs $mnt && return 0
sf_msg1 "$mnt: Creating file system"

if [ -d $mnt ] ; then # Securite
	sf_error "$mnt: Cannot create FS on an existing directory"
	return 1
else
	[ -z "$sf_noexec" ] && mkdir -p $mnt
fi

[ $? = 0 ] || return 1

case "`uname -s`" in
	Linux)
		opts=''
		# When supported, set filesystem label
		echo $type | grep '^ext' >/dev/null && opts="-L `basename $dev`"
		if [ -z "$sf_noexec" ] ; then
			mkfs -t $type $opts $dev || return 1
			echo "$dev $mnt $type defaults 1 2" >>/etc/fstab
		fi
		;;
	*)
		sf_unsupported sf_create_fs
		;;
esac

if [ -z "$sf_noexec" ] ; then
	mount $dev $mnt || return 1
	sf_chown $owner $mnt || return 1
fi

return 0
}

##----------------------------------------------------------------------------
# Returns default FS type for current environment
#
# Args: None
# Returns: Always 0
# Displays: Type
#-----------------------------------------------------------------------------

function sf_fs_default_type
{
typeset type

case `uname -s` in
	Linux) type=ext3;;
	*) sf_unsupported "sf_fs_default_type";;
esac

echo $type
}

##----------------------------------------------------------------------------
# Create a logical volume and a filesystem on it
#
# Combines sf_create_lv and sf_create_fs
#
# Args:
#	$1: Mount point (directory)
#	$2: Logical volume name
#	$3: Volume group name
#	$4: File system type
#	$5: Size in Mbytes
#	$6: Optional. Directory owner[:group]
# Returns: 0: OK, !=0: Error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_lv_fs
{
typeset mnt lv vg type size owner

mnt=$1
lv=$2
vg=$3
type=$4
size=$5
owner=$6

sf_create_lv $lv $vg $size || return 1
sf_create_fs $mnt /dev/$vg/$lv $type $owner || return 1
return 0
}

#=============================================================================
