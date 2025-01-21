.PHONY: all clean sync backup

all: sync

clean:
	rm -f **/*~
	rm -f **/*.html

sync:
	git add .
	git commit -m "Auto-sync conference notes"

backup:
	tar czf ../popl-2025-backup.tar.gz .
