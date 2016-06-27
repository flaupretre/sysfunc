#
# Compute and display the 'dist' variable to transmit to rpm
#
# This script is needed because, unlike RHEL 6, RHEL 4 & 5 don't provide
# this value in their rpm build system
#
#============================================================================

. sysfunc

if [ -f /etc/redhat-release ] ; then
	echo ".el`sed 's/^.* release \(.\).*$/\1/' </etc/redhat-release`"
fi

###############################################################################
