//
//  RandomNumberGenerator.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn. All rights reserved.
//

import Foundation

func generateRandomInt(lessThan n: Int) -> Int {
    
    assert(n <= Int(Int32.max), "Please use an integer less than or equal to Int32.max")
    assert(n >= 0, "Please use a nonnegative integer")
    
    return Int(arc4random_uniform(UInt32(n)))
    
}

func generateRandomInt(withinRange range: CountableRange<Int>)  -> Int {
    
    assert(!range.isEmpty, "Please use a nonempty range")
    
    let rawNumber = generateRandomInt(lessThan: range.count)
    
    return rawNumber + range.startIndex
    
}
func generateRandomInt(withinRange range: CountableClosedRange<Int>) -> Int {
    
    assert(!range.isEmpty, "Please use a nonempty range")
    
    let rawNumber = generateRandomInt(lessThan: range.count)
    
    return rawNumber + range.lowerBound
    
}
