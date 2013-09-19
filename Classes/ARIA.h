/*
 *  ARIA.h
 *  ㅁㄴㅇㄹ
 *
 *  Created by nicejin on 11. 2. 16..
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import <stdio.h>
#import <stdlib.h>

typedef unsigned char Byte;

void DL (const Byte *i, Byte *o);
void RotXOR (const Byte *s, int n, Byte *t);
void printBlock(Byte *b);
int EncKeySetup(const Byte *w0, Byte *e, int keyBits);
int DecKeySetup(const Byte *w0, Byte *d, int keyBits);
void Crypt(const Byte *p, int R, const Byte *e, Byte *c);
void printBlockOfLength(Byte *b, int len);
void printBlock(Byte *b);
void ARIA_test();
