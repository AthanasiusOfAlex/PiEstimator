//
//  ViewController.swift
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

extension ViewController: PiEstimatorDelegate {
    
    func simulationHasBegun() {
        
        piEstimatorLock = .locked
        
    }

    func progressBarWasUpticked(percentDone: Double) {
        
        self.progressBar.doubleValue = percentDone * 100
        
    }
    
    func numberOfPairsWasUpdated(coprimes: Int, composites: Int) {
        
        self.coprimePairs.integerValue = coprimes
        self.compositePairs.integerValue = composites
        
    }
    
    func ratioWasUpdated(ratio: Double) {
        
        self.ratioCoprimesToTotal.doubleValue = ratio
    
    }
    
    func estimateOfPiWasMade(π: Double) {
        
        self.estimateOfPi.doubleValue = π
        
    }
    
    func killSwitchWasTurnedOn() {
        
        killSwitch = .dontKill
        
    }
    
    func simulationHasTerminated() {
    
        piEstimatorLock = .unlocked
        
    }


}

class ViewController: NSViewController {

    @IBOutlet weak var dieCastUpperBound: NSTextField!
    @IBOutlet weak var numberOfInterations: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var estimateOfPi: NSTextField!
    @IBOutlet weak var ratioCoprimesToTotal: NSTextField!
    @IBOutlet weak var compositePairs: NSTextField!
    @IBOutlet weak var coprimePairs: NSTextField!
    @IBOutlet weak var calculating: NSTextField!
    
    @IBAction func upperBoundDidUpdate(_ sender: Any) {
    }
    @IBAction func iterationsDidUpdate(_ sender: Any) {
    }
    @IBAction func runSimulation(_ sender: NSButton) {
        
        //self.progressBar.doubleValue = 0.0
        updatePiEstimator()
        killSwitch = .dontKill
        piEstimator.run()

    }
    
    @IBAction func stopSimulation(_ sender: NSButton) {
    
        killSwitch = .kill
        
    }
    
    @IBAction func quit(_ sender: NSButton) {
        
        NSApplication.shared().terminate(self)
    
    }
    
    private var piEstimator = PiEstimator()
    
    public var killSwitch = PiEstimator.KillSwitch.dontKill
    public var piEstimatorLock = PiEstimator.Lock.unlocked

    
    func updatePiEstimator() {
        
        let upperBoundString = self.dieCastUpperBound.stringValue
        let iterationsString = self.numberOfInterations.stringValue
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let upperBound = Int(formatter.number(from: upperBoundString) ?? 1)
        let iterations = Int(formatter.number(from: iterationsString) ?? 1)

        piEstimator.dieCastUpperBound = upperBound
        piEstimator.iterations = iterations
        
        readValuesFromPiEstimator()
        
    }
    
    func readValuesFromPiEstimator() {
        
        self.dieCastUpperBound.integerValue = piEstimator.dieCastUpperBound
        self.numberOfInterations.integerValue = piEstimator.iterations
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        piEstimator.delegate = self
        readValuesFromPiEstimator()
        self.progressBar.doubleValue = 0.0
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}
