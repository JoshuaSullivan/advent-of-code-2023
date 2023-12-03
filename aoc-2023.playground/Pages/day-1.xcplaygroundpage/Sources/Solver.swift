import Foundation
import RegexBuilder

public struct Solver {
    static let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let digitWords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    static let allDigits = digits + digitWords
    static let digitValueMap: [String : Int] = ["1":1, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "one":1, "two":2, "three":3, "four":4, "five":5, "six":6, "seven":7, "eight":8, "nine":9]
    static let replacementMap: [String : String] = ["one":"o1e", "two":"t2o", "three":"t3e", "four":"f4r", "five":"f5e", "six":"s6x", "seven":"s7n", "eight":"e8t", "nine":"n9e"]
    
    static let digitRegex = Regex { One(.digit) }
    
    // Implement your solving algoritm here. I reocmmend accepting data as an input to the function so you can
    // run the examples as well as the real challenge.
    static let digitOrWord = Regex {
        ChoiceOf {
            One(.digit)
            "one"
            "two"
            "three"
            "four"
            "five"
            "six"
            "seven"
            "eight"
            "nine"
        }
    }
    
    static let reverseDigitOrWord = Regex {
        ChoiceOf {
            One(.digit)
            "eno"
            "owt"
            "eerht"
            "ruof"
            "evif"
            "xis"
            "neves"
            "thgie"
            "enin"
        }
    }
    
    public static func solve(input: [String]) -> Int {
        return input.map {
            let matches = $0.matches(of: digitRegex)
            let first = value(for: matches.first!.output)
            let last = value(for: matches.last!.output)
            return first * 10 + last
        }
        .reduce(0, +)
    }
    
    public static func solveSecondReversedRegex(input: [String]) -> Int {
        let lineDigits: [Int] = input.map { line -> Int in
            
            let first = line.firstMatch(of: digitOrWord)!
            let firstValue = value(for: first.output)
            
            let last = String(line.reversed()).firstMatch(of: reverseDigitOrWord)!
            let lastValue = value(for: String(last.output.reversed()))
                        
            return firstValue * 10 + lastValue
        }
        return lineDigits.reduce(0, +)
    }
    
    public static func solveSecondSlidingWindow(input: [String]) -> Int {
        let lineDigits: [Int] = input.map { line in
            let lineMatches: [String] = (0..<line.count).compactMap { index in
                let fragment = line.dropFirst(index)
                for digit in digits {
                    if fragment.prefix(digit.count) == digit {
                        return digit
                    }
                }
                return nil
            }
            return value(for: lineMatches.first!) * 10 + value(for: lineMatches.last!)
        }
        
        return lineDigits.reduce(0, +)
    }
    
    public static func solveSecondStringReplacement(input: [String]) -> Int {
        let regex = Regex { One(.digit) }
        
        let lineDigits: [Int] = input.map { line in
            let repLine = digitWords.reduce(line) { partialResult, digitWord in
                return partialResult.replacingOccurrences(of: digitWord, with: replacementMap[digitWord]!)
            }
            let matches = repLine.matches(of: regex)
            let first = Int(matches.first!.output)!
            let last = Int(matches.last!.output)!
            return first * 10 + last
        }
        return lineDigits.reduce(0, +)
    }
    
    private static func value(for str: any StringProtocol) -> Int {
        digitValueMap[String(str)]!
    }
}
