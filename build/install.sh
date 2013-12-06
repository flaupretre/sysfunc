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

function make_dir
{
[ -d $1 ] || mkdir -p $1
}

#----------

CMD=`basename $0`
cd `dirname $0`/..
BASE_DIR=`/bin/pwd`
INSTALL_BASE=
[ -n "$RPM_BUILD_ROOT" ] && INSTALL_BASE="$RPM_BUILD_ROOT"
INSTALL_TARGET_DIR="$1"
INSTALL_DIR="$INSTALL_BASE$1"

export BASE_DIR INSTALL_DIR

cd $BASE_DIR

#-- Re-create target tree and copy base files

make_dir $INSTALL_DIR

rm -rf $INSTALL_DIR/*

cp sysfunc.sh.ppc $INSTALL_DIR/sysfunc.sh
chmod 500 $INSTALL_DIR/sysfunc.sh

make_dir $INSTALL_BASE/usr/bin
/bin/rm -rf $INSTALL_BASE/usr/bin/sysfunc
ln -s $INSTALL_TARGET_DIR/sysfunc.sh $INSTALL_BASE/usr/bin/sysfunc
/bin/rm -rf $INSTALL_BASE/usr/bin/sysfunc.sh
ln -s $INSTALL_TARGET_DIR/sysfunc.sh $INSTALL_BASE/usr/bin/sysfunc.sh

make_dir $INSTALL_BASE/usr/share/doc/sysfunc
cp -rp COPYING doc/func_ref.* $INSTALL_BASE/usr/share/doc/sysfunc

###############################################################################
