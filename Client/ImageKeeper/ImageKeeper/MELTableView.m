//
//  MELTableView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELTableView.h"

@implementation MELTableView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event
{
    return event.type == NSLeftMouseDown;
}

@end
