//
//  StegMain.m
//  ImageSecrets
//
//  Created by Timothy Marks on 19/09/09.
//  Copyright 2009 Imothee. All rights reserved.
//
//  This file is part of ImageSecrets.
// 
//  ImageSecrets is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  ImageSecrets is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with ImageSecrets.  If not, see <http://www.gnu.org/licenses/>.

#import "StegMain.h"


@implementation StegMain

@synthesize img, hMesg, hide, unhide, status;

-(id)init{
	
	self = [super init];
	
	[NSApp setDelegate:self];
	
	return self;
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

-(IBAction)hideMessage:(id)sender{

	NSString *filename = [NSString stringWithString:[img currentImage]];
	
	if([filename length] == 0){
		[status setStringValue:@"You must add a file."];
		return;
	}
	
	NSString *message = [NSString stringWithString:[hMesg string]];
	
	NSImage *tmp = [img image];
	
	NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[tmp TIFFRepresentation]];
	
	int BytesPRow, SamplesPerPix;
	int x, y, w, h;
	
	BytesPRow = [rep bytesPerRow];
	SamplesPerPix = [rep samplesPerPixel];
	w = [rep pixelsWide];
	h = [rep pixelsHigh];
	
	x = 0;
	y = 0;
	
	int msgLen = [message length];
	char msgbits[1000];
	
	unsigned char mask_table[] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
	
	int msgCount = 0;
	
	char msgEncodeLen = msgLen;
	for(int j=7; j >= 0; j--){
		char curbit = (msgEncodeLen & mask_table[j]) != 0x00;
		msgbits[msgCount++] = curbit;
	}
	
	for(int i=0; i < msgLen; i++){
		char curChar = [message characterAtIndex:i];
		for(int j=7; j >= 0; j--){
			char curbit = (curChar & mask_table[j]) != 0x00;
			msgbits[msgCount++] = curbit;
		}
	}
	
	int msgHidden = 0;
	for (y=0; y<h; y++) {
        for (x=0; x<w; x++) {
			if(msgHidden >= msgCount){
				break;
			}
			
			NSColor *pxC = [rep colorAtX:x y:y];
			
			CGFloat rc, gc, bc, ac;
			
			rc = [pxC redComponent];
			gc = [pxC greenComponent];
			bc = [pxC blueComponent];
			ac = [pxC alphaComponent];
			
			unsigned char blueNess = (char) bc * 255;
			
			if(msgbits[msgHidden] == 0){
				blueNess &= 0xFE;
			}else{
				blueNess |= 0x01;
			}
			
			bc = blueNess / 255.0;
			
			NSColor *pCol = [NSColor colorWithDeviceRed:rc green:gc blue:bc alpha:ac];
			
			[rep setColor:pCol atX:x y:y];
			
			msgHidden++;
        }
		if(msgHidden >= msgCount){
			break;
		}
    }
	
	NSString *filetype = [filename pathExtension];
	NSString *filepath = [filename stringByDeletingPathExtension];
	
	NSData *sv;
	if(filetype == @"jpg"){
		sv = [rep representationUsingType:NSJPEGFileType properties:nil];
	}else if(filetype == @"gif"){
		sv = [rep representationUsingType:NSGIFFileType properties:nil];
	}else{
		sv = [rep representationUsingType:NSPNGFileType properties:nil];
		filetype = @"png";
	}
	//
	
	filename = [NSString stringWithFormat:@"%@.hidden.%@", filepath, filetype];
		
	[sv writeToFile:filename
				atomically:YES];
	
	[status setStringValue:@"Message Hidden"];
	[hMesg setString:@""];
	
	[img setImage:nil];
	
}

-(IBAction)unhideMessage:(id)sender{

	NSString *filename = [NSString stringWithString:[img currentImage]];
	
	if([filename length] == 0 || filename == nil){
		[status setStringValue:@"You must add a file."];
		return;
	}
	
	NSImage *tmp = [img image];
	
	NSBitmapImageRep *rep = [NSBitmapImageRep imageRepWithData:[tmp TIFFRepresentation]];
	
	int BytesPRow, SamplesPerPix;
	int x, y, w, h;
	Byte *dat;
	
	BytesPRow = [rep bytesPerRow];
	SamplesPerPix = [rep samplesPerPixel];
	dat = [rep bitmapData];
	w = [rep pixelsWide];
	h = [rep pixelsHigh];
	
	x = 0;
	y = 0;
	
	char msgbits[1000];
	
	unsigned char mask_table[] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
	
	int msgUnhidden = 0;
	int msgLen = 100;
	
	for (y=0; y<h; y++) {
        for (x=0; x<w; x++) {
            
			NSColor *pxC = [rep colorAtX:x y:y];
			
			CGFloat rc, gc, bc, ac;
			
			rc = [pxC redComponent];
			gc = [pxC greenComponent];
			bc = [pxC blueComponent];
			ac = [pxC alphaComponent];
			
			unsigned char blueNess = bc * 255;
			
			unsigned char curbit = (blueNess & mask_table[0]) != 0x00;
			msgbits[msgUnhidden++] = curbit;
			
			if(msgUnhidden == 8){
				char oneByte = 0;
				for(int j=0; j < 8; j++){
					oneByte |= msgbits[j] << 7-j;
				}
				msgLen = (oneByte + 1) * 8;
			}
			if(msgUnhidden > msgLen){
				break;
			}
        }
		if(msgUnhidden > msgLen){
			break;
		}
    }
	
	msgUnhidden = 8;
	char result[100];
	while(msgUnhidden < msgLen){
		char oneByte = 0;
		for(int i=0; i < 8; i++){
			oneByte |= msgbits[msgUnhidden+i] << 7-i;
		}
		result[(msgUnhidden / 8)-1] = oneByte;
		msgUnhidden += 8;
	}
	result[(msgUnhidden / 8)-1] = 0;
	
	NSString *message = [NSString stringWithCString:result encoding:NSASCIIStringEncoding];
	[hMesg setString:message];
	[status setStringValue:@"Message Unhidden"];
}

-(IBAction)clearAll:(id)sender{

	[hMesg setString:@""];
	
	[img setImage:nil];
	[status setStringValue:@""];
	
}

@end
