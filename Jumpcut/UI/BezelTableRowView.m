//
//  BezelTableRowView.m
//  Jumpcut
//
//  Created by Georg Seifert on 09.02.22.
//  Copyright © 2022 Steve Cook. All rights reserved.
//

#import "BezelTableRowView.h"

@implementation BezelTableRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:8 yRadius:8];
    if (@available(macOS 10.14, *)) {
        [[NSColor controlAccentColor] set];
    }
    else {
        [[NSColor colorWithDeviceRed:8.0 / 255.0
                               green:109.0 / 255.0
                                blue:214.0 / 255.0
                               alpha:1] set];
    }
    [bezierPath fill];
}

- (void)drawSeparatorInRect:(NSRect)dirtyRect
{
    if (@available(macOS 11, *)) {
        [super drawSeparatorInRect:dirtyRect];
    }
    else {
        if (!self.selected) {
            NSRect frame = self.bounds;
            [[NSColor tertiaryLabelColor] set];
            NSBezierPath *bezierpath = [NSBezierPath bezierPathWithRect:NSMakeRect(NSMinX(frame) + 10, NSMaxY(frame) - 1, NSWidth(frame) - 20, 1)];

            NSArray *colors = @[
                [NSColor clearColor],
                [[NSColor textColor] colorWithAlphaComponent:0.1],
                [NSColor clearColor]
            ];
            CGFloat locations[3];
            locations[0] = 0;
            locations[1] = 0.5;
            locations[2] = 1;
            NSGradient *gradient = [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace sRGBColorSpace]];
            [gradient drawInBezierPath:bezierpath angle:0];
        }
    }
}
@end

