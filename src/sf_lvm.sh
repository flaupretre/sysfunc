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
# Section: Logical volume manager
#=============================================================================

##----------------------------------------------------------------------------
# Checks if a given logical volume exists
#
# Args:
#	$1: VG name
#	$2: LV name
# Returns: 0 if it exists, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_lv_exists
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

function sf_vg_exists
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

function sf_create_lv
{
typeset lv vg size sz_opt rc
rc=0
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
		if [ -z "$sf_noexec" ] ; then
			lvcreate $sz_opt -n $lv $vg
			rc=$?
		fi
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

function sf_create_vg
{
typeset vg pesize device rc
rc=0
vg=$1
pesize=$2
device=$3

sf_vg_exists $vg && return 0

sf_msg1 "Creating VG $vg"

case "`uname -s`" in
	Linux)
		if [ -z "$sf_noexec" ] ; then
			vgcreate -s $pesize $vg /dev/$device
			rc=$?
		fi
		;;
	*)
		sf_unsupported sf_create_vg
		;;
esac

return $rc
}

##------------------------------------------------
# Returns the VG containing a given LV
#
# Args:
#	$1: LV device path
# Returns: Always 0
# Displays: The containing VG name, or nothing if device is not a valid LV.
#------------------------------------------------

function sf_lv_to_vg
{
lvs --noheadings -o vg_name "$1" 2>/dev/null | sed 's/^ //g'
}

##------------------------------------------------
# Returns the available size in a VG (in Mb)
#
# Args:
#	$1: VG name
# Returns: Always 0
# Displays: The available size in Mbytes. Nothing if VG does not exist.
#------------------------------------------------

function sf_lvm_vg_free
{
vgs --noheading --nosuffix -o vg_free --units m rootvg 2>/dev/null \
	| sed -e 's/^  *//g' -e 's/\..*$//'
}

#=============================================================================
