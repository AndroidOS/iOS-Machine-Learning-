//
//  ViewController.swift
//  SeeBooks
//
//  Created by Manuel Carvalho on 5/9/20.
//  Copyright © 2020 Manuel Carvalho. All rights reserved.
//  Bases on Angela Yu's code

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
                   
                   imageView.image = image
                   imagePicker.dismiss(animated: true, completion: nil)
                   guard let ciImage = CIImage(image: image) else {
                       fatalError("couldn't convert uiimage to CIImage")
                   }
                   
               }
        
    }

    @IBAction func btnGetPhoto(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    

}

