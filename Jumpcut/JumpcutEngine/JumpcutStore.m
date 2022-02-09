//
//  JumpcutStore.m
//  Jumpcut
//  http://jumpcut.sourceforge.net/
//
//  Created by steve on Sun Dec 21 2003.
//  Copyright (c) 2003-2006 Steve Cook
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included 
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE  WARRANTIES OF 
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
//  NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
//  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JumpcutStore.h"
#import "JumpcutClipping.h"

#define _DISPLENGTH 40

@implementation JumpcutStore

@synthesize clippings = _clippings;

- (instancetype) init
{
    return [self initRemembering:20
                      displaying:10];
}

- (instancetype) initRemembering:(int)nowRemembering
           displaying:(int)nowDisplaying
{
    self = [super init];
    _clippings = [[NSMutableArray alloc] init];
    [self setRememberNum:nowRemembering];
    [self setDisplayNum:nowDisplaying];
    return self;
}

- (bool) removeClippingAtIndex:(NSUInteger)index
{
    if ([_clippings count] > index) {
        [_clippings removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

// Add a clipping
- (void) addClipping:(NSString *)clipping ofType:(NSString *)type{
    // Clipping object
    JumpcutClipping * newClipping;
    // Create clipping
    newClipping = [[JumpcutClipping alloc] initWithContents:clipping withType:type];
    // Push it onto our recent clippings stack
    [_clippings insertObject:newClipping atIndex:0];
    // Delete clippings older than jcRememberNum
    while ( [_clippings count] > _rememberNum ) {
        [_clippings removeObjectAtIndex:_rememberNum];
    }
}

-(void) addClipping:(NSString *)clipping ofType:(NSString *)type withPBCount:(int *)pbCount
{
    [self addClipping:clipping ofType:type];
}

// Clear remembered and listed
-(void) clearList {
    NSMutableArray *emptyJCList;
    emptyJCList = [[NSMutableArray alloc] init];
    _clippings = emptyJCList;
}


// Set various values
-(void) setRememberNum:(NSUInteger)nowRemembering
{
    if ( nowRemembering > 0 ) {
        _rememberNum = nowRemembering;
        while ( [_clippings count] > _rememberNum ) {
            [_clippings removeObjectAtIndex:_rememberNum];
        }
    }
}

-(NSUInteger) countOfClippings
{
    return [_clippings count];
}


-(NSString *) clippingContentsAtIndex:(NSUInteger)index
{
    if ( index >= [_clippings count] ) {
        return nil;
    } else {
        return [NSString stringWithString:[[_clippings objectAtIndex:index] contents]];
    }
}

-(NSAttributedString *) clippingDisplayStringAtIndex:(NSUInteger)index
{
    return [[_clippings objectAtIndex:index] listAttributedString];
}

-(NSString *) clippingTypeAtIndex:(NSUInteger)index
{
    NSString *returnString = [[_clippings objectAtIndex:index] type];
    return returnString;
}

-(NSArray *) previousContents:(NSUInteger)howMany
{
    NSRange theRange;
    NSArray *subArray;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator;
    JumpcutClipping *aClipping;
    theRange.location = 0;
    theRange.length = howMany;
    if ( howMany > [_clippings count] ) {
        subArray = _clippings;
    } else {
        subArray = [_clippings subarrayWithRange:theRange];
    }
    enumerator = [subArray reverseObjectEnumerator];
    while ( aClipping = [enumerator nextObject] ) {
        [returnArray insertObject:[aClipping contents] atIndex:0];
    }
    return returnArray;
}

-(NSArray *) previousDisplayStrings:(NSUInteger)howMany
{
    NSRange theRange;
    NSArray *subArray;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator;
    JumpcutClipping *aClipping;
    theRange.location = 0;
    theRange.length = howMany;
    if ( howMany > [_clippings count] ) {
        subArray = _clippings;
    } else {
        subArray = [_clippings subarrayWithRange:theRange];
    }
    enumerator = [subArray reverseObjectEnumerator];
    while ( aClipping = [enumerator nextObject] ) {
        [returnArray insertObject:aClipping.menuAttributedString atIndex:0];
    }
    return returnArray;
}

@end
