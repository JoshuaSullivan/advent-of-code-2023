//: # Advent of Code 2023
//: ### Day 4: Scratchcards
//: [Prev](@prev) <---> [Next](@next)

import Foundation

let input = try DataParser<Scratchcard>().parseLines(fileName: "input")

let firstResult = Solver.solveFirst(data: input)
print("first:", firstResult)

let secondResult = Solver.solveSecond(data: input)
print("second:", secondResult)
