//
//  AppDelegate.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/19/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "AppDelegate.h"
#import "MELDataStore.h"
#import "MELImageLibraryPanelController.h"

@interface AppDelegate ()

@property (retain) MELImageLibraryPanelController *imageLibraryPanelController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MELDataStore *dataStore = [[MELDataStore alloc] init];
    
    self.imageLibraryPanelController = [[MELImageLibraryPanelController alloc] initWithWindowNibName:@"MELImageLibraryPanelController"];
    self.imageLibraryPanelController.dataStore = dataStore;
    [self.imageLibraryPanelController showWindow:self];
    
    [dataStore release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
