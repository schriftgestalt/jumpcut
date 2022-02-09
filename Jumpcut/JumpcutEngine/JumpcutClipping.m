//
//  JumpcutClipping.m
//  Jumpcut
//  http://jumpcut.sourceforge.net/
//
//  Created by steve on Sun Jan 12 2003.
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

#import "JumpcutClipping.h"

#define _DISPLENGTH 50

@implementation JumpcutClipping

-(id) init
{
    self = [self initWithContents:@""
                         withType:@""];
    return self;
}

-(id) initWithContents:(NSString *)contents withType:(NSString *)type
{
    self = [super init];
    [self setContents:contents];
    [self setType:type];

    return self;
}

/*
- (id)initWithCoder:(NSCoder *)coder
{
    NSString * newContents;
    int newMenuLength;
    NSString *newType;
    BOOL newHasName;
    if ( self = [super init]) {
        newContents = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(int) at:&newMenuLength];
        newType = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(BOOL) at:&newHasName];
        [self       setContents:newContents
                setMenuLength:newMenuLength];
        [self setType:newType];
        [self setHasName:newHasName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    int codeMenuLength = [self displayLength];
    BOOL codeHasName = [self hasName];
    [coder encodeObject:[self contents]];
    [coder encodeValueOfObjCType:@encode(int) at:&codeMenuLength];
    [coder encodeObject:[self type]];
    [coder encodeValueOfObjCType:@encode(BOOL) at:&codeHasName];
}
*/

- (void) setContents:(NSString *)newContents
{
    _contents = newContents;
    [self resetDisplayStrings];
}

- (NSAttributedString *)replaceNewlinesAndTabs:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\u21B5\u200B"];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"\u21E5"];

    NSMutableAttributedString *menuAttributes = [[NSMutableAttributedString alloc] initWithString:string];
    //[menuAttributes addAttribute:NSFontAttributeName value:[NSFont menuFontOfSize:13] range:NSMakeRange(0, menuAttributes.length)];
    [menuAttributes addAttribute:NSForegroundColorAttributeName value:[NSColor labelColor] range:NSMakeRange(0, menuAttributes.length)];
    NSCharacterSet *spechial = [NSCharacterSet characterSetWithCharactersInString:@"\u21B5\u21E5\u200B"];
    NSRange whitespaceRange = [string rangeOfCharacterFromSet:spechial];
    while (whitespaceRange.location < NSNotFound) {
        [menuAttributes addAttribute:NSForegroundColorAttributeName value:[NSColor tertiaryLabelColor] range:whitespaceRange];
        NSUInteger rangeEnd = NSMaxRange(whitespaceRange);
        if (rangeEnd >= menuAttributes.length) {
            break;
        }
        whitespaceRange = [string rangeOfCharacterFromSet:spechial options:0 range:NSMakeRange(rangeEnd, menuAttributes.length - rangeEnd)];
    }
    return menuAttributes;
}

- (void) resetDisplayStrings
{
    // unsigned long start, lineEnd, contentsEnd;
    // NSRange startRange = NSMakeRange(0,0);
    // NSRange contentsRange;
    // We're resetting the display string, so release the old one.
    // We want to restrict the display string to the clipping contents through the first line break.
    NSString *menuString = _contents;
    if ( [menuString length] > _DISPLENGTH ) {
        menuString = [[NSString stringWithString:[menuString substringToIndex:_DISPLENGTH]] stringByAppendingString:@"…"];
    } else {
        menuString = [NSString stringWithString:menuString];
    }
    _menuAttributedString = [self replaceNewlinesAndTabs:menuString];
    _listAttributedString = [self replaceNewlinesAndTabs:_contents];
    NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
    [textParagraph setLineSpacing:6];
    [(NSMutableAttributedString *)_listAttributedString addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, _listAttributedString.length)];

}


- (NSString *) description
{
    NSString *description = [[super description] stringByAppendingString:@": "];
    description = [description stringByAppendingString:self.menuAttributedString.string];
    return description;
}

@end
