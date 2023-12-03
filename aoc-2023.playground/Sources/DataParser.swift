import Foundation

/// A type that can be initialized from a string value.
///
public protocol StringInitable {
    /// Initialize the object with a string.
    ///
    /// - Note: This operation can fail if the string is not valid for this object type.
    ///
    init?(_ string: String)
}

extension Int: StringInitable {}

extension String: StringInitable {}

/// A helper object that can parse raw string data into structured values.
///
public struct DataParser<T: StringInitable> {

    /// Parsing-specific errors.
    public enum Error: Swift.Error {

        /// Unable to load or parse the input.
        case unableToReadInput
    }

    public init() {}

    /// Parse where input values are separated by newlines.
    ///
    public func parseLines(fileName: String) throws -> [T] {
        return try loadDataString(from: fileName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { T($0) }
    }

    /// Parse where input values are separated by commas.
    ///
    public func parseCSV(fileName: String) throws -> [T] {
        return try loadDataString(from: fileName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { T($0) }
    }

    /// Parse where there are multiple lines and each line is comma-separated.
    ///
    public func parseCSVLines(fileName: String) throws -> [[T]] {
        return try loadDataString(from: fileName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n")
            .map { line in
                line
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .compactMap { T($0) }
            }
    }

    /// Breaks up the data on double-newlines. Single newlines are converted to spaces.
    ///
    public func parseDoubleNewlineWithSpaces(fileName: String) throws -> [T] {
        return try loadDataString(from: fileName)
            .replacingOccurrences(of: "\n\n", with: "❤️")
            .replacingOccurrences(of: "\n", with: " ")
            .split(separator: "❤️")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap { T($0) }
    }

    public func parseDoubleNewlineGroupsOfLines(fileName: String) throws -> [[T]] {
        return try loadDataString(from: fileName)
            .replacingOccurrences(of: "\n\n", with: "❤️")
            .split(separator: "❤️")
            .map { $0.split(separator: "\n").compactMap { T(String($0)) } }
    }
    
    public func parseLinesOfCharacters(fileName: String) throws -> [[T]] {
        return try loadDataString(from: fileName)
            .split(separator: "\n")
            .map { $0.compactMap { T(String($0)) } }
    }

    /// Attempt to load the input file from the Resources folder.
    ///
    public func loadDataString(from fileName: String) throws -> String {
        guard  let dataURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            throw Error.unableToReadInput
        }
        let data = try Data(contentsOf: dataURL)
        guard let str = String(data: data, encoding: .utf8) else {
            throw Error.unableToReadInput
        }
        return str
    }
    
    public func parseCSVWithNil(fileName: String) throws -> [T?] {
        return try loadDataString(from: fileName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { T($0) }
    }
}
