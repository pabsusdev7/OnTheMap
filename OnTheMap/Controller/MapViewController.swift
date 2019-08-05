//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/13/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StudentLocationModel.studentLocations.isEmpty {
            retrieveLocations()
        }
    }
    
    func retrieveLocations(){
        
        UdacityOTMClient.getStudentLocations(limit: 100, orderBy: "updatedAt", asc: false, completion: handleStudentLocationsResponse(locations:error:))
        
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?){
        
        guard !locations.isEmpty else {
            print(error?.localizedDescription ?? "")
            return
        }
        StudentLocationModel.studentLocations = locations
        for location in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
        //self.mapView.reloadInputViews()
        
    }
    
    
    @IBAction func refreshMap(_ sender: Any) {
        retrieveLocations()
    }
    
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Tapped pin!")
        if control == view.rightCalloutAccessoryView {
            if let toOpen = URL(string: view.annotation?.subtitle! ?? "") {
                //app.openURL(URL(string: toOpen)!)
                UIApplication.shared.open(toOpen)
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        UdacityOTMClient.logout(completion: {(response, error)
            in
            if response{
                NotificationUtils.showSuccessMessage(message: "You are now logged out!", action: "OK", vc: self, dismissParent: true)
                //self.performSegue(withIdentifier: "logoutFromMap", sender: nil)
            }else{
                NotificationUtils.showErrorMessage(message: "Error logging you out!", action: "OK", vc: self)
            }
        })
        
    }
    
    
}

