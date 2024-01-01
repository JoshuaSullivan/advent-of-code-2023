//: # Advent of Code 2023
//: ### Day 3: Gear Ratios
//: [Prev](@prev) <---> [Next](@next)

import Foundation

extension Character: StringInitable {}

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
let input = try DataParser<Character>().parseLinesOfCharacters(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
let firstResult = Solver.solveFirst(input: input)
print("First:", firstResult)

let secondResult = Solver.solveSecond(input: input)
print("Second:", secondResult)


