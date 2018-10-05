//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Chester Lau on 8/18/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards = Int()
    
    private(set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private var TCConcentrationViewController: ConcentrationThemeChooserViewController?
    
    private var visibleCardButtons = [UIButton]()

    var themeName = "Sports" {
        didSet{
            chooseTheme()
            updateColorOfButtons()
        }
    }
    
    let themes = ["Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛸",
                  "Halloween": "👻🎃😾☠️🦉🦅🐞🦎🐝👺",
                  "Animals": "🦆🦋🐌🦀🐬🐳🦓🦍🐖🐰",
                  "Faces": "😇😎😀🧐😰😱🤢🤡👽👹",
                  "Flags": "🏁🚩🇦🇽🇧🇪🇧🇷🇨🇦🇨🇬🇯🇵🇺🇸🇯🇪",
                  "Cars": "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚠",
                  "Fruits":"🍏🍎🍐🍊🍋🍌🍉🍇🍓🍒"]
    let themeBackgroundColor = ["Sports": #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), "Halloween": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), "Faces": #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), "Flags": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "Cars": #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), "Fruits": #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
    let themeColorOfCard = ["Sports": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Halloween": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Faces": #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), "Flags": #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), "Cars": #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), "Fruits": #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    var colorOfButtons = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var colorOfBackground = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    var theme = " " {
        didSet{
            emoji = [Card:String]()
            emojiChoices = theme
            emoji = [:]
            updateFlipCountLabel()
            updateColorOfButtons()
        }
    }
    
    var emojiChoices = "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛸"
    
    @IBOutlet var endOfGameLabel: UILabel!
    
    @IBOutlet var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var newGameButton: UIButton!
    
    @IBOutlet var quitButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        endOfGameLabel = UILabel()
        flipCountLabel = UILabel()
        scoreLabel = UILabel()
        newGameButton = UIButton()
        quitButton = UIButton()
        if let tc_cvc = TCConcentrationViewController {
            tc_cvc.tc_themes = themes
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : colorOfButtons]
        let attributedString = NSAttributedString (string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
       }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        flipCount = 0
        game.score = 0
        game.numberOfMatchedPairs = 0
        scoreLabel.text = "Score: 0"
        endOfGameLabel.text = " "
        if themeName == "Random" {
            chooseTheme()
            updateColorOfButtons()
        } else { emojiChoices = theme }
        emoji = [Card:String]()
        emojiChoices = theme
        emoji = [:]
        updateColorOfButtons()
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = colorOfButtons
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil
        }
        game.shuffleCards()
        game.startTime = Date()
    }
    
    @IBAction private func done(_ sender: UIButton) {
        exit(0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visibleCardButtons = (cardButtons?.filter { !$0.superview!.isHidden })!
        numberOfPairsOfCards = Int((visibleCardButtons.count+1) / 2)
        updateViewFromModel()
    }
    
    private func updateColorOfButtons() {
        flipCountLabel.textColor = colorOfButtons
        scoreLabel.textColor = colorOfButtons
        endOfGameLabel.textColor = colorOfButtons
        newGameButton.setTitleColor(colorOfButtons, for: .normal)
        quitButton.setTitleColor(colorOfButtons, for: .normal)
        view.backgroundColor = colorOfBackground
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        if visibleCardButtons.count > 0 {
            scoreLabel.text = "Scores: \(game.score)"
            if game.numberOfMatchedPairs == numberOfPairsOfCards {
                endOfGameLabel.text = "Congrat, you did it!"
            }
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = colorOfButtons
                }else{
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : colorOfButtons
                }
            }
        }
    }
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
//        if emoji[card] != nil{
//            return emoji[card]!
//        }else{
//            return "?"
//        }
    }
    
    private func chooseTheme () {
        let themeKeys = Array(themes.keys)
        if themeName == "Random" {
            let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
            colorOfBackground = Array(themeBackgroundColor.values)[themeIndex]
            colorOfButtons = Array(themeColorOfCard.values)[themeIndex]
            theme = Array(themes.values)[themeIndex]
        } else {
            colorOfBackground = themeBackgroundColor[themeName]!
            colorOfButtons = themeColorOfCard[themeName]!
            theme = themes[themeName]!
            
        }
        
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

