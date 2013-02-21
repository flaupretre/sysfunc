
PROJECT=sysfunc

PPC_DIR=../../../ppc

TARGETS = func_ref.htm

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
	cat ../*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" -e '_' -s
	/bin/rm -f doc.tmp

#----------------
