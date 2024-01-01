import Foundation

public enum Card: String, CaseIterable, Comparable, Equatable, Hashable, CustomStringConvertible {
    case ace = "A"
    case king = "K"
    case queen = "Q"
    case jack = "J"
    case ten = "T"
    case nine = "9"
    case eight = "8"
    case seven = "7"
    case six = "6"
    case five = "5"
    case four = "4"
    case three = "3"
    case two = "2"
    
    public var value: Int {
        Self.allCases.count - Self.allCases.firstIndex(of: self)! - 1
    }
    
    public func value(useJokers: Bool = false) -> Int {
        guard self != .jack else { return 0 }
        return Self.allCases.count - Self.allCases.firstIndex(of: self)!
    }
    
    public static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.value < rhs.value
    }
    
    public var description: String { rawValue }
}

public enum HandType: Int {
    case highCard = 0
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind
    
    init(cards: [Card], useJokers: Bool = false) {
        
        var cardCounts: [Int]
        if useJokers {
            cardCounts = []
            let jokerCount = cards.filter { $0 == .jack }.count
            guard jokerCount < 5 else {
                self = .fiveOfAKind
                return
            }
            let nonJokers = cards.filter { $0 != .jack }
            let cardMap: [Card : Int] = nonJokers.reduce(into: [:]) { partialResult, card in
                partialResult[card, default: 0] += 1
            }
            cardCounts = Array(cardMap.values.sorted().reversed())
            cardCounts[0] += jokerCount
        } else {
            let cardMap: [Card : Int] = cards.reduce(into: [:]) { partialResult, card in
                partialResult[card, default: 0] += 1
            }
            cardCounts = Array(cardMap.values.sorted().reversed())
        }
        
        switch cardCounts[0] {
        case 5:
            self = .fiveOfAKind
        case 4:
            self = .fourOfAKind
        case 3:
            self = (cardCounts[1] == 2) ? .fullHouse : .threeOfAKind
        case 2:
            self = (cardCounts[1] == 2) ? .twoPair : .onePair
        default:
            self = .highCard
        }
    }
    
    var value: Int { rawValue * 1_000_000_000 }
}

public struct Hand: StringInitable, CustomStringConvertible, Comparable {
    
    public let type: HandType
    
    public let cards: [Card]
    
    public var value: Int
    
    public init?(_ string: String) {
        cards = string.compactMap { Card(rawValue: String($0)) }
        type = HandType(cards: cards)
        let handCount = cards.count
        
        let handValue = cards.enumerated()
            .map { index, card in
                let offset = (handCount - index - 1) * 4
                let value = card.value << offset
//                print("[\(index) \(card)] \(card.value) << \(offset) = \(value)")
                return value
            }
            .reduce(0, +)
        value = type.value + handValue
    }
    
    public init(withJokers string: String) {
        cards = string.compactMap { Card(rawValue: String($0)) }
        type = HandType(cards: cards, useJokers: true)
        let handCount = cards.count
        
        let handValue = cards.enumerated()
            .map { index, card in
                let offset = (handCount - index - 1) * 4
                let value = card.value(useJokers: true) << offset
//                print("[\(index) \(card)] \(card.value) << \(offset) = \(value)")
                return value
            }
            .reduce(0, +)
        value = type.value + handValue
    }
    
    public var description: String {
        "[\(cards.map(\.rawValue).joined(separator: ""))]"
    }
    
    public static func < (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.value < rhs.value
    }
}

public struct Wager: StringInitable, Comparable, CustomStringConvertible {
    public let hand: Hand
    public let bid: Int
    
    public init?(_ string: String) {
        let parts = string.split(separator: " ")
        guard
            let hand = Hand(String(parts[0])),
            let bid = Int(parts[1])
        else { return nil }
        self.hand = hand
        self.bid = bid
    }
    
    public init?(withJokers string: String) {
        let parts = string.split(separator: " ")
        hand = Hand(withJokers: String(parts[0]))
        guard let bid = Int(parts[1]) else { return nil }
        self.bid = bid
    }
    
    public static func < (lhs: Wager, rhs: Wager) -> Bool {
        return lhs.hand < rhs.hand
    }
    
    public var description: String {
        "Wager \(hand) \(bid)"
    }
}
