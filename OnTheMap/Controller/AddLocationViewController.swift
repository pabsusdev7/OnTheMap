//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/22/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    var selectedLocation: StudentLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation"{
            let addLocationMapVC = segue.destination as! AddLocationMapViewController
            addLocationMapVC.location = selectedLocation
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        //TODO: Validate fields and perform segue
        
    }
    

}
