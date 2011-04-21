
# WARNING: This definition is redundant with util/config.sh !
# To be replaced by a clean autoconf-based mechanism.

VERSION = 1.1.4

#---

TARGETS = sysfunc.sh

#----------------

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS)

sysfunc.sh: src/sysfunc.sh
	sed -e 's/%VERSION%/$(VERSION)/' <$< >$@

#----------------
