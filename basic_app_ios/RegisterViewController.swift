//
//  RegisterViewController.swift
//  basic_app_ios
//
//  Created by Development on 12/16/15.
//  Copyright © 2015 Development. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var cancel_button: UIButton!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var password_confirmation_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var fname_input: UITextField!
    @IBOutlet weak var lname_input: UITextField!
    
    override func viewDidLoad() {
        setupButtonBorders()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Programmatically set hover/press color of border for buttons
    func setupButtonBorders() {
        self.cancel_button.layer.borderColor = UIColor.white.cgColor
        self.cancel_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
    }
    
    //cancel
    @IBAction func highlight_border_cancel(_ sender: Any) {
        self.cancel_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.cancel_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_cancel(_ sender: Any) {
        self.cancel_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.cancel_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_cancel(_ sender: Any) {
        self.cancel_button.layer.borderColor = UIColor.white.cgColor
        self.cancel_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_cancel(_ sender: Any) {
        self.cancel_button.layer.borderColor = UIColor.white.cgColor
        self.cancel_button.backgroundColor = UIColor.clear
    }
    
    //register (sign up)
    @IBAction func highlight_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.register_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.register_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.backgroundColor = UIColor.clear
    }
    
    
    //Action Buttons (Cancel/Register)
    @IBAction func cancel(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: AnyObject) {
        let email: String = email_input.text!
        let first_name: String = fname_input.text!
        let last_name: String = lname_input.text!
        let password: String = password_input.text!
        let password_confirmation: String = password_confirmation_input.text!
        let name_params: String = "&fname=" + first_name + "&lname=" + last_name
        
        if (password == password_confirmation) {
            let activityIndicatorView = ActivityIndicatorView(title: "Creating User...", center: self.view.center)
            self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
            activityIndicatorView.startAnimating()
            var request:URLRequest = URLRequest(url:Constants.Net.register_api_url! as URL)
            request.httpMethod = "POST"
            let bodyData = "email=" + email + "&p=" + password + name_params
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
                    
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                let success = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
                if (success == "1") {
                    DispatchQueue.main.async(execute: {
                        Constants.Net.registered = true
                        activityIndicatorView.stopAnimating()
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
                        self.present(vc, animated: true, completion: nil)
                    })
                } else if (success as String == Constants.Net.failure) {
                    DispatchQueue.main.async(execute: {
                        activityIndicatorView.stopAnimating()
                        let alert = UIAlertController(title: nil, message: "Something went wrong. Try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        activityIndicatorView.stopAnimating()
                        let alert = UIAlertController(title: nil, message: success as String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }) 
            task.resume()
        } else {
            let alert = UIAlertController(title: nil, message: "Passwords must match.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
