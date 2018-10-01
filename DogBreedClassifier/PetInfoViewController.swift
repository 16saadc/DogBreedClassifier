//
//  PetInfoViewController.swift
//  DogBreedClassifier
//
//  Created by Chris Saad on 9/29/18.
//  Copyright © 2018 Chris Saad. All rights reserved.
//

import UIKit

class PetInfoViewController: UIViewController {

    var email: String?
    var petName: String?
    var petDescription: String?
    var petImage: UIImage?
    var petSex: String?
    var phone: String?
    var zip: String?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var petUIImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = petName ?? "no name found"
        petUIImage.image = petImage ?? nil
        sexLabel.text = "Sex: " + (petSex ?? "no sex found")
        emailLabel.text = "Email: " + (email ?? "no email found")
        descriptionLabel.text = (petDescription ?? "no description found")
        phoneLabel.text = "Phone: " + (phone ?? "No phone found")
        zipLabel.text = "Zip Code: " + (zip ?? "Zip code not found")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
