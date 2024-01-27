//
//  ViewController.swift
//  ImageRecognition
//
//  Created by PavunRaj on 24/01/24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickerImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickerImage
            if let ciImage = CIImage(image: userPickerImage) {
                detectCIIMage(image: ciImage)

            }
        }
        imagePicker.dismiss(animated: true)
        //let model = try? VNCoreMLModel(for: Inceptionv3(configuration: <#T##MLModelConfiguration#>))
    }
    
    func detectCIIMage(image:CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Cound not find the model")
        }
        
        let request = VNCoreMLRequest(model: model) { response, error in
          guard  let result  = response.results as? [VNClassificationObservation] else {
              fatalError("Request error")
            }
            print(result)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try? handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}

