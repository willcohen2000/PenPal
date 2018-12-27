//
//  CorrectionCell.swift
//  PenPal
//
//  Created by Will Cohen on 8/9/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyShadow

protocol viewCorrectionDelegate {
    func viewCorrectionButtonPressed(_ correction: Correction)
}

class CorrectionCell: UITableViewCell {

    @IBOutlet weak var correctionMessageLabel: UILabel!
    @IBOutlet weak var correctorNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var correctionDateLabel: UILabel!
    @IBOutlet weak var viewThisCorrectionButton: UIButton!
    @IBOutlet weak var correctionView: UIView!
    
    var correctionDelegate: viewCorrectionDelegate?
    var correction: Correction!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        correctionView.layer.cornerRadius = 10
        correctionView.layer.shadowRadius = 5
        correctionView.layer.shadowOpacity = 0.3
        correctionView.layer.shadowColor = UIColor.black.cgColor
        correctionView.layer.shadowOffset = CGSize.zero
        correctionView.generateOuterShadow()
        viewThisCorrectionButton.roundedButton()
    }
    
    func configureCell(_ correction: Correction) {
        self.correction = correction
        viewThisCorrectionButton.setTitle(NSLocalizedString("View This Correction", comment: ""), for: .normal)
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
