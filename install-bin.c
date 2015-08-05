/*
 * On Mac OS X and BSD, you can't use stty to set the serial port speed
 * then cp to copy a bin file, because the serial port speed is reset
 * on port close.
 *
 * Hence this program.
 *
 * Use like so: ./install-bin /dev/tty.usbserial < file.bin
 */
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	int tty;
	ssize_t len;
	unsigned char buf[8192];
	struct termios tio;

	tty = open(argv[1], O_WRONLY | O_NOCTTY);
	if (tty < 0) {
		perror("open");
		exit(1);
	}
	cfmakeraw(&tio);
	if (cfsetispeed(&tio, 115200) < 0) {
		perror("cfsetispeed");
		exit(1);
	}
	if (cfsetospeed(&tio, 115200) < 0) {
		perror("cfsetospeed");
		exit(1);
	}
	if (tcsetattr(tty, TCSANOW, &tio) < 0) {
		perror("tcsetattr");
		exit(1);
	}

	for (;;) {
		len = read(0, buf, 8192);
		if (len < 0) {
			perror("read");
			exit (1);
		}
		if (len == 0)
			break;
		len = write(tty, buf, len);
		if (len <= 0) {
			perror("write");
			exit(1);
		}
	}
	close(tty);
	exit(0);
}

