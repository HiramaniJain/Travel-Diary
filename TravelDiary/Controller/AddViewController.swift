//
//  AddViewController.swift
//  TravelDiary
//
//  Created by Heeral on 5/29/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import CoreLocation

class AddViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLocation: UITextView!
    @IBOutlet weak var name: UITextField!
    
    var locationManager: CLLocationManager!
    var currentLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.borderWidth = 2.0
        descriptionLocation.layer.borderColor = UIColor.white.cgColor
        descriptionLocation.layer.borderWidth = 2.0
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let _ = fetchLocation(latitude: String(currentLocation.latitude), longitude: String(currentLocation.longitude)) {
            print("Location already exists")
            showSaveAlert(message: "Location already exists")
            //TODO add alert to show location already exists
        } else {
            let location = Location(context: DataController.shared().viewContext)
            location.latitude = String(currentLocation.latitude)
            location.longitude = String(currentLocation.longitude)
            location.name = name.text
            location.descriptionLocation = descriptionLocation.text
            location.date = Date()
            DataController.shared().save()
        }
    }
    
    // Using to show locations on the map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .orange
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //getting current location from location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location?.coordinate
        
        if currentLocation == nil {
            print("Could not find location")
            return
        }

        print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation
        mapView.addAnnotation(annotation)
    }
    
    // MARK: Helper methods for actions
    private func showSaveAlert(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddViewController {
    
    func fetchLocation(latitude: String, longitude: String) -> Location? {
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        
        guard let location = (try! DataController.shared().viewContext.fetch(fetchRequest)).first else {
            return nil
        }
        return location
    }
}
