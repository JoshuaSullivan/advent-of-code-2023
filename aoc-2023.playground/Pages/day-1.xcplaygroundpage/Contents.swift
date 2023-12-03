//: # Advent of Code 2023
//: ### Day 1: Trebuchet?!
//: [Next](@next)

import UIKit

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
let input = try DataParser<String>().parseLines(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
//let result = Solver.solve(input: input)
//print("First:", result)

let reverseRegex = {
    let t = CACurrentMediaTime()
    _ = Solver.solveSecondReversedRegex(input: input)
    return Int((CACurrentMediaTime() - t) * 1000)
}

let slidingWindow = {
    let t = CACurrentMediaTime()
    _ = Solver.solveSecondSlidingWindow(input: input)
    return Int((CACurrentMediaTime() - t) * 1000)
}

let stringReplacement = {
    let t = CACurrentMediaTime()
    _ = Solver.solveSecondStringReplacement(input: input)
    return Int((CACurrentMediaTime() - t) * 1000)
}

func timeExecution(of closure: () -> Int) -> Int {
    let results = (0..<50).map { _ in closure() }
    return results.reduce(0, +) / 50
}

print("reverse regex:", timeExecution(of: reverseRegex))
print("sliding window:", timeExecution(of: slidingWindow))
print("string replacement:", timeExecution(of: stringReplacement))

