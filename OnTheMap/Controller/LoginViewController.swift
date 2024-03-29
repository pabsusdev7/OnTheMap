//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Pablo Albuja on 7/19/19.
//  Copyright © 2019 Ingenuity Applications. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var pwdTextView: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func performLogin(_ sender: Any) {
        
        guard let email = emailTextView.text, let password = pwdTextView.text else {
            NotificationUtils.showErrorMessage(message: "Please enter your credentials", action: "OK", vc: self)
            return
        }
        setLoggingIn(true)
        UdacityOTMClient.login(username: email, password: password, completion: handleSessionResponse(response:error:))
        
        
    }
    
    func handleSessionResponse(response: Bool?, error: Error?){
        setLoggingIn(false)
        if response!{
            print("Session: "+UdacityOTMClient.Auth.sessionId)
            emailTextView.text = ""
            pwdTextView.text = ""
            performSegue(withIdentifier: "completeLogin", sender: nil)
            
        }else{
            NotificationUtils.showErrorMessage(message: error?.localizedDescription ?? "Error logging in", action: "OK", vc: self)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        if loggingIn{
            loadingIndicator.startAnimating()
        }else{
            loadingIndicator.stopAnimating()
        }
        
        emailTextView.isEnabled = !loggingIn
        pwdTextView.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(UdacityOTMClient.Endpoints.signUp.url)
    }
    

}
