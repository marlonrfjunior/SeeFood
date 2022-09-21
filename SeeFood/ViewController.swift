//
//  ViewController.swift
//  SeeFood
//
//  Created by Marlon Junior on 19/09/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    

}
// MARK: - UIImageControllerDelegate methods
extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            let corImage = CIImage(image: userPickedImage)
            
        }
        imagePicker.dismiss(animated: true)
    }
}
