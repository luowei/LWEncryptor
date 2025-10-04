//
//  LWAESEncryptor.swift
//  LWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

import Foundation
import CommonCrypto

/// AES encryption and decryption encryptor
public class LWAESEncryptor {

    // MARK: - Properties

    private let padding: CCOptions

    // MARK: - Singleton

    public static let shared = LWAESEncryptor()

    // MARK: - Initialization

    public init(padding: CCOptions = CCOptions(kCCOptionPKCS7Padding)) {
        self.padding = padding
    }

    // MARK: - Public Methods

    /// Encrypt data with AES algorithm
    /// - Parameters:
    ///   - data: Plain data to encrypt
    ///   - key: Encryption key as Data
    ///   - iv: Initialization vector as String
    /// - Returns: Encrypted data or nil if encryption fails
    public func encrypt(_ data: Data, key: Data, iv: String?) -> Data? {
        return doCipher(data, operation: CCOperation(kCCEncrypt), key: key, iv: iv)
    }

    /// Decrypt data with AES algorithm
    /// - Parameters:
    ///   - data: Encrypted data to decrypt
    ///   - key: Decryption key as Data
    ///   - iv: Initialization vector as String
    /// - Returns: Decrypted data or nil if decryption fails
    public func decrypt(_ data: Data, key: Data, iv: String?) -> Data? {
        return doCipher(data, operation: CCOperation(kCCDecrypt), key: key, iv: iv)
    }

    /// Decrypt string to data
    /// - Parameters:
    ///   - string: String to decrypt
    ///   - key: Decryption key as String
    ///   - iv: Initialization vector as String
    /// - Returns: Decrypted data or nil if decryption fails
    public func decrypt(string: String, key: String, iv: String?) -> Data? {
        guard let stringData = string.data(using: .utf8),
              let keyData = key.data(using: .utf8) else {
            return nil
        }
        return decrypt(stringData, key: keyData, iv: iv)
    }

    /// Decrypt base64 encoded string to data
    /// - Parameters:
    ///   - base64String: Base64 encoded string to decrypt
    ///   - key: Decryption key as String
    ///   - iv: Initialization vector as String
    /// - Returns: Decrypted data or nil if decryption fails
    public func decryptBase64String(_ base64String: String, key: String, iv: String?) -> Data? {
        guard let cipherData = Data(base64Encoded: base64String),
              let keyData = key.data(using: .utf8) else {
            return nil
        }
        return decrypt(cipherData, key: keyData, iv: iv)
    }

    /// Encrypt string and return base64 encoded data
    /// - Parameters:
    ///   - string: String to encrypt
    ///   - key: Encryption key as String
    ///   - iv: Initialization vector as String
    /// - Returns: Encrypted data or nil if encryption fails
    public func encryptBase64String(_ string: String, key: String, iv: String?) -> Data? {
        guard let plainData = string.data(using: .utf8),
              let keyData = key.data(using: .utf8) else {
            return nil
        }
        return encrypt(plainData, key: keyData, iv: iv)
    }

    // MARK: - Private Methods

    private func doCipher(_ plainText: Data, operation: CCOperation, key: Data, iv: String?) -> Data? {
        let keySize = kCCKeySizeAES128
        let blockSize = kCCBlockSizeAES128

        // Prepare IV
        var ivBytes = [UInt8](repeating: 0, count: blockSize)
        if let ivString = iv, let ivData = ivString.data(using: .utf8) {
            let ivCount = min(ivData.count, blockSize)
            ivData.withUnsafeBytes { ivPointer in
                if let baseAddress = ivPointer.baseAddress {
                    memcpy(&ivBytes, baseAddress, ivCount)
                }
            }
        }

        // Determine padding
        var paddingOption = padding
        if operation == CCOperation(kCCEncrypt) {
            if paddingOption != CCOptions(kCCOptionECBMode) {
                paddingOption = CCOptions(kCCOptionPKCS7Padding)
            }
        }

        // Prepare buffers
        let dataLength = plainText.count
        let bufferSize = dataLength + blockSize
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var numBytesEncrypted: size_t = 0

        let cryptStatus = key.withUnsafeBytes { keyBytes in
            plainText.withUnsafeBytes { dataBytes in
                CCCrypt(
                    operation,
                    CCAlgorithm(kCCAlgorithmAES128),
                    paddingOption,
                    keyBytes.baseAddress,
                    keySize,
                    ivBytes,
                    dataBytes.baseAddress,
                    dataLength,
                    &buffer,
                    bufferSize,
                    &numBytesEncrypted
                )
            }
        }

        guard cryptStatus == kCCSuccess else {
            return nil
        }

        return Data(bytes: buffer, count: numBytesEncrypted)
    }
}
