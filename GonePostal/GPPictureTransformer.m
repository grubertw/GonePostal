//
//  GPPictureTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 6/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPictureTransformer.h"
#import "GPCatalog.h"
#import "Stamp.h"

static NSString * USING_MAJOR_VARIETY = @"Major Variety Picture";
static NSString * USING_GPCATALOG = @"GP Catalog Picture";

@interface GPPictureTransformer()
@property (strong, nonatomic) GPDocument * doc;
@end

@implementation GPPictureTransformer

+ (Class)transformedValueClass { return [NSImage class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

// Initialze the transformer with a reference to the GPDocument.
- (id)initWithDocument:(GPDocument *)doc {
    self = [super init];
    if (self) {
        self.doc = doc;
    }
    return self;
}

//
// Composites the picture located within a GPCatalog or stamp
// with text, indicating if the GPCatalog picture is inheriting
// from the major variety, or if the stamp is inheriting from the
// GPCatalog.
//
- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (   ![value isMemberOfClass:[Stamp class]]
        && ![value isMemberOfClass:[GPCatalog class]]) return nil;
    
    // Determine how to proceed based on the Stamp or GPCatalog object
    // If there is an image set for the object, use that image with no
    // watermarking.
    NSString * filepath;
    bool mustInheritFromMajorVariety = NO;
    bool mustInheritFromCatalog = NO;
    
    if ([value isMemberOfClass:[GPCatalog class]]) {
        GPCatalog * entry = value;
        
        if (entry.default_picture && ![entry.default_picture isEqualToString:@"empty"])
            filepath = entry.default_picture;
        else {
            mustInheritFromMajorVariety = YES;
            
            if (entry.majorVariety)
                filepath = entry.majorVariety.default_picture;
        }
    }
    else if ([value isMemberOfClass:[Stamp class]]) {
        Stamp * stamp = value;
        
        if (stamp.default_picture && ![stamp.default_picture isEqualToString:@"empty"])
            filepath = stamp.default_picture;
        else {
            mustInheritFromCatalog = YES;
            
            if (stamp.gpCatalog) {
                filepath = stamp.gpCatalog.default_picture;
                
                if (   (!filepath || [filepath isEqualToString:@"empty"])
                    && stamp.gpCatalog.majorVariety)
                    filepath = stamp.gpCatalog.majorVariety.default_picture;
            }
        }
    }
    
    // Show no picture if none can be found through the inheritance chain.
    if (!filepath) return nil;
    
    NSString * gpWrapperPath = [[self.doc fileURL] path];
    NSString * absolutePath = [gpWrapperPath stringByAppendingPathComponent:filepath];
    
    // Create the file-backed image
    // (note: draw operations will occour in the cache, not affecting
    // the image data stored on the disk)
    NSImage * gpImage = [[NSImage alloc] initByReferencingFile:absolutePath];
    
    // Make sure the image can be drawn
    if (![gpImage isValid]) return nil;
    
    // Do not watermark the image if the inheritance flags aren't set.
    if (!mustInheritFromCatalog && !mustInheritFromMajorVariety) return gpImage;

    // Get the image's bitmap representation.
    NSBitmapImageRep * bitmap;
    for (id imgRep in [gpImage representations]) {
        if ([imgRep isKindOfClass:[NSBitmapImageRep class]]) {
            bitmap = imgRep;
            break;
        }
    }
    
    if (bitmap) {
        [gpImage lockFocus];
        
        NSMutableAttributedString * watermarkString;
        if (mustInheritFromMajorVariety) {
            watermarkString = [[NSMutableAttributedString alloc] initWithString:USING_MAJOR_VARIETY];
        }
        else if (mustInheritFromCatalog) {
            watermarkString = [[NSMutableAttributedString alloc] initWithString:USING_GPCATALOG];
        }
        
        NSSize imgSize = [gpImage size];
        
        // Determine the scale factor of the font.
        CGFloat fontScale = imgSize.width / 12;
        
        NSFont * font = [NSFont fontWithName:@"Futura Condensed ExtraBold" size:fontScale];
        if (font) {
            NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc] init];
            [ps setAlignment:NSCenterTextAlignment];
            
            [watermarkString setAttributes:
             @{
                       NSFontAttributeName: font,
             NSParagraphStyleAttributeName: ps,
            NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:1.0 alpha:0.6],
                NSStrokeColorAttributeName: [NSColor colorWithCalibratedWhite:0.0 alpha:0.6],
                NSStrokeWidthAttributeName: @(-3.0)
             }
                                     range:NSMakeRange(0, [watermarkString length])];
            
            // Calculate the drawing rectangle.
            NSRect watermarkBottomRect = NSMakeRect(0,
                                                    imgSize.height * 0.05,
                                                    imgSize.width,
                                                    font.boundingRectForFont.size.height);
            NSRect watermarkTopRect = NSMakeRect(0,
                                                 imgSize.height * 0.95 - watermarkBottomRect.size.height,
                                                 watermarkBottomRect.size.width,
                                                 watermarkBottomRect.size.height);
            
            [watermarkString drawInRect:watermarkTopRect];
            [watermarkString drawInRect:watermarkBottomRect];
        }
        
        [gpImage unlockFocus];
    }
    return gpImage;
}

@end
