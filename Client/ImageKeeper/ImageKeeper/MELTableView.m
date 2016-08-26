//
//  MELTableView.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/25/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELTableView.h"

@interface MELTableView()

@end

@implementation MELTableView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib
{
    NSMutableArray *types = [NSMutableArray arrayWithArray:[NSImage imageTypes]];
    [types addObjectsFromArray:[NSURL readableTypesForPasteboard:[NSPasteboard generalPasteboard]]];
    [self registerForDraggedTypes:types];
}

-(BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event
{
    return event.type == NSLeftMouseDown;
}

@end
