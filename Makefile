PREFIX = /usr
SYSCONFDIR = /etc
pkgname = subs2srs
CSFLAGS = -target:winexe -unsafe

SOURCES = $(wildcard subs2srs/*.cs) \
          $(wildcard subs2srs/SubtitleCreator/*.cs) \
          subs2srs/Properties/AssemblyInfo.cs \
          subs2srs/Properties/Resources.Designer.cs \
          subs2srs/Properties/Settings.Designer.cs

RESX = $(wildcard subs2srs/*.resx)
RESOURCES = $(RESX:.resx=.resources)

build: $(RESOURCES)
	cd subs2srs && mcs $(CSFLAGS) -out:subs2srs.exe \
		-r:System.Windows.Forms \
		-r:System.Drawing \
		-r:System.Data \
		-r:./TagLibSharp.dll \
		*.cs SubtitleCreator/*.cs \
		Properties/AssemblyInfo.cs \
		Properties/Resources.Designer.cs \
		Properties/Settings.Designer.cs \
		$(foreach res,$(notdir $(RESOURCES)),-resource:$(res),subs2srs.$(res)) \
		-resource:Properties/Resources.resx \
		-win32icon:Resources/Icon.ico

%.resources: %.resx
	resgen $< $@

install: build
	install -Dm644 subs2srs/subs2srs.exe       $(DESTDIR)/opt/$(pkgname)/subs2srs.exe
	install -Dm644 subs2srs/TagLibSharp.dll     $(DESTDIR)/opt/$(pkgname)/TagLibSharp.dll
	install -Dm644 subs2srs/preferences.txt     $(DESTDIR)/opt/$(pkgname)/preferences.txt
	install -dm755 $(DESTDIR)/opt/$(pkgname)/Utils/SubsReTimer
	cp -r subs2srs/Utils/SubsReTimer/*          $(DESTDIR)/opt/$(pkgname)/Utils/SubsReTimer/
	install -dm755 $(DESTDIR)/opt/$(pkgname)/Utils/ffmpeg/presets
	cp subs2srs/Utils/ffmpeg/presets/*           $(DESTDIR)/opt/$(pkgname)/Utils/ffmpeg/presets/
	install -dm755 $(DESTDIR)/opt/$(pkgname)/Utils/mkvtoolnix
	install -dm755 $(DESTDIR)/opt/$(pkgname)/Utils/mp3gain
	ln -sf /usr/bin/ffmpeg     $(DESTDIR)/opt/$(pkgname)/Utils/ffmpeg/ffmpeg.exe
	ln -sf /usr/bin/mp3gain    $(DESTDIR)/opt/$(pkgname)/Utils/mp3gain/mp3gain.exe
	ln -sf /usr/bin/mkvextract $(DESTDIR)/opt/$(pkgname)/Utils/mkvtoolnix/mkvextract.exe
	ln -sf /usr/bin/mkvinfo    $(DESTDIR)/opt/$(pkgname)/Utils/mkvtoolnix/mkvinfo.exe
	install -Dm755 dist/subs2srs.sh             $(DESTDIR)$(PREFIX)/bin/subs2srs
	install -Dm644 dist/subs2srs.desktop        $(DESTDIR)$(PREFIX)/share/applications/subs2srs.desktop
	install -Dm644 dist/subsretimer.desktop     $(DESTDIR)$(PREFIX)/share/applications/subsretimer.desktop
	install -Dm644 dist/90-avoid-microsoft-sans-serif.conf \
		$(DESTDIR)$(PREFIX)/share/fontconfig/conf.avail/90-avoid-microsoft-sans-serif.conf
	install -dm755 $(DESTDIR)$(SYSCONFDIR)/fonts/conf.d
	ln -sf $(PREFIX)/share/fontconfig/conf.avail/90-avoid-microsoft-sans-serif.conf \
		$(DESTDIR)$(SYSCONFDIR)/fonts/conf.d/90-avoid-microsoft-sans-serif.conf
	install -Dm644 gpl.txt $(DESTDIR)$(PREFIX)/share/licenses/$(pkgname)/LICENSE

uninstall:
	rm -rf $(DESTDIR)/opt/$(pkgname)/
	rm -f $(DESTDIR)$(PREFIX)/bin/subs2srs
	rm -f $(DESTDIR)$(PREFIX)/share/applications/subs2srs.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/applications/subsretimer.desktop
	rm -f $(DESTDIR)$(PREFIX)/share/fontconfig/conf.avail/90-avoid-microsoft-sans-serif.conf
	rm -f $(DESTDIR)$(SYSCONFDIR)/fonts/conf.d/90-avoid-microsoft-sans-serif.conf
	rm -rf $(DESTDIR)$(PREFIX)/share/licenses/$(pkgname)/

clean:
	rm -f subs2srs/*.resources subs2srs/subs2srs.exe

.PHONY: build install uninstall clean
