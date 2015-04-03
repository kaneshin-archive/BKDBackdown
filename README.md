# BKDBackdown

BKDBackdown is Markdown parser for OSX and iOS.

The framework uses [backdown](https://github.com/backdown/backdown) sources to parse markdown text.


## Installation

### Carthage

1. Add the following to your *Cartfile*: `github "backdown/BKDBackdown" ~> 1.0`
2. Run `carthage update`
3. Add BKDBackdown as an embedded framework.


## Usage

Import `#import <BKDBackdown/BKDBackdown.h>` in your header file.

### Objective-C

```objc
BKDMarkdown *markdown = [[BKDBackdown alloc] initWithText:@"# Hello world"];
NSLog(@"%@", markdown.html); // => <h1>Hello world</h1>
```

### Swift

```swift
let markdown = BKDMarkdown(text: "# Hello world")
println(parser.html)  // => <h1>Hello world</h1>
```

## License

[The MIT License (MIT)](http://kaneshin.mit-license.org/)

## Author

Shintaro Kaneko <kaneshin0120@gmail.com>
