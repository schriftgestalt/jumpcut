//
//  JumpcutStore.h
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
// The Jumpcut store is the component that actually holds the strings.
// It deals with everything regarding holding and returning the clippings,
// leaving all UI-related concerns to the other components.

// jcRememberNum and jcDisplayNum are slight misnomers; they're both "remember this many"
// limits, but they represent slightly different things.

// In Jumpcut 0.5, I should go through and fiddle with the nomenclature.

#import <Foundation/Foundation.h>

@class JumpcutClipping;

@interface JumpcutStore : NSObject

@property (strong) NSMutableArray <JumpcutClipping *> *clippings;

// Our various listener-related preferences
@property (nonatomic) NSUInteger rememberNum;
@property (nonatomic) NSUInteger displayNum;
@property (readonly) NSUInteger countOfClippings;

-(NSString *) clippingContentsAtIndex:(NSUInteger)index;
-(NSAttributedString *) clippingDisplayStringAtIndex:(NSUInteger)index;
-(NSString *) clippingTypeAtIndex:(NSUInteger)index;

// Add a clipping
-(void) addClipping:(NSString *)clipping ofType:(NSString *)type;

// Delete a clipping -- falsifiable
-(bool) removeClippingAtIndex:(NSUInteger)index;

// Delete all list clippings
-(void) clearList;

-(NSArray *) previousDisplayStrings:(NSUInteger)howMany;

@end
