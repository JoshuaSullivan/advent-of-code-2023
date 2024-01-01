import Foundation
import RegexBuilder

public struct Game: StringInitable, CustomStringConvertible {
    
    public let id: Int
    
    public let draws: [Draw]
    
    public init?(_ string: String) {
        let colonSplit = string.split(separator: ":")
        self.id = Int(colonSplit[0].dropFirst(5))!
        let drawSplit = colonSplit[1].split(separator: ";")
        self.draws = drawSplit.compactMap { Draw(String($0)) }
    }
    
    public var description: String {
        "Game \(id): \(draws.map { $0.description }.joined(separator: "; "))"
    }
    
    public func isValidFor(red: Int, green: Int, blue: Int) -> Bool {
        draws.allSatisfy { $0.isValidFor(red: red, green: green, blue: blue) }
    }
    
    public var power: Int {
        var maxRed = 0
        var maxGreen = 0
        var maxBlue = 0
        
        for draw in draws {
            maxRed = max(maxRed, draw.red)
            maxGreen = max(maxGreen, draw.green)
            maxBlue = max(maxBlue, draw.blue)
        }
        
        return maxRed * maxGreen * maxBlue
    }
}

public struct Draw: StringInitable, CustomStringConvertible {
    
    static let regex = Regex {
        Capture {
            OneOrMore(.digit)
        }
        ZeroOrMore(.whitespace)
        Capture {
            ChoiceOf {
                "red"
                "green"
                "blue"
            }
        }
    }

    public var red: Int = 0
    public var green: Int = 0
    public var blue: Int = 0
    
    public init?(_ string: String) {
        let components = string.split(separator:",")
        for comp in components {
            let matches = comp.matches(of: Self.regex)
            for match in matches {
                let count = Int(match.1)!
                switch match.2 {
                case "red": red = count
                case "green": green = count
                case "blue": blue = count
                default:
                    fatalError("Unexpected color: \(match.2)")
                }
            }
        }
    }
    
    public var description: String {
        var comps: [String] = []
        if red > 0 { comps.append("\(red) red") }
        if green > 0 { comps.append("\(green) green") }
        if blue > 0 { comps.append("\(blue) blue") }
        return "\(comps.joined(separator: ", "))"
    }
    
    public func isValidFor(red: Int, green: Int, blue: Int) -> Bool {
        self.red <= red && self.green <= green && self.blue <= blue
    }
}
