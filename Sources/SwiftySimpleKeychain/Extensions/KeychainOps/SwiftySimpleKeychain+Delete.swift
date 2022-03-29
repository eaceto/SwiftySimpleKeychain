//
// SwiftySimpleKeychain+Delete.swift
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
     * Deletes an entry in the Keychain with the given **key**
     *
     * - Parameter key: Identifier of the entry
     * - Returns **true** if the key exists and it could be deleted
     */
    func deleteEntry(for key: String) -> Bool {
        if key.isEmpty { return false }
        let deleteQuery = queryFind(by: key)
        let status = SecItemDelete(deleteQuery as CFDictionary)
        return status == errSecSuccess
    }

    /**
     * Deletes all entries in the Keychain
     * Aborts if there is an error deleting one item. 
     */
    func clearAll() {
        #if os(iOS)
        let query = queryFindAll()
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess || status == errSecItemNotFound {
            guard let result = result, let items = result as? [[String: Any]] else {
                return
            }
            for item in items {
                var queryDelete = item
                queryDelete[kSecClass as String] = kSecClassGenericPassword
                let status = SecItemDelete(queryDelete as CFDictionary)
                if status != errSecSuccess {
                    debugPrint("Could not delete item: \(item)")
                    return
                }
            }
        }
        #else
        var queryDelete = baseQuery()
        queryDelete[kSecClass as String] = kSecClassGenericPassword
        queryDelete[kSecMatchLimit as String] = kSecMatchLimitAll
        let status = SecItemDelete(queryDelete as CFDictionary)
        if status != errSecSuccess {
            debugPrint("Could not delete: \(queryDelete)")
        }
        #endif
    }
}
