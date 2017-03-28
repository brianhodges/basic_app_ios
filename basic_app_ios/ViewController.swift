//
//  ViewController.swift
//  basic_app_ios
//
//  Created by Development on 12/13/15.
//  Copyright © 2015 Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var version_label: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (Constants.Net.registered == true) {
            let alert = UIAlertController(title: nil, message: "Account created. Log in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            Constants.Net.registered = false
        }
    }
    
    override func viewDidLoad() {
        setupButtonBorders()
        self.version_label.text = "v" + Constants.Net.version_number
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //Programmatically set hover/press color of border for buttons
    func setupButtonBorders() {
        self.login_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.login_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.register_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
    }
    
    //login
    @IBAction func highlight_border_login(_ sender: Any) {
        self.login_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.login_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_login(_ sender: Any) {
        self.login_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.login_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_login(_ sender: Any) {
        self.login_button.layer.borderColor = UIColor.white.cgColor
        self.login_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_login(_ sender: Any) {
        self.login_button.layer.borderColor = UIColor.white.cgColor
        self.login_button.backgroundColor = UIColor.clear
    }
    
    //register
    @IBAction func highlight_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.register_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.register_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_insider_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_register(_ sender: Any) {
        self.register_button.layer.borderColor = UIColor.white.cgColor
        self.register_button.backgroundColor = UIColor.clear
    }

    
    //Action Buttons (Login/Register)
    @IBAction func login(_ sender: AnyObject) {
        let activityIndicatorView = ActivityIndicatorView(title: "Logging in...", center: self.view.center)
        self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        let email: String = email_input.text!
        let password: String = password_input.text!
        var request:URLRequest = URLRequest(url:Constants.Net.login_api_url! as URL)
        request.httpMethod = "POST"
        let bodyData = "email=" + email + "&p=" + password
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            let success = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
            if (success as String != Constants.Net.failure) {
                Constants.Net.user_id = success as String
                DispatchQueue.main.async(execute: {
                    activityIndicatorView.stopAnimating()
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: ProfileHomeViewController = storyboard.instantiateViewController(withIdentifier: "profile_home") as! ProfileHomeViewController
                    self.present(vc, animated: true, completion: nil)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    activityIndicatorView.stopAnimating()
                    let alert = UIAlertController(title: nil, message: "The Username/Password you've entered is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }) 
        task.resume()
    }
    
    @IBAction func register(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: RegisterViewController = storyboard.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        self.present(vc, animated: true, completion: nil)
    }
}

