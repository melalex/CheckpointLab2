//
//  MELCanvasController.m
//  ImageKeeper
//
//  Created by Александр Мелащенко on 8/20/16.
//  Copyright © 2016 Александр Мелащенко. All rights reserved.
//

#import "MELCanvasController.h"
#import "Macros.h"
#import "MELCanvas.h"
#import "MELDocumentModel.h"
#import "MELRect.h"
#import "MELVisitor.h"

#import "MELImageModel.h"
#import "MELLineModel.h"
#import "MELRectangleModel.h"
#import "MELOvalModel.h"
#import "MELCurveModel.h"

static NSString *const kMELCanvasControllerContextImageToDraw = @"kMELCanvasControllerContextImageToDraw";
static NSString *const kMELCanvasControllerContextImageChangeFrame = @"kMELCanvasControllerContextImageChangeFrame";
static NSString *const kMELCanvasControllerContextSelectedImageChanged = @"kMELCanvasControllerContextSelectedImageChanged";
static NSString *const kMELCanvasControllerContextDocumentModelChanged = @"kMELCanvasControllerContextDocumentModelChanged";

static NSString *const kOld = @"old";
static NSString *const kNew = @"new";

static NSString *const kX = @"x";
static NSString *const kY = @"y";
static NSString *const kWidth = @"width";
static NSString *const kHeight = @"height";

static CGFloat const kDefaultDeltaX = 10.0;
static CGFloat const kDefaultDeltaY = 10.0;

static CGFloat const kFocusRingThickness = 5.0;

@interface MELCanvasController ()
{
    NSObject<MELCanvasModelController> *_dataStore;
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
    
    [_dataStore removeObserver:self
                    forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel)
                       context:(__bridge void * _Nullable)(kMELCanvasControllerContextDocumentModelChanged)];

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
    [self.dataStore putToDocumentModelImageFromLibraryAtIndex:index toPoint:point];
}

- (void)addImage:(NSImage *)image toPoint:(NSPoint)point;
{
    MELRect *frame = [[MELRect alloc] initWithX:point.x - image.size.width / 2
                                              y:point.y - image.size.height / 2
                                          width:image.size.width
                                         height:image.size.height];
    
    [self.dataStore putToDocumentModelImage:image inFrame:frame];
    
    [frame release];
}

- (void)shiftByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY
{
    [[self.dataStore.undoManager prepareWithInvocationTarget:self] shiftByDeltaX:-deltaX deltaY:-deltaY];

    [self.dataStore shiftSelectedElementByDeltaX:deltaX deltaY:deltaY];
}

- (BOOL)isSelected:(id<MELElement>)element
{
    return [self.dataStore isSelected:element];;
}

- (NSImage *)imageFromCanvas
{
    NSRect rect = self.view.bounds;
    
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    NSBitmapImageRep *representation = [[NSBitmapImageRep alloc]
                                        initWithBitmapDataPlanes:NULL
                                        pixelsWide:rect.size.width
                                        pixelsHigh:rect.size.height
                                        bitsPerSample:8
                                        samplesPerPixel:4
                                        hasAlpha:YES
                                        isPlanar:NO
                                        colorSpaceName:NSCalibratedRGBColorSpace
                                        bytesPerRow:0
                                        bitsPerPixel:0];
    
    [image addRepresentation:representation];
    
    [image lockFocus];
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextClearRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, [[NSColor blueColor] CGColor]);
    
    NSArray *elements = self.dataStore.documentModel.elements;
    
    MELVisitor *drawer = [[MELVisitor alloc] init];
    
    for (id<MELElement> element in elements)
    {
        [element acceptVisitor:drawer];
    }
    
    [image unlockFocus];
    
    [representation release];
    [drawer release];
        
    return [image autorelease];
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

- (void)mouseUp:(NSEvent *)theEvent
{
    [self.strategy mouseUpAction:theEvent];
}

#pragma mark - keyboardEvents

#warning make without keyDown

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

#warning make buffer

- (void)copySelectedImage
{
    id<MELElement> elementModel = self.dataStore.selectedElement;
    
    if (elementModel != nil)
    {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        
        [pasteboard clearContents];
        
        NSArray *copiedObjects = [NSArray arrayWithObject:elementModel];
                
        [pasteboard writeObjects:copiedObjects];
    }
}

- (void)paste
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classArray = [NSArray arrayWithObjects:[MELImageModel class], [MELLineModel class], [MELRectangleModel class], [MELOvalModel class], [MELCurveModel class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    
    BOOL ok = [pasteboard canReadObjectForClasses:classArray options:options];
    
    if (ok)
    {
        NSArray *objectsToPaste = [pasteboard readObjectsForClasses:classArray options:options];
        
        id<MELElement> elementModel = [objectsToPaste objectAtIndex:0];
        
        NSRect pointRect = NSMakeRect(NSEvent.mouseLocation.x - elementModel.frame.width / 2, NSEvent.mouseLocation.y - elementModel.frame.height / 2, 0, 0);
        NSPoint mouseLocation = [self.view convertPoint:[self.view.window convertRectFromScreen:pointRect].origin
                                               fromView:nil];
        
        elementModel.frame.x = mouseLocation.x;
        elementModel.frame.y = mouseLocation.y;
        
        [self.dataStore putToDocumentModelElement:elementModel];
    }
}

- (void)deleteSelectedImage
{
    [self.dataStore.documentModel removeElement:self.dataStore.selectedElement];
    
    [self.dataStore deselectElement];
}

#pragma mark - MELCanvasController KVO

- (void)setDataStore:(id<MELCanvasModelController>)dataStore
{
    if (_dataStore != dataStore)
    {
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel.elements)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw)];
        
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, selectedElement)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged)];
        
        [_dataStore removeObserver:self
                        forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel)
                           context:(__bridge void * _Nullable)(kMELCanvasControllerContextDocumentModelChanged)];

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
        
        [_dataStore addObserver:self
                     forKeyPath:@OBJECT_KEY_PATH(_dataStore, documentModel)
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void * _Nullable)(kMELCanvasControllerContextDocumentModelChanged)];
    }
}

- (id<MELCanvasModelController>)dataStore
{
    return _dataStore;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary<NSString *,id> *)aChange context:(void *)aContext
{
    if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageToDraw))
    {
        NSObject<MELElement> *newElement = (id<MELElement>)[aChange[kNew] objectAtIndex:0];
        NSObject<MELElement> *oldElement = (id<MELElement>)[aChange[kOld] objectAtIndex:0];
        
        if (newElement)
        {
            MELRect *frame = newElement.frame;
            
            [newElement addObserver:self context:kMELCanvasControllerContextImageChangeFrame];
            
            [self.dataStore.undoManager registerUndoWithTarget:self.dataStore.documentModel
                                                      selector:@selector(removeElement:)
                                                        object:newElement];
            
            self.canvas.elements = self.dataStore.documentModel.elements;
            
            [self.view setNeedsDisplayInRect:frame.rect];
        }
        else if (oldElement)
        {
            MELRect *frame = oldElement.frame;
            
            [oldElement removeObserver:self context:kMELCanvasControllerContextImageChangeFrame];
            
            [self.dataStore.undoManager registerUndoWithTarget:self.dataStore.documentModel
                                                      selector:@selector(addElement:)
                                                        object:oldElement];

            
            self.canvas.elements = self.dataStore.documentModel.elements;

            [self.view setNeedsDisplayInRect:frame.rect];
        }
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextImageChangeFrame))
    {
        NSRect newRect;
        CGFloat oldValue = 0.0;
        
        if ([aKeyPath isEqualToString:kX] ||
            [aKeyPath isEqualToString:kY] ||
            [aKeyPath isEqualToString:kWidth] ||
            [aKeyPath isEqualToString:kHeight])
        {
            newRect = [(MELRect *)anObject rect];
            oldValue = [aChange[kOld] doubleValue];
        }
        else
        {
            newRect = [[(id<MELElement>)anObject frame] rect];
        }
        
        newRect.origin.x -= kFocusRingThickness;
        newRect.origin.y -= kFocusRingThickness;
        newRect.size.width += kFocusRingThickness * 2;
        newRect.size.height += kFocusRingThickness * 2;
        
        NSRect oldRekt = newRect;
        
        if ([aKeyPath isEqualToString:kX])
        {
            oldRekt.origin.x = oldValue - kFocusRingThickness;
        }
        else if ([aKeyPath isEqualToString:kY])
        {
            oldRekt.origin.y = oldValue - kFocusRingThickness;
        }
        else if ([aKeyPath isEqualToString:kWidth])
        {
            oldRekt.size.width = oldValue + 2 * kFocusRingThickness;
        }
        else if ([aKeyPath isEqualToString:kHeight])
        {
            oldRekt.size.height = oldValue + 2 * kFocusRingThickness;
        }
        
        self.canvas.elements = self.dataStore.documentModel.elements;

        [self.view setNeedsDisplayInRect:newRect];
        [self.view setNeedsDisplayInRect:oldRekt];
    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextSelectedImageChanged))
    {
        if (![aChange[kOld] isEqual:[NSNull null]])
        {
            NSRect oldValue = [[(id<MELElement>)aChange[kOld] frame] rect];
            
            oldValue.origin.x -= kFocusRingThickness;
            oldValue.origin.y -= kFocusRingThickness;
            oldValue.size.width += kFocusRingThickness * 2;
            oldValue.size.height += kFocusRingThickness * 2;

            [self.view setNeedsDisplayInRect:oldValue];
        }
        
        if (![aChange[kNew] isEqual:[NSNull null]])
        {
            NSRect newValue = [[(id<MELElement>)aChange[kNew] frame] rect];

            newValue.origin.x -= kFocusRingThickness;
            newValue.origin.y -= kFocusRingThickness;
            newValue.size.width += kFocusRingThickness * 2;
            newValue.size.height += kFocusRingThickness * 2;
            
            [self.view setNeedsDisplayInRect:newValue];
        }

    }
    else if (aContext == (__bridge void * _Nullable)(kMELCanvasControllerContextDocumentModelChanged))
    {
        self.canvas.elements = self.dataStore.documentModel.elements;
        
        self.canvas.needsDisplay = YES;
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
