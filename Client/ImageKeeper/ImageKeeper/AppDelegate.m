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

static NSString *const kFileExtension = @".ikf";

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

@property (readonly) NSWindow *keyWindow;

@property (readonly) Document *currentDocument;

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
    Document *document = self.currentDocument;
    MELDocumentModel *documentModel = [[MELDocumentModel alloc] init];
    MELDataStore *dataStore =[[MELDataStore alloc] init];
    dataStore.documentModel = documentModel;
    [documentModel release];
    
    self.imageInspector = [[[MELImageInspector alloc] initWithWindowNibName:kMELImageInspector] autorelease];
    self.imageInspector.dataStore = dataStore;
    
    self.imageLibraryPanelController = [[[MELImageLibraryPanelController alloc] initWithWindowNibName:kMELImageLibraryPanelController] autorelease];
    self.imageLibraryPanelController.dataStore = dataStore;
    
    self.canvasController = [[[MELCanvasController alloc] initWithNibName:kMELCanvasController bundle:[NSBundle mainBundle]] autorelease];
    self.canvasController.dataStore = dataStore;
    self.canvasController.canvas.controller = self.canvasController;
    
    self.instrumentPanelController = [[[MELInstrumentPanelController alloc] initWithWindowNibName:kMELInstrumentPanelController] autorelease];
    self.instrumentPanelController.canvasController = self.canvasController;
    
    document.dataStore = dataStore;
    [document.canvas addSubview:self.canvasController.view];
    [self.canvasController.view setFrame:document.canvas.bounds];
    
    [dataStore release];

#pragma mark - Windows position
    
    NSRect documentFrame = [[document.windowControllers[0] window] frame];
    
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    
#warning for screenFrame > documentFrame
    
    documentFrame.origin.y = (screenFrame.size.height - documentFrame.size.height) / 2;
    documentFrame.origin.x = (screenFrame.size.width - documentFrame.size.width) / 2;

    [[document.windowControllers[0] window] setFrame:documentFrame display:YES];

    [self showInstrumentPanel:nil];
    [self showImageInspectorPanel:nil];
    [self showImageLibraryPanel:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    return [filename hasSuffix:kFileExtension];
}

#pragma mark - Panels menu

- (IBAction)showImageInspectorPanel:(id)sender
{
    NSRect documentFrame = [[self.currentDocument.windowControllers[0] window] frame];
    NSRect imageInspectorFrame = self.imageInspector.window.frame;
    
    imageInspectorFrame.origin.y = documentFrame.origin.y + documentFrame.size.height - imageInspectorFrame.size.height;
    imageInspectorFrame.origin.x = documentFrame.origin.x - imageInspectorFrame.size.width - kDistanceBetweenWindows;

    [self.imageInspector.window setFrame:imageInspectorFrame display:YES];
    
    [self.imageInspector showWindow:self];
}

- (IBAction)showInstrumentPanel:(id)sender
{
    NSRect documentFrame = [[self.currentDocument.windowControllers[0] window] frame];
    NSRect instrumentPanelFrame = self.instrumentPanelController.window.frame;

    instrumentPanelFrame.origin.y = documentFrame.origin.y + documentFrame.size.height + kDistanceBetweenWindows;
    instrumentPanelFrame.origin.x = documentFrame.origin.x + documentFrame.size.width / 2 - instrumentPanelFrame.size.width / 2;

    [self.instrumentPanelController.window setFrame:instrumentPanelFrame display:YES];
    
    [self.imageInspector showWindow:self];
}

- (IBAction)showImageLibraryPanel:(id)sender
{
    NSRect documentFrame = [[self.currentDocument.windowControllers[0] window] frame];
    NSRect imageLibraryFrame = self.imageLibraryPanelController.window.frame;

    imageLibraryFrame.origin.y = documentFrame.origin.y + documentFrame.size.height - imageLibraryFrame.size.height;
    imageLibraryFrame.origin.x = documentFrame.origin.x + documentFrame.size.width + kDistanceBetweenWindows;

    [self.imageLibraryPanelController.window setFrame:imageLibraryFrame display:YES];
    
    [self.imageInspector showWindow:self];
}

#pragma mark - Export
- (IBAction)saveAsPng:(id)sender
{
    NSImage *image = [self.canvasController imageFromCanvas];

    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[image size]];
    
    NSNumber *compressionFactor = [NSNumber numberWithFloat:0.9];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor
                                                           forKey:NSImageCompressionFactor];
    
    NSData *imageData = [newRep representationUsingType:NSPNGFileType properties:imageProps];
    
    [imageData writeToFile:@"/Users/melalex/Desktop/foo.png" atomically:YES];
    [newRep autorelease];
}

- (IBAction)saveAsTiff:(id)sender
{
    NSImage *image = [self.canvasController imageFromCanvas];
    
    [[image TIFFRepresentation] writeToFile:@"/Users/melalex/Desktop/foo.tiff" atomically:NO];
}

- (IBAction)saveAsJpeg:(id)sender
{
    NSImage *image = [self.canvasController imageFromCanvas];

    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    
    NSNumber *compressionFactor = [NSNumber numberWithFloat:0.9];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor
                                                           forKey:NSImageCompressionFactor];
    
    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    [imageData writeToFile:@"/Users/melalex/Desktop/foo.jpeg" atomically:YES];
}

#pragma mark - Edit commands

- (IBAction)copy:(id)sender
{
    if (self.keyWindow == self.canvasController.view.window)
    {
        [self.canvasController copySelectedImage];
    }
}

- (IBAction)paste:(id)sender
{
    if (self.keyWindow == self.canvasController.view.window)
    {
        [self.canvasController paste];
    }
}

- (IBAction)delete:(id)sender
{
    if (self.keyWindow == self.canvasController.view.window)
    {
        [self.canvasController deleteSelectedImage];
    }
    else if (self.keyWindow == self.imageLibraryPanelController.window)
    {
        [self.imageLibraryPanelController deleteSelectedRow];
    }
}

#pragma mark -  Getters

- (NSWindow *)keyWindow
{
    return [[NSApplication sharedApplication] keyWindow];
}

- (Document *)currentDocument
{
    Document *document = [[NSDocumentController sharedDocumentController] currentDocument];
    
    if(!document)
    {
        document = [[NSDocumentController sharedDocumentController] documents][0];
    }
    
    return document;
}

@end
