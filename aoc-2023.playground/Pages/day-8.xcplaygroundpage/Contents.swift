//: # Advent of Code 2023
//: ### Day 8: TBD
//: [Prev](@prev) <---> [Next](@next)

import Foundation

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
let input = try DataParser<NodeMap>().loadDataString(from: "input")
let nodeMap = NodeMap(input)!

//: Then pass the data to the solver, along with any parameterization:
let firstResult = Solver.solveFirst(input: nodeMap)
print("first:", firstResult)

let secondResult = Solver.solveSecond(input: nodeMap)
print("second:", secondResult)
