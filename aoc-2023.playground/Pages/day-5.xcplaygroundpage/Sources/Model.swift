import Foundation

public struct MapEntry: StringInitable, CustomStringConvertible {
    let localIndex: Int
    let forwardIndex: Int
    let count: Int
    
    public init?(_ string: String) {
        let comps = string
            .split(separator: " ")
            .compactMap{ Int($0) }
        guard comps.count == 3 else { return nil }
        localIndex = comps[1]
        forwardIndex = comps[0]
        count = comps[2]
    }
    
    public func contains(_ index: Int) -> Bool {
        return index >= localIndex && index < (localIndex + count)
    }
    
    public func mapping(_ index: Int) -> Int {
        guard contains(index) else { return index }
        return index - localIndex + forwardIndex
    }
    
    public var localRange: Range<Int> { localIndex..<(localIndex + count) }
    
    public var forwardRange: Range<Int> { forwardIndex..<(forwardIndex + count) }
    
    public var description: String { "\(localIndex) \(forwardIndex) \(count)" }
}

public struct MapGroup: CustomStringConvertible {
    public let name: String
    public let maps: [MapEntry]
    
    public init(name: String, maps: [MapEntry]) {
        self.name = name
        self.maps = maps
    }
    
    public func mapping(_ index: Int) -> Int {
        guard let validMap = maps.first(where: { $0.contains(index) }) else {
//            print("\(name):", index, "->", index)
            return index
        }
        let value = validMap.mapping(index)
//        print("\(name):", index, "->", value)
        return value
    }
    
    public var description: String {
        "\(name)\n\(maps.map(\.description).joined(separator: "\n"))"
    }
}

public struct MapSequence: StringInitable, CustomStringConvertible {
    public let groups: [MapGroup]
    
    public init?(_ string: String) {
        let chunks = string.split(separator: "\n\n")
        groups = chunks.compactMap { chunkString in
            let comps = chunkString.split(separator: "\n")
            let name = String(comps[0].dropLast(5))
            let maps = comps.dropFirst().compactMap { MapEntry(String($0)) }
            return MapGroup(name: name, maps: maps)
        }
    }
    
    public var description: String {
        groups.map(\.description).joined(separator: "\n\n")
    }
    
    public func mapping(_ index: Int) -> Int {
        groups.reduce(index) { partialResult, group in
            group.mapping(partialResult)
        }
    }
}
