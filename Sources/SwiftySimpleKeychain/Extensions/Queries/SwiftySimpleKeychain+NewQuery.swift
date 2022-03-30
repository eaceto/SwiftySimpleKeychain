//
// SwiftySimpleKeychain+NewQuery.swift
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

internal extension SwiftySimpleKeychain {
    func queryNew(with key: String, value: Data? = nil) -> [String: Any] {
        var query = baseQuery(with: key)
        if let value = value {
            query[kSecValueData as String] = value
        }

        if useAccessControl {
            var accessControl: SecAccessControl?
            var error: Unmanaged<CFError>?

            let accessibility = accessibility()

            accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility, .userPresence, &error)

            if error == nil || accessControl != nil {
                query[kSecAttrAccessControl as String] = accessControl
#if (os(macOS) || os (iOS)) && canImport(LocalAuthentication)
                query[kSecUseAuthenticationContext as String] = localAuthenticationContext
#endif
            }
        }

        return query
    }

    fileprivate func accessibility() -> CFTypeRef {
        var accessibility = kSecAttrAccessibleWhenUnlocked
        if #available(iOS 12.0, *) {
            accessibility = kSecAttrAccessibleAfterFirstUnlock
        }

        switch self.defaultAccessiblity {
        case .afterFirstUnlock:
            accessibility = kSecAttrAccessibleAfterFirstUnlock
        case .always:
#if targetEnvironment(macCatalyst)
            accessibility = kSecAttrAccessibleAfterFirstUnlock
#else
            accessibility = kSecAttrAccessibleAlways
#endif
        case .afterFirstUnlockThisDeviceOnly:
            accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .alwaysThisDeviceOnly:
#if targetEnvironment(macCatalyst)
            accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
#else
            accessibility = kSecAttrAccessibleAlwaysThisDeviceOnly
#endif
        case .whenPasscodeSetThisDeviceOnly:
            #if os(iOS)
            accessibility = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
            #endif
        case .whenUnlocked:
            accessibility = kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly:
            accessibility = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
        return accessibility
    }
}
