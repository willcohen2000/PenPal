//
//  PickNativeLanguageController.swift
//  PenPal
//
//  Created by Will Cohen on 7/17/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class PickNativeLanguageController: UIViewController {

    @IBOutlet weak var pickNativeLanguageCollectionView: UITableView!
    @IBOutlet weak var pickLanguageYouAreAlreadyFluentInLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    
    var nativeLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        progressViewWidthConstraint.constant = UIScreen.main.bounds.width / 3
        pickNativeLanguageCollectionView.delegate = self
        pickNativeLanguageCollectionView.dataSource = self
        pickNativeLanguageCollectionView.allowsSelection = false
        pickNativeLanguageCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressViewWidthConstraint.constant = 0.66 * UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if (nativeLanguages.count != 0) {
            User.sharedInstance.nativeLanguages = []
            User.sharedInstance.nativeLanguages = nativeLanguages
            self.performSegue(withIdentifier: "nextSegue", sender: nil)
        } else {
            MainFunctions.createSimpleAlert(alertTitle: NSLocalizedString("No Languages Selected", comment: "No Languages Selected"), alertMessage: NSLocalizedString("You need to select at least one language to continue.", comment: "You need to select at least one language to continue."), controller: self)
        }
    }
    
    @IBAction func backArrowButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func localize() {
        pickLanguageYouAreAlreadyFluentInLabel.text = NSLocalizedString("Pick the language(s) you are already fluent in", comment: "Choose your target language(s)")
        nextButton.setTitle(NSLocalizedString("Next", comment: "Next/Continue"), for: .normal)
    }
    
}

extension PickNativeLanguageController: pickNativeLanguageDelegate, unpickNativeLanguageDelegate {
    
    func nativeLanguageSelected(_ language: String) {
        nativeLanguages.append(language)
    }
    
    func nativeLanguageDeselected(_ language: String) {
        if let languageIndex = nativeLanguages.index(of: language) {
            nativeLanguages.remove(at: languageIndex)
        }
    }
    
}

extension PickNativeLanguageController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Languages.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = Languages.languages[indexPath.row]
        if let cell = pickNativeLanguageCollectionView.dequeueReusableCell(withIdentifier: "pickNativeLanguageCell") as? PickNativeLanguageCell {
            if (nativeLanguages.contains(post)) {
                cell.configureCellSelected(language: post)
            } else {
                cell.configureCellUnselected(language: post)
            }
            cell.pickDelegate = self
            cell.unpickDelegate = self
            return cell
        } else {
            return PickNativeLanguageCell()
        }
    }
    
}
