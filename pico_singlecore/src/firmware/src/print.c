// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

#include "print.h"

void print_chr(char ch)
{
	*((volatile unsigned int*)OUTPORT) = ch;
}

void print_str(const char *p)
{
	while (*p != 0)
		*((volatile unsigned int*)OUTPORT) = *(p++);
}


void print_dec(unsigned int val)
{
	print_chr('n');
	print_chr('o');
	print_chr('p');
	print_chr('e');
	print_chr('\n');
}


void print_hex(unsigned int val, int digits)
{
	for (int i = (4*digits)-4; i >= 0; i -= 4)
		*((volatile unsigned int*)OUTPORT) = "0123456789ABCDEF"[(val >> i) % 16];
	print_chr('\n');
}

