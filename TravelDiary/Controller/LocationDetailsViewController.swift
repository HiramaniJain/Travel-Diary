//
//  LocationDetailsViewController.swift
//  TravelDiary
//
//  Created by Heeral on 5/29/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import MapKit

class LocationDetailsViewController: UIViewController, MKMapViewDelegate {
   
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var showDescription: UITextView!
    
    var location:Location!
    var isEditingLocation:Bool!
    var actIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.borderWidth = 2.0
        showDescription.layer.borderColor = UIColor.white.cgColor
        showDescription.layer.borderWidth = 2.0
        name.text = location.name
        showDescription.text = location.descriptionLocation
        showDescription.isEditable = false
        showDescription.isSelectable = false
        
        // Adding location in MapView Annotation
        let annotation = MKPointAnnotation()
        let latitude = Double(location.latitude!)!
        let longitude = Double(location.longitude!)!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(annotation)
        
        //Fetch nerby restaurants in the background
        fectchNearbyRestaurants(latitude: latitude, longitude: longitude)
        
        // Check for nearby restaurants alert
        showExploreAlert(latitude: latitude, longitude: longitude)
    }
    
    // MARK: Helper methods for actions
    func showExploreAlert(latitude: Double, longitude: Double) {
        let alert = UIAlertController(title: nil, message: "Explore nearby Restaurants!!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.showActivityIndicatory()
            self.performSegue(withIdentifier: "showRestaurantsFromSavedPin", sender: self)
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
    
    // Preparing Location details view by setting location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditViewController {
            let editViewController = segue.destination as! EditViewController
            editViewController.location = location
        }
        actIndicator.stopAnimating()
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
