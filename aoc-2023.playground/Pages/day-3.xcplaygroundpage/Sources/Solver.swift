import Foundation

public struct Solver {
    
    typealias Coordinate = (x: Int, y: Int)
    
    public static func solveFirst(input: [[Character]]) -> Int {
        var x = 0
        let w = input[0].count
        let h = input.count
        
        let lineTotals: [Int] = (0..<h).map { y in
            var lineTotal = 0
            x = 0
            repeat {
                let char = input[y][x]
                if isDigit(char) {
                    let numberRange = findRangeOfNumber(in: input, startX: x, y: y)
                    if hasNeighboringSymbol(input: input, xRange: numberRange, y: y) {
                        let digits = input[y][numberRange]
                        let digitString = String(digits)
                        lineTotal += Int(digitString)!
                    }
                    x += numberRange.count
                } else {
                    x += 1
                }
            } while x < w
            return lineTotal
        }
        
        return lineTotals.reduce(0, +)
    }
    
    public static func solveSecond(input: [[Character]]) -> Int {
        
        let grid = Grid(data: input)
        
        let gears = grid.findAll("*")
//        print("gears:", gears)
        
        let ratios = gears.map { gear in
            let numbers = grid.neighbors(of: gear)
                .filter { isDigit($0.value) }
                .compactMap { grid.linearSearch(start: $0.coordinate, searchType: .horizontal, matching: { char in isDigit(char) }) }
                .map { line in
                    String(line.allCoordinates.compactMap { grid.value(at: $0) })
                }
                .compactMap { Int($0) }
            let uniqueNumbers = Array(Set(numbers))
            guard uniqueNumbers.count == 2 else { return 0 }
            return uniqueNumbers[0] * uniqueNumbers[1]
        }
//        print(ratios)
        
        return ratios.reduce(0, +)
    }
    
    static func isDigit(_ char: Character) -> Bool {
        let ascii = char.asciiValue!
        return (48...57).contains(ascii)
    }
    
    static func findRangeOfNumber(in input: [[Character]], startX x: Int, y: Int) -> ClosedRange<Int> {
        let w = input[0].count
        var offset = 1
        while x + offset < w && isDigit(input[y][x + offset]) {
            offset += 1
        }
        return x...(x+offset-1)
    }
    
    static func hasNeighboringSymbol(input: [[Character]], xRange: ClosedRange<Int>, y: Int) -> Bool {
        let h = input.count
        let w = input[0].count
        var neighbors: [Character] = []
        for x in xRange {
            if x == xRange.lowerBound && x > 0 {
                if y > 0 { neighbors.append(input[y - 1][x - 1]) }
                neighbors.append(input[y][x - 1])
                if y < h - 1 { neighbors.append(input[y + 1][x - 1]) }
            }
            if x == xRange.upperBound && x < w - 1 {
                if y > 0 { neighbors.append(input[y - 1][x + 1]) }
                neighbors.append(input[y][x + 1])
                if y < h - 1 { neighbors.append(input[y + 1][x + 1]) }
            }
            if y > 0 { neighbors.append(input[y - 1][x]) }
            if y < h - 1 { neighbors.append(input[y + 1][x]) }
        }
        
        return !neighbors.filter({ $0 != "." }).isEmpty
    }
    
    static func findAdjacentNumbers(input: [[Character]], x: Int, y: Int) -> [Coordinate] {
        
        let h = input.count
        let w = input[0].count
        let offsets = [-1, 0, 1]
        var numberCoordinates: [Coordinate] = []
        offsets.forEach { yOffset in
            offsets.forEach { xOffset in
                guard !(xOffset == 0 && yOffset == 0) else { return }
                let x0 = x + xOffset
                let y0 = y + yOffset
                guard y0 >= 0 && y0 < h && x0 >= 0 && x0 < w else { return }
                if isDigit(input[y0][x0]) {
                    numberCoordinates.append((x: x0, y: y0))
                }
            }
        }
        return numberCoordinates
    }
}
