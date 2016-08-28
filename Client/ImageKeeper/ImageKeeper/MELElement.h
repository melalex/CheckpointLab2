//
//  MELElement.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class MELRect;
@class MELVisitor;

#warning Make hit test

static NSString *const kMELElementUTI = @"com.company.element";

@protocol MELElement <NSObject, NSCoding, NSPasteboardWriting, NSPasteboardReading>

@property (retain) MELRect *frame;
@property  NSUInteger layer;

@property CGFloat rotation;
@property CGFloat transparency;

- (void)acceptVisitor:(MELVisitor *)visitor;

- (void)addObserver:(id)observer context:(NSString *)context;
- (void)removeObserver:(id)observer context:(NSString *)context;

@end
