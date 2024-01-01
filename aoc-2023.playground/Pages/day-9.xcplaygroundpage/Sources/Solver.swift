import Foundation

public struct Solver {
    public static func solveFirst(input: [[Int]]) -> Int {
        let extrapolations = input.map { extrapolate($0) }
//        print(extrapolations)
        return extrapolations.reduce(0, +)
    }
    
    public static func solveSecond(input: [[Int]]) -> Int {
        let extrapolations = input.map { extrapolate($0, forward: false) }
        return extrapolations.reduce(0, +)
    }
    
    private static func extrapolate(_ seq: [Int], forward: Bool = true) -> Int {
//        print(seq)
        guard !seq.allIdentical else {
//            print("All Identical:", seq[0])
            return seq[0]
        }
        let subSeq = zip(seq, seq.dropFirst()).map { $1 - $0 }
        let delta = extrapolate(subSeq, forward: forward)
//        print("delta:", delta, "/ value:", (delta + seq.last!))
        return forward ? (seq.last! + delta) : (seq.first! - delta)
    }
}

extension Collection where Element == Int {
    public var allIdentical: Bool {
        self.allSatisfy { $0 == self.first }
    }
}
