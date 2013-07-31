
PROJECT=sysfunc

PPC_DIR=../../../ppc

TARGETS = func_ref.htm func_ref.md

#-----------------

.PHONY: clean

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
