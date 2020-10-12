//
//  MapViewController.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import Firebase
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var pubType: String!
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var lastAnnotation: MKAnnotation?
    var lastLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 50000
    
    @IBAction func addPinToFireBase(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "MyForm") as? PopViewController
        vc!.location = self.lastLocation
        navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        self.mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        fetchPubs()
    }
    func fetchPubs(){
        var pubs = [Pub]()
        Database.database().reference(withPath: "pubs").observe(.value) { snapshot in
            for ses in snapshot.children.allObjects as![DataSnapshot] {
                // parsing the data
                if let dictionary = ses.value as? [String: AnyObject] {
                    if (dictionary["lat"] == nil || dictionary["lon"] == nil || dictionary["type"] == nil){
                        continue
                    }
                    let lat = dictionary["lat"] as? Double
                    let lon = dictionary["lon"] as? Double
                    if (lat == nil || lon == nil){
                        continue
                    }
                    let pub = Pub(name: ses.key, type: dictionary["type"] as! String, lat: lat!, lon: lon!)
                    pubs.append(pub)
                }
            }
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.loadPins(pubs: pubs)
                }
            }
        }
    }
    
    func loadPins(pubs: [Pub]){
        for pub in pubs {
            let location = CLLocationCoordinate2D(latitude: pub.lat, longitude: pub.lon)
            let annotation = CustomPointAnnotation()
            annotation.coordinate = location
            annotation.title = pub.name
            annotation.subtitle = pub.type
            annotation.pubType = pub.type
            self.mapView.addAnnotation(annotation)
        }
    }
    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    func addAnnotation(location: CLLocationCoordinate2D){
        if self.lastAnnotation != nil {
            self.mapView.removeAnnotation(self.lastAnnotation!)
            self.lastAnnotation = nil
        }
        let annotation = CustomPointAnnotation()
        annotation.coordinate = location
        annotation.title = "New location"
        annotation.subtitle = "To add pub at location click `Add` button"
        annotation.pubType = "potential"
        self.mapView.addAnnotation(annotation)
        self.lastLocation = location
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         if !(annotation is CustomPointAnnotation) {
             return nil
         }
         let reuseId = "test"
         var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
         if anView == nil {
             anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
             anView!.canShowCallout = true
         }
         else {
             anView!.annotation = annotation
         }

         let cpa = annotation as! CustomPointAnnotation
         if(cpa.pubType == "pub" || cpa.pubType == "Pub"){
             anView!.image = UIImage(named: "tack")
         } else if (cpa.pubType == "potential") {
             anView!.image = UIImage(named: "pushpin")
            self.lastAnnotation = annotation
         } else {
             anView!.image = UIImage(named: "tack")
         }
         return anView
     }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        print("Center")
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

}

extension MapViewController: CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
