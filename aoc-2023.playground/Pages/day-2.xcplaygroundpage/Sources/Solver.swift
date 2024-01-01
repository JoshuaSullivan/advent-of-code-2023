import Foundation

public struct Solver {
    public static func solveFirst(input: [Game]) -> Int {
        let maxRed = 12
        let maxGreen = 13
        let maxBlue = 14
        
        let validGames = input.filter { $0.isValidFor(red: maxRed, green: maxGreen, blue: maxBlue) }
        
        return validGames.map(\.id).reduce(0, +)
    }
    
    public static func solveSecond(input: [Game]) -> Int {
        return input.map(\.power).reduce(0, +)
    }
}


