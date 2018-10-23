# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libnova
#$(PKG)_WEBSITE  := https://github.com/JohannesBuchner/libnova/
#$(PKG)_VERSION  := 0ae301a
#$(PKG)_GH_CONF  := JohannesBuchner/libnova/branches/master
#$(PKG)_URL      := https://github.com/JohannesBuchner/libnova/archive/master.zip

$(PKG)_WEBSITE  := https://http://libnova.sourceforge.net/
$(PKG)_DESCR    := libnova
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.0
$(PKG)_CHECKSUM := 7c5aa33e45a3e7118d77df05af7341e61784284f1e8d0d965307f1663f415bb1
$(PKG)_FILE     := libnova-$($(PKG)_VERSION).tar.gz
$(PKG)_SUBDIR   := libnova-$($(PKG)_VERSION)
#$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/libnova/files/libnova/v $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL      := https://sourceforge.net/projects/libnova/files/libnova/v%200.15.0/libnova-0.15.0.tar.gz/download
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(SOURCE_DIR)' && ./autogen.sh 
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -lnova'; \
     echo 'Cflags.private:';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    # '$(TARGET)-gcc' \
    #     -W -Wall -Werror -ansi -pedantic \
    #     '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
    #     `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
