//
//  MELPrimitiveModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/23/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"

@interface MELPrimitiveModel : NSObject<MELElement>

- (instancetype)initWithFrame:(MELRect *)frame layer:(NSUInteger)layer;

@end
