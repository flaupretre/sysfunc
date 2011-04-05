
# WARNING: This definition is redundant with util/config.sh !
# To be replaced by a clean autoconf-based mechanism.

VERSION = 1.1.3

#---

TARGETS = sysfunc.sh

#----------------

all: sysfunc.sh

clean:
	/bin/rm -rf $(TARGETS)

sysfunc.sh: src/sysfunc.sh
	sed -e 's/%VERSION%/$(VERSION)/' <$< >$@

#----------------
