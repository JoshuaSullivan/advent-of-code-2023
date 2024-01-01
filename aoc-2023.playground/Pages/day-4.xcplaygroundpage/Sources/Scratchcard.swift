import Foundation

public struct Scratchcard: StringInitable, CustomStringConvertible {
    
    public let index: Int
    public let winningNumbers: [Int]
    public let playerNumbers: [Int]
    
    public init?(_ string: String) {
        let mainSections = string.split(separator: ":")
        index = Int(mainSections[0].split(separator: " ").last!)!
        let numberSections = mainSections[1]
            .split(separator: "|")
            .map { String($0).replacingOccurrences(of: "  ", with: " ") }
        winningNumbers = numberSections[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .compactMap { Int(String($0)) }
        playerNumbers = numberSections[1]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .compactMap { Int(String($0)) }
    }
    
    public var matchCount: Int {
        playerNumbers
            .filter { winningNumbers.contains($0) }
            .count
    }
    
    public var value: Int {
        guard matchCount > 0 else { return 0 }
        return Int(pow(2, Double(matchCount - 1)))
    }
    
    public var description: String {
        "Card \(index): \(winningNumbers) | \(playerNumbers)"
    }
}
