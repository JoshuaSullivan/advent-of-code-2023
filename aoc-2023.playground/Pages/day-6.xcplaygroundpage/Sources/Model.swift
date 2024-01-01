import Foundation
import RegexBuilder

public struct RaceRecord: CustomStringConvertible {
    public let time: Int
    public let distance: Int
    
    public init(time: Int, distance: Int) {
        self.time = time
        self.distance = distance
    }
    
    public var description: String {
        "{time: \(time), dist: \(distance)}"
    }
}

public struct RaceSet: StringInitable, CustomStringConvertible {
    
    public let records: [RaceRecord]
    
    public init?(_ string: String) {
        
        let digitFinder = Regex {
            Capture { OneOrMore(.digit) }
        }
        
        let lines = string.split(separator: "\n")
        let times = lines[0]
            .matches(of: digitFinder)
            .compactMap { Int($0.output.0) }
        let distances = lines[1]
            .matches(of: digitFinder)
            .compactMap { Int($0.output.0) }
        
        records = zip(times, distances).map { RaceRecord(time: $0, distance: $1) }
    }
    
    public var description: String {
        "RaceSet [\(records.map(\.description).joined(separator: ", "))]"
    }
}
