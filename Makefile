
TTY	= /dev/tty.usbserial

.PHONY: all
all: install-bin cube.bin

install-bin: install-bin.c
	$(CC) -g -o install-bin install-bin.c

%.bin %.lst: %.asm
	dasm $< -l$*.lst -f2 -v5 -o$@

.PHONY: install
install: install-bin cube.bin
	./install-bin $(TTY) < cube.bin
