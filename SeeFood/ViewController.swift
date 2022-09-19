//
//  ViewController.swift
//  SeeFood
//
//  Created by Marlon Junior on 19/09/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
    }
    

}
extension ViewController: UIImagePickerControllerDelegate{
    
}
extension ViewController: UINavigationControllerDelegate{
    
}
