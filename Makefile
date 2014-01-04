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

SOFTWARE_NAME = sysfunc

include config.mk

TGZ_PREFIX = $(SOFTWARE_NAME)-$(SOFTWARE_VERSION)
TGZ_FILE = $(TGZ_PREFIX).tar.gz

#=====================================

all: ppc

.PHONY: ppc clean tgz install all rpm

ppc: sysfunc.sh.ppc

sysfunc.sh.ppc:
	chmod +x build/build.sh
	build/build.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

install: sysfunc.sh.ppc
	chmod +x build/install.sh
	build/install.sh $(INSTALL_DIR)

spec: $(SOFTWARE_NAME).spec

$(SOFTWARE_NAME).spec: build/$(SOFTWARE_NAME).spec.in
	chmod +x build/mkspec.sh
	build/mkspec.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

tgz: $(TGZ_FILE)

$(TGZ_FILE): clean
	/bin/rm -rf /tmp/$(TGZ_PREFIX)
	mkdir /tmp/$(TGZ_PREFIX)
	tar cf - . | ( cd /tmp/$(TGZ_PREFIX) ; tar xpf - )
	( cd /tmp ; tar cf - ./$(TGZ_PREFIX) ) | gzip >/tmp/$(TGZ_FILE)
	/bin/rm -rf /tmp/$(TGZ_PREFIX)
	mv /tmp/$(TGZ_FILE) .

rpm: tgz spec
	rpmbuild -bb --define="_sourcedir `pwd`" $(SOFTWARE_NAME).spec
	
clean:
	/bin/rm -rf sysfunc.sh.ppc $(SOFTWARE_NAME).spec $(TGZ_FILE)

#============================================================================
