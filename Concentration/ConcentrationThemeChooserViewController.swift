//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Chester Lau on 8/18/18.
//  Copyright © 2018 Chester Lau. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    var tc_themeName = "Sports"
    
    var tc_themes = [ String: String ]() {
        didSet{
            if !sendTheme(with: tc_themeName) {
                print("Cannot send theme back to ConcentrationViewController")
            }
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSequedToConcentrationViewController: ConcentrationViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == " " {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let themeName = ( sender as? UIButton)?.currentTitle {
            print("\(themeName)")
            tc_themeName = themeName
            if !sendTheme(with: themeName) {
                performSegue(withIdentifier: "Choose Theme", sender: sender)
            }
        }
    }

    private func sendTheme(with themeName: String) -> Bool {
        if let cvc = splitViewDetailConcentrationViewController {
            cvc.themeName = themeName
            return true
            
        } else if let cvc = lastSequedToConcentrationViewController {
            cvc.themeName = themeName
            navigationController?.pushViewController(cvc, animated: true)
            return true
        }
        return false
    }
  
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: Any?.self)
        if segue.identifier == "Choose Theme", let themeName = (sender as? UIButton)?.currentTitle, let cvc = segue.destination as? ConcentrationViewController {
                cvc.themeName = themeName
                lastSequedToConcentrationViewController = cvc
        }
    }
}

