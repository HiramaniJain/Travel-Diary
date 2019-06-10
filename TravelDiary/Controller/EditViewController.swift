//
//  EditViewController.swift
//  TravelDiary
//
//  Created by Heeral on 5/29/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import MapKit

class EditViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var descriptionLocation: UITextView!
    
    var location:Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLocation.delegate = self as? UITextViewDelegate
        name.delegate = self as? UITextFieldDelegate
        
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.borderWidth = 2.0
        descriptionLocation.layer.borderColor = UIColor.white.cgColor
        descriptionLocation.layer.borderWidth = 2.0
        
        name.text = location.name
        descriptionLocation.text = location.descriptionLocation
        
        // Adding location in MapView Annotation
        let annotation = MKPointAnnotation()
        let latitude = Double(location.latitude!)!
        let longitude = Double(location.longitude!)!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(annotation)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        location.name = name.text
        location.descriptionLocation = descriptionLocation.text
        DataController.shared().save()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        showDeleteAlert(title:"Delete", message: "Do you want to delete the location?")
    }
    
    // Preparing next view by passing location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LocationDetailsViewController {
            let locationDetailsViewController = segue.destination as! LocationDetailsViewController
            locationDetailsViewController.location = location
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
    
    // MARK: Helper methods for actions
    private func showDeleteAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "DELETE", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            DataController.shared().delete(location: self.location)
            self.performSegue(withIdentifier: "showMapAfterDelete", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
