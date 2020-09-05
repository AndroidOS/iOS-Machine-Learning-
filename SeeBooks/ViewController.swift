//
//  ViewController.swift
//  SeeBooks
//
//  Created by Manuel Carvalho on 5/9/20.
//  Copyright © 2020 Manuel Carvalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
      
    }

    @IBAction func btnGetPhoto(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
}

