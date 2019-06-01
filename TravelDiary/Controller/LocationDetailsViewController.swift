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
    }
    
    // Preparing Location details view by setting location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditViewController {
            let editViewController = segue.destination as! EditViewController
            editViewController.location = location
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
}
