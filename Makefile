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

#=====================================
# For a non-default install directory, run 'make ... INSTALL_DIR=<inst_dir>'
#=====================================

SOFTWARE_NAME = sysfunc

include config.mk

TGZ_PREFIX = $(SOFTWARE_NAME)-$(SOFTWARE_VERSION)
TGZ_FILE = $(TGZ_PREFIX).tar.gz
RPM_PATTERN=$(TGZ_PREFIX)-*.noarch.rpm

#=====================================

all: ppc

.PHONY: ppc clean tgz install all rpm

ppc: $(SOFTWARE_NAME).sh.ppc

$(SOFTWARE_NAME).sh.ppc:
	chmod +x build/build.sh
	build/build.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

install: $(SOFTWARE_NAME).sh.ppc
	chmod +x build/install.sh
	build/install.sh $(INSTALL_DIR)

specfile: specfile.in
	chmod +x build/mkspec.sh
	build/mkspec.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

tgz: $(TGZ_FILE)

$(TGZ_FILE): clean
	/bin/rm -rf /tmp/$(TGZ_PREFIX)
	mkdir /tmp/$(TGZ_PREFIX)
	tar cf - . | ( cd /tmp/$(TGZ_PREFIX) ; tar xpf - )
	( cd /tmp ; rm -rf $(TGZ_PREFIX)/.git ; tar cf - ./$(TGZ_PREFIX) ) | gzip >$(TGZ_FILE)
	/bin/rm -rf /tmp/$(TGZ_PREFIX)

rpm: tgz specfile
	chmod +x build/dist.sh
	/bin/rm -rf $(HOME)/rpmbuild/RPMS/noarch/$(RPM_PATTERN)
	rpmbuild -bb --define="_sourcedir `pwd`" --define="dist `build/dist.sh`" specfile
	mv -f $(HOME)/rpmbuild/RPMS/noarch/$(RPM_PATTERN) .
	/bin/rm -rf $(HOME)/rpmbuild/BUILD/$(TGZ_PREFIX)
	
clean:
	/bin/rm -rf $(SOFTWARE_NAME).sh.ppc specfile $(TGZ_FILE) $(RPM_PATTERN)

#============================================================================
