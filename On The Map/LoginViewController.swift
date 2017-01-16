//
//  LoginViewController.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/12.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorText: UILabel!
    
    func setUIEnabled(_ enabled: Bool) {
        emailText.isEnabled = enabled
        passwordText.isEnabled = enabled
        loginButton.isEnabled = enabled
        signinButton.isEnabled = enabled
        errorText.text = ""
        errorText.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
            signinButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            signinButton.alpha = 0.5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self
        passwordText.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signUp(_ sender: Any) {
        if let signUpURL = URL(string: "https://www.udacity.com/account/auth#!/signup"), UIApplication.shared.canOpenURL(signUpURL) {
            UIApplication.shared.open(signUpURL)
        }
    }
    @IBAction func logIn(_ sender: Any) {
        if emailText.text!.isEmpty || passwordText.text!.isEmpty {
            errorText.text = "Username or Password Empty"
        }else{
            self.setUIEnabled(false)
            let email = emailText.text
            let password = passwordText.text
            UdacityClient.sharedInstance().loginFlow(email!,password!){sucess,error in
                performUIUpdatesOnMain {
                    if sucess{
                    self.completeLogin()
                    }else{
                        self.alertWithError(error!,"ERROR")
                        self.setUIEnabled(true)
                    }}}}}
    
    func completeLogin(){
        setUIEnabled(true)
        let controller = storyboard?.instantiateViewController(withIdentifier: "NavViewController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    private func alertWithError(_ error: String,_ title: String) {
        let alertView = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}
