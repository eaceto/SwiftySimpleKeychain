//
// SwiftySimpleKeychain+Setters.swift
// SwiftySimpleKeychain
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

#if canImport(Foundation)
import Foundation
#endif

public extension SwiftySimpleKeychain {
    /**
     * Sets a **Data** for the given key
     *
     * Usage:
     * ```swift
     *  _ = keychain.set(data: aData, for: "aKey")
     * ```
     *
     * - Parameter data: The **Data** to store. If nill, it delets the entry.
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **VoidErrorResult**
     */
    func set(data: Data?, for key: String, with promptMessage: String? = nil) -> VoidErrorResult {
        if key.isEmpty { return .failure(SwiftySimpleKeychainError.wrongParameter) }

        let query = queryFind(by: key, promptMessage: promptMessage)

        // Touch ID case
        if useAccessControl && defaultAccessiblity == .whenPasscodeSetThisDeviceOnly {
            // TouchId case. Doesn't support updating keychain items
            // see Known Issues: https://developer.apple.com/library/ios/releasenotes/General/RN-iOSSDK-8.0/
            // We need to delete old and add a new item. This can fail

            var status = SecItemDelete(query as CFDictionary)
            if status == errSecSuccess || status == errSecItemNotFound {
                let newQuery = queryNew(with: key, value: data) as CFDictionary
                status = SecItemAdd(newQuery, nil)
                if status == errSecSuccess {
                    return .success(())
                }
                return .failure(SwiftySimpleKeychainError.from(status))
            }
        }

        var item: CFTypeRef?
        var status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            if let data = data {
                // set data for key
                let updateQuery = queryUpdate(with: data, promptMessage: promptMessage) as CFDictionary
                status = SecItemUpdate(query as CFDictionary, updateQuery)
            } else {
                // delete key
                status = SecItemDelete(query as CFDictionary)
            }
        } else {
            // add a new item for key
            let newQuery = queryNew(with: key, value: data)
            status = SecItemAdd(newQuery as CFDictionary, nil)
        }

        if status == errSecSuccess {
            return .success(())
        }
        return .failure(SwiftySimpleKeychainError.from(status))
    }

    /**
     * Sets a **String** for the given key
     *
     * Usage:
     * ```swift
     *  _ = keychain.set(string: "value", for: "aKey")
     * ```
     *
     * - Parameter data: The **String** to store. If nill, it delets the entry.
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **VoidErrorResult**
     */
    func set(string: String? = nil, for key: String, with promptMessage: String? = nil) -> VoidErrorResult {
        var data: Data?
        if let string = string {
            data = string.data(using: .utf8)
        }
        return set(data: data, for: key, with: promptMessage)
    }
}
