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

@interface Document ()

@end

@implementation Document

- (instancetype)init
{
    if (self = [super init])
    {

    }
    return self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
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

@end
