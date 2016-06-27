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
# Section: Filesystems
#=============================================================================

##----------------------------------------------------------------------------
# Checks if a directory is a file system mount point
#
# ### This function is deprecated. Please use [function:fs_is_mount_point].
#
# Args:
#	$1: Directory to check
# Returns: 0 if true, !=0 if false
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_has_dedicated_fs
{
sf_fs_is_mount_point $*
}

##----------------------------------------------------------------------------
# Checks if a directory is a file system mount point
#
# A filesystem must be mounted on the directory for it to be
# recognized as a mount point.
#
# Args:
#	$1: Directory to check
# Returns: 0 if true, !=0 if false
# Displays: nothing
#-----------------------------------------------------------------------------

function sf_fs_is_mount_point
{
[ -d "$1" ] || return 1

[ "`sf_fs_mount_point $1`" = "$1" ]
}

##----------------------------------------------------------------------------
# Gets the mount point of the filesystem containing a given path
#
# ### This function is deprecated. Please use [function:fs_mount_point].
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The mount directory of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_get_fs_mnt
{
sf_fs_mount_point $*
}

##----------------------------------------------------------------------------
# Gets the mount point of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The mount directory of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_fs_mount_point
{
case "`sf_os_family`" in
	linux)
		df -kP "$1" | tail -1 | awk '{ print $6 }'
		;;
	sunos)
		/usr/bin/df -k "$1" | tail -1 | awk '{ print $6 }'
		;;
	aix)
		df -k "$1" | tail -1 | awk '{ print $7 }'
		;;
	*)
		sf_unsupported sf_fs_mount_point
		;;
esac
}

##----------------------------------------------------------------------------
# Gets the device of the filesystem containing a given path
#
# ### This function is deprecated. Please use [function:fs_device].
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The normalized device of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_get_fs_device
{
sf_fs_device $*
}

##----------------------------------------------------------------------------
# Gets the device of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: The normalized device of the filesystem containing the element
#-----------------------------------------------------------------------------

function sf_fs_device
{
typeset disk

[ -e "$1" ] || return

case "`sf_os_family`" in
	linux)
		disk=`df -kP "$1" | tail -1 | awk '{ print $1 }'`
		;;
	*)
		sf_unsupported sf_fs_device
		;;
esac

sf_disk_normalize_device $disk
}

##----------------------------------------------------------------------------
# Get the size of the filesystem containing a given path
#
# ### This function is deprecated. Please use [function:fs_size].
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: FS size in Mbytes
#-----------------------------------------------------------------------------

function sf_get_fs_size
{
sf_fs_size $*
}

##----------------------------------------------------------------------------
# Get the size of the filesystem containing a given path
#
# Note: This function is to be used for a mounted filesystem. In order to get
#       the size of a file system contained in a given device (mounted or not),
#       use [function:disk_fs_size].
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: FS size in Mbytes
#-----------------------------------------------------------------------------

function sf_fs_size
{
# $1=directory

case "`sf_os_family`" in
	linux)
		sz=`df -kP "$1" | tail -1 | awk '{ print $2 }'`
		;;
	sunos)
		sz=`/usr/bin/df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	aix)
		sz=`df -k "$1" | tail -1 | awk '{ print $2 }'`
		;;
	*)
		sf_unsupported sf_fs_size
		;;
esac

echo `expr $sz / 1024`
}

##----------------------------------------------------------------------------
# Extend a file system to a given size
#
# ### This function is deprecated. Please use [function:fs_extend].
#
# Args:
#	$1: A path contained in the file system to extend
#	$2: The new size in Mbytes, or the size to add if prefixed with a '+'
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_set_fs_space
{
sf_fs_extend $*
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

function sf_fs_extend
{
typeset fs size newsize rc
rc=0

fs=`sf_fs_mount_point $1`
size=`sf_fs_size $1`
newsize=$2
echo "$newsize" | grep '^+' >/dev/null 2>&1
if [ $? = 0 ] ; then
	newsize=`echo $newsize | sed 's/^.//'`
	newsize=`expr $size + $newsize`
fi

if [ "$newsize" -gt "$size" ] ; then
	sf_msg1 "Extending $fs filesystem to $newsize Mb"
	case "`sf_os_family`" in
		aix)
			if [ -z "$sf_noexec" ] ; then
				chfs -a size=${newsize}M $fs
				rc=$?
			fi
			;;
		*)
			sf_unsupported sf_fs_extend
			;;
	esac
fi

return $rc
}

##----------------------------------------------------------------------------
# Create a file system, mount it, and register it (mount at boot)
#
# ### This function is deprecated. Please use [function:fs_create].
#
# Refuses existing directory as mount point (security)
#
# Args:
#	$1: Mount point
#	$2: device path
#	$3: Optional. FS type (if empty, default FS type for this OS)
#	$4: Optional. Mount point directory owner[:group]
# Returns: 0 if no error, 1 on error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_fs
{
sf_fs_create $*
}

##----------------------------------------------------------------------------
# Create a file system, mount it, and register it (mount at boot)
#
# Refuses existing directory as mount point (security)
#
# Args:
#	$1: Mount point
#	$2: device path
#	$3: Optional. FS type (if empty, default FS type for this OS)
#	$4: Optional. Mount point directory owner[:group]
# Returns: 0 if no error, 1 on error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_fs_create
{
typeset mnt dev type owner opts tmp

mnt=$1
dev=$2
type=$3
owner=$4
[ -z "$type" ] && type=`sf_fs_default_type`
[ -z "$owner" ] && owner=root

sf_fs_is_mount_point $mnt && return 0
sf_msg1 "$mnt: Creating file system..."

if [ -d $mnt ] ; then # Securite
	sf_error "$mnt: Cannot create FS on an existing directory"
	return 1
else
	[ -z "$sf_noexec" ] && mkdir -p $mnt
fi

[ $? = 0 ] || return 1

case "`sf_os_family`" in
	linux)
		opts=''
		# When supported, set filesystem label
		echo $type | grep '^ext' >/dev/null && opts="-L `basename $dev`"
		if [ -z "$sf_noexec" ] ; then
			tmp=`sf_tmpfile`
			mkfs -t $type $opts $dev >$tmp 2>&1
			if [ $? != 0 ] ; then
				echo "mkfs failed  with this log :"
				cat $tmp
				/bin/rm -f $tmp
				return 1
			else
				sf_msg1 "$mnt: File system created"
				/bin/rm -f $tmp
			fi
			sf_check_line /etc/fstab "^$dev " "$dev $mnt $type defaults 1 2"
		fi
		;;
	*)
		sf_unsupported sf_fs_create
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

case `sf_os_family` in
	linux)
		for type in ext4 ext3 ext2 ; do
			[ -x /sbin/mkfs.$type ] && break
		done
		;;
	*) sf_unsupported sf_fs_default_type
		;;
esac

echo $type
}

##----------------------------------------------------------------------------
# Create a logical volume and a filesystem on it
#
# ### This function is deprecated. Please use [function:fs_create_lv_fs]
# ### Warning: Note that superseding function has argument 4 and 5 swapped (size and FS type).
#
# Combines [function:create_lv] and [function:fs_create]
#
# Args:
#	$1: Mount point (directory)
#	$2: Logical volume name
#	$3: Volume group name
#	$4: File system type (optional. if empty, defaults to default FS type for this OS)
#	$5: Size (Default: megabytes, optional suffixes: [kmgt]. Special value: 'all'
#		takes the whole free size in the VG. 
#	$6: Optional. Directory owner[:group]
# Returns: 0: OK, !=0: Error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_create_lv_fs
{
sf_fs_create_lv_fs "$1" "$2" "$3" "$5" "$4" "$6"
}

##----------------------------------------------------------------------------
# Create a logical volume and a filesystem on it
#
# Combines [function:create_lv] and [function:fs_create]
#
# Args:
#	$1: Mount point (directory)
#	$2: Logical volume name
#	$3: Volume group name
#	$4: Size (Default: megabytes, optional suffixes: [kmgt]. Special value: 'all'
#		takes the whole free size in the VG. 
#	$5: Optional. File system type. Defaults to default FS type for this environment
#	$6: Optional. Directory owner[:group]
# Returns: 0: OK, !=0: Error
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_fs_create_lv_fs
{
typeset mnt lv vg type size owner

mnt=$1
lv=$2
vg=$3
size=$4
type=$5
owner=$6

sf_create_lv $lv $vg $size || return 1
sf_fs_create $mnt /dev/$vg/$lv $type $owner || return 1
return 0
}

#=============================================================================
