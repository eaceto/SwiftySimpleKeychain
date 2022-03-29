//
// SwiftySimpleKeychainError
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

#if canImport(LocalAuthentication)
import LocalAuthentication
#endif

/**
 * Enum with keychain error codes. It's a mirror of **some** the keychain security error codes.
 *  @see https://developer.apple.com/documentation/security/
 */
public enum SwiftySimpleKeychainError: Error, Equatable {
    /**
     * @see https://developer.apple.com/documentation/security/errSecSuccess
     */
    case noError
    /**
     * @see https://developer.apple.com/documentation/security/errSecUnimplemented
     */
    case unimplemented
    /**
     * @see https://developer.apple.com/documentation/security/errSecParam
     */
    case wrongParameter
    /**
     * @see https://developer.apple.com/documentation/security/errSecAllocate
     */
    case allocation
    /**
     * @see https://developer.apple.com/documentation/security/errSecNotAvailable
     */
    case notAvailable
    /**
     * @see https://developer.apple.com/documentation/security/errSecAuthFailed
     */
    case authFailed
    /**
     * @see https://developer.apple.com/documentation/security/errSecDuplicateItem
     */
    case duplicateItem
    /**
     * @see https://developer.apple.com/documentation/security/errSecItemNotFound
     */
    case itemNotFound
    /**
     * @see https://developer.apple.com/documentation/security/errSecInteractionNotAllowed
     */
    case interactionNotAllowed
    /**
     * @see https://developer.apple.com/documentation/security/errSecDecode
     */
    case decode

    /**
     * An undocumented error with an associated OSStatus code.
     * @see https://www.osstatus.com/
     */
    case other(status: OSStatus)
}
