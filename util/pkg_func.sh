#
# Copyright 2010 - Francois Laupretre
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
#
# Utility functions to build packages
#
# Version 1.2
#
#=============================================================================

cleanup()
{
\rm -rf $tmpfile*
}

#------

step()
{
echo
echo "---- $*"
echo
}

#------

env_filter()
{
sed -e "s!%ENVIRONMENT%!$ENVIRONMENT!g"
}

#------

filter()
{
sed \
	-e "s!%VERSION%!$VERSION!g" \
	-e "s!%RELEASE%!$RELEASE!g" \
	-e "s!%PRODUCT%!$PRODUCT!g" \
	-e "s!%DESCRIPTION%!$DESCRIPTION!g" \
	| env_filter
}

#------

ffilter()
{
# $1 = file

cp $1 $tmpfile.ffilter
filter <$tmpfile.ffilter >$1
}

#------
# The empty 'echo' commands are here to fix problems occuring with files whose
# last character is not a newline.

mk_spec()
{
(
cat <<EOF
Name: %PRODUCT%
Summary: %DESCRIPTION%
Version: %VERSION%
Release: %RELEASE%
provides: %PRODUCT%
EOF

cat $udir/specfile
echo

if ! grep '^%description' $udir/specfile >/dev/null ; then
	echo '%description'
	echo '%DESCRIPTION%'
fi

if [ -f $udir/preinstall.sh ] ; then
	echo '%pre'
	cat $udir/config.sh $udir/preinstall.sh
	echo
fi

if [ -f $udir/postinstall.sh ] ; then
	echo '%post'
	cat $udir/config.sh $udir/postinstall.sh
	echo
fi

if [ -f $udir/preuninstall.sh ] ; then
	echo '%preun'
	cat $udir/config.sh $udir/preuninstall.sh
	echo
fi

if [ -f $udir/postuninstall.sh ] ; then
	echo '%postun'
	cat $udir/config.sh $udir/postuninstall.sh
	echo
fi

echo '%files'
if [ -f $udir/files ] ; then
	cat $udir/files
else
	for f in $files; do	echo "$f" ; done
fi
echo
) | filter >$tspec
}

#------

clean_dir()
{
\rm -rf $1
mkdir -p $1
}

#------

copy_tree()
{
# $1=source
# $2=target

clean_dir $2

cd $1
tar cf - . | ( cd $2 ; tar xpf - )
}

#-------

mk_link()
{
# $1=target
# $2=source

\rm -rf $2
mkdir -p `dirname $2`
ln -s $1 $2
}

#-------

build_rpm()
{
if [ -x /bin/rpm ] ; then
	step "Building RPM package"
	mk_spec
	mkdir -p $result_dir/rpm
	if [ -n "$setarch" ] ; then
		setarch $setarch rpmbuild --target $setarch \
			--define="_rpmdir $result_dir/rpm" -bb $tspec
	else
		rpmbuild --define="_rpmdir $result_dir/rpm" -bb $tspec
	fi
fi
}

#-------

build_tgz()
{
step "Building TGZ package"

rfiles=''
for f in $files
	do
	rfiles="$rfiles .$f"
done

cd /
mkdir -p $result_dir/tgz
tgz_file=`echo "$result_dir/tgz/$PRODUCT-$VERSION-$RELEASE.tgz" | env_filter`
tar cf - $rfiles | gzip --best >$tgz_file
echo "Wrote: $tgz_file"
}

#-------

build_packages()
{
build_rpm
build_tgz
}

#-----------------------------------

[ -z "$sdir" ] && sdir="$PWD/.."
[ -z "$udir" ] && udir="$PWD"
result_dir=/tmp/pkg
[ -z "$tmpfile" ] && tmpfile=/tmp/.mk_pack$$
tspec=/tmp/specfile

files=''
[ -f $udir/files ] && files="`awk '{ print $1 }' <$udir/files`"

export result_dir tmpfile tspec files sdir udir

cleanup

#=============================================================================
