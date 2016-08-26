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
#import "Macros.h"

static CGFloat const kDefaultX = 0.0;
static CGFloat const kDefaultY = 0.0;

static NSString *const kMELImageLibraryPanelControllerContextImagesGhanged = @"kMELImageLibraryPanelControllerContextImagesGhanged";

@interface MELImageLibraryPanelController() <NSTableViewDataSource>
{
    NSObject<MELImageLibraryPanelModelController> *_dataStore;
}

@property (retain) NSArray<NSImage *> *imagePreviewList;

@property (assign) IBOutlet NSTableView *tableView;

@end

@implementation MELImageLibraryPanelController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, images)
                       context:(__bridge void * _Nullable)(kMELImageLibraryPanelControllerContextImagesGhanged)];

    [_dataStore release];
    [_imagePreviewList release];
    
    [super dealloc];
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

- (void)deleteSelectedRow
{
    NSInteger selectedRow = self.tableView.selectedRow;
    
    if (selectedRow >= 0)
    {
        [self.dataStore removeObjectFromImagesAtIndex:selectedRow];
        
        NSInteger maxIndex = (self.dataStore.images.count - 1);
        selectedRow = selectedRow < maxIndex ? selectedRow : maxIndex;
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow];
        [self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}

+ (NSSet *)keyPathsForValuesAffectingDataStore
{
    return [NSSet setWithObjects:@TYPE_KEY_PATH(MELImageLibraryPanelController, dataStore.images), nil];
}

- (NSDragOperation)tableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op
{
    NSPasteboard *board = info.draggingPasteboard;
    NSImage *image = [[NSImage alloc] initWithPasteboard:board];
    
    if (!image)
    {
        NSURL *url = [NSURL URLFromPasteboard:board];
        image = [[NSImage alloc] initWithContentsOfURL:url];
    }
    
    if (image && op == NSTableViewDropAbove)
    {
        [self.dataStore insertObject:image inImagesAtIndex:row];
    }

    return !![image autorelease];
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void * _Nullable)(kMELImageLibraryPanelControllerContextImagesGhanged))
    {
        self.imagePreviewList = self.dataStore.images;
    }
    else
    {
        [super observeValueForKeyPath:aKeyPath ofObject:anObject change:aChange context:aContext];
    }
}

#pragma mark - MELImageLibraryPanelControllerSetters

- (void)setDataStore:(NSObject<MELImageLibraryPanelModelController> *)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, images)
                           context:(__bridge void * _Nullable)(kMELImageLibraryPanelControllerContextImagesGhanged)];
        
        [_dataStore release];
        _dataStore = [dataStore retain];
        
        [_dataStore addObserver:self
                     forKeyPath:@OBJECT_KEY_PATH(_dataStore, images)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                        context:(__bridge void * _Nullable)(kMELImageLibraryPanelControllerContextImagesGhanged)];
    }
}

#pragma mark - MELImageLibraryPanelControllerGetters

- (NSObject<MELImageLibraryPanelModelController> *)dataStore
{
    return _dataStore;
}

@end
