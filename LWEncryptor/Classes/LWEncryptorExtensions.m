//
// Created by luowei on 2019/5/10.
//

#import "LWEncryptorExtensions.h"


@implementation NSString (MD5)

- (NSString*)md5 {
    return [self dataUsingEncoding:NSUTF8StringEncoding].md5String;
}

@end


@interface NSData(Digest)

- (NSString*)md5String;
- (NSData*)md5;
- (NSData*)sha1;
- (NSString*)hex;

@end