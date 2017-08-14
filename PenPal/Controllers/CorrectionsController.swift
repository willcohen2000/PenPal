//
//  CorrectionsController.swift
//  PenPal
//
//  Created by Will Cohen on 8/9/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit

class CorrectionsController: UIViewController {

    @IBOutlet weak var correctionsTableView: UITableView!
    @IBOutlet weak var loadingView: UIImageView!
    @IBOutlet weak var doNotHaveCorrectionsLabel: UILabel!
    
    var selectedCorrection: Correction!
    var corrections = [Correction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doNotHaveCorrectionsLabel.isHidden = true
        loadingView.loadGif(name: "StandardLoadingAnimation")
        
        FirebaseService.loadCorrections(userUID: User.sharedInstance.uid) { (corrections) in
            self.loadingView.isHidden = true
            self.corrections = corrections
            self.correctionsTableView.reloadData()
            
            if (corrections.count == 0) {
                self.doNotHaveCorrectionsLabel.isHidden = false
            }
            
        }
        
        correctionsTableView.delegate = self
        correctionsTableView.dataSource = self
        
    }

}

extension CorrectionsController: viewCorrectionDelegate {
    func viewCorrectionButtonPressed(_ correction: Correction) {
        self.selectedCorrection = correction
        self.performSegue(withIdentifier: Constants.Segues.toFullCorrection, sender: nil)
    }
}

extension CorrectionsController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.toFullCorrection) {
            if let nextVC = segue.destination as? FullCorrectionController {
                nextVC.correction = self.selectedCorrection
            }
        }
    }
}

extension CorrectionsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corrections.count
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCorrection = corrections[indexPath.row]
        self.performSegue(withIdentifier: Constants.Segues.toFullCorrection, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let correction = corrections[indexPath.row]
        if let cell = correctionsTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.correctionCell) as? CorrectionCell {
            cell.configureCell(correction)
            cell.correctionDelegate = self
            return cell
        } else {
            return ExternalLearnerCell()
        }
    }
    
}




