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

PROJECT=sysfunc

PPC_DIR=../../../ppc/public

TARGETS = Function-reference.htm Function-reference.md

#-----------------

.PHONY: clean install

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS) doc.tmp

save: clean
	tar cf - . | gzip --best >../save/$(PROJECT)_doc_`date '+%d%b%y_%Hh'`.tgz

#----------------
# Ignores functions starting with '_', sort functions

Function-reference.htm:
	cat ../sf_*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" html -e '_' -s
	/bin/rm -f doc.tmp

Function-reference.md:
	cat ../sf_*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" md -e '_' -s
	/bin/rm -f doc.tmp

#----------------
# 'install' generates the markdown function ref and copies it to the wiki tree
# Commit/push of the wiki repository must be done then.

install: Function-reference.md
	cp Function-reference.md ../../wiki/Function-reference.md
