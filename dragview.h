//
//  dragview.h
//  draghere
//
//  Created by Phil Cai on 13-9-24.
//  Copyright (c) 2013年 Phil Cai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol dragviewDelegate;


@interface dragview : NSImageView{
    
}
- (NSString*)filePath;
@property (assign) IBOutlet id<dragviewDelegate> delegate;
@end
//@property (nonatomic, unsafe_unretained) IBOutlet id<dragviewDelegate> delegate;
//@property (nonatomic,retain,readonly)NSString *filePath;




@protocol dragviewDelegate <NSObject>
//-(void)dragFileEnter:(NSString *)aFilePath;
-(void)dragViewFile:(NSString *)aFilePath;
//-(void)getSHA1String:(NSString *)aFilePath;
@end