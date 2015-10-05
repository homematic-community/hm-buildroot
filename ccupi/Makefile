BUILDROOT_VERSION=2015.08.1

all: build

buildroot-$(BUILDROOT_VERSION).tar.bz2:
	wget http://git.buildroot.net/buildroot/snapshot/buildroot-$(BUILDROOT_VERSION).tar.bz2

buildroot-$(BUILDROOT_VERSION): buildroot-$(BUILDROOT_VERSION).tar.bz2
	tar xf buildroot-$(BUILDROOT_VERSION).tar.bz2

build/.config: build buildroot-$(BUILDROOT_VERSION)
	cp buildroot.config build/.config

build: buildroot-$(BUILDROOT_VERSION)
	mkdir -p build
	cp buildroot.config build/.config
	cd build && make O=`pwd` -C ../buildroot-$(BUILDROOT_VERSION)
