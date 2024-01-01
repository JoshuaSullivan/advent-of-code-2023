//: # Advent of Code 2023
//: ### Day 9: TBD
//: [Prev](@prev) <---> [Next](@next)

import Foundation

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
let input = try DataParser<Int>().parseCSVLines(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
let firstResult = Solver.solveFirst(input: input)
print("first:", firstResult)

let secondResult = Solver.solveSecond(input: input)
print("second:", secondResult)
