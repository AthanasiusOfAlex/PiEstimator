//
//  MathFunctions.swift
//  PiEstimator
//
//  Created by Louis Melahn on 4/19/17.
//  Copyright © 2017 Louis Melahn. All rights reserved.
//

import Foundation

func gcf(_ m: Int, _ n: Int) -> Int {
    
    assert(m != 0 && n != 0, "Please use only nonzero integers")

    let absM = abs(m)
    let absN = abs(n)
    
    let remainder = absM % absN
    
    if remainder != 0 {
        
        return gcf(absN, remainder)
        
    } else {
        
        return absN
        
    }
    
}

extension Int {
    
    func isCoprimeWith(_ n: Int) -> Bool {
        
        if gcf(self, n)==1 {
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
}
