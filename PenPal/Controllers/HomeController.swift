//
//  HomeController.swift
//  PenPal
//
//  Created by Will Cohen on 7/13/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import AZDropdownMenu

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dropdownMenu: UIButton!
    @IBOutlet weak var targetLanguageLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    
    var dropMenuGlobal: AZDropdownMenu!
    
    var externalLearners = [ExternalLearner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        let options = ["French","English","Italian","Japanese"]
        let menu = AZDropdownMenu(titles: options)
        self.dropMenuGlobal = menu
        
        menu.cellTapHandler = { [weak self] (indexPath: IndexPath) -> Void in
            self?.targetLanguageLabel.text = options[indexPath.row]
        }
        
    }
    
    @IBAction func dropdownMenuButtonPressed(_ sender: Any) {
        dropMenu(menu: dropMenuGlobal)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.homeCell, for: indexPath)
        //let row = indexPath.row
       // cell.textLabel?.text = externalLearners[row]
        
        return cell
    }

}

extension HomeController {
    func dropMenu(menu: AZDropdownMenu) {
        if (menu.isDescendant(of: self.view) == true) {
            menu.hideMenu()
        } else {
            menu.showMenuFromView(self.view)
        }
    }
}

