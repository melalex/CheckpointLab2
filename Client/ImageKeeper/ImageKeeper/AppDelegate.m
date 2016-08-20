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
#import "MELCanvasController.h"
#import "Document.h"
#import "MELDocumentModel.h"

@interface AppDelegate ()

@property (retain) MELImageLibraryPanelController *imageLibraryPanelController;
@property (retain) MELCanvasController *canvasController;


@end

@implementation AppDelegate

- (void)dealloc
{
    [_imageLibraryPanelController release];
    [_canvasController release];
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MELDocumentModel *documentModel = [[MELDocumentModel alloc] init];
    MELDataStore *dataStore = [[MELDataStore alloc] init];
    dataStore.documentModel = documentModel;
    [documentModel release];
    
    self.imageLibraryPanelController = [[MELImageLibraryPanelController alloc] initWithWindowNibName:@"MELImageLibraryPanelController"];
    self.imageLibraryPanelController.dataStore = dataStore;
    [self.imageLibraryPanelController showWindow:self];
    
    self.canvasController = [[MELCanvasController alloc] initWithNibName:@"MELCanvasController" bundle:[NSBundle mainBundle]];
    self.canvasController.dataStore = dataStore;
    
    Document *document = [[NSDocumentController sharedDocumentController] documents][0];
    
    [document.canvas addSubview:self.canvasController.view];
    [self.canvasController.view setFrame:document.canvas.bounds];
    
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
