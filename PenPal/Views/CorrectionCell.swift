//
//  CorrectionCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/9/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Kingfisher

protocol viewCorrectionDelegate {
    func viewCorrectionButtonPressed(_ correction: Correction)
}

class CorrectionCell: UITableViewCell {

    @IBOutlet weak var correctionMessageLabel: UILabel!
    @IBOutlet weak var correctorNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var correctionDateLabel: UILabel!
    
    var correctionDelegate: viewCorrectionDelegate?
    var correction: Correction!
    
    func configureCell(_ correction: Correction) {
        self.correction = correction
        correctionMessageLabel.text = correction.correction
        correctorNameLabel.text = correction.correctionFromUserName
        correctionDateLabel.text = correction.timeOfCorrection
        if (correction.profileImageURL == "") {
            profileImageView.image = UIImage(named: "NoProfileImg")
            profileImageView.maskImageWithImage()
        } else {
            profileImageView.kf.setImage(with: URL(string: correction.profileImageURL))
            profileImageView.maskImageWithImage()
        }
        
    }
    
    @IBAction func viewCorrectionButtonPressed(_ sender: Any) {
        if correctionDelegate != nil {
            correctionDelegate?.viewCorrectionButtonPressed(correction)
        }
    }
    
}
