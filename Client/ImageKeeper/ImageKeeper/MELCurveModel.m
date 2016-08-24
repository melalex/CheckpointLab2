//
//  MELCurveModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCurveModel.h"

@implementation MELCurveModel

#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *writableTypes = nil;
    
    if (!writableTypes)
    {
        writableTypes = [NSArray arrayWithObject:kMELElementUTI];
    }
    
    return writableTypes;
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    NSData *result = nil;
    
    if ([type isEqualToString:kMELElementUTI])
    {
        result = [NSKeyedArchiver archivedDataWithRootObject:self];
    }
    
    return result;
}

#pragma mark - NSPasteboardReading

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *readableTypes = nil;
    
    if (!readableTypes)
    {
        readableTypes = [NSArray arrayWithObject:kMELElementUTI];
    }
    
    return readableTypes;
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pboard
{
    NSPasteboardReadingOptions result = 0;
    
    if ([type isEqualToString:kMELElementUTI])
    {
        result = NSPasteboardReadingAsKeyedArchive;
    }
    
    return result;
}

@end
