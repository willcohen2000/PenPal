//
//  HomeController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import DropDown

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dropdownMenu: UIButton!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dropDownMenuHoldingView: UIView!
    
    var dropMenuGlobal = DropDown()
    var externalLearners = [ExternalLearner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        dropMenuGlobal.anchorView = dropDownMenuHoldingView
        dropDownMenuHoldingView.isHidden = true
        dropMenuGlobal.dataSource = ["French", "English", "Italian", "Spanish", "Korean"]
       
        dropMenuGlobal.selectionAction = { [unowned self] (index: Int, selectedLanguage: String) in
            self.targetLanguageLabel.text = selectedLanguage
        }
        
    }
    
    @IBAction func dropdownMenuButtonPressed(_ sender: Any) {
        dropMenuGlobal.show()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = homeTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.homeCell) as? ExternalLearnerCell {
            return cell
        } else {
            return ExternalLearnerCell()
        }
    }

}


