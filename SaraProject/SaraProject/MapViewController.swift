//
//  MapViewController.swift
//  ARproject
//
//  Created by Sara Alkatheeri on 19/04/2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location permissions
        locationManager.requestWhenInUseAuthorization()
        
        // Set delegate
        locationManager.delegate = self
        
        // Start updating location
        locationManager.startUpdatingLocation()
        
        // Show user's current location on map
        mapView.showsUserLocation = true
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func zoom(_ sender: Any) {
        
        if let currentPos = mapView.userLocation.location?.coordinate{
            let region = MKCoordinateRegion(center: currentPos, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    
    
    @IBAction func mapType(_ sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        } else {
            mapView.mapType = .satellite
        }
        
    }
    
    @IBAction func addAnnotation(_ sender: UILongPressGestureRecognizer) {
        
        let pressedPoint = sender.location(in: mapView)
        let location = mapView.convert(pressedPoint, toCoordinateFrom: mapView)
        
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "I want to go here"
        
        mapView.addAnnotation(annotation)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
//        mapView.removeAnnotations(mapView.annotations)
        
        addCustomAnnotation(lat: location.coordinate.latitude, long: location.coordinate.longitude, title: "Current Location")
        addCustomAnnotation(lat: 48.8606, long: 2.3376, title: "Mona Lisa Painting")
        
        // Zoom to user's current location
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
//        mapView.setRegion(region, animated: true)
    }
    
    func setRegion(annotation: MKPointAnnotation) {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 15000000, longitudinalMeters: 15000000)
        mapView.setRegion(region, animated: true)
    }
    
    func addCustomAnnotation(lat: Double, long: Double, title: String) {
            let latitude = lat
            let longitude = long
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = title
            annotation.subtitle = ""
            mapView.addAnnotation(annotation)
        }
    
}
