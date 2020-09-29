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
    
    @IBOutlet weak var lblPDFbutton: UIBarButtonItem!
    
    @IBOutlet weak var btnShareProp: UIBarButtonItem!
    
    var docInfo = Result(pic: UIImage(named: "Book")!,itemDesc: "")
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []
    
     var text = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        btnShareProp.isEnabled = false
        docInfo.pic = UIImage(named: "Book")!;
        docInfo.itemDesc = "test"
        print("\(docInfo.itemDesc)")
        lblPDFbutton.isEnabled = false
    }
    
    func detect(image: CIImage){ //
    activityIndicator.startAnimating()
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
        self.docInfo.itemDesc = "\(results[0].identifier)"
        DispatchQueue.main.async {
            self.navigationItem.title = "Results"
            self.text="\(results[0].identifier)\n\(results[1].identifier)\n\(results[2].identifier)\n"
            self.lblResult.text = self.text
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.btnShareProp.isEnabled = true
            self.lblPDFbutton.isEnabled = true
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
                   imagePicker.dismiss(animated: true, completion: nil)
                   imageView.image = image
            //docInfo.pic = UIImage(named: "Book")!;
                   //imagePicker.dismiss(animated: true, completion: nil)
                    docInfo.pic = image
                   guard let ciImage = CIImage(image: image) else {
                       fatalError("couldn't convert uiimage to CIImage")
                   }
                    print("detect called")
                    
                   detect(image: ciImage)
               }
        
    }//
    
    @IBAction func btnGetPhoto(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func btnShare(_ sender: UIBarButtonItem) {
        print("Share Button pressed")
       
                 // set up activity view controller
                 let textToShare = [ text ]
                 let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                 activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
                 self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnPDF(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showPDF", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPDF") {
            //print("\(docInfo?.itemDesc)")
           print("showPDF Segue")
            
            if let pdfViewController = segue.destination as? PDFViewController {
                pdfViewController.docInfo = docInfo
                   }
            
        }
    }
}


