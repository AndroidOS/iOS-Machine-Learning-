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
    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
      
    }
    
    func detect(image: CIImage){ //
    
    guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
        fatalError("can't load ML model")
    }
    print("model loaded")
        
    let request = VNCoreMLRequest(model: model) { request, error in
        guard let results = request.results as? [VNClassificationObservation],
            let topResult = results.first
            else {
                fatalError("unexpected result type from VNCoreMLRequest")
        }
        
       print("\(topResult)")
            print("detect ")
            self.classificationResults = results
        DispatchQueue.main.async {
            self.navigationItem.title = "Results"
            self.lblResult.text = "\(results[0].identifier)\n\(results[1].identifier)\n\(results[2].identifier)\n"

        }
      
    }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
       
            print("\(self.classificationResults)")
        
    }//

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
                   
                   imageView.image = image
                   //imagePicker.dismiss(animated: true, completion: nil)
                   guard let ciImage = CIImage(image: image) else {
                       fatalError("couldn't convert uiimage to CIImage")
                   }
                    print("detect called")
                    imagePicker.dismiss(animated: true, completion: nil)
                   detect(image: ciImage)
               }
        
    }//
    
    @IBAction func btnGetPhoto(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    

}


