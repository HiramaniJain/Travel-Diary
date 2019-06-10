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
    var actIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLocation.delegate = self as? UITextViewDelegate
        name.delegate = self as? UITextFieldDelegate
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if currentLocation == nil {
             showAccessAlert(message: "Please allow to access your location")
            return
        }
        
        if let _ = fetchLocation(latitude: String(currentLocation.latitude), longitude: String(currentLocation.longitude)) {
            print("Location already exists")
            showSaveAlert(message: "Location already exists")
        } else {
            let location = Location(context: DataController.shared().viewContext)
            location.latitude = String(currentLocation.latitude)
            location.longitude = String(currentLocation.longitude)
            location.name = name.text
            location.descriptionLocation = descriptionLocation.text
            location.date = Date()
            DataController.shared().save()
            
            showExploreAlert(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        actIndicator.stopAnimating()
    }
    
    // MARK: Helper methods for actions
    func showExploreAlert(latitude: Double, longitude: Double) {
        let alert = UIAlertController(title: nil, message: "Explore nearby Restaurants!!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.showActivityIndicatory()
            self.performSegue(withIdentifier: "showRestaurants", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func completionHandler(success: Bool, error: Error?) {
        if success {
            print("successfull")
        } else {
            let alertVC = UIAlertController(title: "Failed to get nearby Restaurants", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            show(alertVC, sender: nil)
        }
    }
    
    func fectchNearbyRestaurants(latitude:Double, longitude: Double) {
        ExploreNearByRestaurants().exploreRestaurants(latitude: latitude, longitude: longitude, completion: self.completionHandler(success:error:))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            print("Location not found")
            return
        }

        print("locations = \(currentLocation.latitude) \(currentLocation.longitude)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation
        mapView.addAnnotation(annotation)
        
        //Fetch nerby restaurants in the background
        fectchNearbyRestaurants(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
    }
    
    // MARK: Helper methods for actions
    private func showSaveAlert(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Helper methods for actions
    private func showAccessAlert(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            //Redirect to settings page
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(action) in
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
    
    func showActivityIndicatory() {
        actIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actIndicator.center = view.center
        actIndicator.hidesWhenStopped = true
        actIndicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(actIndicator)
        actIndicator.startAnimating()
    }
}
