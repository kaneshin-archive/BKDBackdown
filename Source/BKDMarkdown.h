// BKDMarkdown.h
//
// Copyright (c) 2015 Shintaro Kaneko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, BKDHTMLFlags) {
    BKDHTMLNone         = 0,
    BKDHTMLSkipHTML     = 1 << 0,
    BKDHTMLSkipStyle    = 1 << 1,
    BKDHTMLSkipImages   = 1 << 2,
    BKDHTMLSkipLinks    = 1 << 3,
    BKDHTMLExpandTabs   = 1 << 4,
    BKDHTMLSafelink     = 1 << 5,
    BKDHTMLToc          = 1 << 6,
    BKDHTMLHardWrap     = 1 << 7,
    BKDHTMLUseXHTML     = 1 << 8,
    BKDHTMLEscape       = 1 << 9,
};

typedef NS_OPTIONS(NSUInteger, BKDMarkdownExtensions) {
    BKDMarkdownExtensionNone                   = 0,
    BKDMarkdownExtensionNoIntraEmphasis        = 1 << 0,
    BKDMarkdownExtensionTables                 = 1 << 1,
    BKDMarkdownExtensionFencedCode             = 1 << 2,
    BKDMarkdownExtensionAutolink               = 1 << 3,
    BKDMarkdownExtensionStrikethrough          = 1 << 4,
    BKDMarkdownExtensionSpaceHeaders           = 1 << 6,
    BKDMarkdownExtensionSuperscript            = 1 << 7,
    BKDMarkdownExtensionLaxSpacing             = 1 << 8,
};

@interface BKDMarkdown : NSObject
@property (nonatomic, assign) BKDHTMLFlags flags;
@property (nonatomic, assign) BKDMarkdownExtensions extensions;
@property (nonatomic, strong) NSString *text;
@property (readonly, nonatomic, strong) NSString *html;

- (instancetype)initWithText:(NSString *)text;
@end
