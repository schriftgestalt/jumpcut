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

@end

