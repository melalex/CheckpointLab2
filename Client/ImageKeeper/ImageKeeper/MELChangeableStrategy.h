//
//  MELChangeableStrategy.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/28/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELStrategy.h"

@protocol MELChangeableStrategy <NSObject>

@property (retain) id<MELStrategy> strategy;

@end
