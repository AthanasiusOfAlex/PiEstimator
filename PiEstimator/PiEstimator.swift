//
//  PiEstimator.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn. All rights reserved.
//

import Foundation

class Counter {
    
    private var coprimes_ = 0
    private var composites_ = 0
    
    var coprimes: Int { return coprimes_ }
    var composites: Int { return composites_ }
    
    func uptickBasedOnNubers(_ m: Int, and n: Int) {
        
        if m.isCoprimeWith(n) {
            
            coprimes_ += 1
            
        } else {
            
            composites_ += 1
        }
        
    }
    
}

protocol EstimatorDelegate {
    
    func progressBarWasUpticked(percentDone: Double)
    func numberPairsWereUpdated(coprimes: Int, composites: Int)
    func ratioWasUpdated(ratio: Double)
    func estimateOfPiWasMade(π: Double)
    
}

class TerminalHandler: EstimatorDelegate {
    
    func progressBarWasUpticked(percentDone: Double) {
        
        print("Percentage done: \(percentDone * 100)")
        
    }
    
    func numberPairsWereUpdated(coprimes: Int, composites: Int) {

        print("Coprime pairs: \(coprimes); Composite pairs: \(composites)")

    }
    
    func ratioWasUpdated(ratio: Double) {
        
        print("Ratio of coprimes to total: \(ratio)")

    }
    
    func estimateOfPiWasMade(π: Double) {
        
        print("Estimate of π: \(π)")

    }

}


func estimatePi() {

    let limit = Int(Int32.max)
    let iterations = 10000000
    
    let counter = Counter()
    
    let delegate = TerminalHandler()
    
    let updateFrequency = iterations / 1000
    
    for i in 1...iterations {
        
        // Roll the two “dice”
        let m = generateRandomInt(lessThan: limit) + 1
        let n = generateRandomInt(lessThan: limit) + 1
        
        // Uptick the counter
        counter.uptickBasedOnNubers(m, and: n)
        
        if i%updateFrequency == 0 {
            
            delegate.progressBarWasUpticked(percentDone: Double(i)/Double(iterations))
            
        }
        
    }
    
    delegate.numberPairsWereUpdated(coprimes: counter.coprimes, composites: counter.composites)
    
    let ratio = Double(counter.coprimes) / Double(iterations)
    delegate.ratioWasUpdated(ratio: ratio)
    
    let π = sqrt(6 / ratio)
    delegate.estimateOfPiWasMade(π: π)
    
}
