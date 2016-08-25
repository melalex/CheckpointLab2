//
//  MELImageLibraryPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageLibraryPanelController.h"
#import "MELDataStore.h"
#import "MELDocumentModel.h"
#import "MELRect.h"
#import "MELLibraryTableView.h"

static CGFloat const kDefaultX = 0.0;
static CGFloat const kDefaultY = 0.0;

@interface MELImageLibraryPanelController() <NSDraggingSource>
{
    MELLibraryTableView *_tableView;
}

@property (assign) IBOutlet MELLibraryTableView *tableView;

@end

@implementation MELImageLibraryPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)doubleClickActionHandler:(id)sender
{
    NSInteger selectedRow = [(NSTableView *)sender selectedRow];
    
    if (selectedRow >= 0)
    {
        NSImage *image = self.dataStore.images[selectedRow];
        MELRect *frame = [[MELRect alloc] initWithX:kDefaultX y:kDefaultY width:image.size.width height:image.size.height];
        
        [self.dataStore putToDocumentModelImage:image inFrame:frame];
        
        [frame release];
    }
}

- (NSImage *)imageAtIndex:(NSUInteger)index
{
    return self.dataStore.images[index];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSInteger row = self.tableView.selectedRow;
    
    if (row >= 0)
    {
        NSImage *image = self.dataStore.images[row];
        NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:image];
        NSPoint point = [self.tableView convertPoint:[theEvent locationInWindow] fromView:nil];
        
        dragItem.imageComponentsProvider = ^
        {
            NSDraggingImageComponent *imageComponent = [NSDraggingImageComponent draggingImageComponentWithKey:NSDraggingImageComponentIconKey];
            imageComponent.contents = image;
            
            imageComponent.frame = NSMakeRect(point.x - image.size.width / 2,
                                              point.y - image.size.height / 2,
                                              image.size.width,
                                              image.size.height);
            return @[imageComponent];
        };
        
        NSDraggingSession *session = [self.tableView beginDraggingSessionWithItems:@[dragItem] event:theEvent source:self];
        
        session.animatesToStartingPositionsOnCancelOrFail = YES;
        session.draggingFormation = NSDraggingFormationNone;
    }
    else
    {
        [super mouseDown:theEvent];
    }
}


- (NSDragOperation)draggingSession:(NSDraggingSession *)aSession sourceOperationMaskForDraggingContext:(NSDraggingContext)aContext
{
    return NSDragOperationCopy;
}

#pragma mark - MELImageLibraryPanelControllerSetters

- (void)setTableView:(MELLibraryTableView *)tableView
{
    _tableView = tableView;
    tableView.imageLibraryPanelController = self;
}

#pragma mark - MELImageLibraryPanelControllerGetters

- (NSArray<NSImage *> *)imagePreviewList
{
    return self.dataStore.images;
}

- (MELLibraryTableView *)tableView
{
    return _tableView;
}

@end
