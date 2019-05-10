//
//  LWRSAEncryptor.h
//  libLWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWRSAEncryptor : NSObject

+ (instancetype)defaultEncryptor;

+ (instancetype)defaultEncryptorWith:Padding:(int)padding;

+ (instancetype)encrytorWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey;


#pragma mark - 公钥加密

- (NSData *)encryptByPublicKeyWithString:(NSString *)plainString;
- (NSData *)encryptByPublicKeyWithData:(NSData *)plaindata;

- (NSData *)encryptString:(NSString *)plainText publicKey:(NSString *__nonnull)publicKey;
- (NSData *)encryptData:(NSData *)plainData publicKey:(NSString *__nonnull)publicKey;



#pragma mark - 公钥解密

- (NSData *)decryptData:(NSData *)encryptData publicKey:(NSString *__nonnull)publicKey;



#pragma mark - 私钥解密

- (NSData *)decryptByPrivateKeyWithEncryptString:(NSString *)encryptString;
- (NSData *)decryptByPrivateKeyWithEncryptData:(NSData *)encryptData;

- (NSData *)decryptStringForData:(NSString *)encryptString privateKey:(NSString *__nonnull)privateKey;
- (NSData *)decryptDataForData:(NSData *)encryptData privateKey:(NSString *__nonnull)privateKey;



#pragma mark - 私钥加签

- (NSString *)signString:(NSString *)plainString;
- (NSData *)signData:(NSData *)data;
- (NSData *)signDataForData:(NSData *)plainData privateKey:(NSString *__nonnull)privateKey;



#pragma mark - 验签

- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;
- (BOOL)verifyData:(NSData *)data signature:(NSData *)signature;

- (BOOL)verifyString:(NSString *)sourceString signString:(NSString *)signString publicKey:(NSString *)publicKey;
- (BOOL)verifyData:(NSData *)plainData signature:(NSData *)signature publicKey:(NSString *)publicKey;


@end
