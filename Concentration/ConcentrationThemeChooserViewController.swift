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

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
                cvc.themeName = themeName
                cvc.themes = themes
            }
        } else if let cvc = lastSequedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
                cvc.themeName = themeName
                cvc.themes = themes
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
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                        cvc.theme = theme
                        cvc.themeName = themeName
                        cvc.themes = themes
                    lastSequedToConcentrationViewController = cvc
                }
            }
        }
    }
}
