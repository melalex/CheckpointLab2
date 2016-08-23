//
//  MELCanvasController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvasController.h"
#import "MELDataStore.h"
#import "Macros.h"
#import "MELCanvas.h"
#import "MELDocumentModel.h"
#import "MELRect.h"

static NSString *const kMELCanvasControllerContextImageToDraw = @"kMELCanvasControllerContextImageToDraw";
static NSString *const kMELCanvasControllerContextImageChangeFrame = @"kMELCanvasControllerContextImageChangeFrame";
static NSString *const kMELCanvasControllerContextSelectedImageChanged = @"kMELCanvasControllerContextSelectedImageChanged";

static NSString *const kOld = @"old";
static NSString *const kNew = @"new";

static NSString *const kX = @"x";
static NSString *const kY = @"y";
static NSString *const kWidth = @"width";
static NSString *const kHeight = @"height";
static NSString *const kLayer = @"layer";

static CGFloat const kDefaultDeltaX = 1.0;
static CGFloat const kDefaultDeltaY = 1.0;


@interface MELCanvasController ()
{
    MELDataStore *_dataStore;
    id<MELStrategy> _strategy;
}

@end

@implementation MELCanvasController

- (void)dealloc
{
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.elements)
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
    
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedElement)
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];

    [_dataStore release];
    [_strategy release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)addImageFromLibraryAtIndex:(NSUInteger)index toPoint:(NSPoint)point
{
    NSImage *image = self.dataStore.images[index];
 
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat x = point.x - image.size.width/2;
    CGFloat y = point.y - image.size.height/2;

    MELRect *frame = [[MELRect alloc] initWithX:x y:y width:width height:height];
    
    [self.dataStore putToDocumentModelImage:image inFrame:frame];
}

- (void)shiftByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY
{
    self.dataStore.selectedElement.frame.x += deltaX;
    self.dataStore.selectedElement.frame.y -= deltaY;
}

- (BOOL)isSelected:(id<MELElement>)element
{
    BOOL result = NO;
    
    if (element == self.dataStore.selectedElement)
    {
        result = YES;
    }
    
    return result;
}

- (NSRect)selectedImageFrame
{
    return self.dataStore.selectedElement.frame.rect;
}

#pragma mark - strategy

- (void)setStrategy:(id<MELStrategy>)strategy
{
    if (_strategy != strategy)
    {
        [_strategy release];
        _strategy = [strategy retain];
        
        _strategy.ownerView = self.view;
        _strategy.dataStore = self.dataStore;
    }
}

- (id<MELStrategy>)strategy
{
    return _strategy;
}

#pragma mark - mouseEvents

- (void)mouseDown:(NSEvent *)theEvent
{
    [self.strategy mouseDownAction:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [self.strategy mouseDraggAction:theEvent];
}

#pragma mark - keyboardEvents

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* const character = [theEvent charactersIgnoringModifiers];
    unichar const code = [character characterAtIndex:0];
    
    switch (code)
    {
        case NSUpArrowFunctionKey:
            [self shiftByDeltaX:0 deltaY:-kDefaultDeltaY];
            break;
            
        case NSDownArrowFunctionKey:
            [self shiftByDeltaX:0 deltaY:kDefaultDeltaY];
            break;
            
        case NSLeftArrowFunctionKey:
            [self shiftByDeltaX:-kDefaultDeltaX deltaY:0];
            break;
            
        case NSRightArrowFunctionKey:
            [self shiftByDeltaX:kDefaultDeltaX deltaY:0];
            break;
            
        default:
            [super keyDown:theEvent];
            break;
    }
}

#pragma mark - Edit commands

- (void)copySelectedImage
{
    id<MELElement> elementModel = self.dataStore.selectedElement;
    
    if (elementModel != nil)
    {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:elementModel];
        [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
        
        [pasteboard setData:data forType:NSStringPboardType];
    }
}

- (void)paste
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSData *data = [pasteboard dataForType:NSStringPboardType];
    id<MELElement> elementModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSRect pointRect = NSMakeRect(NSEvent.mouseLocation.x - elementModel.frame.width / 2, NSEvent.mouseLocation.y - elementModel.frame.height / 2, 0, 0);
    NSPoint mouseLocation = [self.view convertPoint:[self.view.window convertRectFromScreen:pointRect].origin
                                           fromView:nil];
    
    elementModel.frame.x = mouseLocation.x;
    elementModel.frame.y = mouseLocation.y;

    [self.dataStore putToDocumentModelElement:elementModel];

}

- (void)deleteSelectedImage
{
    [self.dataStore.documentModel removeElement:self.dataStore.selectedElement];
    
    [self.dataStore deselectImage];
}

#pragma mark - MELCanvasController KVO

- (void)setDataStore:(MELDataStore *)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.elements)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedElement)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];

        [_dataStore release];
        _dataStore = [dataStore retain];
        
        [_dataStore addObserver:self
                     forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.elements)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore addObserver:self
                     forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedElement)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];
    }
}

- (MELDataStore *)dataStore
{
    return _dataStore;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw))
    {
        id<MELElement> newElement = (id<MELElement>)[aChange[kNew] objectAtIndex:0];
        id<MELElement> oldElement = (id<MELElement>)[aChange[kOld] objectAtIndex:0];
        
        if (newElement)
        {
            MELRect *frame = newElement.frame;
            
            [frame addObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(frame, x)
                       options:NSKeyValueObservingOptionOld
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame)];
            
            [frame addObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(frame, y)
                       options:NSKeyValueObservingOptionOld
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame)];
            
            [frame addObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(frame, width)
                       options:NSKeyValueObservingOptionOld
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame)];
            
            [frame addObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(frame, height)
                       options:NSKeyValueObservingOptionOld
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame)];
            
            [newElement addObserver:self
                         forKeyPath:@OBJECT_KEY_PATH(newElement, layer)
                            options:NSKeyValueObservingOptionOld
                            context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame)];
            
            
            self.canvas.elements = self.dataStore.documentModel.elements;
            
            [self.view setNeedsDisplayInRect:frame.rect];
        }
        else if (oldElement)
        {
            MELRect *frame = oldElement.frame;
            
            [frame removeObserver:self
                       forKeyPath:@OBJECT_KEY_PATH(frame, x)
                          context:kMELCanvasControllerContextImageChangeFrame];
            
            [frame removeObserver:self
                       forKeyPath:@OBJECT_KEY_PATH(frame, y)
                          context:kMELCanvasControllerContextImageChangeFrame];
            
            [frame removeObserver:self
                       forKeyPath:@OBJECT_KEY_PATH(frame, width)
                          context:kMELCanvasControllerContextImageChangeFrame];
            
            [frame removeObserver:self
                       forKeyPath:@OBJECT_KEY_PATH(frame, height)
                          context:kMELCanvasControllerContextImageChangeFrame];
            
            [oldElement removeObserver:self
                            forKeyPath:@OBJECT_KEY_PATH(oldElement, layer)
                               context:kMELCanvasControllerContextImageChangeFrame];
            
            self.canvas.elements = self.dataStore.documentModel.elements;

            [self.view setNeedsDisplayInRect:frame.rect];
        }
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame))
    {
        NSRect rect = [aKeyPath isEqualToString:kLayer] ? [[(id<MELElement>)anObject frame] rect] : [(MELRect *)anObject rect];
        CGFloat oldValue = [aChange[kOld] doubleValue];
        
        if ([aKeyPath isEqualToString:kX])
        {
            NSInteger dX = fabs(oldValue - rect.origin.x);
            rect.size.width += dX + 0.5;
            rect.origin.x = fmin(rect.origin.x, oldValue);
        }
        else if ([aKeyPath isEqualToString:kY])
        {
            NSInteger dY = fabs(oldValue - rect.origin.y);
            rect.size.height += dY;
            rect.origin.y = fmin(rect.origin.y, oldValue);
        }
        else if ([aKeyPath isEqualToString:kWidth])
        {
            rect.size.width += fmax(rect.size.width, oldValue);
        }
        else if ([aKeyPath isEqualToString:kHeight])
        {
            rect.size.height += fmax(rect.size.height, oldValue);
        }
        
        self.canvas.elements = self.dataStore.documentModel.elements;

        [self.view setNeedsDisplayInRect:rect];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged))
    {
        if (![aChange[kOld] isEqual:[NSNull null]])
        {
            NSRect oldValue = [[(id<MELElement>)aChange[kOld] frame] rect];
            
            [self.view setNeedsDisplayInRect:oldValue];
        }
        
        if (![aChange[kNew] isEqual:[NSNull null]])
        {
            NSRect newValue = [[(id<MELElement>)aChange[kNew] frame] rect];

            [self.view setNeedsDisplayInRect:newValue];
        }

    }
    else
    {
        [super observeValueForKeyPath:aKeyPath ofObject:anObject change:aChange context:aContext];
    }
}

- (MELCanvas *)canvas
{
    return (MELCanvas *)self.view;
}

@end
