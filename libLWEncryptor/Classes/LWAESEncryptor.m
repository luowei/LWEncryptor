//
//  LWAESEncryptor.m
//  libLWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

#import "LWAESEncryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define kChosenCipherBlockSize    kCCBlockSizeAES128
#define kChosenCipherKeySize    kCCKeySizeAES128
#define kChosenDigestLength        CC_SHA1_DIGEST_LENGTH

@interface LWAESEncryptor () {
    CCOptions _padding;
}

@end

static LWAESEncryptor *sharedInstance = nil;

@implementation LWAESEncryptor

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _padding = kCCOptionPKCS7Padding;
    }
    return self;
}

- (NSData *)encrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv {
    return [self doCipher:data context:kCCEncrypt withBinaryKey:key iv:iv];
}

- (NSData *)decrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv {
    return [self doCipher:data context:kCCDecrypt withBinaryKey:key iv:iv];
}

- (NSData *)decryptString:(NSString *)str key:(NSString *)key iv:(NSString *)iv {
    return [self decrypt:[str dataUsingEncoding:NSUTF8StringEncoding] key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:iv];
}

- (NSData *)decryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv {
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    NSData *plainData = [self decrypt:cipherData key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:iv];

    return plainData;

}

- (NSData *)encryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv {
//    NSData *plainData = [[NSData alloc] initWithBase64EncodedString:str options:0];
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [self encrypt:plainData key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:iv];

    return encryptedData;
}

- (NSData *)doCipher:(NSData *)plainText context:(CCOperation)encryptOrDecrypt withBinaryKey:(NSData *)key iv:(NSString *)ivValue {
    CCCryptorStatus ccStatus = kCCSuccess;
    // Symmetric crypto reference.
    CCCryptorRef thisEncipher = NULL;
    // Cipher Text container.
    NSData *cipherOrPlainText = nil;
    // Pointer to output buffer.
    uint8_t *bufferPtr = NULL;
    // Total size of the buffer.
    size_t bufferPtrSize = 0;
    // Remaining bytes to be performed on.
    size_t remainingBytes = 0;
    // Number of bytes moved to buffer.
    size_t movedBytes = 0;
    // Length of plainText buffer.
    size_t plainTextBufferSize = 0;
    // Placeholder for total written.
    size_t totalBytesWritten = 0;
    // A friendly helper pointer.
    uint8_t *ptr;
    CCOptions *pkcs7;
    pkcs7 = &_padding;
    NSData *aSymmetricKey = key;

    // Initialization vector; dummy in this case 0's.
    uint8_t iv[kChosenCipherBlockSize];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));

    if (ivValue) {
        NSData *binIV = [ivValue dataUsingEncoding:NSUTF8StringEncoding];
        memcpy(iv, binIV.bytes, (size_t) sizeof(iv));
    }

    plainTextBufferSize = [plainText length];

    // We don't want to toss padding on if we don't need to
    if (encryptOrDecrypt == kCCEncrypt) {
        if (*pkcs7 != kCCOptionECBMode) {
            //            if((plainTextBufferSize % kChosenCipherBlockSize) == 0) {
            //                *pkcs7 = 0x0000;
            //            } else {
            //                *pkcs7 = kCCOptionPKCS7Padding;
            //            }
            *pkcs7 = kCCOptionPKCS7Padding;
        }
    } else if (encryptOrDecrypt != kCCDecrypt) {
        NSLog(@"Invalid CCOperation parameter [%d] for cipher context.", *pkcs7);
    }

    // Create and Initialize the crypto reference.
    ccStatus = CCCryptorCreate(encryptOrDecrypt,
            kCCAlgorithmAES128,
            *pkcs7,
            (const void *) [aSymmetricKey bytes],
            kChosenCipherKeySize,
            (const void *) iv,
            &thisEncipher
    );

    // Calculate byte block alignment for all calls through to and including final.
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);

    // Allocate buffer.
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));

    // Zero out buffer.
    memset((void *) bufferPtr, 0x0, bufferPtrSize);

    // Initialize some necessary book keeping.
    ptr = bufferPtr;

    // Set up initial size.
    remainingBytes = bufferPtrSize;

    // Actually perform the encryption or decryption.
    ccStatus = CCCryptorUpdate(thisEncipher,
            (const void *) [plainText bytes],
            plainTextBufferSize,
            ptr,
            remainingBytes,
            &movedBytes
    );

    // Handle book keeping.
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;

    // Finalize everything to the output buffer.
    ccStatus = CCCryptorFinal(thisEncipher,
            ptr,
            remainingBytes,
            &movedBytes
    );

    totalBytesWritten += movedBytes;

    if (thisEncipher) {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }

    if (ccStatus == kCCSuccess)
        cipherOrPlainText = [NSData dataWithBytes:(const void *) bufferPtr length:(NSUInteger) totalBytesWritten];
    else
        cipherOrPlainText = nil;

    if (bufferPtr) free(bufferPtr);

    return cipherOrPlainText;
}


@end
