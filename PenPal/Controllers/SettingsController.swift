//
//  SettingsController.swift
//  PenPal
//
//  Created by Will Cohen on 7/26/17.
//  Copyright © 2017 Will Cohen. All rights reserved.
//

import UIKit
import Firebase


class SettingsController: UIViewController {

    @IBOutlet weak var editMyFourThingsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var myLanguagesCollectionView: UICollectionView!
    
    @IBOutlet weak var lowerSettingsView: ShadowView!

    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettingsView()
        myLanguagesCollectionView.delegate = self
        myLanguagesCollectionView.dataSource = self
        FirebaseService.loadSettingsProfilePicture(imageURL: User.sharedInstance.imageUrl) { (profileImage) in
            if (profileImage == UIImage(named: "AddProfileImageIcon")) {
                self.profilePictureButton.setImage(UIImage(named: "AddProfileImageIcon"), for: .normal)
                self.profilePictureButton.layer.borderColor = UIColor.black.cgColor
                self.profilePictureButton.layer.borderWidth = 0.5
                self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.frame.size.height / 2
            } else {
                self.profilePictureButton.maskCircle(anyImage: profileImage)
                self.profilePictureButton.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
    }
    
    @IBAction func editMyFourThingsButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func profilePictureButtonPressed(_ sender: Any) {
        let pickerController =  UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
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
            cell.languageButton.setTitle(language, for: .normal)
            return cell
        } else {
            return PickNativeLanguageCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension SettingsController {
    func loadSettingsView() {
        editMyFourThingsButton.layer.borderColor = UIColor.black.cgColor
        editMyFourThingsButton.layer.cornerRadius = editMyFourThingsButton.frame.height / 2
        editMyFourThingsButton.layer.borderWidth = 1.0
        nameLabel.text = User.sharedInstance.name
    }
}