# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := e5073f3c6b816e7fa67d359d9745a5bb5de94a628ac85f624c992925a46844f9
$(PKG)_SUBDIR   := gtkglext-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglext/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtk2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/cgit/gtkglext/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --without-x \
        --with-gdktarget=win32 \
        --disable-gtk-doc \
        --disable-man \
        --disable-glibtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS= \
        GDKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`' \
        GTKGLEXT_DEP_CFLAGS='`'$(TARGET)-pkg-config' gtk+-2.0 --cflags`'

    '$(TARGET)-gcc' \
        -W -Wall -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtkglext.exe' \
        `'$(TARGET)-pkg-config' gtkglext-1.0 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
