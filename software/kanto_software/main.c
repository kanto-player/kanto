#include <stdio.h>
#include <system.h>
#include <io.h>
#include <stdint.h>
#include "vga.h"

#define KANTO_BLOCKADDR 0
#define KANTO_READBLOCK 4
#define KANTO_PLAY 8
#define KANTO_DONE 12
#define KANTO_TRACK 16
#define KANTO_KEYS 20

#define MAX_TRACKS 8

uint32_t track_table[MAX_TRACKS];
char track_titles[MAX_TRACKS][60];
int track_count = 0;
unsigned char curtrack;
uint32_t track_start;
uint32_t track_end;

unsigned char selected_track;
unsigned char selected_row;
char buffer[81];

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
	int i, j;
	uint32_t word;

	for (i = 0; i < MAX_TRACKS; i++) {
		track_table[i] = sdbuf_read_word(i * 16);
		if (track_table[i] != 0)
			track_count++;
		for (j = 0; j < 15; j += 1) {
			word = sdbuf_read_word(i * 16 + 1 + j);
			track_titles[i][j * 4 + 0] = word >> 24 & 0xff;
			track_titles[i][j * 4 + 1] = word >> 16 & 0xff;
			track_titles[i][j * 4 + 2] = word >> 8 & 0xff;
			track_titles[i][j * 4 + 3] = word >> 0 & 0xff;
		}
		printf("%i.  %s\n", i, (char * ) &track_titles[i]);
	}
	track_count--;
	printf("Track count: %d\n", track_count);
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

void selection_up()
{
	if (selected_track == 0)
		return;
	if (selected_row == 0) {
		int x, i;;
		for (x = 1, i = --selected_track; i < track_count && x < 5; x++, i++) {
	    	snprintf(buffer, sizeof(buffer), "%c  %u. %s", (i == selected_track) ? '*' : ' ', i, track_titles[i]);
	    	vga_write_string(buffer, 0, x);
		}
		return;
	}
	vga_write_character(' ', 0, selected_row + 1);
	vga_write_character('*', 0, --selected_row + 1);
	selected_track--;
}

void selection_down()
{
	puts("moving selection down");
}

void selection_play()
{
	puts("playing selection");
}

int ignore_next_key = 0;

void key_receive(uint32_t blockaddr)
{
	unsigned short key;
	key = IORD_8DIRECT(PS2_BASE, 4);

	if (ignore_next_key) {
		ignore_next_key = 0;
		return;
	}

	if (key == 0xf0) {
		ignore_next_key = 1;
		return;
	}

	switch (key) {

	case 0x31: // 'n' next track
		stop_playback();
		seek_to_track(curtrack + 1);
		start_playback();
		break;

	case 0x4d: // 'p' previous track
		stop_playback();
		if ((blockaddr - track_start) < 2 * BLOCK_SECOND)
			seek_to_track(curtrack - 1);
		else
			seek_to_track(curtrack);
		start_playback();
		break;

	case 0x2b: // 'f' fast forward
		stop_playback();
		if (track_end - blockaddr < 5 * BLOCK_SECOND)
			seek_to_track(curtrack + 1);
		else
			read_block(blockaddr + 5 * BLOCK_SECOND);
		start_playback();
		break;

	case 0x32: // 'b' rewind
		stop_playback();
		if (blockaddr - track_start < 5 * BLOCK_SECOND)
			seek_to_track(curtrack);
		else
			read_block(blockaddr - 5 * BLOCK_SECOND);
		start_playback();
		break;

	case 0x3b: // 'j' move down
		//selection_down();
		break;
	case 0x42: // 'k' move up
		//selection_up();
		break;
	case 0x5a: // 'enter' select
		//selection_play();
		break;

	}
}

int main()
{
	uint32_t blockaddr;
	int i, j;

	printf("Hello, Kanto\n");
	vga_write_string("Hello, Kanto", 0, 4);

    // stop playback
    stop_playback();

    printf("Starting initialization\n");
    // read first (metadata) block
    read_block(0);
    setup_track_table();
    printf("Track table read\n");

//    for (i = 0; i < track_count && i < 4; i++) {
//    	snprintf(buffer, sizeof(buffer), "   %u. %s", i, track_titles[i]);
//    	vga_write_string(buffer, 0, i + 1);
//    }

    seek_to_track(0);

    selected_track = 0;
    selected_row = 0;

    printf("First block read\n");

    start_playback();

    printf("Playing audio\n");

    for (;;) {
    	blockaddr = IORD_32DIRECT(KANTO_CTRL_BASE, KANTO_BLOCKADDR);

    	if (IORD_8DIRECT(PS2_BASE, 0)) {
    		key_receive(blockaddr);
    	} else if (blockaddr >= track_end) {
    		curtrack++;
    		check_curtrack();
    		track_end = track_table[curtrack + 1];
    		IOWR_8DIRECT(KANTO_CTRL_BASE, KANTO_TRACK, curtrack);
    	}
    }

	return 0;
}
