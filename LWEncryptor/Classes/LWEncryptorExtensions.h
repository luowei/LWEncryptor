//
// Created by luowei on 2019/5/10.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString*)md5;

@end

@interface NSData(Digest)

- (NSString*)md5String;
- (NSData*)md5;
- (NSData*)sha1;
- (NSString*)hex;

@end

