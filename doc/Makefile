
PROJECT=sysfunc
SOURCE=../$(PROJECT).sh

PPC_DIR=../../../ppc

TARGETS = func_ref.htm

#-----------------

.PHONY: clean

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS)

save: clean
	tar cf - . | gzip --best >../save/$(PROJECT)_doc_`date '+%d%b%y_%Hh'`.tgz

#----------------
# Ignores functions starting with '_', sort functions

func_ref.htm: $(SOURCE)
	$(PPC_DIR)/mk_sh_doc.sh "$<" "$@" -e '_' -s

#----------------
