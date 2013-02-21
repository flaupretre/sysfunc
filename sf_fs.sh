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
# Section: Filesystem/Volume management
#=============================================================================

##----------------------------------------------------------------------------
# Checks if a directory is a file system mount point
#
# Args:
#	$1: Directory to check
# Returns: 0 if true, !=0 if false
# Displays: nothing
#-----------------------------------------------------------------------------

sf_has_dedicated_fs()
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

sf_get_fs_mnt()
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
# Get the size of the filesystem containing a given path
#
# Args:
#	$1: Path (must correspond to an existing element)
# Returns: Always 0
# Displays: FS size in Mbytes
#-----------------------------------------------------------------------------

sf_get_fs_size()
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

sf_set_fs_space()
{
typeset fs size newsize rc

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
			chfs -a size=${newsize}M $fs
			rc=$?
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

sf_create_fs()
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
	mkdir -p $mnt
fi

[ $? = 0 ] || return 1

case "`uname -s`" in
	Linux)
		opts=''
		# When supported, set filesystem label
		echo $type | grep '^ext' >/dev/null && opts="-L `basename $dev`"
		mkfs -t $type $opts $dev
		[ $? = 0 ] || return 1
		echo "$dev $mnt $type defaults 1 2" >>/etc/fstab
		;;
	*)
		sf_unsupported sf_create_fs
		;;
esac

mount $dev $mnt
[ $? = 0 ] || return 1

sf_chown $owner $mnt
[ $? = 0 ] || return 1

return 0
}

##----------------------------------------------------------------------------
# Checks if a given logical volume exists
#
# Args:
#	$1: VG name
#	$2: LV name
# Returns: 0 if it exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_lv_exists()
{
typeset vg lv rc

vg=$1
lv=$2

case "`uname -s`" in
	Linux)
		lvs $vg/$lv >/dev/null 2>&1
		rc=$?
		;;
	*)
		sf_unsupported sf_lv_exists
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Checks if a given volume group exists
#
# Args:
#	$1: VG name
# Returns: 0 if it exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

sf_vg_exists()
{
typeset vg rc

vg=$1

case "`uname -s`" in
	Linux)
		vgs $vg >/dev/null 2>&1
		rc=$?
		;;
	*)
		sf_unsupported sf_lv_exists
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Create a logical volume
#
# Args:
#	$1: Logical volume name
#	$2: Volume group name
#	$3: Size (Default: megabytes, optional suffixes: [kmgt]. Special value: 'all'
#		takes the whole free size in the VG. 
# Returns: 0: OK, !=0: Error
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_lv()
{
typeset lv vg size sz_opt

lv=$1
vg=$2
size=$3

if ! sf_vg_exists $vg ; then
	sf_error "VG $vg does not exist"
	return 1
fi

sf_lv_exists $vg $lv && return 0

sz_opt="--size $size"
[ "$size" = all ] && sz_opt="--extents 100%FREE"

sf_msg1 "Creating LV $lv on VG $vg"

case "`uname -s`" in
	Linux)
		lvcreate $sz_opt -n $lv $vg
		rc=$?
		;;
	*)
		sf_unsupported sf_create_lv
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Create a volume group
#
# Args:
#	$1: volume group name
#	$2: PE size (including optional unit, default=Mb)
#	$3: Device path, without the /dev prefix
# Returns: 0: OK, !=0: Error
# Displays: Info msg
#-----------------------------------------------------------------------------

sf_create_vg()
{
typeset vg pesize device

vg=$1
pesize=$2
device=$3

sf_vg_exists $vg && return 0

sf_msg1 "Creating VG $vg"

case "`uname -s`" in
	Linux)
		vgcreate -s $pesize $vg /dev/$device
		rc=$?
		;;
	*)
		sf_unsupported sf_create_vg
		;;
esac

return $rc
}

##----------------------------------------------------------------------------
# Returns default FS type for current environment
#
# Args: None
# Returns: Always 0
# Displays: Type
#-----------------------------------------------------------------------------

sf_fs_default_type()
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

sf_create_lv_fs()
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
