//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/20/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    @IBOutlet var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if StudentLocationModel.studentLocations.isEmpty {
            retrieveLocations()
        }
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?){
        
        guard !locations.isEmpty else {
            print(error?.localizedDescription ?? "")
            return
        }
        StudentLocationModel.studentLocations = locations
        
        locationsTableView.reloadData()
        
    }
    
    func retrieveLocations(){
        
        UdacityOTMClient.getStudentLocations(limit: 100, orderBy: "updatedAt", asc: false, completion: handleStudentLocationsResponse(locations:error:))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationsTableView.reloadData()
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        retrieveLocations()
    }
    

}

extension ListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationModel.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: "ListViewCell")!
        let location = StudentLocationModel.studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = StudentLocationModel.studentLocations[indexPath.row]
        
        if let toOpen = URL(string: location.mediaURL) {
            UIApplication.shared.open(toOpen)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
}
