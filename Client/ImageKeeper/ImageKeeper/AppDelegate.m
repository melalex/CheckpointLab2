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
#import "MELCanvas.h"
#import "Document.h"
#import "MELDocumentModel.h"
#import "MELImageInspector.h"
#import "MELRect.h"
#import "MELInstrumentPanelController.h"

static CGFloat const kDistanceBetweenWindows = 20.0;

static NSString *const kMELImageInspector = @"MELImageInspector";
static NSString *const kMELImageLibraryPanelController = @"MELImageLibraryPanelController";
static NSString *const kMELCanvasController = @"MELCanvasController";
static NSString *const kMELInstrumentPanelController = @"MELInstrumentPanelController";

@interface AppDelegate ()

@property (retain) MELImageLibraryPanelController *imageLibraryPanelController;
@property (retain) MELCanvasController *canvasController;
@property (retain) MELImageInspector *imageInspector;
@property (retain) MELInstrumentPanelController *instrumentPanelController;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_imageLibraryPanelController release];
    [_canvasController release];
    [_imageInspector release];
    
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
#pragma mark - App App dependencies
    MELDocumentModel *documentModel = [[MELDocumentModel alloc] init];
    MELDataStore *dataStore =[[MELDataStore alloc] init];
    dataStore.documentModel = documentModel;
    [documentModel release];
    
    self.imageInspector = [[MELImageInspector alloc] initWithWindowNibName:kMELImageInspector];
    self.imageInspector.dataStore = dataStore;
    
    self.imageLibraryPanelController = [[MELImageLibraryPanelController alloc] initWithWindowNibName:kMELImageLibraryPanelController];
    self.imageLibraryPanelController.dataStore = dataStore;
    
    self.canvasController = [[MELCanvasController alloc] initWithNibName:kMELCanvasController bundle:[NSBundle mainBundle]];
    self.canvasController.dataStore = dataStore;
    self.canvasController.canvas.controller = self.canvasController;
    
    self.instrumentPanelController = [[MELInstrumentPanelController alloc] initWithWindowNibName:kMELInstrumentPanelController];
    self.instrumentPanelController.canvasController = self.canvasController;
    
    Document *document = [[NSDocumentController sharedDocumentController] documents][0];
    
    [document.canvas addSubview:self.canvasController.view];
    [self.canvasController.view setFrame:document.canvas.bounds];
    
    [dataStore release];

#pragma mark - Windows position

    NSRect documentFrame = [[document.windowControllers[0] window] frame];
    NSRect imageInspectorFrame = self.imageInspector.window.frame;
    NSRect imageLibraryFrame = self.imageLibraryPanelController.window.frame;
    NSRect instrumentPanelFrame = self.instrumentPanelController.window.frame;
    
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    
#warning for screenFrame > documentFrame
    
    documentFrame.origin.y = (screenFrame.size.height - documentFrame.size.height)/2;
    documentFrame.origin.x = (screenFrame.size.width - documentFrame.size.width)/2;

    imageInspectorFrame.origin.y = documentFrame.origin.y + documentFrame.size.height - imageInspectorFrame.size.height;
    imageInspectorFrame.origin.x = documentFrame.origin.x - imageInspectorFrame.size.width - kDistanceBetweenWindows;
   
    imageLibraryFrame.origin.y = documentFrame.origin.y + documentFrame.size.height - imageLibraryFrame.size.height;
    imageLibraryFrame.origin.x = documentFrame.origin.x + documentFrame.size.width + kDistanceBetweenWindows;
    
    instrumentPanelFrame.origin.y = documentFrame.origin.y + documentFrame.size.height + kDistanceBetweenWindows;
    instrumentPanelFrame.origin.x = documentFrame.origin.x + documentFrame.size.width / 2 - instrumentPanelFrame.size.width / 2;

    [self.imageInspector.window setFrame:imageInspectorFrame display:YES];
    [self.imageLibraryPanelController.window setFrame:imageLibraryFrame display:YES];
    [self.instrumentPanelController.window setFrame:instrumentPanelFrame display:YES];

    [[document.windowControllers[0] window] setFrame:documentFrame display:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark - Edit commands

- (IBAction)copy:(id)sender
{
    [self.canvasController copySelectedImage];
}

- (IBAction)paste:(id)sender
{
    [self.canvasController paste];
}

- (IBAction)delete:(id)sender
{
    [self.canvasController deleteSelectedImage];
}


@end
