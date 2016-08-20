//
//  MELImageLibraryPanelController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELImageLibraryPanelController.h"
#import "MELDataStore.h"

@interface MELImageLibraryPanelController ()

@end

@implementation MELImageLibraryPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - MELImageLibraryPanelControllerGetters

- (NSArray<NSImage *> *)imagePreviewList
{
    return self.dataStore.images;
}

@end
