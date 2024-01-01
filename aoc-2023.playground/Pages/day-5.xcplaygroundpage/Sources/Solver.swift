import Foundation

public struct Solver {
    public static func solveFirst(seeds: [Int], sequence: MapSequence) -> Int {
        seeds.map { sequence.mapping($0) }.min()!
    }
    
    public static func solveSecond(seeds: [Int], sequence: MapSequence) -> Int {
        return 0
    }
}
