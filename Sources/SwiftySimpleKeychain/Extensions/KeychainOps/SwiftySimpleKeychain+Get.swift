//
// SwiftySimpleKeychain+Get.swift
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
     * Checks if the entry with **key** exists in the Keychain
     *
     * Usage:
     * ```swift
     *  if keychain.hasValue(for: "aKey") {
     *     // entry exists in Keychain
     *  }
     * ```
     *
     * - Parameter key: Identifier of the entry
     * - Returns **true** if the key exists
     */
    func hasValue(for key: String) -> Bool {
        if key.isEmpty { return false }
        let query = queryFind(by: key)
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /**
     * Returns a **DataErrorResult** for the given key
     *
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **DataErrorResult**
     */
    func dataResult(for key: String, with promptMessage: String? = nil) -> DataErrorResult {
        let query = queryFetchOne(by: key, promptMessage: promptMessage)

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status != errSecSuccess {
            return .failure(SwiftySimpleKeychainError.from(status))
        }

        guard let data = item as? Data else {
            return .failure(.decode)
        }

        return .success(data)
    }

    /**
     * Returns a **StringErrorResult** for the given key
     *
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **StringErrorResult**
     */
    func stringResult(for key: String, with promptMessage: String? = nil) -> StringErrorResult {
        let result = dataResult(for: key, with: promptMessage)
        switch result {
        case .success(let data):
            guard let string = String(data: data, encoding: .utf8) else {
                return .failure(.decode)
            }
            return .success(string)
        case .failure(let error):
            return .failure(error)
        }
    }

    /**
     * Returns a **Data** for the given key if exists
     *
     * Usage:
     * ```swift
     *  if let data = keychain.data(for: "aKey") {
     *     // valid data retrieved from the Keychain
     *  }
     * ```
     *
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **Data** if an entry exists for the given key, or **nil** in case of error.
     */
    func data(for key: String, with promptMessage: String? = nil) -> Data? {
        switch dataResult(for: key, with: promptMessage) {
        case .success(let dataValue):
            return dataValue
        case .failure:
            return nil
        }
    }

    /**
     * Returns a **String** for the given key if exists
     *
     * Usage:
     * ```swift
     *  if let text = keychain.string(for: "aKey") {
     *     // valid string retrieved from the Keychain
     *  }
     * ```
     *
     * - Parameter key: Identifier of the key
     * - Parameter promptMessage: A message to show to the user in case the Keychain should be unlocked
     * - Returns **String** if an entry exists for the given key, or **nil** in case of error.
     */
    func string(for key: String, with promptMessage: String? = nil) -> String? {
        guard let data = data(for: key, with: promptMessage), let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
}
