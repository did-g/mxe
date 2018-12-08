# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wxwidgets31
$(PKG)_WEBSITE  := https://www.wxwidgets.org/
$(PKG)_DESCR    := wxWidgets
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := c925dfe17e8f8b09eb7ea9bfdcfcc13696a3e14e92750effd839f5e10726159e
$(PKG)_GH_CONF := wxWidgets/wxWidgets/releases/latest,v
$(PKG)_SUBDIR   := wxWidgets-$($(PKG)_VERSION)
$(PKG)_FILE     := wxWidgets-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/wxWidgets/wxWidgets/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat jpeg libiconv libpng sdl tiff zlib


define $(PKG)_CONFIGURE_OPTS
        $(MXE_CONFIGURE_OPTS) \
        --disable-option-checking \
        --enable-gui \
        --disable-stl \
        --enable-threads \
        --disable-universal \
        --with-themes=all \
        --with-msw \
        --with-opengl \
        --with-libpng=sys \
        --with-libjpeg=sys \
        --with-libtiff=sys \
        --with-regex=yes \
        --with-zlib=sys \
        --with-expat=sys \
        --with-sdl \
        --without-gtk \
        --without-macosx-sdk \
        --without-libxpm \
        --without-libmspack \
        --without-gnomevfs \
        --without-dmalloc \
        LIBS=" `'$(TARGET)-pkg-config' --libs-only-l libtiff-4`" \
        CXXFLAGS='-std=gnu++11' \
        CXXCPP='$(TARGET)-g++ -E -std=gnu++11'
endef

define $(PKG)_BUILD
    # build the wxWidgets variant with unicode support
    mkdir '$(1).unicode'
    cd    '$(1).unicode' && '$(1)/configure' \
        $($(PKG)_CONFIGURE_OPTS) \
        --enable-unicode
    $(MAKE) -C '$(1).unicode' -j '$(JOBS)' \
        $(MXE_DISABLE_CRUFT)
    -$(MAKE) -C '$(1).unicode/locale' -j '$(JOBS)' allmo \
        $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(1).unicode' -j 1 install \
        $(if $(BUILD_SHARED),DLLDEST='/../bin') \
        $(MXE_DISABLE_CRUFT) __install_wxrc___depname=
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/wx-config' \
                     '$(PREFIX)/bin/$(TARGET)-wx-config'

    # build test program
    '$(PREFIX)/bin/$(TARGET)-g++' \
        -W -Wall -Werror -Wno-error=unused-local-typedefs -pedantic -std=gnu++0x \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-wxwidgets.exe' \
        `'$(TARGET)-wx-config' --cflags --libs`
endef

