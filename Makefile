
all: install-bin flash.bin

install-bin: install-bin.c
	$(CC) -g -o install-bin install-bin.c

%.bin: %.asm
	dasm $< -l$*.txt -f3 -v5 -o$@
