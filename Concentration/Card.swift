//
//  Card.swift
//  concentration
//
//  Created by Chester Lau on 7/29/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int { return identifier }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    static func == (lhs: Card, rhs: Int) -> Bool {
        return lhs.identifier == rhs
    }
    
    
    var isFaceUp = false
    var isMatched = false
    var hadBeenFacedUp = false
    private var identifier: Int
    
    private static var identifierfactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierfactory += 1
        return identifierfactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
