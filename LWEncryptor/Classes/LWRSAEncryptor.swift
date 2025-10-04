//
//  LWRSAEncryptor.swift
//  LWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

import Foundation
import Security

/// RSA encryption, decryption, signing and verification encryptor
public class LWRSAEncryptor {

    // MARK: - Properties

    private var publicKey: SecKey?
    private var privateKey: SecKey?
    private let padding: SecPadding

    // MARK: - Singleton

    public static let `default` = LWRSAEncryptor()

    // MARK: - Initialization

    public init(padding: SecPadding = .PKCS1) {
        self.padding = padding
    }

    public convenience init(publicKeyString: String?, privateKeyString: String?, padding: SecPadding = .PKCS1) {
        self.init(padding: padding)

        if let publicKeyString = publicKeyString {
            self.publicKey = Self.createPublicKey(from: publicKeyString)
        }

        if let privateKeyString = privateKeyString {
            self.privateKey = Self.createPrivateKey(from: privateKeyString)
        }
    }

    // MARK: - Public Key Encryption

    /// Encrypt string using public key
    /// - Parameter plainString: String to encrypt
    /// - Returns: Encrypted data or nil if encryption fails
    public func encryptByPublicKey(string plainString: String) -> Data? {
        guard let plainData = plainString.data(using: .utf8) else {
            return nil
        }
        return encryptByPublicKey(data: plainData)
    }

    /// Encrypt data using public key
    /// - Parameter plainData: Data to encrypt
    /// - Returns: Encrypted data or nil if encryption fails
    public func encryptByPublicKey(data plainData: Data) -> Data? {
        guard let publicKey = self.publicKey else {
            return nil
        }
        return encrypt(data: plainData, with: publicKey)
    }

    /// Encrypt string using specified public key
    /// - Parameters:
    ///   - plainText: String to encrypt
    ///   - publicKey: Public key string
    /// - Returns: Encrypted data or nil if encryption fails
    public func encrypt(string plainText: String, publicKey: String) -> Data? {
        guard let plainData = plainText.data(using: .utf8),
              let key = Self.createPublicKey(from: publicKey) else {
            return nil
        }
        return encrypt(data: plainData, with: key)
    }

    /// Encrypt data using specified public key
    /// - Parameters:
    ///   - plainData: Data to encrypt
    ///   - publicKey: Public key string
    /// - Returns: Encrypted data or nil if encryption fails
    public func encrypt(data plainData: Data, publicKey: String) -> Data? {
        guard let key = Self.createPublicKey(from: publicKey) else {
            return nil
        }
        return encrypt(data: plainData, with: key)
    }

    // MARK: - Public Key Decryption

    /// Decrypt data using specified public key
    /// - Parameters:
    ///   - encryptData: Encrypted data
    ///   - publicKey: Public key string
    /// - Returns: Decrypted data or nil if decryption fails
    public func decrypt(data encryptData: Data, publicKey: String) -> Data? {
        guard let key = Self.createPublicKey(from: publicKey) else {
            return nil
        }
        return decrypt(data: encryptData, with: key)
    }

    // MARK: - Private Key Decryption

    /// Decrypt string using private key
    /// - Parameter encryptString: Encrypted string
    /// - Returns: Decrypted data or nil if decryption fails
    public func decryptByPrivateKey(encryptString: String) -> Data? {
        guard let encryptData = encryptString.data(using: .utf8) else {
            return nil
        }
        return decryptByPrivateKey(encryptData: encryptData)
    }

    /// Decrypt data using private key
    /// - Parameter encryptData: Encrypted data
    /// - Returns: Decrypted data or nil if decryption fails
    public func decryptByPrivateKey(encryptData: Data) -> Data? {
        guard let privateKey = self.privateKey else {
            return nil
        }
        return decrypt(data: encryptData, with: privateKey)
    }

    /// Decrypt string using specified private key
    /// - Parameters:
    ///   - encryptString: Encrypted string
    ///   - privateKey: Private key string
    /// - Returns: Decrypted data or nil if decryption fails
    public func decrypt(string encryptString: String, privateKey: String) -> Data? {
        guard let encryptData = encryptString.data(using: .utf8),
              let key = Self.createPrivateKey(from: privateKey) else {
            return nil
        }
        return decrypt(data: encryptData, with: key)
    }

    /// Decrypt data using specified private key
    /// - Parameters:
    ///   - encryptData: Encrypted data
    ///   - privateKey: Private key string
    /// - Returns: Decrypted data or nil if decryption fails
    public func decrypt(data encryptData: Data, privateKey: String) -> Data? {
        guard let key = Self.createPrivateKey(from: privateKey) else {
            return nil
        }
        return decrypt(data: encryptData, with: key)
    }

    // MARK: - Private Key Signing

    /// Sign string using private key
    /// - Parameter plainString: String to sign
    /// - Returns: Signature as hex string or nil if signing fails
    public func sign(string plainString: String) -> String? {
        guard let plainData = plainString.data(using: .utf8),
              let signatureData = sign(data: plainData) else {
            return nil
        }
        return signatureData.hexString
    }

    /// Sign data using private key
    /// - Parameter data: Data to sign
    /// - Returns: Signature data or nil if signing fails
    public func sign(data: Data) -> Data? {
        guard let privateKey = self.privateKey else {
            return nil
        }
        return sign(data: data, with: privateKey)
    }

    /// Sign data using specified private key
    /// - Parameters:
    ///   - plainData: Data to sign
    ///   - privateKey: Private key string
    /// - Returns: Signature data or nil if signing fails
    public func sign(data plainData: Data, privateKey: String) -> Data? {
        guard let key = Self.createPrivateKey(from: privateKey) else {
            return nil
        }
        return sign(data: plainData, with: key)
    }

    // MARK: - Signature Verification

    /// Verify signature for string
    /// - Parameters:
    ///   - string: Original string
    ///   - signString: Signature string (base64 encoded)
    /// - Returns: true if signature is valid, false otherwise
    public func verify(string: String, withSign signString: String) -> Bool {
        guard let data = string.data(using: .utf8),
              let signatureData = Data(base64Encoded: signString),
              let publicKey = self.publicKey else {
            return false
        }
        return verify(data: data, signature: signatureData, with: publicKey)
    }

    /// Verify signature for data
    /// - Parameters:
    ///   - data: Original data
    ///   - signature: Signature data
    /// - Returns: true if signature is valid, false otherwise
    public func verify(data: Data, signature: Data) -> Bool {
        guard let publicKey = self.publicKey else {
            return false
        }
        return verify(data: data, signature: signature, with: publicKey)
    }

    /// Verify signature for string using specified public key
    /// - Parameters:
    ///   - sourceString: Original string
    ///   - signString: Signature string (base64 encoded)
    ///   - publicKey: Public key string
    /// - Returns: true if signature is valid, false otherwise
    public func verify(string sourceString: String, signString: String, publicKey: String) -> Bool {
        guard let data = sourceString.data(using: .utf8),
              let signatureData = Data(base64Encoded: signString),
              let key = Self.createPublicKey(from: publicKey) else {
            return false
        }
        return verify(data: data, signature: signatureData, with: key)
    }

    /// Verify signature for data using specified public key
    /// - Parameters:
    ///   - plainData: Original data
    ///   - signature: Signature data
    ///   - publicKey: Public key string
    /// - Returns: true if signature is valid, false otherwise
    public func verify(data plainData: Data, signature: Data, publicKey: String) -> Bool {
        guard let key = Self.createPublicKey(from: publicKey) else {
            return false
        }
        return verify(data: plainData, signature: signature, with: key)
    }

    // MARK: - Private Helper Methods

    private func encrypt(data plainData: Data, with key: SecKey) -> Data? {
        let blockSize = SecKeyGetBlockSize(key)
        let maxChunkSize = blockSize - 11 // For PKCS1 padding

        guard plainData.count <= maxChunkSize else {
            // Handle chunking for large data
            return encryptInChunks(data: plainData, with: key, chunkSize: maxChunkSize)
        }

        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(
            key,
            .rsaEncryptionPKCS1,
            plainData as CFData,
            &error
        ) as Data? else {
            return nil
        }

        return encryptedData
    }

    private func encryptInChunks(data: Data, with key: SecKey, chunkSize: Int) -> Data? {
        var result = Data()
        var offset = 0

        while offset < data.count {
            let end = min(offset + chunkSize, data.count)
            let chunk = data.subdata(in: offset..<end)

            var error: Unmanaged<CFError>?
            guard let encryptedChunk = SecKeyCreateEncryptedData(
                key,
                .rsaEncryptionPKCS1,
                chunk as CFData,
                &error
            ) as Data? else {
                return nil
            }

            result.append(encryptedChunk)
            offset = end
        }

        return result
    }

    private func decrypt(data encryptedData: Data, with key: SecKey) -> Data? {
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(
            key,
            .rsaEncryptionPKCS1,
            encryptedData as CFData,
            &error
        ) as Data? else {
            return nil
        }

        return decryptedData
    }

    private func sign(data: Data, with key: SecKey) -> Data? {
        guard let shaData = data.sha1() else {
            return nil
        }

        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(
            key,
            .rsaSignatureDigestPKCS1v15SHA1,
            shaData as CFData,
            &error
        ) as Data? else {
            return nil
        }

        return signature
    }

    private func verify(data: Data, signature: Data, with key: SecKey) -> Bool {
        guard let shaData = data.sha1() else {
            return false
        }

        var error: Unmanaged<CFError>?
        let result = SecKeyVerifySignature(
            key,
            .rsaSignatureDigestPKCS1v15SHA1,
            shaData as CFData,
            signature as CFData,
            &error
        )

        return result
    }

    // MARK: - Key Creation

    private static func createPublicKey(from keyString: String) -> SecKey? {
        let pemKey = formatToPEM(keyString, isPublicKey: true)
        guard let keyData = pemKey.data(using: .utf8) else {
            return nil
        }

        let options: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic
        ]

        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, options as CFDictionary, &error) else {
            return nil
        }

        return secKey
    }

    private static func createPrivateKey(from keyString: String) -> SecKey? {
        let pemKey = formatToPEM(keyString, isPublicKey: false)
        guard let keyData = pemKey.data(using: .utf8) else {
            return nil
        }

        let options: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate
        ]

        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, options as CFDictionary, &error) else {
            return nil
        }

        return secKey
    }

    private static func formatToPEM(_ rsaKey: String, isPublicKey: Bool) -> String {
        var keyStr = ""
        let lineLength = 64
        let keyLength = rsaKey.count
        let lines = (keyLength % lineLength == 0) ? (keyLength / lineLength) : (keyLength / lineLength + 1)

        for i in 0..<lines {
            if i == lines - 1 {
                let startIndex = rsaKey.index(rsaKey.startIndex, offsetBy: i * lineLength)
                keyStr += String(rsaKey[startIndex...])
            } else {
                let startIndex = rsaKey.index(rsaKey.startIndex, offsetBy: i * lineLength)
                let endIndex = rsaKey.index(startIndex, offsetBy: lineLength)
                keyStr += String(rsaKey[startIndex..<endIndex]) + "\n"
            }
        }

        if isPublicKey {
            return "-----BEGIN PUBLIC KEY-----\n\(keyStr)\n-----END PUBLIC KEY-----"
        } else {
            return "-----BEGIN PRIVATE KEY-----\n\(keyStr)\n-----END PRIVATE KEY-----"
        }
    }
}
