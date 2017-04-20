//
//  PiEstimator.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn. All rights reserved.
//

import Cocoa

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

class PiEstimator {

    let limit = Int(Int32.max)
    let iterations = 10000000
    
    let counter = Counter()
    
    var delegate: EstimatorDelegate?
    
    var updateFrequency: Int { return iterations / 1000 }
    
    func run() {
        
        Async.background {
            
            for i in 1...self.iterations {
                
                // Roll the two “dice”
                let m = generateRandomInt(lessThan: self.limit) + 1
                let n = generateRandomInt(lessThan: self.limit) + 1
                
                // Uptick the counter
                self.counter.uptickBasedOnNubers(m, and: n)
                
                if i%self.updateFrequency == 0 {
                    
                    Async.main {
                        self.delegate?.progressBarWasUpticked(percentDone: Double(i)/Double(self.iterations))
                    }
                    
                }
                
            }
            
        }.main {
        
            self.delegate?.numberPairsWereUpdated(coprimes: self.counter.coprimes,
                                                  composites: self.counter.composites)
            
            let ratio = Double(self.counter.coprimes) / Double(self.iterations)
            self.delegate?.ratioWasUpdated(ratio: ratio)
            
            let π = sqrt(6 / ratio)
            self.delegate?.estimateOfPiWasMade(π: π)
        
        }
        
    }
    
}
