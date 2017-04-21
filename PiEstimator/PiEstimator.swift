//
//  PiEstimator.swift
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

import Cocoa



class Counter {
    
    private var coprimes_ = 0
    private var composites_ = 0
    
    
    var coprimes: Int { return coprimes_ }
    var composites: Int { return composites_ }
    var total: Int { return coprimes_ + composites_ }
    
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

public protocol PiEstimatorDelegate: class {
    
    func simulationHasBegun()
    func progressBarWasUpticked(percentDone: Double)
    func numberOfPairsWasUpdated(coprimes: Int, composites: Int)
    func ratioWasUpdated(ratio: Double)
    func estimateOfPiWasMade(π: Double)
    func killSwitchWasTurnedOn()
    func simulationHasTerminated()
    
    var killSwitch: PiEstimator.KillSwitch { get set }
    var piEstimatorLock: PiEstimator.Lock { get set }
    
}

class TerminalHandler: PiEstimatorDelegate {
    
    func simulationHasBegun() {
    
        piEstimatorLock = .locked
        
    }
    
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
    
    func killSwitchWasTurnedOn() {
        
        killSwitch = .dontKill
        
    }
    
    func simulationHasTerminated() {
    
        piEstimatorLock = .unlocked
        
    }
    
    var killSwitch = PiEstimator.KillSwitch.dontKill
    var piEstimatorLock = PiEstimator.Lock.unlocked

}

public class PiEstimator {

    weak public var delegate: PiEstimatorDelegate?
    public var dieCastUpperBound = Int(Int32.max)
    public var iterations = 1000

    /// Works as a kill switch. If it is on, the PiEstimator will stop on the next loop.
    public enum KillSwitch { case kill; case dontKill }
    
    /// Works as a lock. As long as it is on, the estimator should never be activated.
    public enum Lock { case locked; case unlocked }
    
    private var progressBarUpdateFrequency: Int { return iterations / 1000 }
    private var counter = Counter()
    
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
        
        // Refuse to run if the lock is locked.
        if delegate?.piEstimatorLock == PiEstimator.Lock.locked { return }
        
        Async.background {
            
            // The simulation has begun. This is a good moment to lock the estimator.
            self.delegate?.simulationHasBegun()
            
            let counter = self.counter
            let progressBarTimer = Timer()
            let dataUpdateTimer = Timer()
            
            if counter.total >= self.iterations { counter.reset() }
            
            for i in counter.total + 1...self.iterations {
                
                if self.delegate?.killSwitch == .kill {
                    
                    self.delegate?.killSwitchWasTurnedOn()
                    break
                    
                }
                
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
                        
                        let totalSoFar = counter.total
                        let ratio = Double(counter.coprimes) / Double(totalSoFar)
                        self.delegate?.ratioWasUpdated(ratio: ratio)
                        
                        let π = sqrt(6 / ratio)
                        self.delegate?.estimateOfPiWasMade(π: π)
                        
                    }
                    
                }
                
            }
            
            // The simulation has terminated. This is a good place to unlock the estimator.
            self.delegate?.simulationHasTerminated()
            
        }
        
    }
    
}
