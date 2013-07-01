//
//  GPPDFViewController.m
//  GonePostal
//
//  Created by Travis Gruber on 6/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPDFViewController.h"

@interface GPPDFViewController ()

@property (weak, nonatomic) IBOutlet NSSearchField * searchField;

@property (weak, nonatomic) IBOutlet NSDrawer * outlineDrawer;
@property (weak, nonatomic) IBOutlet NSOutlineView * outlineView;

@property (strong, nonatomic) Attachment * attachment;

@property (strong, nonatomic) PDFDocument * pdfDocument;
@property (strong, nonatomic) PDFOutline * rootOutline;

@property (nonatomic) NSInteger currRotation;
@property (strong, nonatomic) PDFSelection * currSelection;

@end

@implementation GPPDFViewController

- (id)initWithAttachment:(Attachment *)attachment {
    self = [super initWithWindowNibName:@"GPPDFViewController"];
    if (self) {
        _attachment = attachment;
        
        _hasOutline = NO;
        _outlineVisable = NO;
        _canZoomIn = YES;
        _canZoomOut = YES;
        
        _currRotation = 0;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Get the full path to the PDF file.
    NSString * gpWrapperPath = [[[self document] fileURL] path];
    NSString * absolutePath = [gpWrapperPath stringByAppendingPathComponent:self.attachment.filename];
    
    NSURL * fileURL = [NSURL fileURLWithPath:absolutePath isDirectory:NO];
    self.pdfDocument = [[PDFDocument alloc] initWithURL:fileURL];
    
    [self.pdfView setDocument:self.pdfDocument];
    
    // Determine whether to incoude an outine view within a drawer
    self.rootOutline = [self.pdfDocument outlineRoot];
    if (self.rootOutline) {
        [self.outlineView reloadData];
        self.hasOutline = YES;
        [self.outlineDrawer setContentSize:NSMakeSize(250, 600)];
    }    
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.attachment.name;
}

- (IBAction)showOutline:(id)sender {
    if (self.hasOutline) {
        self.outlineVisable = (self.outlineVisable) ? NO : YES;
    }
}

- (IBAction)zoomIn:(id)sender {
    [self.pdfView zoomIn:sender];
    self.canZoomIn = [self.pdfView canZoomIn];
    self.canZoomOut = [self.pdfView canZoomOut];
}

- (IBAction)zoomOut:(id)sender {
    [self.pdfView zoomOut:sender];
    self.canZoomOut = [self.pdfView canZoomOut];
    self.canZoomIn = [self.pdfView canZoomIn];
}

- (IBAction)rotateClockwise:(id)sender {
    PDFPage * page = self.pdfView.visiblePages[0];

    self.currRotation += 90;
    if (self.currRotation >= 360) self.currRotation = 0;
    
    [page setRotation:self.currRotation];
    [self.pdfView setNeedsDisplay:YES];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSInteger numChildren = 0;
    
    if (item) {
        numChildren = [item numberOfChildren];
    }
    else {
        numChildren = [self.rootOutline numberOfChildren];
    }
    
    return numChildren;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    id child;
    
    if (item) {
        child = [item childAtIndex:index];
    }
    else {
        child = [self.rootOutline childAtIndex:index];
    }
    
    return child;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    BOOL isExpandable = NO;
    
    if (item) {
        isExpandable = [item numberOfChildren] > 0;
    }
    else {
        isExpandable = [self.rootOutline numberOfChildren] > 0;
    }
    
    return isExpandable;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    return [item label];
}

- (IBAction)takeDestinationFromOutline:(id)sender {
    [self.pdfView goToDestination:[[sender itemAtRow:[sender selectedRow]] destination]];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
    NSSearchField * searchField = aNotification.object;
    
    if ([searchField isEqualTo:self.searchField]) {
        self.currSelection = [self.pdfDocument findString:searchField.stringValue fromSelection:self.currSelection withOptions:NSLiteralSearch];
        [self.pdfView setCurrentSelection:self.currSelection];
        [self.pdfView scrollSelectionToVisible:self];
    }
}

@end
