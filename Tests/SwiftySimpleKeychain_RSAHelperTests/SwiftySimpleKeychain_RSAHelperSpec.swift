// SwiftySimpleKeychain_RSAHelperSpec
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
@testable import SwiftySimpleKeychain_RSAHelper

let PublicKeyTag = "public"
let PrivateKeyTag = "private"
let kKeychainService = "dev.eaceto.swiftysimplekeychain.tests"

class SwiftySimpleKeychainRSAHelperSpec: QuickSpec {
    override func spec() {
        describe("SwiftySimpleKeychain") {

            var keychain: SwiftySimpleKeychain!
                        
            it("should fail init with invalid public key tag") {
                keychain = SwiftySimpleKeychain(with: kKeychainService)
                let result = keychain.generateRSAKeyPair(with: .size2048Bits, publicKeyTag: "", privateKeyTag: PrivateKeyTag)
                if case let .failure(error) = result {
                    switch error {
                    case .wrongParameter:
                        return
                    default:
                        fail("Invalid error")
                    }
                } else {
                    fail("Test should fail because public key tag is invalid")
                }
            }
            
            it("should fail init with invalid private key tag") {
                keychain = SwiftySimpleKeychain(with: kKeychainService)
                let result = keychain.generateRSAKeyPair(with: .size2048Bits, publicKeyTag: PublicKeyTag, privateKeyTag: "")
                if case let .failure(error) = result {
                    switch error {
                    case .wrongParameter:
                        return
                    default:
                        fail("Invalid error")
                    }
                } else {
                    fail("Test should fail because private key tag is invalid")
                }
            }
            
            it("should fail finding an entry for an unexistent tag") {
                keychain = SwiftySimpleKeychain(with: kKeychainService)
                expect(keychain.hasRSAKey(with: PublicKeyTag)).to(beFalse())
            }
            
            it("should fail creating a query for an invalid tags") {
                keychain = SwiftySimpleKeychain(with: kKeychainService)
                let result = keychain.keyQuery(with: "")
                if case let .failure(error) = result {
                    switch error {
                    case .wrongParameter:
                        return
                    default:
                        fail("Invalid error")
                    }
                } else {
                    fail("Test should fail because private key tag is invalid")
                }
                
                
            }
            
            describe("obtain RSA key as Data with default tags") {

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    let result = keychain.generateRSAKeyPair()
                    if case .failure = result {
                        fail("Could not create a RSA Key Pair")
                    }
                }

                afterEach {
                    _ = keychain.deleteRSAKey(with: PublicKeyTag)
                    _ = keychain.deleteRSAKey(with: PrivateKeyTag)
                }

                it("should obtain keys with default tags") {
                    let publicKeyData = keychain.rsaKeyData(with: PublicKeyTag)
                    
                    expect(publicKeyData).notTo(beNil())
                    expect(publicKeyData!.count).to(beGreaterThan(0))
                    
                    let privateKeyData = keychain.rsaKeyData(with: PrivateKeyTag)
                    expect(privateKeyData).notTo(beNil())
                    expect(privateKeyData!.count).to(beGreaterThan(0))
                }
            }
                        
            describe("obtain RSA key as Data") {

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    let result = keychain.generateRSAKeyPair(
                        publicKeyTag:PublicKeyTag,
                        privateKeyTag:PrivateKeyTag
                    )
                    if case let .failure(error) = result {
                        print(error)
                        fail("Could not create a RSA Key Pair. \(error)")
                    }
                }

                afterEach {
                    _ = keychain.deleteRSAKey(with: PublicKeyTag)
                    _ = keychain.deleteRSAKey(with: PrivateKeyTag)
                }

                it("should obtain keys data") {
                    let publicKeyData = keychain.rsaKeyData(with: PublicKeyTag)
                    
                    expect(publicKeyData).notTo(beNil())
                    expect(publicKeyData!.count).to(beGreaterThan(0))
                    
                    let privateKeyData = keychain.rsaKeyData(with: PrivateKeyTag)
                    expect(privateKeyData).notTo(beNil())
                    expect(privateKeyData!.count).to(beGreaterThan(0))
                }
                
                it("should obtain keys ref (SecKey)") {
                    let publicKeyData = keychain.rsaSecKey(with: PublicKeyTag)
                    
                    expect(publicKeyData).notTo(beNil())
                    
                    let privateKeyData = keychain.rsaSecKey(with: PrivateKeyTag)
                    expect(privateKeyData).notTo(beNil())
                }
                
                it("should obtain keys data results") {
                    let publicKeyDataResult = keychain.rsaKeyDataResult(with: PublicKeyTag)
                    guard case let .success(publicKeyData) = publicKeyDataResult else {
                        if case let .failure(error) = publicKeyDataResult {
                            print(error)
                            fail("Fail to get Public Key. \(error)")
                        }
                        return
                    }
                    
                    expect(publicKeyData).notTo(beNil())
                    expect(publicKeyData.count).to(beGreaterThan(0))
                    
                    let privateKeyDataResult = keychain.rsaKeyDataResult(with: PrivateKeyTag)
                    guard case let .success(privateKeyData) = privateKeyDataResult else {
                        if case let .failure(error) = privateKeyDataResult {
                            print(error)
                            fail("Fail to get Public Key. \(error)")
                        }
                        return
                    }
                    
                    expect(privateKeyData).notTo(beNil())
                    expect(privateKeyData.count).to(beGreaterThan(0))
                }
                
                it("should obtain keys ref (SecKey) results") {
                    let publicKeySecKeyResult = keychain.rsaSecKeyResult(with: PublicKeyTag)
                    guard case let .success(publicKeyRef) = publicKeySecKeyResult else {
                        if case let .failure(error) = publicKeySecKeyResult {
                            print(error)
                            fail("Fail to get Public Key. \(error)")
                        }
                        return
                    }
                    
                    expect(publicKeyRef).notTo(beNil())
                    
                    let privateKeySecKeyResult = keychain.rsaSecKeyResult(with: PrivateKeyTag)
                    guard case let .success(privateKeyRef) = privateKeySecKeyResult else {
                        if case let .failure(error) = privateKeySecKeyResult {
                            print(error)
                            fail("Fail to get Public Key. \(error)")
                        }
                        return
                    }
                    
                    expect(privateKeyRef).notTo(beNil())
                }
            }

            describe("check if RSA key exists") {

                beforeEach {
                    keychain = SwiftySimpleKeychain(with: kKeychainService)
                    let result = keychain.generateRSAKeyPair(
                        publicKeyTag:PublicKeyTag,
                        privateKeyTag:PrivateKeyTag
                    )
                    if case let .failure(error) = result {
                        print(error)
                        fail("Could not create a RSA Key Pair. \(error)")
                    }
                }

                afterEach {
                    _ = keychain.deleteRSAKey(with: PublicKeyTag)
                    _ = keychain.deleteRSAKey(with: PrivateKeyTag)
                }

                it("should check if the key exists") {
                    expect(keychain.hasRSAKey(with: PublicKeyTag)).to(beTruthy())
                    expect(keychain.hasRSAKey(with: PrivateKeyTag)).to(beTruthy())
                }

                it("should return NO for nonexisting key") {
                    expect(keychain.hasRSAKey(with: "NONEXISTENT")).to(beFalsy())
                }
            }
        }
    }
}
