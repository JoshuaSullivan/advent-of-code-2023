import Foundation

public struct Solver {
    public static func solveFirst(input: NodeMap) -> Int {
        var seq = input.directions.cycled().makeIterator()
        var count = 0
        var node: String = "AAA"
        repeat {
            count += 1
            node = input.nextNode(from: node, goLeft: seq.next()!)
        } while node != "ZZZ"
        return count
    }
    
    public static func solveSecond(input: NodeMap) -> Int {
        let starts = input.nodes.filter { $0.id.last! == "A" }
        let cycleLengths = starts.map { distanceToEnd(start: $0.id, map: input) }
        print(zip(starts, cycleLengths).map { "\($0.0.id): \($0.1)" })
        return cycleLengths.reduce(1) { lcm($0, $1) }
    }
    
    private static func distanceToEnd(start: String, map: NodeMap) -> Int {
        var seq = map.directions.cycled().makeIterator()
        var count = 0
        var node = start
        repeat {
            count += 1
            node = map.nextNode(from: node, goLeft: seq.next()!)
        } while node.last! != "Z"
        return count
    }
    
    private static func gcd(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : gcd(b, a % b)
    }

    // Function to calculate the LCM of two numbers
    private static func lcm(_ a: Int, _ b: Int) -> Int {
        return (a / gcd(a, b)) * b
    }
}
