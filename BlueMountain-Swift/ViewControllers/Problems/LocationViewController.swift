//
//  LocationViewController.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/25/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import MapKit

protocol UserLocationDelegate : class {
    func didSelectLocation(_ locationCord : CLLocationCoordinate2D)
}

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var okButton: UIButton!
    
    let locationManager = CLLocationManager()
    let userAnnotation = MKPointAnnotation()
    weak var userLocationDelegate : UserLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.okButton.isEnabled = false
        self.okButton.alpha = 0.5
        
        self.locationManager.delegate = self as CLLocationManagerDelegate
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self as? MKMapViewDelegate
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(_:)))
        longPressGesture.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapView.showsUserLocation = false
        self.locationManager.stopUpdatingLocation()
    }
    
    
}




// MARK: - CLLocationManagerDelegate functions
extension LocationViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationManager.stopUpdatingLocation()
        
        let userLocation = locations[locations.count - 1]
        
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        region.span = MKCoordinateSpanMake(0.2, 0.2)
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to get  location \(error.localizedDescription)")
    }
}

// MARK: - Add User Annotation
extension LocationViewController{
    
    func addAnnotation(_ gesture : UIGestureRecognizer){
        
        if (gesture.state != UIGestureRecognizerState.ended) {
            return;
        }
        let touchPoint = gesture.location(in: self.mapView)
        let mapCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        self.userAnnotation.coordinate = mapCoordinate
        self.mapView.addAnnotation(userAnnotation)
        self.okButton.isEnabled = true
        self.okButton.alpha = 1.0
    }
}


// MARK: - Button Handlers
extension LocationViewController {
    
    @IBAction func OKButtonPressed(_ sender: UIButton) {
        self.userLocationDelegate?.didSelectLocation(userAnnotation.coordinate)
        self.dismiss(animated: true) { 
            self.mapView = nil
        }
    }
    
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            self.mapView = nil
        }
    }
}
