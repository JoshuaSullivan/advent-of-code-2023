import Foundation

public struct Solver {
    public static func solve(input: [Int], using count: Int) -> Int {
        input
            .combinations(ofCount: count) // From Algorithms; very handy!
            .first(where: { $0.reduce(0, +) == 2020 })!
            .reduce(1, *)
    }
}
