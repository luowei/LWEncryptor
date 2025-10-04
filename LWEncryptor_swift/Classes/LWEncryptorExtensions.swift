//
//  LWEncryptorExtensions.swift
//  LWEncryptor
//
//  Created by luowei on 05/10/2019.
//  Copyright (c) 2019 luowei. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - String Extension for MD5

extension String {

    /// Calculate MD5 hash of the string
    /// - Returns: MD5 hash as hex string
    public var md5: String {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        return data.md5String
    }
}

// MARK: - Data Extension for Digest

extension Data {

    /// Calculate MD5 hash of the data
    /// - Returns: MD5 hash as Data or nil if data is empty
    public func md5() -> Data? {
        guard !self.isEmpty else {
            return nil
        }

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes { bytes in
            _ = CC_MD5(bytes.baseAddress, CC_LONG(self.count), &digest)
        }

        return Data(digest)
    }

    /// Calculate MD5 hash and return as hex string
    /// - Returns: MD5 hash as hex string
    public var md5String: String {
        guard let md5Data = self.md5() else {
            return ""
        }
        return md5Data.hexString
    }

    /// Calculate SHA1 hash of the data
    /// - Returns: SHA1 hash as Data or nil if data is empty
    public func sha1() -> Data? {
        guard !self.isEmpty else {
            return nil
        }

        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes { bytes in
            _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
        }

        return Data(digest)
    }

    /// Convert data to hex string
    /// - Returns: Hex string representation
    public var hexString: String {
        return self.map { String(format: "%02X", $0) }.joined()
    }
}
