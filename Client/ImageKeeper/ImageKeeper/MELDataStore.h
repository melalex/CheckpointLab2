//
//  MELDataStore.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELDataStore : NSObject

@property (readonly, retain) NSArray<NSImage *> *images;

- (void)addImage:(NSImage *)image;
- (void)removeImage:(NSImage *)image;

@end
