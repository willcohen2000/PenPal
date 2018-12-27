//
//  SettingsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import SwiftyShadow

class SettingsController: UIViewController {

    @IBOutlet weak var editMyFourThingsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var myLanguagesCollectionView: UICollectionView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var lowerSettingsView: UIView!
    @IBOutlet weak var editMyFourThingsToTalkAboutLabel: UILabel!
    @IBOutlet weak var languagesImLearningLabel: UILabel!
    @IBOutlet weak var upperSettingsView: UIView!
    
    var selectedImage: UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        myLanguagesCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRoundedShadow(view: upperSettingsView)
        addRoundedShadow(view: lowerSettingsView)
        localize()
        loadSettingsView()
        myLanguagesCollectionView.delegate = self
        myLanguagesCollectionView.dataSource = self
        if (User.sharedInstance.imageUrl) != nil {
            FirebaseService.loadSettingsProfilePicture(imageURL: User.sharedInstance.imageUrl) { (profileImage) in
                if (profileImage == UIImage(named: "AddProfileImageIcon")) {
                    self.profilePictureButton.setImage(UIImage(named: "AddProfileImageIcon"), for: .normal)
                    self.profilePictureButton.layer.borderColor = UIColor.black.cgColor
                    self.profilePictureButton.layer.borderWidth = 0.5
                    self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.frame.size.height / 2
                } else {
                    if let profileImage = profileImage {
                        self.profilePictureButton.maskCircle(anyImage: profileImage)
                        self.profilePictureButton.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        self.profilePictureButton.maskCircle(anyImage: UIImage(named: "AddProfileImageIcon")!)
                        self.profilePictureButton.layer.borderColor = UIColor.clear.cgColor
                    }
                }
            }
        } else {
            self.profilePictureButton.maskCircle(anyImage: UIImage(named: "AddProfileImageIcon")!)
            self.profilePictureButton.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
    private func addRoundedShadow(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.generateOuterShadow()
    }
    
    private func loadSettingsView() {
        self.profilePictureButton.setImage(UIImage(named: "User"), for: .normal)
        
        editMyFourThingsButton.layer.borderColor = Colors.primaryPurple.cgColor
        editMyFourThingsButton.layer.cornerRadius = editMyFourThingsButton.frame.height / 2
        editMyFourThingsButton.layer.borderWidth = 1.0
        
        signOutButton.roundedButton()
        
        nameLabel.text = User.sharedInstance.name
    }
    
    @IBAction func profilePictureButtonPressed(_ sender: Any) {
        let pickerController =  UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let logOutAlert = UIAlertController(title: NSLocalizedString("Are you sure you want to log out?", comment: "Are you sure you want to log out?"), message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        logOutAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.default,handler: nil))
        logOutAlert.addAction(UIAlertAction(title: NSLocalizedString("Sign Me Out", comment: "Sign Me Out"), style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            let _ = KeychainWrapper.standard.removeObject(forKey: "uid")
            self.performSegue(withIdentifier: Constants.Segues.loggedOutSegue, sender: nil)
        }))
        self.present(logOutAlert, animated: true, completion: nil)
    }
    
    private func localize() {
        editMyFourThingsButton.setTitle(NSLocalizedString("Edit", comment: "Edit"), for: .normal)
        signOutButton.setTitle(NSLocalizedString("Sign Out", comment: "Sign Out/Log Out"), for: .normal)
        editMyFourThingsToTalkAboutLabel.text = NSLocalizedString("Edit my four things to talk about", comment: "Edit my four things to talk about")
        languagesImLearningLabel.text = NSLocalizedString("Languages I am learning", comment: "Languages I'm learning")
    }

}

extension SettingsController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segues.toEditTargetLanguage) {
            if let nextVC = segue.destination as? AddNewTargetLanguageController {
                var languagesDataSource = [String]()
                for (language) in Languages.languages {
                    if (!User.sharedInstance.targetLanguages.contains(language)) {
                        languagesDataSource.append(language)
                    }
                }
                nextVC.targetLanguages = languagesDataSource
            }
        }
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let profileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profilePictureButton.maskCircle(anyImage: profileImage)
            selectedImage = profileImage
        }
        dismiss(animated: true, completion: nil)
        let storageReference = Storage.storage().reference().child("ProfileImages").child(User.sharedInstance.uid)
        if let profileImage = self.selectedImage {
            let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
            storageReference.putData(imageData!, metadata: nil, completion: { (metaData, error) in
                if (error != nil) {
                    return
                } else {
                   Database.database().reference().child("Users").child(User.sharedInstance.uid).child("profileImageUrl").setValue(String(describing: metaData!.downloadURLs![0]))
                    User.sharedInstance.imageUrl = String(describing: metaData!.downloadURLs![0])
                }
            })
        }
    }
}

extension SettingsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.sharedInstance.targetLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let language = User.sharedInstance.targetLanguages[indexPath.row]
        if let cell = myLanguagesCollectionView.dequeueReusableCell(withReuseIdentifier: "myLanguages", for: indexPath) as? MyLanguagesCollectionViewCell {
            cell.languageButton.setTitle(NSLocalizedString(language, comment: ""), for: .normal)
            return cell
        } else {
            return UICollectionViewCell()//PickNativeLanguageCell()
        }
    }
}
