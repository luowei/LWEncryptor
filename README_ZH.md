# LWEncryptor

[![CI Status](https://img.shields.io/travis/luowei/LWEncryptor.svg?style=flat)](https://travis-ci.org/luowei/LWEncryptor)
[![Version](https://img.shields.io/cocoapods/v/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![License](https://img.shields.io/cocoapods/l/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)
[![Platform](https://img.shields.io/cocoapods/p/LWEncryptor.svg?style=flat)](https://cocoapods.org/pods/LWEncryptor)

## 简介

LWEncryptor 是一个功能强大且易于使用的 iOS 加密解密框架，提供了以下加密算法的完整实现：

- **MD5** - 消息摘要算法，用于数据完整性校验
- **SHA1** - 安全散列算法，用于数字签名
- **AES** - 高级加密标准（对称加密算法）
- **RSA** - 非对称加密算法，支持加密解密和数字签名

该框架基于 OpenSSL 库构建，提供了简洁的 Objective-C API，适用于需要数据加密保护的 iOS 应用程序。

## 功能特性

### 1. AES 对称加密
- AES-128 加密算法
- 支持自定义密钥（Key）和初始化向量（IV）
- PKCS7 填充模式
- 支持字符串和二进制数据加密
- 支持 Base64 编码/解码

### 2. RSA 非对称加密
- 支持公钥加密/私钥解密
- 支持私钥加密/公钥解密
- RSA PKCS1 填充模式
- 支持自定义填充方式
- PEM 格式密钥支持

### 3. 数字签名
- 基于 SHA1 的 RSA 数字签名
- 私钥签名
- 公钥验签
- 支持字符串和二进制数据签名

### 4. 哈希算法
- MD5 哈希
- SHA1 哈希
- 十六进制编码输出

## 系统要求

- iOS 8.0 或更高版本
- Xcode
- CocoaPods 或 Carthage

## 安装

### CocoaPods

LWEncryptor 可以通过 [CocoaPods](https://cocoapods.org) 安装。只需在 Podfile 中添加以下代码：

```ruby
pod 'LWEncryptor'
```

然后执行：

```bash
pod install
```

### Carthage

在 Cartfile 中添加：

```ruby
github "luowei/LWEncryptor"
```

然后执行：

```bash
carthage update
```

## 使用方法

### 导入头文件

```objective-c
#import <LWEncryptor/LWAESEncryptor.h>
#import <LWEncryptor/LWRSAEncryptor.h>
#import <LWEncryptor/LWEncryptorExtensions.h>
```

### AES 加密解密

#### 基本用法

```objective-c
// 获取 AES 加密器单例
LWAESEncryptor *aesEncryptor = [LWAESEncryptor sharedInstance];

// 准备数据
NSString *plainText = @"Hello, World!";
NSString *key = @"1234567890123456"; // 16 字节密钥
NSString *iv = @"1234567890123456";  // 16 字节初始化向量

// 加密字符串（返回 Base64 编码）
NSData *encryptedData = [aesEncryptor encryptBase64String:plainText
                                                       key:key
                                                        iv:iv];
NSString *encryptedBase64 = [encryptedData base64EncodedStringWithOptions:0];
NSLog(@"加密后: %@", encryptedBase64);

// 解密 Base64 字符串
NSData *decryptedData = [aesEncryptor decryptBase64String:encryptedBase64
                                                       key:key
                                                        iv:iv];
NSString *decryptedText = [[NSString alloc] initWithData:decryptedData
                                                encoding:NSUTF8StringEncoding];
NSLog(@"解密后: %@", decryptedText);
```

#### 加密二进制数据

```objective-c
LWAESEncryptor *aesEncryptor = [LWAESEncryptor sharedInstance];

// 准备二进制数据
NSData *plainData = [@"敏感数据" dataUsingEncoding:NSUTF8StringEncoding];
NSData *keyData = [@"1234567890123456" dataUsingEncoding:NSUTF8StringEncoding];
NSString *iv = @"1234567890123456";

// 加密
NSData *encryptedData = [aesEncryptor encrypt:plainData key:keyData iv:iv];

// 解密
NSData *decryptedData = [aesEncryptor decrypt:encryptedData key:keyData iv:iv];
```

### RSA 加密解密

#### 初始化 RSA 加密器

```objective-c
// 方式 1: 使用默认单例（需要设置密钥）
LWRSAEncryptor *rsaEncryptor = [LWRSAEncryptor defaultEncryptor];

// 方式 2: 使用自定义填充模式
LWRSAEncryptor *rsaEncryptor = [LWRSAEncryptor defaultEncryptorWith:Padding:RSA_PKCS1_PADDING];

// 方式 3: 使用指定的公钥和私钥初始化
NSString *publicKey = @"你的公钥字符串（不含 PEM 头尾）";
NSString *privateKey = @"你的私钥字符串（不含 PEM 头尾）";
LWRSAEncryptor *rsaEncryptor = [LWRSAEncryptor encrytorWithPublicKey:publicKey
                                                          privateKey:privateKey];
```

#### 公钥加密 / 私钥解密

```objective-c
// 公钥加密字符串
NSString *plainText = @"需要加密的敏感信息";
NSData *encryptedData = [rsaEncryptor encryptByPublicKeyWithString:plainText];

// 或者使用指定的公钥
NSString *publicKey = @"你的公钥字符串";
NSData *encryptedData = [rsaEncryptor encryptString:plainText publicKey:publicKey];

// 私钥解密
NSData *decryptedData = [rsaEncryptor decryptByPrivateKeyWithEncryptData:encryptedData];
NSString *decryptedText = [[NSString alloc] initWithData:decryptedData
                                                encoding:NSUTF8StringEncoding];
```

#### 私钥加密 / 公钥解密

```objective-c
// 注意：RSA 私钥加密通常用于数字签名场景
// 如需私钥加密，可以自定义实现或使用数字签名功能
```

### RSA 数字签名

#### 私钥签名

```objective-c
LWRSAEncryptor *rsaEncryptor = [LWRSAEncryptor encrytorWithPublicKey:publicKey
                                                          privateKey:privateKey];

// 对字符串签名（返回十六进制字符串）
NSString *sourceString = @"需要签名的数据";
NSString *signature = [rsaEncryptor signString:sourceString];
NSLog(@"签名: %@", signature);

// 对二进制数据签名
NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
NSData *signatureData = [rsaEncryptor signData:sourceData];

// 或者使用指定的私钥签名
NSString *privateKey = @"你的私钥字符串";
NSData *signatureData = [rsaEncryptor signDataForData:sourceData privateKey:privateKey];
```

#### 公钥验签

```objective-c
// 验证字符串签名
NSString *sourceString = @"需要验证的数据";
NSString *signatureBase64 = @"Base64 编码的签名";
BOOL isValid = [rsaEncryptor verifyString:sourceString withSign:signatureBase64];

if (isValid) {
    NSLog(@"签名验证成功");
} else {
    NSLog(@"签名验证失败");
}

// 验证二进制数据签名
NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
NSData *signatureData = [[NSData alloc] initWithBase64EncodedString:signatureBase64 options:0];
BOOL isValid = [rsaEncryptor verifyData:sourceData signature:signatureData];

// 或者使用指定的公钥验签
NSString *publicKey = @"你的公钥字符串";
BOOL isValid = [rsaEncryptor verifyString:sourceString
                               signString:signatureBase64
                                publicKey:publicKey];
```

### MD5 哈希

```objective-c
// 字符串 MD5
NSString *text = @"Hello, World!";
NSString *md5Hash = [text md5];
NSLog(@"MD5: %@", md5Hash);

// 二进制数据 MD5
NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
NSString *md5String = [data md5String];
NSData *md5Data = [data md5];
```

### SHA1 哈希

```objective-c
// 二进制数据 SHA1
NSData *data = [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding];
NSData *sha1Data = [data sha1];

// 转换为十六进制字符串
NSString *sha1Hex = [sha1Data hex];
NSLog(@"SHA1: %@", sha1Hex);
```

### 十六进制编码

```objective-c
// 将二进制数据转换为十六进制字符串
NSData *data = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
NSString *hexString = [data hex];
NSLog(@"十六进制: %@", hexString);
```

## API 参考

### LWAESEncryptor

```objective-c
@interface LWAESEncryptor : NSObject

// 获取单例
+ (instancetype)sharedInstance;

// 加密二进制数据
- (NSData *)encrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;

// 解密二进制数据
- (NSData *)decrypt:(NSData *)data key:(NSData *)key iv:(NSString *)iv;

// 解密字符串
- (NSData *)decryptString:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

// 解密 Base64 编码的字符串
- (NSData *)decryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

// 加密字符串（返回 Base64 编码）
- (NSData *)encryptBase64String:(NSString *)str key:(NSString *)key iv:(NSString *)iv;

@end
```

### LWRSAEncryptor

```objective-c
@interface LWRSAEncryptor : NSObject

// 获取默认加密器
+ (instancetype)defaultEncryptor;

// 使用指定填充模式创建加密器
+ (instancetype)defaultEncryptorWith:Padding:(int)padding;

// 使用公钥和私钥创建加密器
+ (instancetype)encrytorWithPublicKey:(NSString *)publicKey
                           privateKey:(NSString *)privateKey;

#pragma mark - 公钥加密

- (NSData *)encryptByPublicKeyWithString:(NSString *)plainString;
- (NSData *)encryptByPublicKeyWithData:(NSData *)plaindata;
- (NSData *)encryptString:(NSString *)plainText publicKey:(NSString *)publicKey;
- (NSData *)encryptData:(NSData *)plainData publicKey:(NSString *)publicKey;

#pragma mark - 公钥解密

- (NSData *)decryptData:(NSData *)encryptData publicKey:(NSString *)publicKey;

#pragma mark - 私钥解密

- (NSData *)decryptByPrivateKeyWithEncryptString:(NSString *)encryptString;
- (NSData *)decryptByPrivateKeyWithEncryptData:(NSData *)encryptData;
- (NSData *)decryptStringForData:(NSString *)encryptString privateKey:(NSString *)privateKey;
- (NSData *)decryptDataForData:(NSData *)encryptData privateKey:(NSString *)privateKey;

#pragma mark - 私钥签名

- (NSString *)signString:(NSString *)plainString;
- (NSData *)signData:(NSData *)data;
- (NSData *)signDataForData:(NSData *)plainData privateKey:(NSString *)privateKey;

#pragma mark - 公钥验签

- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;
- (BOOL)verifyData:(NSData *)data signature:(NSData *)signature;
- (BOOL)verifyString:(NSString *)sourceString
          signString:(NSString *)signString
           publicKey:(NSString *)publicKey;
- (BOOL)verifyData:(NSData *)plainData
         signature:(NSData *)signature
         publicKey:(NSString *)publicKey;

@end
```

### LWEncryptorExtensions

```objective-c
// NSString 分类
@interface NSString (MD5)
- (NSString*)md5;  // 返回字符串的 MD5 哈希值
@end

// NSData 分类
@interface NSData(Digest)
- (NSString*)md5String;  // 返回 MD5 哈希的十六进制字符串
- (NSData*)md5;          // 返回 MD5 哈希数据
- (NSData*)sha1;         // 返回 SHA1 哈希数据
- (NSString*)hex;        // 将数据转换为十六进制字符串
@end
```

## 安全建议

### 密钥管理
1. **不要硬编码密钥** - 永远不要在代码中直接硬编码加密密钥
2. **使用 Keychain** - 使用 iOS Keychain 服务安全存储密钥
3. **密钥长度** - AES 使用至少 128 位密钥，RSA 建议使用 2048 位或更长
4. **定期更换密钥** - 对于长期使用的应用，建议定期更换加密密钥

### AES 加密
1. **随机 IV** - 每次加密时使用随机生成的初始化向量（IV）
2. **密钥派生** - 使用 PBKDF2 等密钥派生函数从密码生成密钥
3. **不要重用 IV** - 相同的密钥不要重复使用相同的 IV

### RSA 加密
1. **数据大小限制** - RSA 加密的数据大小不能超过密钥长度减去填充长度
2. **混合加密** - 对于大数据，建议使用 RSA 加密 AES 密钥，然后用 AES 加密数据
3. **私钥保护** - 私钥必须严格保密，建议加密存储

### 数字签名
1. **验证签名** - 始终验证数据签名以确保数据完整性和来源可信
2. **时间戳** - 在签名数据中包含时间戳以防止重放攻击
3. **哈希算法** - 虽然本库使用 SHA1，但生产环境建议升级到 SHA256 或更强的算法

## 运行示例项目

要运行示例项目，请按照以下步骤操作：

1. 克隆仓库到本地：
```bash
git clone https://github.com/luowei/LWEncryptor.git
```

2. 进入 Example 目录：
```bash
cd LWEncryptor/Example
```

3. 安装依赖：
```bash
pod install
```

4. 打开工作空间：
```bash
open LWEncryptor.xcworkspace
```

5. 在 Xcode 中运行项目

## 技术实现

### 依赖库
- **OpenSSL-Universal** - 提供 OpenSSL 加密库支持
- **CommonCrypto** - Apple 的加密框架（用于 AES 和哈希算法）

### 加密算法
- **AES-128** - 使用 CBC 模式，PKCS7 填充
- **RSA** - 支持 PKCS1 填充模式
- **SHA1** - 用于 RSA 数字签名的哈希算法
- **MD5** - 用于数据完整性校验

### 编码格式
- **PEM 格式** - RSA 密钥使用 PEM 格式
- **Base64** - 用于二进制数据的文本编码
- **十六进制** - 用于哈希值的可读输出

## 常见问题

### Q: 如何生成 RSA 密钥对？
A: 可以使用 OpenSSL 命令行工具生成：
```bash
# 生成私钥
openssl genrsa -out private_key.pem 2048

# 导出公钥
openssl rsa -in private_key.pem -pubout -out public_key.pem

# 移除 PEM 头尾后使用
```

### Q: AES 密钥应该多长？
A: 本库使用 AES-128，因此密钥长度应为 16 字节（128 位）。

### Q: 为什么 RSA 加密大数据会失败？
A: RSA 不适合加密大量数据。对于大数据，建议：
1. 生成随机 AES 密钥
2. 用 AES 加密数据
3. 用 RSA 加密 AES 密钥
4. 传输加密后的数据和加密后的密钥

### Q: 如何安全存储密钥？
A: 推荐使用 iOS Keychain 服务或第三方库如 UICKeyChainStore。

### Q: 支持 Swift 吗？
A: 是的，可以通过桥接头文件在 Swift 项目中使用本库。

## 版本历史

### 1.0.0
- 首次发布
- 支持 AES-128 加密解密
- 支持 RSA 加密解密
- 支持 RSA 数字签名和验签
- 支持 MD5 和 SHA1 哈希算法

## 贡献

欢迎提交问题和拉取请求！如果您发现 bug 或有功能建议，请：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个拉取请求

## 作者

**luowei**
- Email: luowei@wodedata.com
- GitHub: [@luowei](https://github.com/luowei)

## 许可证

LWEncryptor 基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

```
Copyright (c) 2019 luowei <luowei@wodedata.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

## 相关链接

- [GitHub 仓库](https://github.com/luowei/LWEncryptor.git)
- [CocoaPods 主页](https://cocoapods.org/pods/LWEncryptor)
- [问题追踪](https://github.com/luowei/LWEncryptor/issues)
- [OpenSSL 文档](https://www.openssl.org/docs/)

## 致谢

感谢 OpenSSL 项目提供的强大加密库支持。
