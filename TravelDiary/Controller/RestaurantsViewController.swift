//
//  RestaurantsViewController.swift
//  TravelDiary
//
//  Created by Heeral on 6/1/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import MapKit

class RestaurantsViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        fetchRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        fetchRestaurants()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        restaurants.removeAll()
    }
    
    // adding location in map view
    func fetchRestaurants() {
        if restaurants.isEmpty {
            showAlert(message: "Not able to find any restaurants")
        }
        
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            let latitude = restaurant.latitude
            let longitude = restaurant.longitude
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.address
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
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
    private func showAlert(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
