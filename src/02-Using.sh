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
# Section: Using sysfunc
#-----------------------------------------------------------------------------
# # Loading the library #
# 
# The library is loaded using the following directive :
# 
#     . sysfunc
# 
# assuming that /usr/bin is in your path.
# 
# Once the library is loaded, every sysfunc commands are available, prefixed
# with the 'sf_' string.
# 
# # Calling a single function #
# 
# It is possible to call a single function without preloading the library.
# 
# The syntax to use is :
# 
#     sysfunc <command> [args]
# 
# where <command> is the name of a sysfunc function to call, without the
# 'sf_' prefix.
# 
# **Example :**
# 
# The following line creates or updates the 'myvar' DB variable with the current time :
# 
#     sysfunc db_set_timestamp myvar 
# 
# This command is equivalent as executing :
# 
#     . sysfunc
#     sf_db_set_timestamp myvar
# 
# The second form will be preferred when using several function calls in a script,
# as it is faster and avoids specifying 'sysfunc ' before every commands. The first
# form is easier to use when calling a single command, from the command line for
# instance.
# 
# # Checking whether the library is loaded #
# 
# The [function:loaded] function checks if the library is loaded. When using this
# function, you must redirect stderr to /dev/null to avoid displaying an error
# when the library is not loaded (when the library is not loaded, the
# [function:loaded] function won't be found).
# 
# The syntax to use is:
# 
#     sf_loaded 2>/dev/null
# 
# This will set $? to 0 if the library is loaded, and to 1 if not.
# 
# So, you can conditionally load the library using a line like :
# 
#     sf_loaded 2>/dev/null || . sysfunc
# 
# This line causes the library to be loaded only if it was not done already.
# 
# > Tip: When
# > dealing with a set of several shell scripts, include such a
# > directive at the beginning
# > of every script which use sysfunc functions. This way, you ensure that the sysfunc
# > commands
# > are available when you need them, but the library is loaded only once.
#=============================================================================

#=============================================================================
# Section: -
# This pseudo-section creates a separator on the main documentation page.
#=============================================================================
