//
//  RandomNumberGenerator.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
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
