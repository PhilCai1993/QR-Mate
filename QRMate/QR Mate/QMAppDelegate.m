//
//  QMAppDelegate.m
//  QR Mate
//
//  Created by Phil Cai on 14-3-29.
//  Copyright (c) 2014年 Phil Cai Bot. All rights reserved.
//

#import "QMAppDelegate.h"




@implementation QMAppDelegate {
    NSString *thePath;
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //textview url detector
    NSError *error = NULL;
    dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    if (error) {
        dataDetector = nil;
    }
    [self.textView setString:@"QR Mate designed by PhilCai"];
    [self.textView didChangeText];

    //over
    
    //button

    NSImage *clickImage = [NSImage imageNamed:@"sharebutton.png"];
    [clickImage setSize:NSMakeSize(self.clickButton.bounds.size.width, self.clickButton.bounds.size.height*0.9)];
    [self.clickButton setImage:clickImage];
    //
    
    [self.qrImageView setImage:[NSImage imageNamed:@"initImage"]];
    [self.resultTextField setStringValue:@"QR Mate designed by PhilCai"];

    [self.window setBackgroundColor:[NSColor colorWithCalibratedWhite:0.91 alpha:1]];


    
}

- (void)applicationWillTerminate:(NSNotification *)notification {
   
}


-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

-(IBAction)grab:(id)sender {
    NSTask *captureTask = [[NSTask alloc] init];
    //    captureTask.launchPath = @"usr/sbin/screencapture";
    captureTask.launchPath = @"/usr/sbin/screencapture";
    captureTask.arguments = [NSArray arrayWithObjects:@"-i",@"-c", nil];

        [captureTask setTerminationHandler:^(NSTask *t){
            NSPasteboard *pboard = [NSPasteboard generalPasteboard];
            NSPasteboardItem *pboardItem = [[pboard pasteboardItems] objectAtIndex:0];
            NSString *pboardItemType = [[pboard types] objectAtIndex:0];
            NSData *imgData = [pboardItem dataForType:pboardItemType];
            NSImage *img = [[NSImage alloc] initWithData:imgData];
            if (img) {
//                [img setSize:NSMakeSize(336, 336)];
                [self.qrImageView setImage:img];
                [self qrDecode];
                
            }else{
                NSLog(@"Please catch a pic");
            }
           
            
        }
         ];
    
        [captureTask launch];
}




-(void)dragViewFile:(NSString *)filePath{

//    NSLog(@"Filepath received:%@",filePath);
    
    thePath = filePath;
    NSImage *i = [[NSImage alloc] initWithContentsOfFile:filePath];
//    NSImage *i = [NSImage imageNamed:@"HashGround.png"];
    [self.qrImageView setImage:i];
    [self qrDecode];
}




-(CGImageRef)nsimage2cgimageref:(NSImage*)image{
    NSData*imgData = [image TIFFRepresentation];
    CGImageRef ref;

        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imgData, NULL);
        ref = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);

    return ref ;
}

-(void)qrDecode{
    CGImageRef imageToDecode;  // Given a CGImage in which we are looking for barcodes
    imageToDecode =[self nsimage2cgimageref: self.qrImageView.image];
    ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError* error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints* hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
    ZXResult* result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        NSString* contents = result.text;
        NSLog(@"%@",contents);
        [self.resultTextField setStringValue:contents];
        [self.textView setString:contents];

        
        
        //
        NSString *string = [_textView.textStorage string];
        NSArray *matches = [dataDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        [_textView.textStorage beginEditing];
        [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [string length])];
        [_textView.textStorage removeAttribute:NSLinkAttributeName range:NSMakeRange(0, [string length])];
        for(NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            if ([match resultType]==NSTextCheckingTypeLink) {
                NSURL *url = [match URL];
                [_textView.textStorage addAttributes:@{NSLinkAttributeName:url.absoluteString} range:matchRange];
            }
        }
        [_textView.textStorage endEditing];
        //
        
        

    } else {
        NSLog(@"NO result");
        [self.resultTextField setStringValue:@"Sorry,cannot decode."];
        [self.textView setString:@"Sorry,cannot decode."];

    }
}


+ (NSMenu *)defaultMenu {
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Sharing Menu"];
//    [theMenu insertItemWithTitle:@"Save on Desktop" action:@selector(saveOnDesktop) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Share on Weibo" action:@selector(shareOnWeibo) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Share on Twitter" action:@selector(shareOnTwitter) keyEquivalent:@"" atIndex:1];
    [theMenu insertItemWithTitle:@"Share on Tencent Weibo" action:@selector(shareOnTencent) keyEquivalent:@"" atIndex:2];
    return theMenu;
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent
{
    NSPoint mouseLocation = [NSEvent mouseLocation];
//    NSPoint mouseLocation = NSMakePoint(0, 0);
    // 1. Create transparent window programmatically.
    
    NSRect frame = NSMakeRect(mouseLocation.x, mouseLocation.y, 200, 200);
    NSWindow* newWindow  = [[NSWindow alloc] initWithContentRect:frame
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
    [newWindow setAlphaValue:0];
    [newWindow makeKeyAndOrderFront:NSApp];
    
    NSPoint locationInWindow = [newWindow convertScreenToBase: mouseLocation];
    
    // 2. Construct fake event.
    
    int eventType = NSLeftMouseDown;
    
    NSEvent *fakeMouseEvent = [NSEvent mouseEventWithType:eventType
                                                 location:locationInWindow
                                            modifierFlags:0
                                                timestamp:0
                                             windowNumber:[newWindow windowNumber]
                                                  context:nil
                                              eventNumber:0
                                               clickCount:0
                                                 pressure:0];
    // 3. Pop up menu
    [NSMenu popUpContextMenu:[[self class]defaultMenu] withEvent:fakeMouseEvent forView:[newWindow contentView]];
}

-(void)saveOnDesktop{
//    NSLog(@"save on desktop");
//    NSArray* paths = NSSearchPathForDirectoriesInDomains
//    ( NSDesktopDirectory, NSUserDomainMask, NO );
//    NSString *theDesktopPath = [paths objectAtIndex:0];
//    NSLog(@"%@",theDesktopPath);
//
////    NSImage *image = self.qrImageView.image;
////    NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
////    NSData *data = [imgRep representationUsingType: NSPNGFileType properties: nil];
////    [data writeToFile: @"/Users/PhilCai/Desktop/qr.png" atomically: YES];
//
//    [self saveImage:self.qrImageView.image];
}
-(void)shareOnWeibo{
    NSLog(@"share on weibo");
    NSSharingService *weiboSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNamePostOnSinaWeibo];
    NSMutableArray *shareItems = [[NSMutableArray alloc] initWithObjects:self.textView.textStorage.string,self.qrImageView.image,nil];
    [weiboSharingService performWithItems:shareItems];

}
-(void)shareOnTwitter{
    NSLog(@"share on Twitter");
    NSSharingService *twitterSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNamePostOnTwitter];
    NSMutableArray *shareItems = [[NSMutableArray alloc] initWithObjects:self.textView.textStorage.string,self.qrImageView.image,nil];
    [twitterSharingService performWithItems:shareItems];
}
-(void)shareOnTencent{
    NSLog(@"TencentWeibo");
    NSSharingService *tencentSharingService = [NSSharingService sharingServiceNamed:NSSharingServiceNamePostOnTencentWeibo];
    NSMutableArray *shareItems = [[NSMutableArray alloc] initWithObjects:self.textView.textStorage.string,self.qrImageView.image,nil];
    [tencentSharingService performWithItems:shareItems];
}
-(IBAction)buttonClicked:(id)sender{
    [self hotkeyWithEvent:nil];
}



-(void)textDidChange:(NSNotification *)notification {
//    NSLog(@"text changed");
    if (notification.object==_textView) {
        if (dataDetector) {
            NSString *string = [_textView.textStorage string];
            if (string.length==0) {
                NSImage *dropImage = [NSImage imageNamed:@"DropImage"];
                [dropImage setSize:NSMakeSize(336, 336)];
                [self.qrImageView setImage:dropImage];

            }
            else{
            [self.qrImageView setImage:[QRCodeGenerator qrImageForString:string imageSize:self.qrImageView.bounds.size.width]];
            }
            NSArray *matches = [dataDetector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
            [_textView.textStorage beginEditing];
            [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, [string length])];
            [_textView.textStorage removeAttribute:NSLinkAttributeName range:NSMakeRange(0, [string length])];
            for(NSTextCheckingResult *match in matches) {
                NSRange matchRange = [match range];
                if ([match resultType]==NSTextCheckingTypeLink) {
                    NSURL *url = [match URL];
                    [_textView.textStorage addAttributes:@{NSLinkAttributeName:url.absoluteString} range:matchRange];
                }
            }
            [_textView.textStorage endEditing];
        }
    }
}

- (IBAction)saveImage:(id)sender
{
        NSLog(@"save on desktop");
        NSArray* paths = NSSearchPathForDirectoriesInDomains
        ( NSDesktopDirectory, NSUserDomainMask, NO );
        NSString *theDesktopPath = [paths objectAtIndex:0];
        NSLog(@"%@",theDesktopPath);
    NSImage *image = [NSImage imageNamed:@"sharebutton.png"];
    [image lockFocus];
    //先设置 下面一个实例
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, 250, 250)];
    [image unlockFocus];
    
    //再设置后面要用到得 props属性
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    
    
    //之后 转化为NSData 以便存到文件中
    NSData *imageData = [bits representationUsingType:NSJPEGFileType properties:imageProps];
    
    //设定好文件路径后进行存储就ok了
//    [imageData writeToFile:theDesktopPath atomically:YES];
    [imageData writeToURL:[NSURL URLWithString:@"/Users/PhilCai/Desktop/my.png"] atomically:YES];
}
-(IBAction)help:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://philcai.com/qr-mate"]];

}
@end
