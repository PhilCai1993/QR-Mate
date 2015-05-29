//
//  dragview.m
//  draghere
//
//  Created by Phil Cai on 13-9-24.
//  Copyright (c) 2013年 Phil Cai. All rights reserved.
//

#import "dragview.h"

@implementation dragview {
    NSString* filePath;
}


@synthesize delegate = _delegate;
//- (void)dealloc {
//    [self setDelegate:nil];
//    [super dealloc];
//}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /***
         第一步：帮助view注册拖动事件的监听器，可以监听多种数据类型，这里只列出比较常用的：
         NSStringPboardType         字符串类型
         
         NSFilenamesPboardType      文件
         
         NSURLPboardType            url链接
         NSPDFPboardType            pdf文件
         NSHTMLPboardType           html文件
         ***/
        //这里我们只添加对文件进行监听，如果拖动其他数据类型到view中是不会被接受的
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
    }
    
    return self;
}

/***
 第二步：当拖动数据进入view时会触发这个函数，我们可以在这个函数里面判断数据是什么类型，来确定要显示什么样的图标。比如接受到的数据是我们想要的NSFilenamesPboardType文件类型，我们就可以在鼠标的下方显示一个“＋”号，当然我们需要返回这个类型NSDragOperationCopy。如果接受到的文件不是我们想要的数据格式，可以返回NSDragOperationNone;这个时候拖动的图标不会有任何改变。
 ***/
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
	NSPasteboard *pboard = [sender draggingPasteboard];
    
	if ([[pboard types] containsObject:NSURLPboardType]) {
        return NSDragOperationCopy;
	}
    
	return NSDragOperationNone;
}

/***
 第三步：当在view中松开鼠标键时会触发以下函数，我们可以在这个函数里面处理接受到的数据
 ***/
-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    
    
    // 1）、获取拖动数据中的粘贴板
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // 2）、从粘贴板中提取我们想要的NSFilenamesPboardType数据，这里获取到的是一个文件链接的数组，里面保存的是所有拖动进来的文件地址，如果你只想处理一个文件，那么只需要从数组中提取一个路径就可以了。
    
    NSURL *myURL = [NSURL URLFromPasteboard:zPasteboard];
    //[[NSWorkspace sharedWorkspace] openURL:myURL];
    filePath = [myURL path];
    
//    [self setImage:[[NSImage alloc] initWithContentsOfFile:filePath]];
    [self.delegate dragViewFile:filePath];
    //    [self.delegate getSHA1String:filePath];
    
    return YES;
}

- (NSString*)filePath
{
    return filePath;
}



- (void)drawRect:(NSRect)dirtyRect
{
  
    
//    //// Abstracted Attributes
//    NSString* textContent = @"Drop";
//    NSString* text2Content = @"QR";
//    NSString* text3Content = @"Image";
//    NSString* text4Content = @"Here";
//    
//    
//    //// Rectangle Drawing
//    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: NSMakeRect(0, 0, 250, 250)];
//    [[NSColor clearColor] setFill];
//    [rectanglePath fill];
//    [[NSColor blackColor] setStroke];
//    [rectanglePath setLineWidth: 1];
//    [rectanglePath stroke];
//    
//    
//    //// Text Drawing
//    NSRect textRect = NSMakeRect(45, 175, 154, 56);
//    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    [textStyle setAlignment: NSCenterTextAlignment];
//    
//    NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        [NSFont fontWithName: @"Helvetica" size: 42], NSFontAttributeName,
//                                        [NSColor blackColor], NSForegroundColorAttributeName,
//                                        textStyle, NSParagraphStyleAttributeName, nil];
//    
//    [textContent drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];
//    
//    
//    //// Text 2 Drawing
//    NSRect text2Rect = NSMakeRect(43, 130, 154, 46);
//    NSMutableParagraphStyle* text2Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    [text2Style setAlignment: NSCenterTextAlignment];
//    
//    NSDictionary* text2FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSFont fontWithName: @"Helvetica" size: 42], NSFontAttributeName,
//                                         [NSColor blackColor], NSForegroundColorAttributeName,
//                                         text2Style, NSParagraphStyleAttributeName, nil];
//    
//    [text2Content drawInRect: NSOffsetRect(text2Rect, 0, 1) withAttributes: text2FontAttributes];
//    
//    
//    //// Text 3 Drawing
//    NSRect text3Rect = NSMakeRect(43, 68, 154, 62);
//    NSMutableParagraphStyle* text3Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    [text3Style setAlignment: NSCenterTextAlignment];
//    
//    NSDictionary* text3FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSFont fontWithName: @"Helvetica" size: 42], NSFontAttributeName,
//                                         [NSColor blackColor], NSForegroundColorAttributeName,
//                                         text3Style, NSParagraphStyleAttributeName, nil];
//    
//    [text3Content drawInRect: NSOffsetRect(text3Rect, 0, 1) withAttributes: text3FontAttributes];
//    
//    
//    //// Text 4 Drawing
//    NSRect text4Rect = NSMakeRect(43, 22, 154, 46);
//    NSMutableParagraphStyle* text4Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//    [text4Style setAlignment: NSCenterTextAlignment];
//    
//    NSDictionary* text4FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
//                                         [NSFont fontWithName: @"Helvetica" size: 42], NSFontAttributeName,
//                                         [NSColor blackColor], NSForegroundColorAttributeName,
//                                         text4Style, NSParagraphStyleAttributeName, nil];
//    
//    [text4Content drawInRect: NSOffsetRect(text4Rect, 0, 1) withAttributes: text4FontAttributes];
//    
//    
//
//    
//    

}

@end
