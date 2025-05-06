//
//  RegexMatch.swift
//  ATSyntaxTools
//
//  Created by Christopher Jr Riley on 2025-05-06.
//

import Foundation

/// A utility enum that provides functionality for matching regular expressions against strings.
public enum RegexMatch {

    /// Checks if the string matches the given regular expression pattern.
    ///
    /// This method uses either `Regex` or `NSRegularExpression` to determine if the
    /// entire string matches the specified regular expression pattern.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern to match against.
    ///   - text: The string used for the match.
    /// - Returns: A `[String]` that displays all of the matches in `text`, or `nil`
    /// if there are no matches.
    public static func match(_ pattern: String, in text: String) -> [String?]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            guard let match = regex.firstMatch(in: text, options: [], range: range) else {
                return nil
            }

            print(match.numberOfRanges)

            var results: [String?] = []
            for i in 0..<match.numberOfRanges {
                let range = match.range(at: i)
                if range.location != NSNotFound, let range = Range(range, in: text) {
                    results.append(String(text[range]))
                } else {
                    results.append(nil)
                }
            }
            return results
        } catch {
            return nil
        }
    }
}
