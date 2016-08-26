//
//  MELImagePreviewModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/26/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MELImagePreviewModel : NSObject

@property (retain) NSImage *image;
@property (retain) NSString *name;

+ (instancetype)imagePreviewModelWithImage:(NSImage *)image name:(NSString *)name;

@end
