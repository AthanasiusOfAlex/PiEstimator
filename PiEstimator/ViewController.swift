//
//  ViewController.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn. All rights reserved.
//

import Cocoa

extension ViewController: EstimatorDelegate {
    
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
    
    @IBAction func runSimulation(_ sender: NSButton) {
        
        self.progressBar.doubleValue = 0.0
        piEstimator.run()

    }
    
    @IBAction func quit(_ sender: NSButton) {
        
        NSApplication.shared().terminate(self)
    
    }
    
    @IBAction func updateUpperBound(_ sender: NSTextField) {
    
        piEstimator.dieCastUpperBound = self.dieCastUpperBound.integerValue
        
    }
    
    @IBAction func updateIterations(_ sender: NSTextField) {
        
        piEstimator.iterations = self.numberOfInterations.integerValue
        
    }
    
    private let piEstimator = PiEstimator()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        piEstimator.delegate = self
        self.dieCastUpperBound.integerValue = piEstimator.dieCastUpperBound
        self.numberOfInterations.integerValue = piEstimator.iterations
        self.progressBar.doubleValue = 0.0
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

