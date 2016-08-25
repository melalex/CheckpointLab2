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

static CGFloat const kDefaultX = 0.0;
static CGFloat const kDefaultY = 0.0;

@interface MELImageLibraryPanelController()

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

#pragma mark - MELImageLibraryPanelControllerSetters

#pragma mark - MELImageLibraryPanelControllerGetters

- (NSArray<NSImage *> *)imagePreviewList
{
    return self.dataStore.images;
}

@end
