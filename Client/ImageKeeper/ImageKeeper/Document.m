//
//  Document.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/19/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "Document.h"
#import "MELCanvas.h"
#import "MELDocumentModel.h"
#import "MELCanvasController.h"

@interface Document ()
{
    id<MELDocumentModelProtocol> _dataStore;
}

@property (assign) IBOutlet MELCanvas *canvas;

@end

@implementation Document

- (instancetype)init
{
    if (self = [super init])
    {

    }
    return self;
}

- (void)dealloc
{
    [_dataStore release];
    
    [super dealloc];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)setCanvasController:(MELCanvasController *)canvasController
{
    self.canvas.controller = canvasController;
    canvasController.view = self.canvas;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dataStore.documentModel];
    
    if (!data && outError)
    {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
    }
    
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
    
    MELDocumentModel *fileContents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!fileContents && outError)
    {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:nil];
    }
    
    if (fileContents)
    {
        self.dataStore.documentModel = fileContents;
        readSuccess = YES;
    }
    
    return readSuccess;
}

- (void)setDataStore:(id<MELDocumentModelProtocol>)dataStore
{
    if(_dataStore != dataStore)
    {
        [_dataStore release];
        _dataStore = [dataStore retain];
        
        _dataStore.undoManager = self.undoManager;
    }
}

- (id<MELDocumentModelProtocol>)dataStore
{
    return _dataStore;
}

@end
