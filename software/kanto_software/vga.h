/*
 * vga.h
 *
 *  Created on: May 13, 2013
 *      Author: jy2432
 */

#ifndef VGA_H_
#define VGA_H_

void vga_write_character(char c, unsigned int x, unsigned int y);

void vga_write_string(char *s, unsigned int y);


#endif /* VGA_H_ */
