//: # Advent of Code 2023
//: ### Day 5: If You Give A Seed A Fertilizer
//: [Prev](@prev) <---> [Next](@next)

import Foundation

let exampleSeeds = [79, 14, 55, 13]
let seeds = [304740406, 53203352, 1080760686, 52608146, 1670978447, 367043978, 1445830299, 58442414, 4012995194, 104364808, 4123691336, 167638723, 2284615844, 178205532, 3164519436, 564398605, 90744016, 147784453, 577905361, 122056749]

let input = try DataParser<MapSequence>().loadDataString(from: "input")
let sequence = MapSequence(input)!

let firstResult = Solver.solveFirst(seeds: seeds, sequence: sequence)
print("First:", firstResult)

let secondResult = Solver.solveSecond(seeds: seeds, sequence: sequence)
print("Second:", secondResult)
