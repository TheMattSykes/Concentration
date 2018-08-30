//
//  Concentration.swift
//  Concentration
//
//  Created by Matthew Sykes on 16/08/2018.
//  Copyright © 2018 mattsykes. All rights reserved.
//

import Foundation

class Concentration {
    
    var flipLabelData = "Flips: 0" // Flip Count String Updater
    
    var flipCount = 0 {
        didSet {
            flipLabelData = "Flips: \(flipCount)"
        }
    }
    
    var scoreLabelData = "Score: 0" // Flip Count String Updater
    
    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
            
            scoreLabelData = "Score: \(score)"
        }
    }
    
    var progress = 0.0 // progress bar value
    
    var cards = [Card]() // An empty array of Card objects
    
    var emojiChoices = [String]() // An empty array of Strings
    
    var emoji = [Int:String]() // Empty Dictionary
    
    var themes = [["🐶","🐷","🐟","🐙","🐌","🦔"],
                  ["🍎","🍋","🍍","🍊","🍓","🍒"],
                  ["🎃","👻","🐻","👀","🌚","🕷"]]
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func reset() {
        cards = [Card]()
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    score += 2 // Increase score by 2 when match is made
                    progress += (100.0/(Double(cards.count)/2.0)/100.0) // Update progress bar
                } else {
                    score -= 1 // Decrease score by 1 when failed attempt made
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    // Theme selecter and emoji list generator
    func newEmojiList() -> Array<String> {
        let randomIndex = Int(arc4random_uniform(UInt32(themes.count)))
        
        return themes[randomIndex]
    }
    
    init(numberOfPairsOfCards: Int) {
        
        emojiChoices = newEmojiList()
        
        if cards.count > 0 {
            cards = [Card]() // reset cards array
        }
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // Shuffle the cards
        var newCardsList = [Card]()
        
        // Insert random element from first array into new array
        for _ in 0..<cards.count {
            let randomCardIndex = Int(arc4random_uniform(UInt32(cards.count)))

            newCardsList.append(cards[randomCardIndex])
            cards.remove(at: randomCardIndex)
        }
        cards = newCardsList
    }
}
