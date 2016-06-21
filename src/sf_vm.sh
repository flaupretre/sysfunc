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
# Section: Virtual machine
#=============================================================================

##----------------------------------------------------------------------------
# Check if we are on a VMware host
#
# Args: None
# Returns: 0 if VMware, 1 if not
# Displays: Nothing
##----------------------------------------------------------------------------

function sf_vm_host_is_vmware
{
if [ -x /usr/sbin/virt-what ] ; then
	/usr/sbin/virt-what | grep vmware >/dev/null
	return $?
else
	grep VMware /proc/scsi/scsi >/dev/null 2>&1
	return $?
fi
}

#=============================================================================
