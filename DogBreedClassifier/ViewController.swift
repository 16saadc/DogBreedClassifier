//
//  ViewController.swift
//  DogBreedClassifier
//
//  Created by Chris Saad on 6/13/18.
//  Copyright © 2018 Chris Saad. All rights reserved.
//

import UIKit
import AVKit
import Vision
import MapKit
import CoreLocation




class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var cityStr: String = ""
    var stateStr: String = ""
    @IBOutlet weak var descriptionLabel: UILabel!
    let confidence: Float = 0.7
    
    @IBOutlet weak var cameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let outputPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(outputPreviewLayer)
        outputPreviewLayer.frame = cameraView.frame
        //camera data output monitor
        let camOutput = AVCaptureVideoDataOutput()
        camOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(camOutput)
        self.descriptionLabel.text = "No breed found"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.locality {
                self.cityStr = city.lowercased()
            }
            if let state = placeMark.administrativeArea {
                self.stateStr = state.lowercased()
            }
        })
    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let model = try? VNCoreMLModel(for: DogBreeds().model) else {return}
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            let id = firstObservation.identifier.replacingOccurrences(of: "_", with: " ")
            DispatchQueue.main.async {
                if (firstObservation.confidence > self.confidence) {
                    self.descriptionLabel.text = "\(id)"
                    print(id)
                } else {
                    self.descriptionLabel.text = "No breed found"
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    @IBAction func captureButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showPetCells", sender: self)
    
        /**
        // capture what is in the label
        var splitName = self.descriptionLabel.text!.components(separatedBy: " ")
        if (splitName.count == 3) {
            if let url = URL(string: "https://www.petfinder.com/search/dogs-for-adoption/us/" + stateStr + "/" + cityStr + "/?breed%5B0%5D=" + splitName[0] + "+" + splitName[1] + "+" + splitName[2] + "&sort%5B0%5D=recently_added") {
                UIApplication.shared.open(url, options: [:])
            }
        } else if (splitName.count == 2) {
            if let url = URL(string: "https://www.petfinder.com/search/dogs-for-adoption/us/" + stateStr + "/" + cityStr + "/?breed%5B0%5D=" + splitName[0] + "+" + splitName[1] + "&sort%5B0%5D=recently_added") {
                UIApplication.shared.open(url, options: [:])
            }
        } else {
            if let url = URL(string: "https://www.petfinder.com/search/dogs-for-adoption/us/" + stateStr + "/" + cityStr + "/?breed%5B0%5D=" + splitName[0] + "&sort%5B0%5D=recently_added") {
                UIApplication.shared.open(url, options: [:])
            }
        }
 */

        let urlString = "http://api.petfinder.com/pet.find?key=369f2db448e6c1fc647834d2dd7debdc&location=GA&animal=dog&count=3&format=json"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard data != nil else { return }
            
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print(dataAsString!)
            
            do {
                let dogData = try JSONDecoder().decode(Response.self, from: data)
                for pet in (dogData.petfinder?.pets?.pet)! {
                    print(pet.name!["$t"] ?? "no pet found")
                }

            } catch let jsonErr {
                print("Error: ", jsonErr)
            }
            
            
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

