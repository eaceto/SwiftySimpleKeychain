// SimpleKeychainSpec.swift
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

import Foundation

import Quick
import Nimble

@testable import SwiftySimpleKeychain

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let kKeychainService = "dev.eaceto.swiftysimplekeychain.tests"

class SwiftySimpleKeychainSpec: QuickSpec {
    override func spec() {
        describe("SwiftySimpleKeychain") {

            var keychain: SwiftySimpleKeychain!

            describe("initialization") {
                it("should init with default values") {
                    keychain = SwiftySimpleKeychain()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service only") {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service and access group") {
                    keychain = SwiftySimpleKeychain(with: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
                
                it("should init with default values // using the static method") {
                    keychain = SwiftySimpleKeychain.with()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
                
                it("should init with service only // using the static method") {
                    keychain = SwiftySimpleKeychain.with(kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should init with service and access group // using the static method") {
                    keychain = SwiftySimpleKeychain.with(kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

            }

            describe("factory methods") {
                it("should create with default values") {
                    keychain = SwiftySimpleKeychain()
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service only") {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    expect(keychain.accessGroup).to(beNil())
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }

                it("should create with service and access group") {
                    keychain = SwiftySimpleKeychain(with: kKeychainService, accessGroup: "Group")
                    expect(keychain.accessGroup).to(equal("Group"))
                    expect(keychain.service).to(equal(kKeychainService))
                    expect(keychain.defaultAccessiblity).to(equal(SwiftySimpleKeychainItemAccessible.afterFirstUnlockThisDeviceOnly))
                    expect(keychain.useAccessControl).to(beFalsy())
                }
            }

            describe("Storing values") {

                var key: String!

                beforeEach({
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    key = UUID().uuidString
                })

                it("should store a a value under a new key") {
                    let aResult = keychain.set(string: "value", for: key)
                    expect(aResult).to(beSuccess())
                }

                it("should store a a value under an existing key") {
                    _ = keychain.set(string: "value1", for: key)
                    let aResult = keychain.set(string: "value2", for: key)
                    expect(aResult).to(beSuccess())
                }

                it("should store a data value under a new key") {
                    let aResult = keychain.set(data: NSData() as Data, for: key)
                    expect(aResult).to(beSuccess())
                }

                it("should store a data value under an existing key") {
                    _ = keychain.set(data: Data() as Data, for: key)
                    let aResult = keychain.set(data: NSData() as Data, for: key)
                    expect(aResult).to(beSuccess())
                }
                
                it("should remove an stored a String value when set to nil") {
                    var aResult = keychain.set(string: "", for: key)
                    expect(aResult).to(beSuccess())
                    expect(keychain.hasValue(for: key)).to(beTruthy())
                    
                    aResult = keychain.set(string: nil, for: key)
                    expect(aResult).to(beSuccess())
                    
                    expect(keychain.hasValue(for: key)).to(beFalsy())
                }
                
                it("should remove an stored a data value when set to nil") {
                    var aResult = keychain.set(data: NSData() as Data, for: key)
                    expect(aResult).to(beSuccess())
                    expect(keychain.hasValue(for: key)).to(beTruthy())
                    
                    aResult = keychain.set(data: nil, for: key)
                    expect(aResult).to(beSuccess())
                    
                    expect(keychain.hasValue(for: key)).to(beFalsy())
                }

            }

            describe("Removing values") {

                var key: String!

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    key = UUID().uuidString
                    _ = keychain.set(string: "value1", for: key)
                }

                it("should remove entry for key") {
                    expect(keychain.deleteEntry(for: key)).to(beTruthy())
                }

                it("should fail with nonexisting key") {
                    expect(keychain.deleteEntry(for: "SHOULDNOTEXIST")).to(beFalsy())
                }

                it("should clear all entries") {
                    keychain.clearAll()
                    expect(keychain.string(for: key)).to(beNil())
                }

            }

            describe("retrieving values") {

                var key: String!

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    key = UUID().uuidString
                    _ = keychain.set(string: "value1", for: key)
                }

                it("should return that a key exists") {
                    expect(keychain.hasValue(for: key))
                        .to(beTrue())
                }

                it("should return nil data with non existing key") {
                    expect(keychain.data(for: "SHOULDNOTEXIST")).to(beNil())
                }

                it("should return nil string with non existing key") {
                    expect(keychain.string(for: "SHOULDNOTEXIST")).to(beNil())
                }

                it("should return string for a key") {
                    expect(keychain.string(for: key)).to(equal("value1"))
                }

                it("should return data for a key") {
                    expect(keychain.data(for: key)).notTo(beNil())
                }
            }

            describe("retrieving results with values") {

                var key: String!

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    key = UUID().uuidString
                    _ = keychain.set(string: "value1", for: key)
                }

                it("should return that a key exists") {
                    expect(keychain.hasValue(for: key))
                        .to(beTrue())
                }

                it("should return nil data with non existing key") {
                    expect(keychain.dataResult(for: "SHOULDNOTEXIST"))
                        .to(beFailure { error in
                            guard case .itemNotFound = error else {
                                fail("Error is: \(error)")
                                return
                            }
                        })
                }

                it("should return nil string with non existing key") {
                    expect(keychain.stringResult(for: "SHOULDNOTEXIST"))
                        .to(beFailure { error in
                            guard case .itemNotFound = error else {
                                fail("Error is: \(error)")
                                return
                            }
                        })
                }

                it("should return string for a key") {
                    expect(keychain.stringResult(for: key))
                        .to(beSuccess { value in
                            expect(value).to(equal("value1"))
                        })
                }

                it("should return data for a key") {
                    expect(keychain.dataResult(for: key))
                        .to(beSuccess { value in
                            expect(value).notTo(beNil())
                        })
                }
            }
            
            describe("setting local authentication properties") {
                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                }
                
#if (os(macOS) || os (iOS)) && canImport(LocalAuthentication)
                it("should set reusable time to zero") {
                    keychain.setTouchIDAuthenticationAllowableReuse(duration: TimeInterval.zero)
                    expect(keychain.localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration).to(equal(0))
                }
                
                it("should set reusable time to zero when a negative value is set") {
                    keychain.setTouchIDAuthenticationAllowableReuse(duration: TimeInterval(integerLiteral: -10))
                    expect(keychain.localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration).to(equal(0))
                }
                
                it("should set reusable time to zero when a negative value is set") {
                    keychain.setTouchIDAuthenticationAllowableReuse(duration: TimeInterval.infinity)
                    expect(keychain.localAuthenticationContext.touchIDAuthenticationAllowableReuseDuration).to(beGreaterThan(0))
                }
#endif
            }
        }
    }
}
