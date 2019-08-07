//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/22/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {

    var location: MKPointAnnotation!
    var selectedStudentLocation: StudentLocation!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let location = location {
            mapView.addAnnotation(location)
            var region: MKCoordinateRegion = mapView.region
            region.center.latitude = location.coordinate.latitude
            region.center.longitude = location.coordinate.longitude
            region.span.latitudeDelta = 0.05
            region.span.longitudeDelta = 0.05
            mapView.setRegion(region, animated: true)
            
            UdacityOTMClient.getUserInfo(completion: {(response, error)
                in
                if let user = response{
                    StudentLocationModel.selectedStudentLocation = StudentLocation(objectId:  StudentLocationModel.selectedStudentLocation != nil ? (StudentLocationModel.selectedStudentLocation.objectId ?? "") : "", uniqueKey: UUID().uuidString, firstName: user.firstName, lastName: user.lastName, mapString: location.title ?? "", mediaURL: location.subtitle ?? "", latitude:  Float(location.coordinate.latitude) , longitude: Float(location.coordinate.longitude) , createdAt: "", updatedAt: "")
                }else{
                    NotificationUtils.showErrorMessage(message: "User information invalid. Cannot process request.", action: "OK", vc: self, dismissParent: true)
                }
            })
            
            
        }
        
        
        
    }

    @IBAction func postLocation(_ sender: Any) {
        
        if let studentLocation = StudentLocationModel.selectedStudentLocation {
            UdacityOTMClient.postLocation(studentLocation: studentLocation, completion: {(response, error)
                in
                if response! {
                    NotificationUtils.showSuccessMessage(message: "Location added successfuly", action: "OK", vc: self, dismissParent: true)
                }else{
                    NotificationUtils.showErrorMessage(message: "There was en error adding the location. Please, try again later.", action: "OK", vc: self, dismissParent: true)
                }
                
            })
        }
        
    }
}
