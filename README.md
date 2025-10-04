# LWEncryptor

[![CI Status](https://img.shields.io/travis/luowei/LWEncryptor.svg?style=flat)](https://travis-ci.org/luowei/LWEncryptor)
[![Version](https://img.shields.io/cocoapods/v/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![License](https://img.shields.io/cocoapods/l/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![Platform](https://img.shields.io/cocoapods/p/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)

**[English](./README.md)** | **[中文版](./README_ZH.md)** | **[Swift Version](./README_SWIFT_VERSION.md)**

---

## Overview

LWEncryptor is a comprehensive encryption library for iOS that provides easy-to-use interfaces for AES encryption/decryption, RSA encryption/decryption/signing, and cryptographic hash functions (MD5, SHA1). Built on top of OpenSSL, it offers robust security features with a simple Objective-C API.

## Features

- **AES Encryption**: CBC mode with customizable keys and initialization vectors
- **RSA Encryption**: Public/private key encryption and decryption with configurable padding
- **Digital Signatures**: RSA signing and verification
- **Hash Functions**: MD5 and SHA1 hashing for strings and data
- **Base64 Support**: Built-in Base64 encoding/decoding
- **Singleton Pattern**: Convenient shared instances for common use cases

## Table of Contents

- [Installation](#installation)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Usage Examples](#usage-examples)
  - [AES Encryption](#aes-encryption)
  - [RSA Encryption](#rsa-encryption)
  - [MD5 Hashing](#md5-hashing)
  - [SHA1 Hashing](#sha1-hashing)
- [API Reference](#api-reference)
- [Example Project](#example-project)
- [License](#license)
- [Author](#author)

## Installation

### CocoaPods

LWEncryptor is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'LWEncryptor'
```

Then run:
```bash
pod install
```

### Carthage

Add the following line to your Cartfile:

```ruby
github "luowei/LWEncryptor"
```

Then run:
```bash
carthage update
```

## Requirements

- iOS 8.0 or later
- Xcode 9.0 or later
- OpenSSL-Universal (automatically included as a dependency)

## Quick Start

Import the library in your Objective-C files:

```objective-c
#import <LWEncryptor/LWAESEncryptor.h>
#import <LWEncryptor/LWRSAEncryptor.h>
#import <LWEncryptor/LWEncryptorExtensions.h>
```

## Usage Examples

### AES Encryption

AES (Advanced Encryption Standard) is a symmetric encryption algorithm. LWEncryptor provides AES-128/192/256 encryption in CBC mode.

#### Basic AES Encryption and Decryption

```objective-c
#import <LWEncryptor/LWAESEncryptor.h>

// Get the shared instance
LWAESEncryptor *aes = [LWAESEncryptor sharedInstance];

// Prepare your data
NSString *plainText = @"Hello, World!";
NSString *keyString = @"1234567890123456"; // 16 bytes for AES-128
NSString *ivString = @"1234567890123456";  // 16 bytes IV

// Convert to NSData
NSData *key = [keyString dataUsingEncoding:NSUTF8StringEncoding];
NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];

// Encrypt
NSData *encryptedData = [aes encrypt:plainData key:key iv:ivString];
NSLog(@"Encrypted: %@", encryptedData);

// Decrypt
NSData *decryptedData = [aes decrypt:encryptedData key:key iv:ivString];
NSString *decryptedText = [[NSString alloc] initWithData:decryptedData
                                                encoding:NSUTF8StringEncoding];
NSLog(@"Decrypted: %@", decryptedText); // Output: Hello, World!
```

#### AES with Base64 Encoding

```objective-c
// Encrypt string and get Base64 encoded result
NSData *encryptedBase64 = [aes encryptBase64String:@"Sensitive Data"
                                               key:@"MySecretKey12345"
                                                iv:@"MyIV123456789012"];

// Convert to Base64 string for transmission or storage
NSString *base64String = [encryptedBase64 base64EncodedStringWithOptions:0];
NSLog(@"Base64 Encrypted: %@", base64String);

// Decrypt from Base64
NSData *decryptedData = [aes decryptBase64String:base64String
                                             key:@"MySecretKey12345"
                                              iv:@"MyIV123456789012"];
NSString *result = [[NSString alloc] initWithData:decryptedData
                                         encoding:NSUTF8StringEncoding];
NSLog(@"Decrypted: %@", result);
```

#### AES Key Sizes

```objective-c
// AES-128 (16 bytes key)
NSString *key128 = @"1234567890123456";

// AES-192 (24 bytes key)
NSString *key192 = @"123456789012345678901234";

// AES-256 (32 bytes key)
NSString *key256 = @"12345678901234567890123456789012";

// Use with encryption
NSData *keyData = [key256 dataUsingEncoding:NSUTF8StringEncoding];
NSData *encrypted = [aes encrypt:plainData key:keyData iv:ivString];
```

### RSA Encryption

RSA is an asymmetric encryption algorithm using public/private key pairs. LWEncryptor supports RSA encryption, decryption, signing, and verification.

#### Generate RSA Key Pair

First, you need to generate RSA keys. You can use OpenSSL command line:

```bash
# Generate private key
openssl genrsa -out private_key.pem 2048

# Extract public key
openssl rsa -in private_key.pem -pubout -out public_key.pem
```

#### Basic RSA Encryption and Decryption

```objective-c
#import <LWEncryptor/LWRSAEncryptor.h>

// Your RSA keys (PEM format)
NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\n"
                      @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n"
                      @"-----END PUBLIC KEY-----";

NSString *privateKey = @"-----BEGIN RSA PRIVATE KEY-----\n"
                       @"MIIEowIBAAKCAQEA...\n"
                       @"-----END RSA PRIVATE KEY-----";

// Create encryptor with keys
LWRSAEncryptor *rsa = [LWRSAEncryptor encrytorWithPublicKey:publicKey
                                                  privateKey:privateKey];

// Encrypt with public key
NSString *plainText = @"Confidential Message";
NSData *encryptedData = [rsa encryptByPublicKeyWithString:plainText];
NSLog(@"Encrypted: %@", [encryptedData base64EncodedStringWithOptions:0]);

// Decrypt with private key
NSData *decryptedData = [rsa decryptByPrivateKeyWithEncryptData:encryptedData];
NSString *decryptedText = [[NSString alloc] initWithData:decryptedData
                                                encoding:NSUTF8StringEncoding];
NSLog(@"Decrypted: %@", decryptedText); // Output: Confidential Message
```

#### RSA Encryption with Separate Keys

```objective-c
LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptor];

// Encrypt with specific public key
NSData *encrypted = [rsa encryptString:@"Secret Data" publicKey:publicKey];

// Decrypt with specific private key
NSData *decrypted = [rsa decryptDataForData:encrypted privateKey:privateKey];
```

#### RSA with Custom Padding

```objective-c
// Use custom padding (e.g., RSA_PKCS1_OAEP_PADDING)
LWRSAEncryptor *rsaWithPadding = [LWRSAEncryptor defaultEncryptorWith:Padding:RSA_PKCS1_OAEP_PADDING];

NSData *encrypted = [rsaWithPadding encryptByPublicKeyWithString:@"Data"];
NSData *decrypted = [rsaWithPadding decryptByPrivateKeyWithEncryptData:encrypted];
```

#### RSA Digital Signatures

```objective-c
// Sign data with private key
NSString *dataToSign = @"Important Document";
NSString *signature = [rsa signString:dataToSign];
NSLog(@"Signature: %@", signature);

// Verify signature with public key
BOOL isValid = [rsa verifyString:dataToSign withSign:signature];
if (isValid) {
    NSLog(@"Signature is valid!");
} else {
    NSLog(@"Signature verification failed!");
}

// Sign and verify with separate keys
NSData *documentData = [dataToSign dataUsingEncoding:NSUTF8StringEncoding];
NSData *signatureData = [rsa signDataForData:documentData privateKey:privateKey];

BOOL verified = [rsa verifyData:documentData
                      signature:signatureData
                      publicKey:publicKey];
```

#### Public Key Decryption

```objective-c
// In some cases, you might need to decrypt with public key
// (when data was encrypted with private key)
NSData *decryptedWithPublic = [rsa decryptData:encryptedData publicKey:publicKey];
```

### MD5 Hashing

MD5 is a widely used cryptographic hash function producing a 128-bit hash value. While not recommended for security-critical applications, it's still useful for checksums and non-cryptographic purposes.

#### String MD5

```objective-c
#import <LWEncryptor/LWEncryptorExtensions.h>

NSString *text = @"Hello, World!";
NSString *md5Hash = [text md5];
NSLog(@"MD5: %@", md5Hash);
// Output: MD5: 65A8E27D8879283831B664BD8B7F0AD4
```

#### Data MD5

```objective-c
NSData *data = [@"Sample Data" dataUsingEncoding:NSUTF8StringEncoding];

// Get MD5 as NSData
NSData *md5Data = [data md5];
NSLog(@"MD5 Data: %@", md5Data);

// Get MD5 as hex string
NSString *md5String = [data md5String];
NSLog(@"MD5 String: %@", md5String);
```

#### File MD5

```objective-c
// Calculate MD5 for a file
NSString *filePath = [[NSBundle mainBundle] pathForResource:@"document" ofType:@"pdf"];
NSData *fileData = [NSData dataWithContentsOfFile:filePath];
NSString *fileMD5 = [fileData md5String];
NSLog(@"File MD5: %@", fileMD5);
```

#### MD5 for Data Integrity

```objective-c
// Generate checksum
NSData *originalData = [@"Important Data" dataUsingEncoding:NSUTF8StringEncoding];
NSString *checksum = [originalData md5String];

// Save checksum with data
[self saveData:originalData withChecksum:checksum];

// Later, verify integrity
NSData *retrievedData = [self loadData];
NSString *retrievedChecksum = [retrievedData md5String];

if ([checksum isEqualToString:retrievedChecksum]) {
    NSLog(@"Data integrity verified!");
} else {
    NSLog(@"Data has been corrupted!");
}
```

### SHA1 Hashing

SHA1 produces a 160-bit hash value. It's more secure than MD5 for most purposes.

#### Basic SHA1

```objective-c
NSData *data = [@"Secure Data" dataUsingEncoding:NSUTF8StringEncoding];

// Get SHA1 as NSData
NSData *sha1Data = [data sha1];

// Convert to hex string
NSString *sha1String = [sha1Data hex];
NSLog(@"SHA1: %@", sha1String);
```

#### SHA1 for Password Storage

```objective-c
// Note: For real password storage, use bcrypt or PBKDF2
NSString *password = @"UserPassword123";
NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
NSString *hashedPassword = [[passwordData sha1] hex];

// Store hashedPassword in database
[self saveHashedPassword:hashedPassword forUser:@"john"];
```

## Security Best Practices

### General Security Guidelines

#### 1. Key Management
- **Never Hardcode Keys**: Never embed encryption keys directly in your source code. Keys in source code can be extracted through reverse engineering.
- **Use Keychain**: Store sensitive keys securely using iOS Keychain Services or wrapper libraries like KeychainAccess.
- **Key Rotation**: Implement a key rotation strategy for long-lived applications to minimize the impact of potential key compromise.
- **Secure Key Generation**: Use cryptographically secure random number generators (e.g., SecRandomCopyBytes) for generating keys and IVs.

```objective-c
// Good: Generate random key
NSMutableData *keyData = [NSMutableData dataWithLength:32];
int result = SecRandomCopyBytes(kSecRandomDefault, keyData.length, keyData.mutableBytes);
if (result == errSecSuccess) {
    // Use keyData as your AES key
}

// Bad: Hardcoded key
NSString *key = @"1234567890123456"; // NEVER DO THIS IN PRODUCTION
```

#### 2. Key Derivation
For password-based encryption, use proper key derivation functions:

```objective-c
// Use PBKDF2 to derive keys from passwords
#import <CommonCrypto/CommonKeyDerivation.h>

- (NSData *)deriveKeyFromPassword:(NSString *)password salt:(NSData *)salt {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedKey = [NSMutableData dataWithLength:32]; // 256-bit key

    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      passwordData.bytes,
                                      passwordData.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA256,
                                      100000, // Iterations
                                      derivedKey.mutableBytes,
                                      derivedKey.length);

    return (result == kCCSuccess) ? derivedKey : nil;
}
```

### AES Encryption Best Practices

#### 1. Initialization Vector (IV)
- **Random IV**: Always generate a random IV for each encryption operation
- **Unique IV**: Never reuse the same IV with the same key
- **IV Storage**: The IV doesn't need to be secret, but should be stored/transmitted with the ciphertext

```objective-c
// Generate random IV
NSMutableData *iv = [NSMutableData dataWithLength:16]; // AES block size
SecRandomCopyBytes(kSecRandomDefault, iv.length, iv.mutableBytes);
NSString *ivString = [[iv base64EncodedStringWithOptions:0] substringToIndex:16];

// Encrypt with random IV
LWAESEncryptor *aes = [LWAESEncryptor sharedInstance];
NSData *encrypted = [aes encrypt:plainData key:keyData iv:ivString];

// Store IV with encrypted data (e.g., prepend IV to ciphertext)
NSMutableData *encryptedWithIV = [NSMutableData dataWithData:iv];
[encryptedWithIV appendData:encrypted];
```

#### 2. Key Sizes
- **AES-128**: 16 bytes (128 bits) - Fast, sufficient for most applications
- **AES-192**: 24 bytes (192 bits) - More secure, moderate performance
- **AES-256**: 32 bytes (256 bits) - Most secure, recommended for sensitive data

```objective-c
// Use appropriate key size based on security requirements
NSMutableData *aes256Key = [NSMutableData dataWithLength:32]; // 256-bit
SecRandomCopyBytes(kSecRandomDefault, aes256Key.length, aes256Key.mutableBytes);
```

#### 3. Data Padding
LWEncryptor uses PKCS7 padding by default, which is appropriate for most use cases. Ensure you handle padding correctly during decryption.

### RSA Encryption Best Practices

#### 1. Key Size
- **Minimum**: 2048 bits for RSA keys
- **Recommended**: 3072 bits or 4096 bits for long-term security
- **Never**: Use keys smaller than 2048 bits in production

```bash
# Generate 4096-bit RSA key pair
openssl genrsa -out private_key.pem 4096
openssl rsa -in private_key.pem -pubout -out public_key.pem
```

#### 2. Padding Schemes
- **RSA_PKCS1_OAEP_PADDING**: Recommended for encryption (more secure than PKCS1)
- **RSA_PKCS1_PADDING**: Default, acceptable but OAEP is preferred
- **Never use NO_PADDING**: Always use proper padding schemes

```objective-c
// Use OAEP padding for better security
LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptorWith:Padding:RSA_PKCS1_OAEP_PADDING];
```

#### 3. Data Size Limitations
RSA can only encrypt data smaller than the key size minus padding overhead:
- **2048-bit key with PKCS1 padding**: Max ~245 bytes
- **2048-bit key with OAEP padding**: Max ~214 bytes

For larger data, use hybrid encryption:

```objective-c
// Hybrid Encryption: Encrypt data with AES, then encrypt AES key with RSA
- (NSData *)hybridEncrypt:(NSData *)plainData publicKey:(NSString *)publicKey {
    // 1. Generate random AES key
    NSMutableData *aesKey = [NSMutableData dataWithLength:32];
    SecRandomCopyBytes(kSecRandomDefault, aesKey.length, aesKey.mutableBytes);

    // 2. Generate random IV
    NSMutableData *iv = [NSMutableData dataWithLength:16];
    SecRandomCopyBytes(kSecRandomDefault, iv.length, iv.mutableBytes);
    NSString *ivString = [[NSString alloc] initWithData:iv encoding:NSUTF8StringEncoding];

    // 3. Encrypt data with AES
    LWAESEncryptor *aes = [LWAESEncryptor sharedInstance];
    NSData *encryptedData = [aes encrypt:plainData key:aesKey iv:ivString];

    // 4. Encrypt AES key with RSA
    LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptor];
    NSData *encryptedKey = [rsa encryptData:aesKey publicKey:publicKey];

    // 5. Combine: [IV length (4 bytes)] + [IV] + [encrypted key length (4 bytes)] + [encrypted key] + [encrypted data]
    NSMutableData *result = [NSMutableData data];
    uint32_t ivLength = (uint32_t)iv.length;
    [result appendBytes:&ivLength length:sizeof(ivLength)];
    [result appendData:iv];

    uint32_t keyLength = (uint32_t)encryptedKey.length;
    [result appendBytes:&keyLength length:sizeof(keyLength)];
    [result appendData:encryptedKey];
    [result appendData:encryptedData];

    return result;
}
```

#### 4. Private Key Protection
- **Encrypt Private Keys**: Store private keys encrypted with a strong password
- **Secure Storage**: Use Keychain or encrypted file storage
- **Access Control**: Implement biometric authentication (Touch ID/Face ID) for private key access

```objective-c
// Example: Store private key in Keychain with biometric protection
- (void)savePrivateKeyToKeychain:(NSString *)privateKey identifier:(NSString *)identifier {
    NSData *keyData = [privateKey dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassKey,
        (__bridge id)kSecAttrApplicationTag: identifier,
        (__bridge id)kSecValueData: keyData,
        (__bridge id)kSecAttrAccessControl: (__bridge id)SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            kSecAccessControlBiometryCurrentSet,
            nil
        )
    };

    SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}
```

### Digital Signature Best Practices

#### 1. Hash Algorithms
- **SHA1**: Deprecated for security-critical applications (used by LWEncryptor for compatibility)
- **SHA256**: Recommended minimum for new applications
- **SHA384/SHA512**: For maximum security

Note: LWEncryptor currently uses SHA1 for RSA signatures. Consider updating to SHA256 for production use.

#### 2. Signature Verification
Always verify signatures before trusting data:

```objective-c
// Verify signature before processing data
- (void)processSecureMessage:(NSData *)messageData
                    signature:(NSData *)signature
                    publicKey:(NSString *)publicKey {
    LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptor];

    BOOL isValid = [rsa verifyData:messageData signature:signature publicKey:publicKey];

    if (isValid) {
        // Signature is valid, process the message
        [self processMessage:messageData];
    } else {
        // Signature verification failed, reject the message
        NSLog(@"Invalid signature - message rejected");
        return;
    }
}
```

#### 3. Timestamp and Nonce
Prevent replay attacks by including timestamps or nonces in signed data:

```objective-c
- (NSData *)signWithTimestamp:(NSString *)message privateKey:(NSString *)privateKey {
    // Create message with timestamp
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *messageWithTimestamp = [NSString stringWithFormat:@"%@|%f", message, timestamp];
    NSData *messageData = [messageWithTimestamp dataUsingEncoding:NSUTF8StringEncoding];

    // Sign the message
    LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptor];
    return [rsa signDataForData:messageData privateKey:privateKey];
}

- (BOOL)verifyWithTimestamp:(NSString *)message
                  signature:(NSData *)signature
                  publicKey:(NSString *)publicKey
              maxAgeSeconds:(NSTimeInterval)maxAge {
    // Verify signature
    LWRSAEncryptor *rsa = [LWRSAEncryptor defaultEncryptor];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];

    if (![rsa verifyData:messageData signature:signature publicKey:publicKey]) {
        return NO; // Invalid signature
    }

    // Check timestamp
    NSArray *components = [message componentsSeparatedByString:@"|"];
    if (components.count < 2) return NO;

    NSTimeInterval messageTime = [components.lastObject doubleValue];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

    return (now - messageTime) <= maxAge; // Check if not too old
}
```

### Hash Function Best Practices

#### 1. MD5 Usage
- **Not Recommended**: MD5 is cryptographically broken
- **Acceptable Use Cases**: Non-security checksums, cache keys, file deduplication
- **Never Use For**: Password hashing, digital signatures, security tokens

```objective-c
// OK: Use MD5 for cache key
NSString *cacheKey = [[urlString dataUsingEncoding:NSUTF8StringEncoding] md5String];

// WRONG: Never use MD5 for passwords
NSString *passwordHash = [password md5]; // INSECURE!
```

#### 2. SHA1 Usage
- **Limited Use**: SHA1 is deprecated for security-critical applications
- **Still Acceptable**: Git commits, legacy system compatibility
- **Better Alternatives**: SHA256, SHA384, SHA512

#### 3. Password Hashing
Never use MD5 or SHA1 for password hashing. Use PBKDF2, bcrypt, or Argon2 instead:

```objective-c
// Correct password hashing with PBKDF2
- (NSString *)hashPassword:(NSString *)password {
    // Generate random salt
    NSMutableData *salt = [NSMutableData dataWithLength:16];
    SecRandomCopyBytes(kSecRandomDefault, salt.length, salt.mutableBytes);

    // Derive key using PBKDF2
    NSData *derivedKey = [self deriveKeyFromPassword:password salt:salt];

    // Store salt and hash together
    NSMutableData *combined = [NSMutableData dataWithData:salt];
    [combined appendData:derivedKey];

    return [combined base64EncodedStringWithOptions:0];
}
```

### Data Transmission Security

#### 1. Use HTTPS
Always transmit encrypted data over HTTPS to prevent man-in-the-middle attacks:

```objective-c
// Configure NSURLSession with proper security
NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
config.TLSMinimumSupportedProtocolVersion = tls_protocol_version_TLSv12;
```

#### 2. Certificate Pinning
Implement certificate pinning for critical APIs:

```objective-c
// Implement certificate pinning in NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    // Verify server certificate
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        // Implement certificate validation logic
        // Compare with pinned certificate
    }
}
```

#### 3. Sensitive Data in Memory
Clear sensitive data from memory when no longer needed:

```objective-c
// Zero out sensitive data
- (void)clearSensitiveData:(NSMutableData *)sensitiveData {
    if (sensitiveData) {
        memset(sensitiveData.mutableBytes, 0, sensitiveData.length);
        sensitiveData = nil;
    }
}
```

### Common Security Pitfalls

#### 1. Avoid ECB Mode
Never use ECB (Electronic Codebook) mode for AES encryption. LWEncryptor uses CBC mode, which is better but consider using GCM mode for authenticated encryption.

#### 2. Don't Roll Your Own Crypto
Use established libraries and algorithms. Don't create custom encryption schemes.

#### 3. Validate All Inputs
Always validate and sanitize inputs before encryption/decryption:

```objective-c
- (NSData *)safeEncrypt:(NSString *)plainText key:(NSString *)key iv:(NSString *)iv {
    // Validate inputs
    if (!plainText || !key || !iv) {
        NSLog(@"Invalid input parameters");
        return nil;
    }

    if (key.length < 16) {
        NSLog(@"Key too short - must be at least 16 bytes");
        return nil;
    }

    if (iv.length != 16) {
        NSLog(@"IV must be exactly 16 bytes");
        return nil;
    }

    // Proceed with encryption
    LWAESEncryptor *aes = [LWAESEncryptor sharedInstance];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];

    return [aes encrypt:plainData key:keyData iv:iv];
}
```

#### 4. Error Handling
Implement proper error handling and never expose detailed error messages to users:

```objective-c
@try {
    NSData *decrypted = [aes decrypt:encryptedData key:keyData iv:iv];
    return decrypted;
} @catch (NSException *exception) {
    NSLog(@"Decryption error: %@", exception.name);
    // Show generic error to user
    [self showError:@"Unable to decrypt data"];
    return nil;
}
```

### Compliance Considerations

#### 1. Export Regulations
Be aware of encryption export regulations in your target countries. Strong encryption may be subject to export controls.

#### 2. GDPR and Privacy
Implement proper encryption for personal data to comply with GDPR and other privacy regulations.

#### 3. Data Retention
Implement secure data deletion when retention periods expire:

```objective-c
- (void)securelyDeleteFile:(NSString *)filePath {
    // Overwrite file with random data before deletion
    NSData *randomData = [NSMutableData dataWithLength:1024 * 1024]; // 1MB
    SecRandomCopyBytes(kSecRandomDefault, randomData.length, (uint8_t *)randomData.bytes);

    [randomData writeToFile:filePath atomically:YES];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}
```

### Security Audit Checklist

Use this checklist to ensure your implementation follows security best practices:

- [ ] Keys are never hardcoded in source code
- [ ] Keys are stored securely using Keychain
- [ ] Random IVs are generated for each AES encryption
- [ ] Key derivation functions (PBKDF2) are used for password-based encryption
- [ ] RSA keys are at least 2048 bits
- [ ] OAEP padding is used for RSA encryption
- [ ] Hybrid encryption is used for large data
- [ ] Signatures are verified before trusting data
- [ ] Timestamps/nonces prevent replay attacks
- [ ] HTTPS is used for all network communications
- [ ] Certificate pinning is implemented for critical APIs
- [ ] Sensitive data is cleared from memory
- [ ] Input validation is performed
- [ ] Error handling doesn't leak sensitive information
- [ ] Code has been reviewed for security vulnerabilities
- [ ] Third-party dependencies are up to date

## API Reference

### LWAESEncryptor

AES encryption and decryption class.

#### Class Methods

##### `+ (instancetype)sharedInstance`
Returns the shared singleton instance of LWAESEncryptor.

**Returns:** Shared LWAESEncryptor instance

#### Instance Methods

##### `- (NSData *)encrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv`
Encrypts data using AES encryption.

**Parameters:**
- `data`: The data to encrypt
- `key`: The encryption key (16/24/32 bytes for AES-128/192/256)
- `iv`: The initialization vector (16 bytes)

**Returns:** Encrypted data as NSData

##### `- (NSData *)decrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv`
Decrypts AES encrypted data.

**Parameters:**
- `data`: The encrypted data
- `key`: The decryption key (must match encryption key)
- `iv`: The initialization vector (must match encryption IV)

**Returns:** Decrypted data as NSData

##### `- (NSData *)decryptString:(NSString *)str key:(NSString *)key iv:(NSString *)iv`
Decrypts an encrypted string.

**Parameters:**
- `str`: The encrypted string
- `key`: The decryption key
- `iv`: The initialization vector

**Returns:** Decrypted data as NSData

##### `- (NSData *)decryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv`
Decrypts a Base64 encoded encrypted string.

**Parameters:**
- `str`: The Base64 encoded encrypted string
- `key`: The decryption key
- `iv`: The initialization vector

**Returns:** Decrypted data as NSData

##### `- (NSData *)encryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv`
Encrypts a Base64 string.

**Parameters:**
- `str`: The Base64 string to encrypt
- `key`: The encryption key
- `iv`: The initialization vector

**Returns:** Encrypted data as NSData

### LWRSAEncryptor

RSA encryption, decryption, signing, and verification class.

#### Class Methods

##### `+ (instancetype)defaultEncryptor`
Returns a default RSA encryptor instance.

**Returns:** Default LWRSAEncryptor instance

##### `+ (instancetype)defaultEncryptorWith:Padding:(int)padding`
Returns an RSA encryptor with custom padding.

**Parameters:**
- `padding`: RSA padding mode (e.g., RSA_PKCS1_PADDING, RSA_PKCS1_OAEP_PADDING)

**Returns:** LWRSAEncryptor instance with specified padding

##### `+ (instancetype)encrytorWithPublicKey:(NSString *)publicKey privateKey:(NSString *)privateKey`
Creates an RSA encryptor with specified public and private keys.

**Parameters:**
- `publicKey`: PEM format public key string
- `privateKey`: PEM format private key string

**Returns:** Configured LWRSAEncryptor instance

#### Public Key Encryption Methods

##### `- (NSData *)encryptByPublicKeyWithString:(NSString *)plainString`
Encrypts a string using the public key.

**Parameters:**
- `plainString`: The plain text string to encrypt

**Returns:** Encrypted data

##### `- (NSData *)encryptByPublicKeyWithData:(NSData *)plaindata`
Encrypts data using the public key.

**Parameters:**
- `plaindata`: The plain data to encrypt

**Returns:** Encrypted data

##### `- (NSData *)encryptString:(NSString *)plainText publicKey:(NSString *)publicKey`
Encrypts a string with a specific public key.

**Parameters:**
- `plainText`: The text to encrypt
- `publicKey`: The public key to use

**Returns:** Encrypted data

##### `- (NSData *)encryptData:(NSData *)plainData publicKey:(NSString *)publicKey`
Encrypts data with a specific public key.

**Parameters:**
- `plainData`: The data to encrypt
- `publicKey`: The public key to use

**Returns:** Encrypted data

#### Public Key Decryption Methods

##### `- (NSData *)decryptData:(NSData *)encryptData publicKey:(NSString *)publicKey`
Decrypts data using the public key.

**Parameters:**
- `encryptData`: The encrypted data
- `publicKey`: The public key to use

**Returns:** Decrypted data

#### Private Key Decryption Methods

##### `- (NSData *)decryptByPrivateKeyWithEncryptString:(NSString *)encryptString`
Decrypts an encrypted string using the private key.

**Parameters:**
- `encryptString`: The encrypted string

**Returns:** Decrypted data

##### `- (NSData *)decryptByPrivateKeyWithEncryptData:(NSData *)encryptData`
Decrypts encrypted data using the private key.

**Parameters:**
- `encryptData`: The encrypted data

**Returns:** Decrypted data

##### `- (NSData *)decryptStringForData:(NSString *)encryptString privateKey:(NSString *)privateKey`
Decrypts an encrypted string with a specific private key.

**Parameters:**
- `encryptString`: The encrypted string
- `privateKey`: The private key to use

**Returns:** Decrypted data

##### `- (NSData *)decryptDataForData:(NSData *)encryptData privateKey:(NSString *)privateKey`
Decrypts encrypted data with a specific private key.

**Parameters:**
- `encryptData`: The encrypted data
- `privateKey`: The private key to use

**Returns:** Decrypted data

#### Signing Methods

##### `- (NSString *)signString:(NSString *)plainString`
Signs a string using the private key.

**Parameters:**
- `plainString`: The string to sign

**Returns:** Base64 encoded signature string

##### `- (NSData *)signData:(NSData *)data`
Signs data using the private key.

**Parameters:**
- `data`: The data to sign

**Returns:** Signature data

##### `- (NSData *)signDataForData:(NSData *)plainData privateKey:(NSString *)privateKey`
Signs data with a specific private key.

**Parameters:**
- `plainData`: The data to sign
- `privateKey`: The private key to use

**Returns:** Signature data

#### Verification Methods

##### `- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString`
Verifies a string signature.

**Parameters:**
- `string`: The original string
- `signString`: The signature to verify

**Returns:** YES if signature is valid, NO otherwise

##### `- (BOOL)verifyData:(NSData *)data signature:(NSData *)signature`
Verifies a data signature.

**Parameters:**
- `data`: The original data
- `signature`: The signature to verify

**Returns:** YES if signature is valid, NO otherwise

##### `- (BOOL)verifyString:(NSString *)sourceString signString:(NSString *)signString publicKey:(NSString *)publicKey`
Verifies a string signature with a specific public key.

**Parameters:**
- `sourceString`: The original string
- `signString`: The signature to verify
- `publicKey`: The public key to use

**Returns:** YES if signature is valid, NO otherwise

##### `- (BOOL)verifyData:(NSData *)plainData signature:(NSData *)signature publicKey:(NSString *)publicKey`
Verifies a data signature with a specific public key.

**Parameters:**
- `plainData`: The original data
- `signature`: The signature to verify
- `publicKey`: The public key to use

**Returns:** YES if signature is valid, NO otherwise

### NSString (MD5)

MD5 extension for NSString.

##### `- (NSString *)md5`
Calculates the MD5 hash of the string.

**Returns:** Hex string representation of MD5 hash (uppercase)

### NSData (Digest)

Cryptographic hash extensions for NSData.

##### `- (NSData *)md5`
Calculates the MD5 hash of the data.

**Returns:** MD5 hash as NSData (16 bytes)

##### `- (NSString *)md5String`
Calculates the MD5 hash and returns it as a hex string.

**Returns:** Hex string representation of MD5 hash (uppercase)

##### `- (NSData *)sha1`
Calculates the SHA1 hash of the data.

**Returns:** SHA1 hash as NSData (20 bytes)

##### `- (NSString *)hex`
Converts binary data to hex string representation.

**Returns:** Hex string (uppercase)

## Example Project

To run the example project:

1. Clone the repository
```bash
git clone https://github.com/luowei/LWEncryptor.git
cd LWEncryptor
```

2. Install dependencies
```bash
cd Example
pod install
```

3. Open the workspace
```bash
open LWEncryptor.xcworkspace
```

4. Build and run the example project in Xcode

## Author

luowei, luowei@wodedata.com

## License

LWEncryptor is available under the MIT license. See the LICENSE file for more info.
