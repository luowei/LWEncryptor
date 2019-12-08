//
//  LWRSAEncryptor.m
//  LWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWRSAEncryptor.h"
#import <OpenSSL-Universal/openssl/rsa.h>
#import <OpenSSL-Universal/openssl/sha.h>
#import <OpenSSL-Universal/openssl/pem.h>


static LWRSAEncryptor *sharedEncryptor = nil;


@interface LWRSAEncryptor () {
    RSA *_publicKeyRSA;
    RSA *_privateKeyRSA;
}


@property(nonatomic) int padding;

@end

@implementation LWRSAEncryptor

+ (instancetype)defaultEncryptor {
    static LWRSAEncryptor *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (instancetype)defaultEncryptorWith:Padding:(int)padding {
    return [[LWRSAEncryptor alloc] initWithPadding:padding];
}

+ (instancetype)encrytorWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey {
    return [[LWRSAEncryptor alloc] initWithPublicKey:publicKey privateKey:privateKey];
}

- (instancetype)init {
    if (self = [super init]) {
        self.padding = RSA_PKCS1_PADDING;
        //todo: 设置publickKey 与 privateKey
    }
    return self;
}

- (id)initWithPadding:(int)padding {
    self = [super init];
    if (self) {
        self.padding = padding;
        //todo: 设置publickKey 与 privateKey
    }
    return self;
}


- (instancetype)initWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey {
    if (self = [super init]) {
        self.padding = RSA_PKCS1_PADDING;
        _publicKeyRSA = [self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding] ];
        _privateKeyRSA = [self privateKeyValue:[privateKey dataUsingEncoding:NSUTF8StringEncoding] ];
    }
    return self;
}


#pragma mark - 构造 RSA

- (RSA *)publicKeyValue:(NSData *)publicKey {
    NSString *pemKey = [self formatToPEM:publicKey isPublicKey:YES];
    const char *key = [pemKey UTF8String];
    BIO *bio = BIO_new_mem_buf((void *) key, (int) strlen(key));
    RSA *publicRSA = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    return publicRSA;
}

- (RSA *)privateKeyValue:(NSData *)privateKey {
    NSString *pemKey = [self formatToPEM:privateKey isPublicKey:NO];
    const char *key = [pemKey UTF8String];
    BIO *bio = BIO_new_mem_buf((void *) key, (int) strlen(key));
    RSA *privateRSA = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    BIO_free(bio);
    return privateRSA;
}

- (NSString *)formatToPEM:(NSData *)rsaKeyData isPublicKey:(BOOL)type {
    NSString *rsaKey = [[NSString alloc] initWithData:rsaKeyData encoding:NSUTF8StringEncoding];
    NSMutableString *rsaKeyStr = [[NSMutableString alloc] init];
    NSInteger y = rsaKey.length % 64 == 0 ? rsaKey.length / 64 : rsaKey.length / 64 + 1;
    for (int i = 0; i < y; i++) {
        if (i == (y - 1)) {
            [rsaKeyStr appendString:[NSString stringWithFormat:@"%@", [rsaKey substringFromIndex:i * 64]]];
        } else {
            [rsaKeyStr appendString:[NSString stringWithFormat:@"%@", [rsaKey substringWithRange:NSMakeRange(i * 64, 64)]]];
            [rsaKeyStr appendFormat:@"\n"];
        }
    }
    if (type) {//公钥
        return [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----", rsaKeyStr];
    } else {//私钥
        return [NSString stringWithFormat:@"-----BEGIN PRIVATE KEY-----\n%@\n-----END PRIVATE KEY-----", rsaKeyStr];
    }
}




#pragma mark - 公钥加密

- (NSData *)encryptByPublicKeyWithString:(NSString *)plainString {
    return [self encryptDataWithPublicKey:[plainString dataUsingEncoding:NSUTF8StringEncoding] RSA:_publicKeyRSA];
}
- (NSData *)encryptByPublicKeyWithData:(NSData *)data {
    return [self encryptDataWithPublicKey:data RSA:_publicKeyRSA];
}

- (NSData *)encryptString:(NSString *)plainText publicKey:(NSString *__nonnull)publicKey {
    return [self encryptDataWithPublicKey:[plainText dataUsingEncoding:NSUTF8StringEncoding]
                                            RSA:[self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)encryptData:(NSData *)plainData publicKey:(NSString *__nonnull)publicKey {
    return [self encryptDataWithPublicKey:plainData
                                            RSA:[self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)encryptDataWithPublicKey:(NSData *)plaindata RSA:(RSA *)rsa {
    if (!rsa) {
        return nil;
    }
    int maxSize = RSA_size(rsa);
    unsigned char *output = (unsigned char *) malloc(maxSize * sizeof(char));
    int bytes = RSA_public_encrypt((int) [plaindata length], [plaindata bytes], output, rsa, _padding);
    return (bytes > 0) ? [NSData dataWithBytes:output length:(NSUInteger) bytes] : nil;
}



#pragma mark - 公钥解密

- (NSData *)decryptData:(NSData *)encryptData publicKey:(NSString *__nonnull)publicKey {
    return [self decryptData:encryptData
                               rsa:[self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)decryptData:(NSData *)encryptorData rsa:(RSA *)rsa {
    if (!rsa) {
        return nil;
    }
    int maxSize = RSA_size(rsa);
    unsigned char *output = (unsigned char *) malloc(maxSize * sizeof(char));
    int bytes = RSA_public_decrypt((int) [encryptorData length], [encryptorData bytes], output, rsa, _padding);
    return (bytes > 0) ? [NSData dataWithBytes:output length:(NSUInteger) bytes] : nil;
}





#pragma mark - 私钥加签

- (NSString *)signString:(NSString *)plainString {
    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self signData:plainData];

    //data to hex
    NSMutableString *hex = [NSMutableString string];
    unsigned char *chars = (unsigned char *)data.bytes;
    for (int i = 0; i!= data.length; ++i) {
        [hex appendFormat:@"%02X", chars[i] & 0x00FF];
    }
    return hex;
}

- (NSData *)signData:(NSData *)data {
    return [self signData:data withRSA:_privateKeyRSA];
}

- (NSData *)signDataForData:(NSData *)plainData privateKey:(NSString *__nonnull)privateKey {
    return [self signData:plainData
                        withRSA:[self privateKeyValue:[privateKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)signData:(NSData *)data withRSA:(RSA *)rsa {
    if (!rsa || data.length == 0) {
        return nil;
    }

//    NSData *shaData = [data sha1];
    unsigned char shaData[SHA_DIGEST_LENGTH];
    SHA1((unsigned char *)data.bytes, data.length, shaData);

    NSMutableData *signature = [NSMutableData dataWithLength:(NSUInteger) RSA_size(rsa)];
    unsigned int signatureLength = 0;
    if (RSA_sign(NID_sha1, shaData, SHA_DIGEST_LENGTH, signature.mutableBytes, &signatureLength, rsa) == 0) {
        return nil;
    }
    [signature setLength:(NSUInteger) signatureLength];

    return signature.copy;
}





#pragma mark - 私钥解密

- (NSData *)decryptByPrivateKeyWithEncryptString:(NSString *)encryptString {
    return [self decryptByPrivateKeyWithEncryptData:[encryptString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)decryptByPrivateKeyWithEncryptData:(NSData *)encryptData {
    return [self decryptEncryptData:encryptData withRSA:_privateKeyRSA];
}

- (NSData *)decryptStringForData:(NSString *)encryptString privateKey:(NSString *)privateKey {
    return [self decryptEncryptData:[encryptString dataUsingEncoding:NSUTF8StringEncoding]
                                  withRSA:[self privateKeyValue:[privateKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)decryptDataForData:(NSData *)encryptData privateKey:(NSString *)privateKey {
    return [self decryptEncryptData:encryptData
                                  withRSA:[self privateKeyValue:[privateKey dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSData *)decryptEncryptData:(NSData *)encryptorData withRSA:(RSA *)rsa {
    if (!rsa) {
        return nil;
    }
    int maxSize = RSA_size(rsa);
    unsigned char *output = (unsigned char *) malloc(maxSize * sizeof(char));
    int bytes = RSA_private_decrypt((int) [encryptorData length], [encryptorData bytes], output, rsa, _padding);
    return (bytes > 0) ? [NSData dataWithBytes:output length:(NSUInteger) bytes] : nil;
}




#pragma mark - 验签

- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString {
    return [self verifySourceString:string withSign:signString rsa:_publicKeyRSA];
}
- (BOOL)verifyData:(NSData *)data signature:(NSData *)signature {
    return [self verifyData:data signature:signature rsa:_publicKeyRSA];
}


- (BOOL)verifyString:(NSString *)sourceString signString:(NSString *)signString publicKey:(NSString *)publicKey {
    return [self verifySourceString:sourceString withSign:signString rsa:[self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding]]];
}
- (BOOL)verifyData:(NSData *)plainData signature:(NSData *)signature publicKey:(NSString *)publicKey {
    return [self verifyData:plainData signature:signature rsa:[self publicKeyValue:[publicKey dataUsingEncoding:NSUTF8StringEncoding]]];
}


- (BOOL)verifyData:(NSData *)data signature:(NSData *)signature rsa:(RSA *)rsa {
//    NSData *shaData = [data sha1];
    unsigned char shaData[SHA_DIGEST_LENGTH];
    SHA1((unsigned char *)data.bytes, data.length, shaData);

    if (RSA_verify(NID_sha1, shaData, SHA_DIGEST_LENGTH, signature.bytes, (int) signature.length, rsa) == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)verifySourceString:(NSString *)string withSign:(NSString *)signString rsa:(RSA *)rsa {
    if (!rsa) {
        NSLog(@"please import public key first");
        return NO;
    }

    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int) [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *) [signatureData bytes];
    unsigned int sig_len = (int) [signatureData length];
    unsigned char sha1[20];
    SHA1((unsigned char *) message, messageLength, sha1);
    int verify_ok = RSA_verify(NID_sha1, sha1, 20, sig, sig_len, rsa);

    if (1 == verify_ok) {
        return YES;
    }
    return NO;
}

@end
