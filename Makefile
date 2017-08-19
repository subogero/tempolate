install: README.md
	cp lib/Tempolate.pm $(DESTDIR)/usr/share/perl5
uninstall:
	rm $(DESTDIR)/usr/share/perl5/Tempolate.pm
README.md: lib/Tempolate.pm
	pod2markdown $< >README.md
