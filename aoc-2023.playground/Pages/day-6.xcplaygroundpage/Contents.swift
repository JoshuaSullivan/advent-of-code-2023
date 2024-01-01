//: # Advent of Code 2023
//: ### Day 6: TBD
//: [Prev](@prev) <---> [Next](@next)

import Foundation

let inputString = try DataParser<RaceSet>().loadDataString(from: "input")
let races = RaceSet(inputString)!

let firstResult = Solver.solveFirst(input: races)
print("first:", firstResult)

let secondResult = Solver.solveSecond(time: 47_707_566, distance: 282_107_911_471_062)
print("second:", secondResult)
