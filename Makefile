
# WARNING: This definition is redundant with util/config.sh !
# To be replaced by a clean autoconf-based mechanism.

VERSION = 1.1.14

#---

TARGETS = sysfunc.sh

#----------------

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS)

sysfunc.sh: src/sysfunc.sh
	sed -e 's/%VERSION%/$(VERSION)/' <$< >$@

install: sysfunc.sh
	[ -f /usr/bin/sysfunc.sh ] || ln -s /opt/sysfunc/sysfunc.sh /usr/bin/sysfunc.sh

#----------------
