//
// SwiftySimpleKeychain
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

#if swift(<5.3)
#error("Alamofire doesn't support Swift versions below 5.3")
#endif

/**
 *  A simple helper class to deal with storing and retrieving values from  Keychain.
 *  It has support for sharing keychain items using Access Group and ffine grained accesibility
 *  over a specific Kyechain Item (Using Access Control).
 *  The support is only available for iOS and macOS, otherwise it will default using the coarse grained accesibility field.
 *  When a `NSString` or `NSData` is stored using Access Control and the accesibility flag
 *  `SwiftySimpleKeychainItem.accessibleAfterFirstUnlock`, iOS / macOS will prompt the user for
 *  it's passcode or pass a TouchID challenge (if available).
 */
public class SwiftySimpleKeychain {

    /**
     *  Service name under all items are saved. Default value is Bundle Identifier or "default" if not available
     */
    private(set) var service: String

    /**
     *  Access Group for Keychain item sharing. If it's nil no keychain sharing is possible. Default value is nil.
     */
    private(set) var accessGroup: String?

    /**
     *  What type of accessibility the items stored will have. 
     *  All values are translated to `kSecAttrAccessible` constants.
     *  Default value is A0SimpleKeychainItemAccessibleAfterFirstUnlock.
     *  @see kSecAttrAccessible
     */
    private(set) var defaultAccessiblity: SwiftySimpleKeychainItemAccessible

    /**
     *  Tells SwiftySimpleKeychain to use `kSecAttrAccessControl` instead of `kSecAttrAccessible`.
     *  It will work only in iOS 8+, defaulting to `kSecAttrAccessible` on lower version.
     *  Default value is False.
     */
    private(set) var useAccessControl: Bool

    /**
    *  LocalAuthenticationContext used to access items. Default value is a new LAContext object
    */
    #if canImport(LocalAuthentication)
    private(set) var localAuthenticationContext: LAContext
    #endif

    /**
     * Instantiates a SwiftySimpleKeychain
     *
     * Usage:
     * ```swift
     *  keychain = SwiftySimpleKeychain(with: "service-name")
     * ```
     *
     * - Parameter service: **Service name** under all items are saved. Defaults to `default`
     * - Parameter accessGroup: an **Access Group** for Keychain item sharing. Defaults to `nil`
     */
    public init(with service: String = "default", accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
        self.defaultAccessiblity = .afterFirstUnlock
        self.useAccessControl = false

        // This does not apply to watchOS, tvOS and Linux
        // and all future platforms where LocalAuthentication is not available
        #if canImport(LocalAuthentication)
        localAuthenticationContext = LAContext()
        localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = 0
        #endif
    }

    /**
     * Sets the TouchID Authentication allowable reuse time
     *
     * Usage:
     * ```swift
     *  keychain.setTouchIDAuthenticationAllowableReuse(0) // do not reuse authentication
     * ```
     *
     * - Parameter duration: a TimeInterval that represents the allowable reuse time
     */
    func setTouchIDAuthenticationAllowableReuse(duration: TimeInterval) {
        // This does not apply to watchOS, tvOS and Linux
        // and all future platforms where LocalAuthentication is not available
        #if canImport(LocalAuthentication)
        if duration <= 0 {
            localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = 0
        } else if duration >= LATouchIDAuthenticationMaximumAllowableReuseDuration {
            localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration
                = LATouchIDAuthenticationMaximumAllowableReuseDuration
        } else {
            localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration = duration
        }
        #endif
    }
}

public extension SwiftySimpleKeychain {
    
    /**
     * Instantiates a SwiftySimpleKeychain
     *
     * Usage:
     * ```swift
     *  keychain = SwiftySimpleKeychain.with("service-name")
     * ```
     *
     * - Parameter service: **Service name** under all items are saved. Defaults to `default`
     * - Parameter accessGroup: an **Access Group** for Keychain item sharing. Defaults to `nil`
     */
    static func with(_ service: String = "default", accessGroup: String? = nil) -> SwiftySimpleKeychain {
        return SwiftySimpleKeychain(with: service, accessGroup: accessGroup)
    }
}
