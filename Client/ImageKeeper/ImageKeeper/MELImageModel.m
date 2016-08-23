//
//  MELImageModel.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageModel.h"
#import "MELRect.h"
#import "Macros.h"

@implementation MELImageModel

- (instancetype)initWithImage:(NSImage *)image frame:(MELRect *)frame layer:(NSUInteger)layer;
{
    if (self = [self init])
    {
        _image = [image retain];
        _frame = [frame retain];
        _layer = layer;
    }
    return self;
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        _image = [[aDecoder decodeObjectForKey:@"image"] retain];
        _frame = [[aDecoder decodeObjectForKey:@"frame"] retain];
        _layer = [aDecoder decodeIntegerForKey:@"layer"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.frame forKey:@"frame"];
    [aCoder encodeInteger:self.layer forKey:@"layer"];
}


#warning commented code

//- (id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type
//{
//    if ( [type isEqualToString:@"my.company.MELImageModel"])
//    {
//        
//    }
//    return nil;
//}
//
//
//
//- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
//    
//    static NSArray *writableTypes = nil;
//    
//    if (!writableTypes)
//    {
//
//    }
//    
//    return writableTypes;
//}
//
//- (id)pasteboardPropertyListForType:(NSString *)type
//{
//    if ([type isEqualToString:BOOKMARK_UTI])
//    {
//        return [NSKeyedArchiver archivedDataWithRootObject:self];
//    }
//    
//    if ([type isEqualToString:(NSString *)kUTTypeURL])
//    {
//        return [url pasteboardPropertyListForType:(NSString *)kUTTypeURL];
//    }
//    
//    if ([type isEqualToString:NSPasteboardTypeString])
//    {
//        return [NSString stringWithFormat:@"<a href=\"%@\">%@</a>", [url absoluteString], title];
//    }
//    
//    return nil;
//}
//
//+ (NSArray<NSString *> *)readableTypesForPasteboard:(NSPasteboard *)pasteboard;
//{
//    return @[@"my.company.MELImageModel"];
//}

@end
