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
    var capturedBreed: String = ""
    var pets: [Pet]?
    
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
                    self.capturedBreed = firstObservation.identifier.replacingOccurrences(of: "_", with: "+")
                    print(id)
                } else {
                    self.descriptionLabel.text = "No breed found"
                    self.capturedBreed = "NA"
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    
    func getPets(completion: @escaping ([Pet]?, Error?) -> ()) {
        //let urlString = "http://api.petfinder.com/pet.find?key=369f2db448e6c1fc647834d2dd7debdc&location=ga&animal=dog&count=50&format=json&breed=American+Bulldog"
        if (self.capturedBreed == "NA") {
            return
        }
        let urlString = "http://api.petfinder.com/pet.find?key=369f2db448e6c1fc647834d2dd7debdc&location=" + self.stateStr + "&animal=dog&count=50&format=json&breed=" + self.capturedBreed
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            //guard data != nil else { return }
            
            guard let data = data else { return }
            //let dataAsString = String(data: data, encoding: .utf8)
            //print(dataAsString!)
            
            do {
                let dogData = try JSONDecoder().decode(Response.self, from: data)
                if let petData = dogData.petfinder?.pets?.pet {
                    print("pet data found")
                    DispatchQueue.main.async {
                        completion(petData, nil)
                    }
                }
                
            } catch let jsonErr {
                completion(nil, error)
                print("Error: ", jsonErr)
            }
            
        }.resume()
    }
    
    
    @IBAction func captureButton(_ sender: UIButton) {
        
        let group = DispatchGroup()
        group.enter()
        getPets { (petArr, err) in
            DispatchQueue.main.async {
                self.pets = petArr
                group.leave()
            }
        }
        
        
        group.notify(queue: .main) {
            self.performSegue(withIdentifier: "showPetCells", sender: self)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let breed = capturedBreed
        if let tableViewController = segue.destination as? TableViewController {
            tableViewController.pets = self.pets
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

