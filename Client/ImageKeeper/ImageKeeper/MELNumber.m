//
//  MELNumber.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELNumber.h"

NSString * const kMELNumberUTI = @"com.company.number";
NSString * const kMELNumberIntegerValue = @"integerValue";

@implementation MELNumber

+ (MELNumber *)numberWithItegerValue:(NSInteger)value;
{
    MELNumber *number = [[MELNumber alloc] init];
    number.integerValue = value;

    return [number autorelease];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _integerValue = [aDecoder decodeIntegerForKey:kMELNumberIntegerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.integerValue forKey:kMELNumberIntegerValue];
}


#pragma mark - NSPasteboardWriting

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard
{
    static NSArray *writableTypes = nil;
    
    if (!writableTypes)
    {
        writableTypes = [[NSArray alloc] initWithObjects:kMELNumberUTI, nil];
    }
    
    return writableTypes;
}

- (id)pasteboardPropertyListForType:(NSString *)type
{
    NSData *result = nil;
    
    if ([type isEqualToString:kMELNumberUTI])
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
        readableTypes = [[NSArray alloc] initWithObjects:kMELNumberUTI, nil];
    }
    
    return readableTypes;
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pboard
{
    NSPasteboardReadingOptions result = 0;
    
    if ([type isEqualToString:kMELNumberUTI])
    {
        result = NSPasteboardReadingAsKeyedArchive;
    }
    
    return result;
}


@end
