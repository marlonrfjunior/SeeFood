//
//  ViewController.swift
//  SeeFood
//
//  Created by Marlon Junior on 19/09/22.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage


class ViewController: UIViewController, UINavigationControllerDelegate{


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    @IBAction func LibaryTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    

}
// MARK: - UIImageControllerDelegate methods
extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let corImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            detect(image: corImage)
        }
        imagePicker.dismiss(animated: true)
       
    }
}
// MARK: - CoreML functions
extension ViewController {
    func detect(image : CIImage){
        guard let model = try? VNCoreMLModel(for: WhatDogClassifier().model) else{
            fatalError("Loading CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model){(request , error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            if let firstResult = result.first {
               
                let fixUrl = "https://pt.wikipedia.org/w/api.php?"
               
                let parameters : [String : String] = [
                    "format":"json",
                    "action":"query",
                    "prop":"extracts|pageimages",
                    "exintro":"",
                    "explaintext":"",
                    "titles": firstResult.identifier,
                    "indexpageids":"",
                    "redirects":"1",
                    "pithumbsize":"500",
                ]
                
                AF.request(fixUrl, method: .get ,parameters: parameters).responseJSON { (response) in
            
                    let infoData : JSON = JSON(response.value)
                        let pageid =  infoData["query"]["pageids"][0].stringValue
                        let title = infoData["query"]["pages"][pageid]["title"].stringValue
                        let description = infoData["query"]["pages"][pageid]["extract"].stringValue
                    let imageURL = infoData["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                    self.navigationItem.title =  title
                    self.textLabel.text = description
                    self.imageView.sd_setImage(with: URL(string: imageURL))
                }
            }
        }
    let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
        
    }
}

// MARK: - Info Manager Delegate methods
extension ViewController  {
    
    
}




// MARK: - Info Manager Delegate methods
extension ViewController  {
    
//    func fetchInfo ( info : String) -> InfoModel?{
//
//        return result
//    }
    
}



