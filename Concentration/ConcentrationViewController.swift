//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Chester Lau on 8/18/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import UIKit

//import WigglyUIControlView.swift

class ConcentrationViewController: UIViewController {
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards = Int()
    
    private(set) var flipCount = 0 {
        didSet{
            updateLabel(for: "Attempt")
        }
    }
    
    private var vibratingNewGameButtonTimer: Timer? {
        willSet{
            vibratingNewGameButtonTimer?.invalidate()
        }
    }
    
    private var turnBackCardsTimer: Timer? {
        willSet{
            turnBackCardsTimer?.invalidate()
        }
    }
    
    private var TCConcentrationViewController: ConcentrationThemeChooserViewController?
    
    private var visibleCardButtons = [UIButton]()

    private var cornerRadius: CGFloat!
    
    private var turnCardCount = 1 {
        didSet{
            turnCardCount = turnCardCount > 2 ? 0 : turnCardCount
        }
    }
    
    private var matchedArray = [false, false]
    private var matchedButtonsArray = [UIButton(), UIButton()]
    
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
    
    var theme = " " {        didSet{
            emoji = [Card:String]()
            emojiChoices = theme
            emoji = [:]
            updateColorOfButtons()
        }
    }
    
    var emojiChoices = "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛸"
    
    @IBOutlet var endOfGameLabel: UILabel!
    
    @IBOutlet var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet var scoreLabel: UILabel!
  
    @IBOutlet var quitButton: UIButton!
    
    @IBOutlet var vibratingNewGameButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        endOfGameLabel = UILabel()
        flipCountLabel = UILabel()
        scoreLabel = UILabel()
        quitButton = UIButton()
        vibratingNewGameButton = UIButton()
        if let tc_cvc = TCConcentrationViewController {
            tc_cvc.tc_themes = themes
        }
    }
    
    private func updateLabel(for label: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : -5.0,
            .strokeColor : colorOfButtons]
        switch label {
        case "Attempt":
                let attributedString = NSAttributedString (string: "Attempts: \(Int(flipCount/2))", attributes: attributes)
                flipCountLabel.attributedText = attributedString
        case "Point":
                let attributedString = NSAttributedString (string: "Wumpum: \(game.score) 🐚", attributes: attributes)
                scoreLabel.attributedText = attributedString
        default :
            print("Have to provide 'Attempt' or 'Point'")
        }
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
        updateLabel(for: "Point")
        updateLabel(for: "Attempt")
        endOfGameLabel.text = " "
        if themeName == "Random" {
            chooseTheme()
            updateColorOfButtons()
        } else { emojiChoices = theme }
        emoji = [Card:String]()
        emojiChoices = theme
        emoji = [:]
        updateColorOfButtons()
        vibratingNewGameButtonTimer = nil
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
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
    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        vibratingNewGameButton.delegate = self
//        }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visibleCardButtons = (cardButtons?.filter { !$0.superview!.isHidden })!
        numberOfPairsOfCards = Int((visibleCardButtons.count+1) / 2)
        let height = CGFloat(visibleCardButtons[0].bounds.size.height)
        let width = CGFloat(visibleCardButtons[0].bounds.size.width)
        cornerRadius = (height / 8 +  width / 8) / 2
        updateLabel(for: "Attempt")
        updateViewFromModel()
    }
    
    private func updateColorOfButtons() {
        flipCountLabel.textColor = colorOfButtons
        scoreLabel.textColor = colorOfButtons
        endOfGameLabel.textColor = colorOfButtons
        vibratingNewGameButton.setTitleColor(colorOfButtons, for: .normal)
        quitButton.setTitleColor(colorOfButtons, for: .normal)
        view.backgroundColor = colorOfBackground
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        if visibleCardButtons.count > 0 {
            matchedArray = [false, false]
            updateLabel(for: "Point")
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = self.game.cards[index]
                if card.isFaceUp{
                    if card.isMatched {
                        if matchedArray[0] == false {
                            matchedArray[0] = true
                            matchedButtonsArray[0] = button
                        } else {
                            matchedArray[1] = true
                            matchedButtonsArray[1] = button
                        }
                    }
                    UIView.transition(with: button, duration: 0.6,
                                  options: [.transitionFlipFromRight],
                                  animations: {button.setTitle(self.emoji(for: card), for: UIControl.State.normal)
                                               button.backgroundColor = self.colorOfButtons
                                              }
                    )
                }else{
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : colorOfButtons
                }
                button.layer.cornerRadius = cornerRadius
                button.clipsToBounds = true
            }
            
            if matchedArray[0] == true, matchedArray[1] == true {
                matchedDance(the: matchedButtonsArray[0], forDelay: 0, withfillMode: CAMediaTimingFillMode.both.rawValue, andRemovedOnCompletion: false)
                matchedDance(the: matchedButtonsArray[1], forDelay: 0, withfillMode: CAMediaTimingFillMode.both.rawValue, andRemovedOnCompletion: false)
            }
            
            if game.numberOfMatchedPairs == numberOfPairsOfCards {
                endOfGameLabel.text = "Congrat, you did it!"
                vibratingNewGameButtonTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (Timer) in self.vibrate(the: self.vibratingNewGameButton) }
                vibratingNewGameButtonTimer!.tolerance = 1.0
                turnBackCardsTimer = nil
            } else {
            turnBackCardsTimer = nil
            turnBackCardsTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (Timer) in self.updateViewFromModel()
                self.turnBackCardsTimer!.tolerance = 1.0
                }
            }
        }
    }
    
    var emoji = [Card:String]()
    
    func emoji(for card: Card) -> String {
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
    
    @objc private func vibrate(the sender: Any) {
        let uiControl = sender as? UIControl
        let buttonLayer = uiControl!.layer
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: uiControl!.center.x - 10, y: uiControl!.center.y))
        animation.fromValue = NSValue(cgPoint: CGPoint(x: uiControl!.center.x + 10, y: uiControl!.center.y))
        buttonLayer.add(animation, forKey: "position")
    }
    
    @objc private func matchedDance(the sender: Any, forDelay beginTime: CFTimeInterval, withfillMode fillMode: String, andRemovedOnCompletion removedOnCompletion: Bool) {
        let uiControl = sender as? UIControl
        let buttonLayer = uiControl!.layer
        
        let anticOverTiming = CAMediaTimingFunction(controlPoints: 0.42, -0.30, 0.58, 1.30)
        
        let template1OpacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        template1OpacityAnimation.duration = 1.750
        template1OpacityAnimation.values = [1.000, 1.000, 0.000] as [Float]
        template1OpacityAnimation.keyTimes = [0.000, 0.857, 1.000] as [NSNumber]
        template1OpacityAnimation.timingFunctions = [anticOverTiming, anticOverTiming]
        template1OpacityAnimation.beginTime = beginTime
        template1OpacityAnimation.fillMode = CAMediaTimingFillMode(rawValue: fillMode)
        template1OpacityAnimation.isRemovedOnCompletion = removedOnCompletion
        buttonLayer.add(template1OpacityAnimation, forKey:"stretches_Opacity")
        
        let template1ScaleXAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        template1ScaleXAnimation.duration = 1.750
        template1ScaleXAnimation.values = [1.200, 1.200, 2.400, 1.200, 2.400, 1.800, 2.200, 0.000] as [Float]
        template1ScaleXAnimation.keyTimes = [0.000, 0.143, 0.286, 0.429, 0.571, 0.714, 0.857, 1.000] as [NSNumber]
        template1ScaleXAnimation.timingFunctions = [anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming]
        template1ScaleXAnimation.beginTime = beginTime
        template1ScaleXAnimation.fillMode = CAMediaTimingFillMode(rawValue: fillMode)
        template1ScaleXAnimation.isRemovedOnCompletion = removedOnCompletion
        buttonLayer.add(template1ScaleXAnimation, forKey:"stretches_ScaleX")
        
        let template1ScaleYAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        template1ScaleYAnimation.duration = 1.750
        template1ScaleYAnimation.values = [2.000, 3.000, 1.500, 3.000, 1.500, 2.000, 2.300, 0.000] as [Float]
        template1ScaleYAnimation.keyTimes = [0.000, 0.143, 0.286, 0.429, 0.571, 0.714, 0.857, 1.000] as [NSNumber]
        template1ScaleYAnimation.timingFunctions = [anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming, anticOverTiming]
        template1ScaleYAnimation.beginTime = beginTime
        template1ScaleYAnimation.fillMode = CAMediaTimingFillMode(rawValue: fillMode)
        template1ScaleYAnimation.isRemovedOnCompletion = removedOnCompletion
        buttonLayer.add(template1ScaleYAnimation, forKey:"stretches_ScaleY")
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

extension UIView {
    func getImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapShotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapShotImageFromMyView!
    }
}

