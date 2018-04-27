//
//  ViewController.swift
//  OCRwithTesseract
//
//  Created by Bernardo Sarto de Lucena on 4/27/18.
//  Copyright © 2018 Bernardo Sarto de Lucena. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {
    
    lazy var ocrRequest: VNCoreMLRequest = {
        do {
            //THIS MODEL IS TRAINED BY ME FOR FONT "Inconsolata" (Numbers 0...9 and UpperCase Characters A..Z)
            let model = try VNCoreMLModel(for:OCR().model)
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError("cannot load model")
        }
    }()

    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation]
            else { fatalError("Unexpected result!") }
        guard let best = observations.first
            else { fatalError("Can't get best resutl!") }
        
        // on main queue
        DispatchQueue.main.async {
            // best.identifier is our prediction with highest confidence
            print ("Recognized \(best.identifier)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // lets load an image from resource
        let ourFirstImage: UIImage = UIImage(named: "7")!
        
        // we need an ciimage - no need to scale
        let ourInput: CIImage = CIImage(image: ourFirstImage)!
        
        // prepare the handler
        let handler = VNImageRequestHandler(ciImage: ourInput, options: [:])
        
        // some options
        self.ocrRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        
        // feed to the queue
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([self.ocrRequest])
            } catch {
                print("Error")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

