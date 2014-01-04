
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
