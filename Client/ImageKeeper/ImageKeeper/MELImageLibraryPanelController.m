//
//  MELImageLibraryPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageLibraryPanelController.h"
#import "MELDataStore.h"
#import "MELImageModel.h"
#import "MELDocumentModel.h"

static CGFloat const kDefaultX = 0.0;
static CGFloat const kDefaultY = 0.0;

@interface MELImageLibraryPanelController ()

@end

@implementation MELImageLibraryPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)doubleClickActionHandler:(id)sender
{
    NSInteger selectedRow = [(NSTableView *)sender selectedRow];
    
    if (selectedRow >= 0)
    {
        NSImage *image = self.dataStore.images[selectedRow];
        NSRect frame = NSMakeRect(kDefaultX, kDefaultY, image.size.width, image.size.height);
        
        [self.dataStore.documentModel addImagesToDrawObject:[[MELImageModel alloc] initWithImage:image frame:frame]];
    }
}

#pragma mark - MELImageLibraryPanelControllerGetters

- (NSArray<NSImage *> *)imagePreviewList
{
    return self.dataStore.images;
}

@end
