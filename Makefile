
TTY	= /dev/tty.usbserial

.PHONY: all
all: install-bin flash.bin

install-bin: install-bin.c
	$(CC) -g -o install-bin install-bin.c

%.bin %.txt: %.asm
	dasm $< -l$*.txt -f2 -v5 -o$@

.PHONY: install
install: install-bin flash.bin
	./install-bin $(TTY) < flash.bin
