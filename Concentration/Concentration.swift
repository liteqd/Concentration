//
//  Concentration.swift
//  concentration
//
//  Created by Chester Lau on 7/29/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import Foundation

struct Concentration
{
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    }else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var score = 0
    
    private var scoreMultiplier = 1
    
    var numberOfMatchedPairs = 0
    
    var startTime = Date()
    private var endTime = Date()
    
    private mutating func timer(){
        endTime = Date()
        let timeInterval: Double = endTime.timeIntervalSince(startTime)
        switch timeInterval {
        case 0..<4.0:
            scoreMultiplier = 4
        case 4.0..<8.0:
            scoreMultiplier = 2
        default:
            scoreMultiplier = 1
        }
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    timer()
                    startTime = Date()
                    numberOfMatchedPairs += 1
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    if cards[index].hadBeenFacedUp && cards[matchIndex].hadBeenFacedUp {
                    score += 1 * scoreMultiplier
                    }else {
                        score += 2 * scoreMultiplier
                    }
                }else {
                    cards[index].hadBeenFacedUp = true
                    cards[matchIndex].hadBeenFacedUp = true
              }
            cards[index].isFaceUp = true
            }else{
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    mutating func shuffleCards() {
        for _ in 1...cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(0, randomIndex)
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        // shuffle the cards
        shuffleCards()
//        for _ in 1...cards.count {
//            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
//            cards.swapAt(0, randomIndex)
//        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


