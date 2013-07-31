
PROJECT=sysfunc

PPC_DIR=../../../ppc

TARGETS = func_ref.htm func_ref.md

#-----------------

.PHONY: clean install

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS) doc.tmp

save: clean
	tar cf - . | gzip --best >../save/$(PROJECT)_doc_`date '+%d%b%y_%Hh'`.tgz

#----------------
# Ignores functions starting with '_', sort functions

func_ref.htm:
	cat ../sf_*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" html -e '_' -s
	/bin/rm -f doc.tmp

func_ref.md:
	cat ../sf_*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" md -e '_' -s
	/bin/rm -f doc.tmp

#----------------
# 'install' generates the markdown function ref and copies it to the wiki tree
# Commit/push of the wiki repository must be done then.

install: func_ref.md
	cp func_ref.md ../../wiki/Function-reference.md
