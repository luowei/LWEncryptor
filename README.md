# LWEncryptor

[![CI Status](https://img.shields.io/travis/luowei/LWEncryptor.svg?style=flat)](https://travis-ci.org/luowei/LWEncryptor)
[![Version](https://img.shields.io/cocoapods/v/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![License](https://img.shields.io/cocoapods/l/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![Platform](https://img.shields.io/cocoapods/p/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
@interface LWAESEncryptor : NSObject
+ (instancetype)sharedInstance;
- (NSData *)encrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;
- (NSData *)decrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;
- (NSData *)decryptString:(NSString *)str key:(NSString *)key iv:(NSString *)iv;
- (NSData *)decryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;
- (NSData *)encryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;
@end


@interface NSString (MD5)
- (NSString*)md5;
@end

@interface NSData(Digest)
- (NSString*)md5String;
- (NSData*)md5;
- (NSData*)sha1;
- (NSString*)hex;
@end

```

## Requirements

## Installation

LWEncryptor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LWEncryptor'
```

**Carthage**
```ruby
github "luowei/LWEncryptor"
```

## Author

luowei, luowei@wodedata.com

## License

LWEncryptor is available under the MIT license. See the LICENSE file for more info.
