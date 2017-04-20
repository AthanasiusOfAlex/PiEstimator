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
    
    func numberPairsWereUpdated(coprimes: Int, composites: Int) {
        
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

    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var estimateOfPi: NSTextField!
    @IBOutlet weak var ratioCoprimesToTotal: NSTextField!
    @IBOutlet weak var compositePairs: NSTextField!
    @IBOutlet weak var coprimePairs: NSTextField!
    @IBOutlet weak var calculating: NSTextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.progressBar.doubleValue = 0.0

        let piEstimator = PiEstimator()
        piEstimator.delegate = self
        
        piEstimator.run()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

