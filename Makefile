# -*- coding: us-ascii-unix -*-

NAME       = harbour-helsinki-city-bikes
VERSION    = 1.0.205

DESTDIR    =
PREFIX     = /usr
DATADIR    = $(DESTDIR)$(PREFIX)/share/$(NAME)
DESKTOPDIR = $(DESTDIR)$(PREFIX)/share/applications
ICONDIR    = $(DESTDIR)$(PREFIX)/share/icons/hicolor

check:
	pyflakes hcb trackers

clean:
	rm -rf dist
	rm -rf __pycache__ */__pycache__ */*/__pycache__
	rm -rf .cache */.cache */*/.cache
	rm -f rpm/*.rpm

dist:
	$(MAKE) clean
	mkdir -p dist/$(NAME)-$(VERSION)
	cp -r `cat MANIFEST` dist/$(NAME)-$(VERSION)
	tar -C dist -cJf dist/$(NAME)-$(VERSION).tar.xz $(NAME)-$(VERSION)

install:
	@echo "Installing Python files..."
	mkdir -p $(DATADIR)/hcb
	cp hcb/*.py $(DATADIR)/hcb
	@echo "Installing QML files..."
	mkdir -p $(DATADIR)/qml/icons
	cp qml/helsinki-city-bikes.qml $(DATADIR)/qml/$(NAME).qml
	cp qml/[ABCDEFGHIJKLMNOPQRSTUVXYZ]*.qml $(DATADIR)/qml
	cp qml/icons/*.png $(DATADIR)/qml/icons
	@echo "Installing trackers..."
	mkdir -p $(DATADIR)/trackers
	cp trackers/*.json $(DATADIR)/trackers
	cp trackers/*.py $(DATADIR)/trackers
	@echo "Installing desktop file..."
	mkdir -p $(DESKTOPDIR)
	cp data/$(NAME).desktop $(DESKTOPDIR)
	@echo "Installing icons..."
	mkdir -p $(ICONDIR)/86x86/apps
	mkdir -p $(ICONDIR)/108x108/apps
	mkdir -p $(ICONDIR)/128x128/apps
	mkdir -p $(ICONDIR)/256x256/apps
	cp data/helsinki-city-bikes-86.png  $(ICONDIR)/86x86/apps/$(NAME).png
	cp data/helsinki-city-bikes-108.png $(ICONDIR)/108x108/apps/$(NAME).png
	cp data/helsinki-city-bikes-128.png $(ICONDIR)/128x128/apps/$(NAME).png
	cp data/helsinki-city-bikes-256.png $(ICONDIR)/256x256/apps/$(NAME).png

rpm:
	$(MAKE) dist
	mkdir -p $$HOME/rpmbuild/SOURCES
	cp dist/$(NAME)-$(VERSION).tar.xz $$HOME/rpmbuild/SOURCES
	rm -rf $$HOME/rpmbuild/BUILD/$(NAME)-$(VERSION)
	rpmbuild -ba --nodeps rpm/$(NAME).spec
	cp $$HOME/rpmbuild/RPMS/noarch/$(NAME)-$(VERSION)-*.rpm rpm
	cp $$HOME/rpmbuild/SRPMS/$(NAME)-$(VERSION)-*.rpm rpm

test:
	py.test hcb trackers

.PHONY: check clean dist install rpm test
