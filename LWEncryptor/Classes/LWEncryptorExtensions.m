//
// Created by luowei on 2019/5/10.
//

#import "LWEncryptorExtensions.h"


@implementation NSString (MD5)

- (NSString*)md5 {
    return [self dataUsingEncoding:NSUTF8StringEncoding].md5String;
}

@end


@implementation NSData(Digest)

- (NSData*)md5 {
    if(![self length] ) {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (int)[self length], result);
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    return data;
}

- (NSString*)md5String {
    return [[self md5] hex];
}

- (NSData*)sha1 {
    if(![self length] ) {
        return nil;
    }
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], (int)[self length], result);
    NSData *data = [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
    return data;
}

- (NSString*)hex {
    NSMutableString *hex = [NSMutableString string];
    unsigned char *chars = (unsigned char *)self.bytes;
    for (int i = 0; i!= self.length; ++i) {
        [hex appendFormat:@"%02X", chars[i] & 0x00FF];
    }
    return hex;
}

@end
