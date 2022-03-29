//
// SwiftySimpleKeychainError+Init
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

internal extension SwiftySimpleKeychainError {
    static func from(_ status: OSStatus) -> SwiftySimpleKeychainError {
        switch status {
        case errSecSuccess: return .noError
        case errSecUnimplemented: return .unimplemented
        case errSecParam: return .wrongParameter
        case errSecAllocate: return .allocation
        case errSecNotAvailable: return .notAvailable
        case errSecAuthFailed: return .authFailed
        case errSecDuplicateItem: return .duplicateItem
        case errSecItemNotFound: return .itemNotFound
        case errSecInteractionNotAllowed: return .interactionNotAllowed
        case errSecDecode: return .decode
        default: return .other(status: status)
        }
    }
}
