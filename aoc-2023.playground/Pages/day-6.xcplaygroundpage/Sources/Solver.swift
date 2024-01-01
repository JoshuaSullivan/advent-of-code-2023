import Foundation

public struct Solver {
    public static func solveFirst(input: RaceSet) -> Int {
        input.records
            .map { record in
                (1..<record.time)
                    .map { (record.time - $0) * $0 }
                    .filter { $0 > record.distance }
                    .count
            }
            .reduce(1, *)
    }
    
    public static func solveSecond(time: Int, distance: Int) -> Int {
        findUpperBound(time: time, distance: distance) - findLowerBound(time: time, distance: distance)
    }
    
    private static func findLowerBound(time: Int, distance: Int) -> Int {
        for t in (1..<time) {
            guard (time - t) * t < distance else { return t - 1 }
        }
        return 0
    }
    
    private static func findUpperBound(time: Int, distance: Int) -> Int {
        for t in (1..<time).reversed() {
            guard (time - t) * t < distance else { return t }
        }
        return time
    }
}
