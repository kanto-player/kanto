#include <stdio.h>
#include <system.h>
#include <io.h>
#include <stdint.h>

#define KANTO_BLOCKADDR 0
#define KANTO_READBLOCK 4
#define KANTO_PLAY 8
#define KANTO_STOP 12
#define KANTO_DONE 16
#define KANTO_TRACK 20
#define KANTO_SKIP 24

#define wait_for_done() while (!IORD_8DIRECT(KANTO_CTRL_BASE, KANTO_DONE))

static inline uint32_t read_sdbuf_word(unsigned char offset)
{
	uint32_t word, upper, lower;

	upper = IORD_16DIRECT(SDBUF_BASE, 4 * offset) & 0xffff;
	lower = IORD_16DIRECT(SDBUF_BASE, 4 * offset + 2) & 0xffff;

	word = upper << 16 | lower;

	return word;
}

int main()
{
    uint32_t blockaddr;
    uint32_t sdbuf_word;
    unsigned char skip;
    int i;

    printf("Hello, Kanto\n");

    // stop playback
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 0);
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
    for (i = 0; i < 128; i++) {
    	sdbuf_word = read_sdbuf_word(i);
    	printf("%x\n", sdbuf_word);
    }
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_TRACK, 0xff);
    IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 1);

    printf("Playing audio\n");

    for (;;) {
    	blockaddr = IORD_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR);
    	skip = IORD_8DIRECT(KANTO_CTRL_BASE, KANTO_SKIP);

    	if (skip & 0x3) {
    		IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 0);
    		wait_for_done();
    	}
    }

	return 0;
}
