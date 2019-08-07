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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let addLocationMapVC = segue.destination as! AddLocationMapViewController
            addLocationMapVC.location = annotation
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        if let setLocation = location.text, let setURL = url.text, !setLocation.isEmpty, !setURL.isEmpty {
            
            let url = URL(string: setURL)
            
            if let url = url, UIApplication.shared.canOpenURL(url){
                setGeocoding(true)
                CLGeocoder().geocodeAddressString(setLocation, completionHandler: {(placeMarks, error)
                    in
                    self.setGeocoding(false)
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
    
    func setGeocoding(_ geocoding: Bool){
        if geocoding{
            loadingIndicator.startAnimating()
        }else{
            loadingIndicator.stopAnimating()
        }
        
        location.isEnabled = !geocoding
        url.isEnabled = !geocoding
        findLocationButton.isEnabled = !geocoding
    }
    

}
