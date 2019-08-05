//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/22/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController {
    
    let annotation = MKPointAnnotation()
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let addLocationMapVC = segue.destination as! AddLocationMapViewController
            addLocationMapVC.location = annotation
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        //TODO: Validate fields and perform segue
        
        if let setLocation = location.text, let setURL = url.text, !setLocation.isEmpty, !setURL.isEmpty {
            
            let url = URL(string: setURL)
            
            if let url = url, UIApplication.shared.canOpenURL(url){
                CLGeocoder().geocodeAddressString(setLocation, completionHandler: {(placeMarks, error)
                    in
                    if let placeMark = placeMarks?[0] {
                        self.annotation.coordinate = (placeMark.location?.coordinate)!
                        self.annotation.title = setLocation
                        self.annotation.subtitle = setURL
                        
                        self.performSegue(withIdentifier: "findLocation", sender: nil)
                    }else{
                        NotificationUtils.showErrorMessage(message: error?.localizedDescription ?? "", action: "OK", vc: self)
                    }
                })
            }else{
                NotificationUtils.showErrorMessage(message: "Please enter a valid URL", action: "OK", vc: self)
            }
            
        }else{
            NotificationUtils.showErrorMessage(message: "Please enter a value for each field", action: "OK", vc: self)
        }
        
    }
    

}
