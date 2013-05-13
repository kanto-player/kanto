#include <stdio.h>
#include <system.h>
#include <io.h>
#include <stdint.h>

#define KANTO_BLOCKADDR 0
#define KANTO_READBLOCK 4
#define KANTO_PLAY 8
#define KANTO_DONE 12
#define KANTO_TRACK 16
#define KANTO_KEYS 20

#define MAX_TRACKS 128

uint32_t track_table[MAX_TRACKS];
unsigned char curtrack;
uint32_t track_start;
uint32_t track_end;

#define NEXT_TRACK 0x1
#define LAST_TRACK 0x2
#define FAST_FORWARD 0x4
#define REWIND 0x8

/* number of blocks in a second */
#define BLOCK_SECOND (172 * 512)

#define wait_for_done() while (!IORD_8DIRECT(KANTO_CTRL_BASE, KANTO_DONE))

static inline uint32_t sdbuf_read_word(unsigned char offset)
{
	uint32_t word, upper, lower;

	upper = IORD_16DIRECT(SDBUF_BASE, 4 * offset) & 0xffff;
	lower = IORD_16DIRECT(SDBUF_BASE, 4 * offset + 2) & 0xffff;

	word = upper << 16 | lower;

	return word;
}

static inline void stop_playback(void)
{
	IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 0);
	wait_for_done();
}

static inline void start_playback(void)
{
	IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_PLAY, 1);
}

static inline void read_block(uint32_t addr)
{
	IOWR_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR, addr);
	// pulse the readblock signal
	IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_READBLOCK, 1);
	IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_READBLOCK, 0);
	wait_for_done();
}

static inline void setup_track_table(void)
{
	int i;

	for (i = 0; i < MAX_TRACKS; i++) {
		track_table[i] = sdbuf_read_word(i);
	}
}

static inline void check_curtrack(void)
{
	if (track_table[curtrack] == 0 || track_table[curtrack + 1] == 0)
		curtrack = 0;
}

static inline void seek_to_track(int track)
{
	curtrack = track;
	check_curtrack();
	track_start = track_table[curtrack];
	track_end = track_table[curtrack + 1];

	read_block(track_start);
	printf("Setting current track to %d\n", curtrack);
	IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_TRACK, curtrack);
}

int main()
{
    uint32_t blockaddr;
    unsigned char keys;
    unsigned char last_keys;

    printf("Hello, Kanto\n");

    // stop playback
    stop_playback();

    printf("Starting initialization\n");
    // read first (metadata) block
    read_block(0);
    setup_track_table();
    printf("Track table read\n");

    seek_to_track(0);

    printf("First block read\n");

    start_playback();

    printf("Playing audio\n");

    for (;;) {
    	blockaddr = IORD_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR);
    	last_keys = keys;
    	keys = IORD_8DIRECT(KANTO_CTRL_BASE, KANTO_KEYS);

    	if (keys && !last_keys) {
    		stop_playback();
    		if (keys & NEXT_TRACK)
    			seek_to_track(curtrack + 1);
    		else if (keys & LAST_TRACK) {
    			if ((blockaddr - track_start) < BLOCK_SECOND)
    				seek_to_track(curtrack - 1);
    			else
    				seek_to_track(curtrack);
    		} else if (keys & FAST_FORWARD) {
    			if (track_end - blockaddr < 5 * BLOCK_SECOND)
    				seek_to_track(curtrack + 1);
    			else
    				read_block(blockaddr + 5 * BLOCK_SECOND);
    		} else if (keys & REWIND) {
    			if (blockaddr - track_start < 5 * BLOCK_SECOND)
    				seek_to_track(curtrack);
    			else
    				read_block(blockaddr - 5 * BLOCK_SECOND);
    		}
    		start_playback();
    	} else if (blockaddr >= track_end) {
    		curtrack++;
    		check_curtrack();
    		track_end = track_table[curtrack + 1];
    		IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_TRACK, curtrack);
    	}
    }

	return 0;
}
