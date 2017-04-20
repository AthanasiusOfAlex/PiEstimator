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
    
    func reset() {
        
        coprimes_ = 0
        composites_ = 0
        
    }
    
}

public protocol EstimatorDelegate {
    
    func progressBarWasUpticked(percentDone: Double)
    func numberOfPairsWasUpdated(coprimes: Int, composites: Int)
    func ratioWasUpdated(ratio: Double)
    func estimateOfPiWasMade(π: Double)
 
    var killSwitch: PiEstimator.KillSwitch { get }
    
}

class TerminalHandler: EstimatorDelegate {
    
    func progressBarWasUpticked(percentDone: Double) {
        
        print("Percentage done: \(percentDone * 100)")
        
    }
    
    func numberOfPairsWasUpdated(coprimes: Int, composites: Int) {

        print("Coprime pairs: \(coprimes); Composite pairs: \(composites)")

    }
    
    func ratioWasUpdated(ratio: Double) {
        
        print("Ratio of coprimes to total: \(ratio)")

    }
    
    func estimateOfPiWasMade(π: Double) {
        
        print("Estimate of π: \(π)")

    }
    
    var killSwitch = PiEstimator.KillSwitch.off

}

public class PiEstimator {

    public var delegate: EstimatorDelegate?
    public var dieCastUpperBound = Int(Int32.max)
    public var iterations = 1000

    /// Works as a kill switch. If it is on, the PiEstimator will stop on the next loop.
    public enum KillSwitch { case on; case off }
    
    private var progressBarUpdateFrequency: Int { return iterations / 1000 }
    
    private class Timer {
        
        private var startTime = DispatchTime.now().uptimeNanoseconds
        private var currentTime: UInt64 {
            
            return DispatchTime.now().uptimeNanoseconds
            
        }
        
        func reset() {
            
            startTime = currentTime
            
        }
        
        var elapsedTime: Int {
            
            assert(currentTime >= startTime, "Current time was less than start time")
            return Int(currentTime - startTime)
            
        }
        
    }
    
    func run() {
        
        Async.background {
            
            let counter = Counter()
            let progressBarTimer = Timer()
            let dataUpdateTimer = Timer()
            
            for i in 1...self.iterations {
                
                if self.delegate?.killSwitch == .on { break }
                
                // Roll the two “dice”
                let m = generateRandomInt(lessThan: self.dieCastUpperBound) + 1
                let n = generateRandomInt(lessThan: self.dieCastUpperBound) + 1
                
                // Uptick the counter
                counter.uptickBasedOnNubers(m, and: n)
                
                if progressBarTimer.elapsedTime >= 250000000 || i==1 || i==self.iterations {
                    
                    Async.main {
                        
                        let percentDone = Double(i)/Double(self.iterations)
                        self.delegate?.progressBarWasUpticked(percentDone: percentDone)
                    
                    }
                    
                }
                
                if dataUpdateTimer.elapsedTime >= 500000000 || i==1 || i==self.iterations {
                    
                    dataUpdateTimer.reset()
                    
                    Async.main {

                        self.delegate?.numberOfPairsWasUpdated(coprimes: counter.coprimes,
                                                              composites: counter.composites)
                        
                        let totalSoFar = counter.coprimes + counter.composites
                        let ratio = Double(counter.coprimes) / Double(totalSoFar)
                        self.delegate?.ratioWasUpdated(ratio: ratio)
                        
                        let π = sqrt(6 / ratio)
                        self.delegate?.estimateOfPiWasMade(π: π)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
