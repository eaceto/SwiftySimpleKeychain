//
// SwiftySimpleKeychain+RSAHelper
// SwiftySimpleKeychain_RSAHelper
//
// Copyright (c) 2022 Ezequiel (Kimi) Aceto (https://eaceto.dev). Based on Auth0's SimpleKeychain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftySimpleKeychain

#if canImport(Foundation)
import Foundation
#endif

#if canImport(Security)
import Security
#endif

/**
 *  An extension of SwiftySimpleKeychain to deal with generation, retrieving and deletion of
 *  public / private RSA keys using the Keychain.
 *  It honours the configuration (and access control) of **SwiftySimpleKeychain**
 */
public extension SwiftySimpleKeychain {
    
    /**
     * Generates a RSA key pair with the specified key size and stores it in the Keychain
     *
     * Usage:
     * ```swift
     *  keychain = SwiftySimpleKeychain(with: "service-name")
     *  let result = keychain.generateRSAKeyPair()
     *  if case let .failure(error) = result {
     *      print(error)
     *  }
     * ```
     *
     * - Parameters:
     *  - parameter length: the length (int bits) of the RSA keys. Defaults to 2048 bits
     *  - parameter publicKeyTag: a tag (identifier) for the public key. Defaults to *public*
     *  - parameter privateKeyTag: a tag (identifier) for the private key. Defaults to *private*
     *  - return a **VoidErrorResult**
     */
    func generateRSAKeyPair(with length: SwiftySimpleKeychainRSAKeySize = .size2048Bits,
                            publicKeyTag: String = "public",
                            privateKeyTag : String = "private"
    ) -> VoidErrorResult {
        if (publicKeyTag.isEmpty || privateKeyTag.isEmpty) {
            return .failure(.wrongParameter)
        }
        
        guard let publicKeyTagData = publicKeyTag.data(using: .utf8) else {
            return .failure(.decode)
        }
        
        guard let privateKeyTagData = privateKeyTag.data(using: .utf8) else {
            return .failure(.decode)
        }
        
        var pairAttr = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: length.rawValue,
        ] as [String:Any]
        
        let privateAttr = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privateKeyTagData,
        ] as [String:Any]
        
        let publicAttr = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: publicKeyTagData,
        ] as [String:Any]
        
        pairAttr[kSecPrivateKeyAttrs as String] = privateAttr
        pairAttr[kSecPublicKeyAttrs as String] = publicAttr
        
        var publicKeyRef : SecKey?
        var privateKeyRef : SecKey?

        let status = SecKeyGeneratePair(pairAttr as CFDictionary, &publicKeyRef, &privateKeyRef);

        if status == errSecSuccess {
            return .success(())
        }
        return .failure(SwiftySimpleKeychainError.from(status))
    }
    
    /**
     * Finds a Key stored in the **Keychain** and returns a **DataErrorResult**
     * Use this method if you would like to know why fetching a key fails, and an error
     * is present in the *failure* response.
     *
     * Usage:
     * ```swift
     * let result = keychain.rsaKeyDataResult(with: "publicKeyTag")
     * guard case let .success(publicKeyData) = publicKeyDataResult else {
     *     if case let .failure(error) = publicKeyDataResult {
     *         print(error)
     *         fail("Fail to get Public Key. \(error)")
     *     }
     *     return
     * }
     * ```
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the key.
     *  - return a **DataErrorResult**
     */
    func rsaKeyDataResult(with tag: String) -> DataErrorResult {
        let queryResult = keyQuery(with: tag)
        var query: [String:Any]
        
        switch queryResult {
        case .success(let dict): query = dict
        case .failure(let err): return .failure(err)
        }
        
        query[kSecReturnData as String] = true
        
        var dataRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &dataRef)
        
        if status != errSecSuccess {
            return .failure(SwiftySimpleKeychainError.from(status))
        }
        
        guard let data = dataRef as? Data else {
            return .failure(SwiftySimpleKeychainError.allocation)
        }
        return .success(data)
    }
    
    /**
     * Finds a Key stored in the **Keychain** and returns a **Data** if found
     * Use this method if you want a simple response (data or zero) regardless of error on failure
     *
     * Usage:
     * ```swift
     * let data = keychain.rsaKeyData(with: "publicKeyTag")
     * ```
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the key.
     *  - return a **Data** if found. If not, returns nil
     */
    func rsaKeyData(with tag: String) -> Data? {
        let result = rsaKeyDataResult(with: tag)
        switch result {
        case .success(let data): return data
        case .failure(_ ): return nil
        }
    }
    
    /**
     * Cheks if there is a key with the provided **tag**
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the key.
     *  - return **true** if the key exists
     */
    func hasRSAKey(with tag: String) -> Bool {
        let queryResult = keyQuery(with: tag)
        var query: [String:Any]
        
        switch queryResult {
        case .success(let dict): query = dict
        case .failure(_): return false
        }
        
        query[kSecReturnData as String] = false
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /**
     * Deletes a RSA Key identified with the provided **tag**
     *
     * Usage:
     * ```swift
     * let deleted = keychain.deleteRSAKey(with: "publicKeyTag")
     * ```
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the key.
     *  - return **true** if the key exists and was deleted
     */
    func deleteRSAKey(with tag: String) -> Bool {
        let queryResult = keyQuery(with: tag)
        var query: [String:Any]
        
        switch queryResult {
        case .success(let dict): query = dict
        case .failure(_): return false
        }
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    /**
     * Finds a Key stored in the **Keychain** and returns a **SecKeyErrorResult**
     *
     * ```swift
     *  let result = keychain.rsaSecKeyResult(with: "publicTag")
     *  if case let .failure(error) = result {
     *      print(error)
     *  }
     * ```
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the key.
     *  - return a **SecKeyErrorResult**
     */
    func rsaSecKeyResult(with tag: String) -> SecKeyErrorResult {
        let queryResult = keyQuery(with: tag)
        var query: [String:Any]
        
        switch queryResult {
        case .success(let dict): query = dict
        case .failure(let err): return .failure(err)
        }
        
        query[kSecReturnData as String] = true
            
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            return .success(result as! SecKey)
        }
        return .failure(SwiftySimpleKeychainError.from(status))
    }
    
    /**
     * Finds a Key stored in the **Keychain** and returns a **SecKeyErrorResult**
     *
     * ```swift
     *  if let publicKey = keychain.rsaSecKey(with: "publicTag") {
     *
     *  }
     * ```
     *
     * - Parameters:
     *  - parameter tag: a tag (identifier) for the  key.
     *  - return a **SecKey** if the RSA key exists.
     */
    func rsaSecKey(with tag: String) -> SecKey? {
        switch rsaSecKeyResult(with: tag) {
        case .success(let secKey): return secKey
        case .failure: return nil
        }
    }
}

extension SwiftySimpleKeychain {
    internal func keyQuery(with tag: String) -> Result<[String:Any],SwiftySimpleKeychainError> {
        if (tag.isEmpty) {
            return .failure(.wrongParameter)
        }
        
        guard let tagData = tag.data(using: .utf8) else {
            return .failure(.decode)
        }
        
        return .success([
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tagData,
            kSecAttrType as String: kSecAttrKeyTypeRSA
        ] as [String:Any])
    }
}
