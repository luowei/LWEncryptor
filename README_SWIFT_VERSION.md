# LWEncryptor Swift版本使用指南

## 概述

LWEncryptor_swift 是 LWEncryptor 的 Swift 实现版本，提供了 AES 对称加密和 RSA 非对称加密功能。

## 安装

### CocoaPods

在你的 Podfile 中添加：

```ruby
pod 'LWEncryptor_swift'
```

然后运行：

```bash
pod install
```

## 系统要求

- iOS 10.0+
- Swift 5.0+

## 主要功能

### 1. AES 加密解密

AES（Advanced Encryption Standard）是一种对称加密算法，使用相同的密钥进行加密和解密。

```swift
import LWEncryptor_swift

// AES 加密
let plainText = "Hello, World!"
let key = "your-secret-key"
if let encrypted = LWAESEncryptor.encrypt(plainText, key: key) {
    print("加密结果: \(encrypted)")

    // AES 解密
    if let decrypted = LWAESEncryptor.decrypt(encrypted, key: key) {
        print("解密结果: \(decrypted)")
    }
}
```

### 2. RSA 加密解密

RSA 是一种非对称加密算法，使用公钥加密，私钥解密。

```swift
import LWEncryptor_swift

// 生成 RSA 密钥对
let keyPair = LWRSAEncryptor.generateKeyPair()

// 使用公钥加密
let plainText = "Hello, World!"
if let encrypted = LWRSAEncryptor.encrypt(plainText, publicKey: keyPair.publicKey) {
    print("加密结果: \(encrypted)")

    // 使用私钥解密
    if let decrypted = LWRSAEncryptor.decrypt(encrypted, privateKey: keyPair.privateKey) {
        print("解密结果: \(decrypted)")
    }
}
```

## 扩展功能

LWEncryptorExtensions 提供了一些便捷的扩展方法，简化加密解密操作。

```swift
import LWEncryptor_swift

// String 扩展示例
let text = "Hello, World!"
let encrypted = text.aesEncrypt(key: "your-key")
let decrypted = encrypted?.aesDecrypt(key: "your-key")
```

## 注意事项

1. **密钥管理**：请妥善保管加密密钥，不要将密钥硬编码在代码中
2. **密钥长度**：AES 支持 128、192、256 位密钥长度
3. **安全性**：RSA 密钥长度建议使用 2048 位或更高
4. **依赖项**：本库依赖 OpenSSL-Universal

## Objective-C 版本

如果你的项目使用 Objective-C，请使用原版 LWEncryptor：

```ruby
pod 'LWEncryptor'
```

详细使用说明请参考 [README.md](README.md)

## 许可证

LWEncryptor_swift 使用 MIT 许可证。详见 LICENSE 文件。
