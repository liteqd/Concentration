//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Chester Lau on 8/18/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    let themes = ["Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓",
            "Halloween": "👻🎃😾☠️🦉🦅🐞🦎🐝",
            "Animals": "🦆🦋🐌🦀🐬🐳🦓🦍🐖",
            "Faces": "😇😎😀🧐😰😱🤢🤡👽",
            "Flags": "🏁🚩🇦🇽🇧🇪🇧🇷🇨🇦🇨🇬🇯🇵🇺🇸",
            "Cars": "🚗🚕🚙🚌🚎🏎🚓🚑🚒",
            "Fruits":"🍏🍎🍐🍊🍋🍌🍉🍇🍓"]
    
    let themeColorOfBackground = ["Sports": #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), "Halloween": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), "Faces": #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), "Flags": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "Cars": #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), "Fruits": #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
    let themeColorOfButtons = ["Sports": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Halloween": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Faces": #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), "Flags": #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), "Cars": #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), "Fruits": #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    
    struct TC_themeInfo {
        var themeName = "Random"
        
        var colorOfButtons = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        var colorOfBackground = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
//        var emojiChoices = "👻🎃😾☠️🦉🦅🐞🦎🐝"
        var theme = "👻🎃😾☠️🦉🦅🐞🦎🐝"
    }
    
    var tc_themeInfo = TC_themeInfo()  {
        didSet{
            chooseTheme() 
        }
    }
    
    var tc_emojiChoices = " "

//    {
//        didSet{
//            updateColorOfButtons()
//            updateFlipCountLabel()
//        }
//    }
    
//     {
//        didSet{
//            chooseTheme()
//        }
//    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.themeInfo.theme == " " {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if themeName == "Random" {
                    let themeKeys = Array(themes.keys)
                    let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
                    let theme = Array(themes.values)[themeIndex]
                    print("good1")
                    print("\(theme)")
                    cvc.themeInfo.theme = theme
                } else {
                    let theme = themes[themeName]
                    print("good2")
                    print("\(String(describing: theme))")
                    cvc.themeInfo.theme = theme!
                }
                tc_themeInfo.themeName = themeName
                cvc.emojiChoices = tc_emojiChoices
                cvc.themeInfo.colorOfBackground = tc_themeInfo.colorOfBackground
                cvc.themeInfo.colorOfButtons = tc_themeInfo.colorOfButtons
                cvc.themeInfo.themeName = themeName
//                cvc.themeInfo.theme = themes
                
            }
        } else if let cvc = lastSequedToConcentrationViewController {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if themeName == "Random" {
                    let themeKeys = Array(themes.keys)
                    let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
                    let theme = Array(themes.values)[themeIndex]
                    print("good3")
                    print("\(theme)")
                    cvc.themeInfo.theme = theme
                } else {
                    let theme = themes[themeName]
                    print("good4")
                    print("\(String(describing: theme))")
                    cvc.themeInfo.theme = theme!
                }
                tc_themeInfo.themeName = themeName
                cvc.emojiChoices = tc_emojiChoices
                cvc.themeInfo.colorOfBackground = tc_themeInfo.colorOfBackground
                cvc.themeInfo.colorOfButtons = tc_themeInfo.colorOfButtons
                cvc.themeInfo.themeName = themeName
//                cvc.themes = themes
            }
                    navigationController?.pushViewController(cvc, animated: true)
        } else {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
  
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
       return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
// MARK: - Navigation
    
    private var lastSequedToConcentrationViewController: ConcentrationViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: Any?.self)
        if segue.identifier == "Choose Theme" {
//            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
            if let themeName = (sender as? UIButton)?.currentTitle {
                
                if let cvc = segue.destination as? ConcentrationViewController {
                    if themeName == "Random" {
                        let themeKeys = Array(themes.keys)
                        let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
                        let theme = Array(themes.values)[themeIndex]
                        cvc.themeInfo.theme = theme
                    } else {
                        let theme = themes[themeName]
                        cvc.themeInfo.theme = theme!
                    }
                    print("\(themeName)")
                    tc_themeInfo.themeName = themeName
                   
                    cvc.emojiChoices = tc_emojiChoices
                    cvc.themeInfo.colorOfBackground = tc_themeInfo.colorOfBackground
                    cvc.themeInfo.colorOfButtons = tc_themeInfo.colorOfButtons
                    cvc.themeInfo.theme = tc_themeInfo.theme
//                    cvc.themes = themes
                    
                    lastSequedToConcentrationViewController = cvc
                }
            }
        }
    }
    
//    private func chooseTheme () {
//        let themes = ["Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓",
//                      "Halloween": "👻🎃😾☠️🦉🦅🐞🦎🐝",
//                      "Animals": "🦆🦋🐌🦀🐬🐳🦓🦍🐖",
//                      "Faces": "😇😎😀🧐😰😱🤢🤡👽",
//                      "Flags": "🏁🚩🇦🇽🇧🇪🇧🇷🇨🇦🇨🇬🇯🇵🇺🇸",
//                      "Cars": "🚗🚕🚙🚌🚎🏎🚓🚑🚒",
//                      "Fruits":"🍏🍎🍐🍊🍋🍌🍉🍇🍓"]
//        let themeBackgroundColor = ["Sports": #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), "Halloween": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), "Faces": #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), "Flags": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "Cars": #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), "Fruits": #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
//        let themeColorOfCard = ["Sports": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Halloween": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Faces": #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), "Flags": #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), "Cars": #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), "Fruits": #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
//        let themeKeys = Array(themes.keys)
//        print("\(tc_themeInfo.themeName)")
//        if tc_themeInfo.themeName == "Random" {
//            let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
//            tc_themeInfo.emojiChoices = Array(themes.values)[themeIndex]
//            tc_themeInfo.colorOfBackground = Array(themeColorOfBackground.values)[themeIndex]
//            tc_themeInfo.colorOfButtons = Array(themeColorOfButtons.values)[themeIndex]
//        } else {
//
//            tc_themeInfo.emojiChoices = themes[tc_themeInfo.themeName]!
//
//            tc_themeInfo.colorOfBackground = themeColorOfBackground[tc_themeInfo.themeName]!
//            tc_themeInfo.colorOfButtons = themeColorOfButtons[tc_themeInfo.themeName]!
//        }
//
//    }
    
    private func chooseTheme () {
        let themeBackgroundColor = ["Sports": #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), "Halloween": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), "Faces": #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), "Flags": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "Cars": #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), "Fruits": #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
        let themeColorOfCard = ["Sports": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Halloween": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), "Animals": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "Faces": #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), "Flags": #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), "Cars": #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), "Fruits": #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
        let themeKeys = Array(themes.keys)
        if tc_themeInfo.themeName == "Random" {
            let themeIndex = Int(arc4random_uniform(UInt32(themeKeys.count)))
            tc_emojiChoices = Array(themes.values)[themeIndex]
            tc_themeInfo.colorOfBackground = Array(themeBackgroundColor.values)[themeIndex]
            tc_themeInfo.colorOfButtons = Array(themeColorOfCard.values)[themeIndex]
        } else {
            tc_emojiChoices = themes[tc_themeInfo.themeName]!
            tc_themeInfo.colorOfBackground = themeBackgroundColor[tc_themeInfo.themeName]!
            tc_themeInfo.colorOfButtons = themeColorOfCard[tc_themeInfo.themeName]!
            
        }
        
    }
    
}

