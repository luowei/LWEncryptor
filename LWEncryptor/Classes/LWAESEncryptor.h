//
//  LWAESEncryptor.h
//  LWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWAESEncryptor : NSObject

+ (instancetype)sharedInstance;

- (NSData *)encrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;

- (NSData *)decrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;

- (NSData *)decryptString:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

- (NSData *)decryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

- (NSData *)encryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

@end
