//
//  MELDocumentModel.h
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MELElement.h"

@class MELRect;

@interface MELDocumentModel : NSObject

#warning encapsulate
@property (retain, readonly) NSArray<id<MELElement>> *elements;

- (void)addElement:(id<MELElement>)element;
- (void)removeElement:(id<MELElement>)element;

- (id<MELElement>)takeTopElementInPoint:(NSPoint)point;

@end
