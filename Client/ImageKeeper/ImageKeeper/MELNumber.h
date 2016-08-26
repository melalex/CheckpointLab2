//
//  MELNumber.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

extern NSString * const kMELNumberUTI;

@interface MELNumber : NSObject<NSPasteboardReading, NSPasteboardWriting, NSCoding>

@property NSInteger integerValue;

+ (MELNumber *)numberWithItegerValue:(NSInteger)value;

@end
