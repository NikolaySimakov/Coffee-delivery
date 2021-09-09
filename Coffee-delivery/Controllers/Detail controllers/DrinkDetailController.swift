//
//  DetailController.swift
//  Coffee-delivery
//
//  Created by User on 20/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addToCart(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("something")
        }
    }
    
    
    var _image = UIImage()
    var _title = String()
    var _description = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 10
        self.imageView.image = _image
        self.titleLabel.text = _title
    }

}
