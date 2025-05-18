//
//  PunyCodeTests.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation
import Testing
@testable import ATSyntaxTools

@Suite("Punycode Tests") struct PunyCodeTests {

    @Test("Get valid punycode.", arguments: PunycodeStrings.validStrings)
    func getValidPunycode(input: String, output: String) async throws {
        let encoded = try Punycode.encodeDomain(input)

        try #require(encoded == output, "Encoded string should match expected output.")

        let decoded = try Punycode.decodeDomain(encoded)

        #expect(decoded == input, "Decoded string should match original input.")
    }

    public enum PunycodeStrings {
        public static let validStrings: [(input: String, output: String)] = {
            return [
                (input: "hello", output: "hello"),
                (input: "1234567890", output: "1234567890"),
                (input: "user-name", output: "user-name"),
                (input: "my.domain", output: "my.domain"),
                (input: "bücher", output: "xn--bcher-kva"),
                (input: "mañana", output: "xn--maana-pta"),
                (input: "façade", output: "xn--faade-zra"),
                (input: "smörgåsbord", output: "xn--smrgsbord-82a8p"),
                (input: "δοκιμή", output: "xn--jxalpdlp"),
                (input: "пример", output: "xn--e1afmkfd"),
                (input: "مثال", output: "xn--mgbh0fb"),
                (input: "דוגמה", output: "xn--6dbbec0c"),
                (input: "テスト", output: "xn--zckzah"),
                (input: "🫂", output: "xn--619h"),
                (input: "🍕.com", output: "xn--vi8h.com"),
                (input: "🫠sss🍿.com", output: "xn--sss-ke13b05r.com")
            ]
        }()
    }
}
