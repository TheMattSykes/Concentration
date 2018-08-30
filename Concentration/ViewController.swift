//
//  ViewController.swift
//  Concentration
//
//  Created by Matthew Sykes on 15/08/2018.
//  Copyright © 2018 mattsykes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = newGame()
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var gameProgress: UIProgressView!
    
    // Cards (Button)
    @IBAction func touchCard(_ sender: UIButton) {
        game.flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    // New Game Button
    @IBAction func touchNewGame(_ sender: UIButton) {
        game = newGame()
        updateViewFromModel()
    }
    
    func newGame() -> Concentration {
        return Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = game.flipLabelData
        scoreCountLabel.text = game.scoreLabelData
        gameProgress.progress = Float(game.progress)
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        
        if game.emoji[card.identifier] == nil, game.emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(game.emojiChoices.count)))
            game.emoji[card.identifier] = game.emojiChoices.remove(at: randomIndex)
        }
        
        // Return emoji if set or ? if not set
        return game.emoji[card.identifier] ?? "?"
    }
}
