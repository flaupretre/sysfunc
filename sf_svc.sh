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
# Section: Service management
#=============================================================================

##----------------------------------------------------------------------------
# Check if a service is enabled on boot
#
# On Linux, check for current runlevel.
# On Solaris, check for level 3.
#
# Args:
# $1: Service name
# Returns:  0 if enabled, 1 if diasabled, 2 if not installed
# Displays: Nothing
##----------------------------------------------------------------------------

function sf_svc_is_enabled
{
typeset _svc _base _script _snum _knum
_svc=$1

sf_svc_is_installed $_svc || return 2

case "`uname -s`" in
	Linux)
		chkconfig $_svc || return 1
		;;
	SunOS)
		# We don't use states as defined on 'chkconfig' line in service
		# script, as states do not correspond on Solaris.
		_base=`sf_svc_base`
		_script=`sf_svc_script $_svc`
		grep '^# *chkconfig:' $_script | head -1 \
			| sed 's/^.*: *[^ ][^ ]*  *//' | read _snum _knum
		[ -f $_base/rc3.d/S$_snum$_svc ] || return 1
		;;
	*)
		sf_unsupported sf_svc_is_enabled
		;;
esac
return 0
}

##----------------------------------------------------------------------------
# Enable service start/stop at system boot/shutdown
#
# Args:
#	$*: Service names
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_svc_enable
{
typeset _svc _base _script _state _snum _knum

_base=`sf_svc_base`
for _svc in $*
	do
	if ! sf_svc_is_installed $_svc ; then
		sf_error "$_svc: No such service"
		continue
	fi

	case "`uname -s`" in
		Linux)
			chkconfig $_svc
			if [ $? != 0 ] ; then
				sf_msg1 "Enabling service $_svc"
				if [ -z "$sf_noexec" ] ; then
					/sbin/chkconfig --add $_svc
					/sbin/chkconfig $_svc reset
					/sbin/chkconfig $_svc on
				fi
			fi
			;;
		SunOS)
			# We don't use states as defined on 'chkconfig' line in service
			# script, as states do not correspond on Solaris.
			_script=`sf_svc_script $_svc`
			grep '^# *chkconfig:' $_script | head -1 \
				| sed 's/^.*: *[^ ][^ ]*  *//' | read _snum _knum
			for _state in 3 # Start
				do
				sf_check_link ../init.d/$_svc $_base/rc$_state.d/S$_snum$_svc
			done
			for _state in 0 1 2 S # Kill
				do
				sf_check_link ../init.d/$_svc $_base/rc$_state.d/K$_knum$_svc
			done
			;;
		*)
			sf_unsupported sf_svc_enable
			;;
	esac
done
}

##----------------------------------------------------------------------------
# Disable service start/stop at system boot/shutdown
#
# Args:
#	$*: Service names
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_svc_disable
{
typeset _svc _base _script _state _snum _knum _pattern _f

_base=`sf_svc_base`
for _svc in $*
	do
	if ! sf_svc_is_installed $_svc ; then
		sf_trace "$_svc: No such service"
		continue
	fi

	case "`uname -s`" in
		Linux)
			chkconfig $_svc
			if [ $? = 0 ] ; then
				sf_msg1 "$_svc: Disabling service"
				if [ -z "$sf_noexec" ] ; then
					/sbin/chkconfig --del $_svc
				fi
			fi
			;;
		SunOS)
			_pattern="$_base/rc?.d/[KS]??$_svc"
			_f="`ls -l $_pattern | head -1`"
			if [ -f "$_f" ] ; then
				sf_msg1 "$_svc: Disabling service"
				sf_delete $_pattern
			fi
			;;
		*)
			sf_unsupported sf_svc_disable
			;;
	esac
done
}

##----------------------------------------------------------------------------
# Install a service script (script to start/stop a service)
#
# Args:
#	$1: Source script
#	$2: Service name
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_svc_install
{
sf_check_copy "$1" `sf_svc_script $2` 755
}

##----------------------------------------------------------------------------
# Uninstall a service script (script to start/stop a service)
#
# Args:
#	$1: Service name
# Returns: Always 0
# Displays: Info msg
#-----------------------------------------------------------------------------

function sf_svc_uninstall
{
sf_svc_stop $1
sf_svc_disable $1
sf_delete `sf_svc_script $1`
}

##----------------------------------------------------------------------------
# Check if a service script is installed
#
# Args:
#	$1: Service name
# Returns: 0 is installed, 1 if not
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_svc_is_installed
{
[ -x "`sf_svc_script $1`" ]
}

##----------------------------------------------------------------------------
# Start a service
#
# Args:
#	$1: Service name
# Returns: Return code from script execution
# Displays: Output from service script
#-----------------------------------------------------------------------------

function sf_svc_start
{
if sf_svc_is_installed "$1" ] ; then
	`sf_svc_script $1` start
else
	sf_error "$1: Service is not installed"
fi
}

##----------------------------------------------------------------------------
# Stop a service
#
# Args:
#	$1: Service name
# Returns: Return code from script execution
# Displays: Output from service script
#-----------------------------------------------------------------------------

function sf_svc_stop
{
if sf_svc_is_installed "$1" ] ; then
	`sf_svc_script $1` stop
else
	sf_error "$1: Service is not installed"
fi
}

##----------------------------------------------------------------------------
# Check if a service is running
#
# Args:
#	$1: Service name
# Returns: 0 if service is running, 1 if stopped, 2 if not installed
# Displays: Nothing
#-----------------------------------------------------------------------------

function sf_svc_is_up
{
typeset _svc
_svc=$1

sf_svc_is_installed $_svc || return 2

case "`uname -s`" in
	Linux)
		service $_svc status >/dev/null 2>&1 || return 1
		;;
	*)
		sf_unsupported sf_svc_is_up
		;;
esac
return 0
}

##----------------------------------------------------------------------------
# Display the base directory of service scripts
#
# Args: None
# Returns: Always 0
# Displays: String
#-----------------------------------------------------------------------------

function sf_svc_base
{
case `uname -s` in
	Linux)
		echo /etc/rc.d ;;
	SunOS)
		echo /etc ;;
	HP-UX)
		echo /sbin ;;
	*)
		sf_unsupported sf_svc_base ;;
esac
}

##----------------------------------------------------------------------------
# Display the full path of the script corresponding to a given service
#
# Args:
#	$1: Service name
# Returns: Always 0
# Displays: Script path
#-----------------------------------------------------------------------------

function sf_svc_script
{
echo `sf_svc_base`/init.d/$1
}

#=============================================================================
