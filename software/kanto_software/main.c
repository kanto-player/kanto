#include <stdio.h>
#include <system.h>
#include <io.h>
#include <stdint.h>

#define KANTO_BLOCKADDR 0
#define KANTO_READBLOCK 4
#define KANTO_PLAY 8
#define KANTO_STOP 12
#define KANTO_DONE 16

#define wait_for_done() while (!IORD_8DIRECT(KANTO_CTRL_BASE, KANTO_DONE))

int main()
{
    uint32_t blockaddr;

    printf("Hello, Kanto\n");
    // wait for sd card to become ready
    wait_for_done();
    printf("Starting initialization\n");
    // set the block address back to the beginning
    IOWR_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR, 0);
    // pulse the readblock signal
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_READBLOCK, 1);
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_READBLOCK, 0);
    wait_for_done();
    printf("First block read\n");
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_STOP, 0);
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 1);
    printf("Playing audio\n");

    for (;;) {
    	blockaddr = IORD_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR);
    }

	return 0;
}
