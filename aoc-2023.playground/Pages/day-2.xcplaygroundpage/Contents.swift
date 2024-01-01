//: # Advent of Code 2023
//: ### Day 2: Cube Conundrum
//: [Prev](@prev) <---> [Next](@next)

import Foundation
import RegexBuilder

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
let input = try DataParser<Game>().parseLines(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
let firstResult = Solver.solveFirst(input: input)
print("First:", firstResult)

let secondResult = Solver.solveSecond(input: input)
print("Second:", secondResult)
