import Foundation

public struct Node: StringInitable, CustomStringConvertible {
    public let id: String
    public let left: String
    public let right: String
    
    public init?(_ string: String) {
        let st = string.startIndex
        id = String(string[st...string.index(st, offsetBy: 2)])
        left = String(string[string.index(st, offsetBy: 7)...string.index(st, offsetBy: 9)])
        right = String(string[string.index(st, offsetBy: 12)...string.index(st, offsetBy: 14)])
    }
    
    public var description: String { "\(id) = (\(left), \(right))" }
}

public struct NodeMap: StringInitable, CustomStringConvertible {
    public let directions: [Bool]
    public let nodes: [Node]
    
    private let nodeMap: [String : Node]
    
    public init?(_ string: String) {
        let parts = string.split(separator: "\n\n")
        directions = parts[0].map { $0 == "L" }
        nodes = parts[1].split(separator: "\n")
            .compactMap { Node(String($0)) }
        
        nodeMap = nodes.reduce(into: [:], { partialResult, node in
            partialResult[node.id] = node
        })
    }
    
    public func nextNode(from: String, goLeft: Bool) -> String {
        guard let node = nodeMap[from] else { fatalError("Node \(from) was not found.") }
        return goLeft ? node.left : node.right
    }
    
    public var description: String {
        let dirs = directions.map { $0 ? "L" : "R" }.joined(separator: "")
        let nodeStrs = nodes.map(\.description).joined(separator: "\n")
        
        return "\(dirs)\n\n\(nodeStrs)"
    }
}
