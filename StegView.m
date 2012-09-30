//
//  StegView.m
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

#import "StegView.h"


@implementation StegView

@synthesize currentImage;


- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	if(self.currentImage == nil){
		self.currentImage = [NSString stringWithString:@""];
	}
	[super drawRect:rect];
}

- (void)setImage:(NSImage *)newImage{

	if(newImage == nil){
		self.currentImage = [NSString stringWithString:@""];
	}
	[super setImage:newImage];
	
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		
        // Depending on the dragging source and modifier keys,
        // the file data may be copied or linked
		
        self.currentImage = [NSString stringWithString:[files objectAtIndex:0]];
    }
	
    return [super performDragOperation:sender];
}

@end
