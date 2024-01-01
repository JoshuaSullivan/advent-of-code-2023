import Foundation

public struct Solver {
    public static func solveFirst(data: [Scratchcard]) -> Int {
        data.map(\.value).reduce(0, +)
    }
    
    public static func solveSecond(data: [Scratchcard]) -> Int {
        let matches = data.map(\.matchCount)
        var tally: [Int] = Array(repeating: 0, count: data.count)
        for index in 0..<data.count {
            resolve(cardIndex: index, matches: matches, tally: &tally)
        }
        return tally.reduce(0, +)
    }
    
    private static func resolve(cardIndex: Int, matches: [Int], tally: inout [Int]) {
        let value = matches[cardIndex]
        tally[cardIndex] += 1
        guard value != 0 else { return }
        for child in ((cardIndex+1)..<(cardIndex + value + 1)) {
            resolve(cardIndex: child, matches: matches, tally: &tally)
        }
    }
}
