//
//  Array+AppTools.swift
//  AngelDoctor
//
//  Created by dsq on 2021/1/7.
//

import UIKit
extension Array {
    mutating func safeRemoveFirst() -> Element? {
        if isEmpty { return nil }
        return removeFirst()
    }
    
    func safeIndex(_ i: Int) -> Array.Iterator.Element? {
        guard !isEmpty && self.count > abs(i) else {
            return nil
        }
        
        for item in self.enumerated() {
            if item.offset == i {
                return item.element
            }
        }
        return nil
    }
}
