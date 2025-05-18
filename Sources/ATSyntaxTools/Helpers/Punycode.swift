//
//  Punycode.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-18.
//

import Foundation

/// A namespace for helpers to encode and decode Unicode strings using the
/// Punycode algorithm.
public enum Punycode {

    /// The base used in Punycode for digit values.
    private static let punycodeBase: UInt32 = 36

    /// Minimum threshold value for bias adaptation.
    private static let thresholdMin: UInt32 = 1

    /// Maximum threshold value for bias adaptation.
    private static let thresholdMax: UInt32 = 26

    /// Skew factor used in bias adaptation.
    private static let skewValue: UInt32 = 38

    /// Damping factor used for bias adaptation.
    private static let dampFactor: UInt32 = 700

    /// Initial bias value for the algorithm.
    private static let initialBiasValue: UInt32 = 72

    /// Starting code point for processing non-ASCII input.
    private static let initialCodePoint: UInt32 = 128

    /// Delimiter used in Punycode to separate basic and encoded code points.
    private static let labelDelimiter: Character = "-"

    /// Decodes a Punycode string into a Unicode string.
    ///
    /// - Parameter punycode: The Punycode-encoded string (must be ASCII only).
    /// - Returns: The decoded Unicode string.
    ///
    /// - Throws: `PunycodeError` if the input is invalid or decoding fails.
    public static func decode(_ punycode: String) throws -> String {
        guard punycode.allSatisfy({ $0.isASCII }) else { throw PunycodeError.nonASCIIInput }

        var nextCodePoint = initialCodePoint
        var insertionIndex: UInt32 = 0
        var bias = initialBiasValue

        // Split basic code points and encoded part
        let (basicScalars, encodedSequence): ([Unicode.Scalar], Substring) = {
            if let delimiterIndex = punycode.lastIndex(of: labelDelimiter) {
                let basics = punycode[..<delimiterIndex].compactMap { UnicodeScalar(String($0)) }
                let rest = punycode[punycode.index(after: delimiterIndex)...]
                return (basics, rest)
            } else {
                return ([], punycode[...])
            }
        }()

        var decodedScalars = basicScalars
        var inputIterator = encodedSequence.makeIterator()

        while peekNext(&inputIterator) != nil {
            let previousIndex = insertionIndex
            var weight: UInt32 = 1
            var currentThreshold: UInt32 = punycodeBase

            while true {
                guard let char = inputIterator.next() else { throw PunycodeError.invalidDigit(invalidCharacter: "?") }
                let digit = decodePunycodeDigit(char)
                if digit == punycodeBase {
                    throw PunycodeError.invalidDigit(invalidCharacter: char)
                }
                if digit > (UInt32.max - insertionIndex) / weight { throw PunycodeError.overflow }
                insertionIndex += digit * weight

                let threshold = calculateThreshold(min: thresholdMin, k: currentThreshold, bias: bias, max: thresholdMax)
                if digit < threshold { break }
                if punycodeBase > (UInt32.max - threshold) / weight { throw PunycodeError.overflow }
                weight *= punycodeBase - threshold
                currentThreshold += punycodeBase
            }

            let outputLength = UInt32(decodedScalars.count) + 1
            bias = adaptBias(delta: insertionIndex - previousIndex, codePointCount: outputLength, isFirst: previousIndex == 0)

            let codePointOffset = insertionIndex / outputLength
            if nextCodePoint > UInt32.max - codePointOffset { throw PunycodeError.overflow }
            nextCodePoint += codePointOffset
            insertionIndex = insertionIndex % outputLength

            guard let unicodeScalar = UnicodeScalar(nextCodePoint) else { throw PunycodeError.invalidUnicodeScalar(scalar: nextCodePoint) }
            decodedScalars.insert(unicodeScalar, at: Int(insertionIndex))
            insertionIndex += 1
        }

        // Return the decoded string by reconstructing from scalars
        return String(String.UnicodeScalarView(decodedScalars))
    }

    /// Encodes a Unicode string as a Punycode string.
    ///
    /// - Parameter unicode: The Unicode string to encode.
    /// - Returns: The encoded Punycode string.
    ///
    /// - Throws: `PunycodeError` if the input is invalid or encoding fails.
    public static func encode(_ unicode: String) throws -> String {
        let scalars = Array(unicode.unicodeScalars)
        return try encode(scalars)
    }

    /// Internal encoder working directly with an array of characters.
    ///
    /// - Parameter inputCharacters: The input characters to encode.
    /// - Returns: The encoded Punycode string.
    ///
    /// - Throws: `PunycodeError` if the input is invalid or encoding fails.
    private static func encode(_ scalars: [Unicode.Scalar]) throws -> String {
        guard !scalars.isEmpty else {
            throw PunycodeError.emptyInput
        }

        var nextCodePoint = initialCodePoint
        var delta: UInt32 = 0
        var bias = initialBiasValue

        // Output all basic (ASCII) code points first, in order.
        var encodedOutput = scalars.filter { $0.isASCII }.map { Character($0) }
        let numBasicCodePoints = UInt32(encodedOutput.count)
        var numHandledCodePoints = numBasicCodePoints

        if numBasicCodePoints > 0 {
            encodedOutput.append(labelDelimiter)
        }

        // Work with scalars' UInt32 values
        let codePoints = scalars.map { $0.value }

        while numHandledCodePoints < scalars.count {
            // Find the smallest code point >= current nextCodePoint
            guard let minCodePoint = codePoints.filter({ $0 >= nextCodePoint }).min() else {
                throw PunycodeError.overflow
            }

            if minCodePoint - nextCodePoint > (UInt32.max - delta) / (numHandledCodePoints + 1) {
                throw PunycodeError.overflow
            }

            delta += (minCodePoint - nextCodePoint) * (numHandledCodePoints + 1)
            nextCodePoint = minCodePoint

            for codePoint in codePoints {
                if codePoint < nextCodePoint {
                    delta += 1
                    if delta == 0 { throw PunycodeError.overflow }
                } else if codePoint == nextCodePoint {
                    var remainingDelta = delta
                    var k: UInt32 = punycodeBase
                    while true {
                        let threshold = calculateThreshold(min: thresholdMin, k: k, bias: bias, max: thresholdMax)
                        if remainingDelta < threshold {
                            encodedOutput.append(encodePunycodeDigit(remainingDelta))
                            break
                        }
                        encodedOutput.append(encodePunycodeDigit(threshold + (remainingDelta - threshold) % (punycodeBase - threshold)))
                        remainingDelta = (remainingDelta - threshold) / (punycodeBase - threshold)
                        k += punycodeBase
                    }
                    bias = adaptBias(delta: delta, codePointCount: numHandledCodePoints + 1, isFirst: numHandledCodePoints == numBasicCodePoints)
                    delta = 0
                    numHandledCodePoints += 1
                }
            }
            delta += 1
            nextCodePoint += 1
        }

        return String(encodedOutput)
    }

    /// Adapt the bias according to Punycode specifications.
    ///
    /// - Parameters:
    ///   - delta: The difference in code points since the last adaptation.
    ///   - codePointCount: Number of code points processed so far.
    ///   - isFirst: Whether this is the first bias adaptation.
    /// - Returns: The new bias value.
    private static func adaptBias(delta: UInt32, codePointCount: UInt32, isFirst: Bool) -> UInt32 {
        var adjustedDelta = isFirst ? delta / dampFactor : delta / 2
        adjustedDelta += adjustedDelta / codePointCount
        var k: UInt32 = 0
        while adjustedDelta > (punycodeBase - thresholdMin) * thresholdMax / 2 {
            adjustedDelta /= punycodeBase - thresholdMin
            k += punycodeBase
        }
        return k + (punycodeBase - thresholdMin + 1) * adjustedDelta / (adjustedDelta + skewValue)
    }

    /// Calculates the threshold for bias adaptation.
    ///
    /// - Parameters:
    ///   - min: Minimum threshold.
    ///   - k: Current bias step value.
    ///   - bias: Current bias.
    ///   - max: Maximum threshold.
    /// - Returns: The calculated threshold value.
    private static func calculateThreshold(min: UInt32, k: UInt32, bias: UInt32, max: UInt32) -> UInt32 {
        if min + bias >= k {
            return min
        } else if max + bias <= k {
            return max
        } else {
            return k - bias
        }
    }

    /// Decodes a single Punycode digit character into its value.
    ///
    /// - Parameter character: The character to decode.
    /// - Returns: The digit value, or `punycodeBase` if invalid.
    private static func decodePunycodeDigit(_ character: Character) -> UInt32 {
        guard let asciiValue = character.asciiValue else { return punycodeBase }
        switch character {
            case "0"..."9":
                return UInt32(asciiValue - Character("0").asciiValue! + 26)
            case "A"..."Z":
                return UInt32(asciiValue - Character("A").asciiValue!)
            case "a"..."z":
                return UInt32(asciiValue - Character("a").asciiValue!)
            default:
                return punycodeBase
        }
    }

    /// Encodes a digit value as a Punycode character.
    ///
    /// - Parameter digitValue: The digit value to encode (0-35).
    /// - Returns: The corresponding character.
    private static func encodePunycodeDigit(_ digitValue: UInt32) -> Character {
        // 'a'..'z' = 0..25, '0'..'9' = 26..35
        let asciiValue = digitValue + 22 + (digitValue < 26 ? 75 : 0)
        if let unicodeScalar = UnicodeScalar(asciiValue) {
            return Character(unicodeScalar)
        } else {
            assertionFailure("Invalid digit to encode: \(digitValue)")
            return "?"
        }
    }

    /// Peeks at the next element in a given iterator without advancing it.
    /// - Parameter iterator: The iterator to peek into. This is passed as an `inout` value so it won't be consumed.
    /// - Returns: The next element if present; otherwise, `nil`.
    private static func peekNext<T: IteratorProtocol>(_ iterator: inout T) -> T.Element? {
        var copy = iterator
        return copy.next()
    }
}
