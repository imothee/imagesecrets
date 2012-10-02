//
//  StegMain.h
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

#import <Cocoa/Cocoa.h>
#import "StegView.h"

@interface StegMain : NSView {
	
	IBOutlet StegView		*img;
	IBOutlet NSTextView		*hMesg;
	IBOutlet NSButton		*hide;
	IBOutlet NSButton		*unhide;
	IBOutlet NSTextField	*status;
}

@property (nonatomic, retain) StegView *img;
@property (nonatomic, retain) NSTextView *hMesg;
@property (nonatomic, retain) NSButton *hide;
@property (nonatomic, retain) NSButton *unhide;
@property (nonatomic, retain) NSTextField *status;

-(IBAction)hideMessage:(id)sender;
-(IBAction)unhideMessage:(id)sender;
-(IBAction)clearAll:(id)sender;

@end
