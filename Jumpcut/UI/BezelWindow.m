//
//  BezelWindow.m
//  Jumpcut
//
//  Created by Steve Cook on 4/3/06.
//  Copyright 2006 Steve Cook. All rights reserved.
//
//  This code is open-source software subject to the MIT License; see the homepage
//  at <http://jumpcut.sourceforge.net/> for details.

#import "BezelWindow.h"
#import "AppDelegate.h"

@implementation BezelWindow {
    BOOL _hasSetup;
}

- (void)awakeFromNib
{
    if (!_hasSetup)
    {
        self.movableByWindowBackground = YES;

        NSVisualEffectView *visualEffect = [NSVisualEffectView new];
        visualEffect.translatesAutoresizingMaskIntoConstraints = NO;
        visualEffect.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        visualEffect.material = NSVisualEffectMaterialPopover;

        visualEffect.state = NSVisualEffectStateActive;
        visualEffect.wantsLayer = YES;
        visualEffect.layer.cornerRadius = 16.0;

        self.backgroundColor = NSColor.clearColor;

        NSView *contentView = self.contentView;

        [contentView addSubview:visualEffect positioned:NSWindowBelow relativeTo:contentView.subviews.firstObject];

        [visualEffect.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:0].active = YES;
        [visualEffect.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:0].active = YES;
        [visualEffect.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:0].active = YES;
        [visualEffect.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:0].active = YES;
        _hasSetup = YES;
    };
}

- (NSColor *)roundedBackgroundWithRect:(NSRect)bgRect withRadius:(float)radius withAlpha:(float)alpha
{
    NSImage *bg = [[NSImage alloc] initWithSize:bgRect.size];
    [bg lockFocus];
    // I'm not at all clear why this seems to work
    NSRect dummyRect = NSMakeRect(0, 0, [bg size].width, [bg size].height);
    NSBezierPath *roundedRec = [NSBezierPath bezierPathWithRoundedRect:dummyRect xRadius:radius yRadius:radius];
    [[NSColor windowBackgroundColor] set];
    [roundedRec fill];
    [bg unlockFocus];
    return [NSColor colorWithPatternImage:bg];
}

- (NSColor *)sizedBezelBackgroundWithRadius:(float)radius withAlpha:(float)alpha
{
    return [self roundedBackgroundWithRect:[self frame] withRadius:radius withAlpha:alpha];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (void)keyDown:(NSEvent *)theEvent
{
    if ( self.delegate )
    {
        [(AppDelegate *)self.delegate processBezelKeyDown:theEvent];
    }
}

@end
