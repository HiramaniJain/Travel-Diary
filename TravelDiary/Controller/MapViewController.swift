//
//  MapViewController.swift
//  TravelDiary
//
//  Created by Heeral on 5/29/19.
//  Copyright © 2019 heeral. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import GoogleSignIn

class MapViewController: UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTitle: UINavigationItem!
    
    var locations: [Location]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapTitle.title = DataController.shared().getTitle()
        
        locations = fetchAllLocation()
        showLocation(locations: locations)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        locations = fetchAllLocation()
        showLocation(locations: locations)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locations.removeAll()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        
        var rootVC : UIViewController?
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! ViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
    // Preparing Location details view by setting location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LocationDetailsViewController {
            guard let location = sender as? Location else {
                return
            }
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
    
    // Adding action on selected pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        
        mapView.deselectAnnotation(annotation, animated: true)
        print("\(#function) lat \(annotation.coordinate.latitude) lon \(annotation.coordinate.longitude)")
        let latitude = String(annotation.coordinate.latitude)
        let longitude = String(annotation.coordinate.longitude)
        if let location = fetchLocation(latitude: latitude, longitude: longitude) {
            performSegue(withIdentifier: "showLocationDetailsFromMapView", sender: location)
        }
    }
}

extension MapViewController {
    
    func fetchAllLocation() -> [Location]? {
        var locations: [Location]?
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        if let result = try? DataController.shared().viewContext.fetch(fetchRequest) {
            locations = result
        }
        
        return locations
    }
    
    // adding location in map view
    func showLocation(locations: [Location]) {
        if locations.isEmpty {
            print("No Locations found")
        }
        
        for location in locations where location.latitude != nil && location.longitude != nil {
            let annotation = MKPointAnnotation()
            let latitude = Double(location.latitude!)!
            let longitude = Double(location.longitude!)!
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func fetchLocation(latitude: String, longitude: String) -> Location? {
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        
        guard let location = (try! DataController.shared().viewContext.fetch(fetchRequest)).first else {
            return nil
        }
        return location
    }
}
