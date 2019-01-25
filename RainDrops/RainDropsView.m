//
//  RainDropsView.m
//  RainDrops
//
//  Created by Jo Albright on 1/25/19.
//  Copyright © 2019 Roadie, Inc. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import "RainDropsView.h"

CGFloat padding = 100;
CGFloat spacing = 30;
CGFloat size = 50;

@interface RainDropsView ()

@property (nonatomic) CGFloat rows;
@property (nonatomic) CGFloat cols;

@property (nonatomic) NSMutableArray *drops;

@end

@implementation RainDropsView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {

    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];

        _drops = [@[] mutableCopy];

        _rows = floor((frame.size.height - padding * 2) / (spacing + size));
        _cols = floor((frame.size.width - padding * 2) / (spacing + size));

        for (int c = 0; c < self.cols; c++) {

            NSMutableArray *array = [@[] mutableCopy];

            for (int r = 0; r < self.rows; r++) {

                [array addObject:[NSNumber numberWithFloat:0]];

            }

            [_drops addObject:array];

        }

    }
    return self;

}

- (void)startAnimation { [super startAnimation]; }

- (void)stopAnimation { [super stopAnimation]; }

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];

    CGContextRef context = [NSGraphicsContext currentContext].CGContext;

    CGFloat xSpacing = (self.cols - 1) * spacing;
    CGFloat ySpacing = (self.rows - 1) * spacing;

    CGFloat xSize = self.cols * size;
    CGFloat ySize = self.rows * size;

    CGFloat xOffset = (rect.size.width - (xSpacing + xSize + padding * 2)) / 2;
    CGFloat yOffset = (rect.size.height - (ySpacing + ySize + padding * 2)) / 2;

    for (int c = 0; c < self.cols; c++) {

        for (int r = 0; r < self.rows; r++) {

            CGFloat x = padding + c * (size + spacing) + xOffset;
            CGFloat y = padding + r * (size + spacing) + yOffset;

            CGFloat a = ((NSNumber *)self.drops[c][r]).floatValue;

            [[NSColor colorWithWhite:1 alpha:a] set];

            CGContextFillEllipseInRect(context, CGRectMake(x, y, size, size));

        }

    }

}

- (void)animateOneFrame {

    [self rainDrops];
//    if (arc4random_uniform(4) == 2) { [self rainDrops]; }
    [self fadeAll];
    [self setNeedsDisplay:YES];
    return;

}

- (void)rainDrops {

    int d = arc4random_uniform(3);

    for (int i = 0; i < d; i++) {

        int c = arc4random_uniform(self.cols);
        int r = arc4random_uniform(self.rows);

        self.drops[c][r] = [NSNumber numberWithInt:1];

    }

}

- (void)fadeAll {

    for (int c = 0; c < self.cols; c++) {

        for (int r = 0; r < self.rows; r++) {

            CGFloat i = ((NSNumber *)self.drops[c][r]).floatValue;
            self.drops[c][r] = [NSNumber numberWithFloat:i - 0.02];

        }

    }

}

- (BOOL)hasConfigureSheet { return NO; }

- (NSWindow*)configureSheet { return nil; }

@end
