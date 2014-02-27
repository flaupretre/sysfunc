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
# Section: Message display
#=============================================================================

##----------------------------------------------------------------------------
# Displays a warning message
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Warning message
#-----------------------------------------------------------------------------

function sf_warning
{
sf_msg " *===* WARNING *===* : $1" >&2
}

#----------------------------------------------------------------------------
# Core message display (internal)
#----------------------------------------------------------------------------

function __msg
{
echo "$*"
}

##----------------------------------------------------------------------------
# Displays a message (string)
#
# If the $sf_noexec environment variable is set, prefix the message with '(n)'
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Message
#-----------------------------------------------------------------------------

function sf_msg
{
typeset prefix

prefix=''
[ -n "$sf_noexec" ] && prefix='(n)'
__msg "$prefix$1"
}

##----------------------------------------------------------------------------
# Display trace message
#
# If the $sf_verbose environment variable is set or $sf_verbose_level >= 1,
# displays the message.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message if verbose mode is active, nothing if not
#-----------------------------------------------------------------------------

function sf_trace
{
[ -n "$sf_verbose" -o "$sf_verbose_level" -ge 1 ] && __msg ">>> $*" >&2
}

##----------------------------------------------------------------------------
# Display debug message
#
# If $sf_verbose_level >= 2, displays the message.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message if verbose level set to debug (2) or more
#-----------------------------------------------------------------------------

function sf_debug
{
[ "$sf_verbose_level" -ge 2 ] && __msg "D>> $*" >&2
}

##----------------------------------------------------------------------------
# Displays a message prefixed with spaces
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message prefixed with spaces
#-----------------------------------------------------------------------------

function sf_msg1
{
sf_msg "        $*"
}

##----------------------------------------------------------------------------
# Displays a 'section' message
#
# This is a message prefixed with a linefeed and some hyphens. 
# To be used as paragraph/section title.
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: Message
#-----------------------------------------------------------------------------

function sf_msg_section
{
sf_msg ''
sf_msg "--- $1"
}

##----------------------------------------------------------------------------
# Displays a separator line
#
# Args: None
# Returns: Always 0
# Displays: separator line
#-----------------------------------------------------------------------------

function sf_separator
{
__msg "==================================================================="
}

##----------------------------------------------------------------------------
# Display a new line
#
# Args: None
# Returns: Always 0
# Displays: new line
#-----------------------------------------------------------------------------

function sf_newline
{
__msg
}

##----------------------------------------------------------------------------
# Displays a 'banner' message
#
# The message is displayed with an horizontal separator line above and below
#
# Args:
#	$1 : message
# Returns: Always 0
# Displays: message
#-----------------------------------------------------------------------------

function sf_banner
{
sf_newline
sf_separator
__msg " $1"
sf_separator
sf_newline
}

#=============================================================================
# Section: User interaction
#=============================================================================

##----------------------------------------------------------------------------
# Ask a question to the user
#
# Args:
#	$1 : Question
# Returns: Always 0
# Displays: message to stderr, answer to stdout
#-----------------------------------------------------------------------------

function sf_ask
{
echo "$SHELL" | grep bash >/dev/null
if [ $? = 0 ] ; then
	echo -n "$1 " >&2
else
	echo "$1 \c" >&2
fi

read answer
__msg $answer
}

##----------------------------------------------------------------------------
# Asks a 'yes/no' question, gets answer, and return yes/no code
#
# Works at least for questions in english, french, and german :
# Accepts 'Y', 'O', and 'J' for 'yes' (upper or lowercase), and
# anything different is considered as 'no'
#- If the $sf_forceyes environment variable is set, the user is not asked
# and the 'yes' code is returned.
#
# Args:
#	$1 : Question string
# Returns: 0 for 'yes', 1 for 'no'
# Displays: Question and typed answer if $sf_forceyes not set, nothing if
#            $sf_forceyes is set.
#-----------------------------------------------------------------------------

function sf_yn_question
{
typeset answer

if [ -n "$sf_forceyes" ] ; then
	sf_debug "Forcing answer to 'yes'"
	return 0
fi

answer=`sf_ask "$1"`

__msg
[ "$answer" != o -a "$answer" != O \
	-a "$answer" != y -a "$answer" != Y \
	-a "$answer" != j -a "$answer" != J ] \
	&& return 1

return 0
}

#=============================================================================

# $sf_verbose remains for compatibility. $sf_verbose_level must
# contain a numeric value.

[ -z "$sf_verbose_level" ] && sf_verbose_level=0

export sf_verbose_level
