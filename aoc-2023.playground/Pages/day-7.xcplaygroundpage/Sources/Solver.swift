import Foundation

public struct Solver {
    public static func solveFirst(input: [Wager]) -> Int {
        let sortedWagers = input.sorted()
        return sortedWagers.enumerated()
            .map { index, wager in
                let i = index + 1
//                print(i, wager.hand, wager.bid, (wager.bid * i))
                return wager.bid * i
            }
            .reduce(0, +)
    }
    
    public static func solveSecond(rawData: String) -> Int {
        let wagers = rawData
            .split(separator: "\n")
            .compactMap { Wager(withJokers: String($0)) }
        print(wagers)
        let sortedWagers = wagers.sorted()
        return sortedWagers.enumerated()
            .map { index, wager in
                let i = index + 1
                print(i, wager.hand, wager.bid, (wager.bid * i))
                return wager.bid * i
            }
            .reduce(0, +)
    }
}
