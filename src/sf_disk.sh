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
# Section: Disk management
#-----------------------------------------------------------------------------
# This section contains functions to manipulate disks and block devices.
#=============================================================================

##------------------------------------------------
# Normalize a disk device name
#
# After being normalized, device names can be compared.
#
# Input can be in the form:
#
#	- /dev/<vg>/<lv>
#	- /dev/mapper/...
#	- /dev/<partition or disk> (as /dev/sda1)
#	- LABEL=xxx
#	- UUID=xxx
#
# Output is in the form:
#
#	- /dev/<vg>/<lv> if LVM logical volume
#	- /dev/<physical> if physical disk
#	- Copy of input if input was not recognised
#
# Args:
#	$1: Device name to normalize
# Returns: 0 if device exists, 1 if not
# Displays: Normalized name if device exists, copy of input if not
#------------------------------------------------

function sf_disk_normalize_device
{
typeset dsk ndsk

dsk="$1"

case "$dsk" in
	/dev/mapper/*)
		#Note 1: 'lvs -o path' is not supported in RHEL4
		set -- `lvs --noheadings -o 'vg_name,name' $dsk 2>/dev/null`
		#Note 2: 'lvs' on a '/dev/mapper/' path is not supported on some
		#        RHEL 4 versions (at least 4.5)
		# On those systems, we just split the string on the first '-'.
		[ -z "$1" ] && set -- `echo $dsk | sed -e 's,^/dev/mapper/,,' -e 's/-/ /'`
		ndsk="/dev/$1/$2"
		;;
	UUID=*|LABEL=*)
		if [ `sf_os_version` = 4 ] ; then
			ndsk=`blkid -t "$dsk" | awk -F: '{ print $1 }'`
		else
			ndsk=`blkid -o device -t "$dsk"`
		fi
		ndsk=`sf_disk_normalize_device $ndsk`
		;;
	*)
		ndsk=$dsk
		;;
esac
ndsk=`echo $ndsk | sf_txt_cleanup`
# sf_debug "sf_disk_normalize_device: Normalized '$dsk' to '$ndsk'"
echo $ndsk
[ -b "$ndsk" ] # Must remain function's last statement (return code)
}

##------------------------------------------------
# Get the size of a file system (from device name)
#
# File system can be mounted or not.
#
# Note: In order to get the size of a mounted filesystem containing a given
#       path, use [flink:fs_size].
#
# Args:
#	$1: Device
# Returns: 0 if dev exists and contains a FS, else !=0.
# Displays: FS size in bytes. If the device does not exist or does not contain
#           a FS, displays nothing.
#------------------------------------------------

function sf_disk_fs_size
{
typeset dev bcount bsize fsize
dev="$1"
fisize=''

[ "`sf_disk_category $dev`" = fs ] || return 1

case "`uname -s`" in
	Linux)
		bcount=`dumpe2fs $dev 2>/dev/null | grep "^Block count:" | sed 's/^.* //'`
		bsize=`dumpe2fs $dev 2>/dev/null | grep "^Block size:" | sed 's/^.* //'`
		fsize=`expr $bcount \* $bsize`	# FS size
		#sf_debug "$dev: Bcount=$bcount, Bsize=$bsize, FS size: $fsize"
		;;
	*)
		sf_unsupported sf_disk_fs_size
		;;
esac

echo $fsize

return 0
}

##------------------------------------------------
# Get category of content for a given disk device
#
# Args:
#	$1: Device path
# Returns: Always 0
# Displays:
#	'fs' if it is a filesystem
#	'swap' if it is a swap partition
#	else, the type returned by disk_type()
#------------------------------------------------

function sf_disk_category
{
typeset disk category
disk=$1

[ "`uname -s`" = Linux ] || sf_unsupported sf_disk_category

if dumpe2fs $disk >/dev/null 2>&1 ; then
	category='fs'
else
	category=`sf_disk_type "$disk"`
fi

#sf_debug "sf_disk_category: return category '$category' for $disk"
echo $category
}

##------------------------------------------------
# Returns type of content for a given disk device
#
# Args:
#	$1: Device path
# Returns: Always 0
# Displays: type returned by 'blkid' command
#------------------------------------------------
#Note: 'blkid -o export' is not supported in RHEL4

function sf_disk_type
{
[ "`uname -s`" = Linux ] || sf_unsupported sf_disk_type

blkid "$1" 2>/dev/null | sed -e 's/.*TYPE="//g' -e 's/".*$//g'
return 0
}

##------------------------------------------------
# Scan and discover new SCSI devices
#
# Calling program should wait between 5 and 10 seconds for new devices
# to be discovered.
#
# Args: None
# Returns: Always 0
# Displays: Nothing
#------------------------------------------------

function sf_disk_rescan
{
typeset i

case "`uname -s`" in
	Linux)
		# Use two mechanisms because 1st one does not see disk resizes on a
		# VM in RHEL 6.
		for i in /sys/class/scsi_host/host*/scan ; do
			echo "- - -" >$i
		done
		for i in  /sys/class/scsi_device/*/device/rescan ; do
			echo 1 >$i
		done
		;;
	*)
		sf_unsupported sf_disk_rescan
		;;
esac
}

#=============================================================================
