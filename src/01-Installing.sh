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
# Section: Installing sysfunc
#-----------------------------------------------------------------------------
# #Installing from a package
# 
# RHEL RPM packages are available from [Sourceforge](https://sourceforge.net/projects/sysfunc/files/).
# 
# Packages named '.el5' are for RHEL 4 & 5. Those named '.el6' are for RHEL 6.
# 
# Depending on your operating system, other packages may be available from alternate sources.
# 
# #Installing from the source tar file
# 
# Sysfunc is a shell library, so it does not require to be compiled before installation. The only tool you
# need to install the software from the source tar file is the __make__ utility.
# 
# Here are the steps to follow :
# 
# - Download the tar-gzipped package file from [Sourceforge](https://sourceforge.net/projects/sysfunc/files/),
# - gunzip it,
# - cd to the place where it was extracted, and run :
# 
# 		make install
# 
# - If you want the library not to be installed in the default location (/opt/sysfunc), the command becomes :
# 
# 		make install INSTALL_DIR=<path>
# 
# That's all.
# 
# Check the installation by running :
# 
#     sysfunc tm_now
# 
# which should display the current date and time.
# 
#=============================================================================
