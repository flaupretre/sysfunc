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


CMD=`basename $0`
cd `dirname $0`/..
BASE_DIR=`/bin/pwd`

SOFTWARE_VERSION="$1"
INSTALL_DIR="$2"

export BASE_DIR SOFTWARE_VERSION INSTALL_DIR


#==== MAIN ====
#-- Aggregate source files to preprocessed file

cd $BASE_DIR

(
cd src
for i in sf_*.sh ; do
	echo "#>>==== Entering $i"
	cat $i
	echo # force newline at EOF
	echo "#<<==== Exiting $i"
done
cat sysfunc.sh
cd ..
) | sed -e "s,%INSTALL_DIR%,$INSTALL_DIR,g" \
	-e "s,%SOFTWARE_VERSION%,$SOFTWARE_VERSION,g" >sysfunc.sh.ppc
