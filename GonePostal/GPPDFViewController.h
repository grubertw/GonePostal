//
//  GPPDFViewController.h
//  GonePostal
//
//  Created by Travis Gruber on 6/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "Attachment.h"

@interface GPPDFViewController : NSWindowController <NSOutlineViewDataSource, NSTextFieldDelegate>

@property (weak, nonatomic) IBOutlet PDFView * pdfView;

@property (nonatomic) BOOL hasOutline;
@property (nonatomic) BOOL outlineVisable;
@property (nonatomic) BOOL canZoomIn;
@property (nonatomic) BOOL canZoomOut;

- (id)initWithAttachment:(Attachment *)attachment;

@end
