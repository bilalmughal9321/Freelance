//
//  MapVC.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Current Location"
        checkLocationPermissions()
        addMarkerAtSpecificLocation(latitude: 25.256332308, longitude: 55.308665432)
    }
    
    // MARK: - Location Permissions
    private func checkLocationPermissions() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            showLocationAccessAlert()
        @unknown default:
            break
        }
    }
    
    private func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func showLocationAccessAlert() {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location access in Settings to view your current location.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Add Marker (Annotation)
    private func addMarkerAtSpecificLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "National Bank of Dubai" // Marker title
        annotation.subtitle = "National Bank of Dubai (NBD) (Arabic: بنك دبي الوطني‎) is a building in Dubai, United Arab Emirates (UAE)." // Optional subtitle
        mapView.addAnnotation(annotation)
        
        // Set region to center map around the marker
        let region = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation() // Stop after getting the location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            showLocationAccessAlert()
        }
    }
}
