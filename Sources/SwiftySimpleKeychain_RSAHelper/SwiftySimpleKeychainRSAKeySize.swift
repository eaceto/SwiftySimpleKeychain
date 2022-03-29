//
// SwiftySimpleKeychainRSAKeySize.swift
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

#if canImport(Security)
import Security
#endif

/**
 * SwiftySimpleKeychainRSAKeySize defines an enum with values
 * for different RSA key size (in bits)
 */
public enum SwiftySimpleKeychainRSAKeySize: Int {
    
    /**
     * RSA key size - 512 bits
     * @see https://en.wikipedia.org/wiki/Key_size
     */
    case size512Bits = 512
    
    /**
     * RSA key size - 1024 bits
     * Security Strength level: 80-bit symmetric keys
     * Not recommended anymore
     * @see https://en.wikipedia.org/wiki/Key_size
     */
    case size1024Bits = 1024
    
    /**
     * RSA key size - 2048 bits
     * Security Strength level: 112-bit symmetric keys
     * Recommended by NIST since 2015 - until 2030
     * @see https://en.wikipedia.org/wiki/Key_size
     */
    case size2048Bits = 2048

    /**
     * RSA key size - 3072 bits
     * Security Strength level: 128-bit symmetric keys
     * @see https://en.wikipedia.org/wiki/Key_size
     */
    case size3072Bits = 3072
    
    /**
     * RSA key size - 4096 bits
     * Security Strength level: between 128-bit & 192-bit symmetric keys 
     * @see https://en.wikipedia.org/wiki/Key_size
     */
    case size4096Bits = 4096
}
