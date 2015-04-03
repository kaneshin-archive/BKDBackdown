// BKDMarkdown.m
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

#import "BKDMarkdown.h"

#include "markdown.h"
#include "html.h"
#include "buffer.h"

#define OUTPUT_UNIT 64
#define MAX_NESTING 16

void
bd_render(struct buf *ob, const struct buf *ib)
{
    struct sd_callbacks callbacks;
    struct html_renderopt options;
    struct sd_markdown *markdown;

    unsigned int flags = HTML_USE_XHTML;
    sdhtml_renderer(&callbacks, &options, flags);
    markdown = sd_markdown_new(0, 16, &callbacks, &options);
    sd_markdown_render(ob, ib->data, ib->size, markdown);
    sd_markdown_free(markdown);
}

@interface BKDMarkdown ()
@property (readwrite, nonatomic, strong) NSString *html;
@end

@implementation BKDMarkdown {
    bd_buf *ob;
    struct sd_markdown *markdown;

    struct sd_callbacks callbacks;
    struct html_renderopt options;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        ob = bufnew(OUTPUT_UNIT);
        self.flags = BKDHTMLNone;
        self.extensions = BKDMarkdownExtensionNone;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    self = [self init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)dealloc {
    bufrelease(ob);
    sd_markdown_free(markdown);
}

- (void)refreshMarkdown {
    sdhtml_renderer(&callbacks, &options, [self htmlFlags]);
    if (markdown) {
        sd_markdown_free(markdown);
    }
    markdown = sd_markdown_new([self markdownExtensions], MAX_NESTING, &callbacks, &options);
}

- (void)setFlags:(BKDHTMLFlags)flags {
    _flags = flags;
    [self refreshMarkdown];
}

- (void)setExtensions:(BKDMarkdownExtensions)extensions {
    _extensions = extensions;
    [self refreshMarkdown];
}

- (void)setText:(NSString *)text {
    _text = text;
    _html = nil;
    bufreset(ob);
}

- (NSString *)html {
    if (_html == nil) {
        const uint8_t *data = (uint8_t *)[self.text.copy UTF8String];
        uint32_t size = (uint32_t)[self.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        sd_markdown_render(ob, data, size, markdown);
        _html = [[NSString alloc] initWithBytes:ob->data length:ob->size encoding:NSUTF8StringEncoding];
        if (_html == nil) {
            _html = @"";
        }
    }
    return _html;
}

- (uint32_t)htmlFlags {
    uint32_t f = 0;
    if (self.flags & BKDHTMLSkipHTML) {
        f |= HTML_SKIP_HTML;
    }
    if (self.flags & BKDHTMLSkipStyle) {
        f |= HTML_SKIP_STYLE;
    }
    if (self.flags & BKDHTMLSkipImages) {
        f |= HTML_SKIP_IMAGES;
    }
    if (self.flags & BKDHTMLSkipLinks) {
        f |= HTML_SKIP_LINKS;
    }
    if (self.flags & BKDHTMLExpandTabs) {
        f |= HTML_EXPAND_TABS;
    }
    if (self.flags & BKDHTMLSafelink) {
        f |= HTML_SAFELINK;
    }
    if (self.flags & BKDHTMLToc) {
        f |= HTML_TOC;
    }
    if (self.flags & BKDHTMLHardWrap) {
        f |= HTML_HARD_WRAP;
    }
    if (self.flags & BKDHTMLUseXHTML) {
        f |= HTML_USE_XHTML;
    }
    if (self.flags & BKDHTMLEscape) {
        f |= HTML_ESCAPE;
    }
    return f;
}

- (uint32_t)markdownExtensions {
    uint32_t ext = 0;
    if (self.extensions & BKDMarkdownExtensionNoIntraEmphasis) {
        ext |= MKDEXT_NO_INTRA_EMPHASIS;
    }
    if (self.extensions & BKDMarkdownExtensionTables) {
        ext |= MKDEXT_TABLES;
    }
    if (self.extensions & BKDMarkdownExtensionFencedCode) {
        ext |= MKDEXT_FENCED_CODE;
    }
    if (self.extensions & BKDMarkdownExtensionAutolink) {
        ext |= MKDEXT_AUTOLINK;
    }
    if (self.extensions & BKDMarkdownExtensionStrikethrough) {
        ext |= MKDEXT_STRIKETHROUGH;
    }
    if (self.extensions & BKDMarkdownExtensionSpaceHeaders) {
        ext |= MKDEXT_SPACE_HEADERS;
    }
    if (self.extensions & BKDMarkdownExtensionSuperscript) {
        ext |= MKDEXT_SUPERSCRIPT;
    }
    if (self.extensions & BKDMarkdownExtensionLaxSpacing) {
        ext |= MKDEXT_LAX_SPACING;
    }
    return ext;
}

@end
