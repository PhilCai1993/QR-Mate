//
//  QMAppDelegate.h
//  QR Mate
//
//  Created by Phil Cai on 14-3-29.
//  Copyright (c) 2014年 Phil Cai Bot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "dragview.h"
#import "ZXingObjC.h"
#import "QRCodeGenerator.h"
@class dragview;
@interface QMAppDelegate : NSObject <NSApplicationDelegate,dragviewDelegate>
{
    NSDataDetector *dataDetector;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *qrImageView;
//@property (assign) IBOutlet NSImageView *myView;
@property (assign) IBOutlet NSTextField *resultTextField;
@property (assign) IBOutlet NSTextView *textView;
@property (assign) IBOutlet NSButton *clickButton;
-(IBAction)grab:(id)sender;
-(IBAction)buttonClicked:(id)sender;
- (IBAction)saveImage:(id)sender;
-(IBAction)help:(id)sender;
@end
