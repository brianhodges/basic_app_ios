//
//  EditProfileViewController.swift
//  basic_app_ios
//
//  Created by Development on 12/23/15.
//  Copyright © 2015 Development. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var update_button: UIButton!
    @IBOutlet weak var cancel_button: UIButton!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var fname_input: UITextField!
    @IBOutlet weak var lname_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var password_confirm_input: UITextField!
    
    override func viewDidLoad() {
        setupButtonBorders()
        super.viewDidLoad()
        if is_authenticated() {
            var request:URLRequest = URLRequest(url:Constants.Net.my_info_api_url! as URL)
            request.httpMethod = "POST"
            let bodyData = "user_id=" + Constants.Net.user_id
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let status : Int = jsonResult["status"] as! Int
                        if (status == Constants.Net.success) {
                            DispatchQueue.main.async(execute: {
                                if let email: String = (jsonResult["email"] as? String) {
                                    self.email_input.text = email
                                }
                                if let first_name: String = (jsonResult["first_name"] as? String) {
                                    self.fname_input.text = first_name
                                }
                                if let last_name: String = (jsonResult["last_name"] as? String) {
                                    self.lname_input.text = last_name
                                }
                            })
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }) 
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Programmatically set hover/press color of border for buttons
    func setupButtonBorders() {
        self.cancel_button.layer.borderColor = UIColor.white.cgColor
        self.cancel_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.update_button.layer.borderColor = UIColor.white.cgColor
        self.update_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
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
    
    //update
    @IBAction func highlight_border_update(_ sender: Any) {
        self.update_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.update_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_update(_ sender: Any) {
        self.update_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.update_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_update(_ sender: Any) {
        self.update_button.layer.borderColor = UIColor.white.cgColor
        self.update_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_update(_ sender: Any) {
        self.update_button.layer.borderColor = UIColor.white.cgColor
        self.update_button.backgroundColor = UIColor.clear
    }
    
    
    //Action Buttons (Cancel/Update)
    @IBAction func cancel(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ProfileHomeViewController = storyboard.instantiateViewController(withIdentifier: "profile_home") as! ProfileHomeViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        let password: String = password_input.text!
        let password_confirmation: String = password_confirm_input.text!
        let email: String = email_input.text!
        let first_name: String = fname_input.text!
        let last_name: String = lname_input.text!
        let params: String = "&email=" + email + "&fname=" + first_name + "&lname=" + last_name
        
        if (password == password_confirmation) {
            let activityIndicatorView = ActivityIndicatorView(title: "Updating User...", center: self.view.center)
            self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
            activityIndicatorView.startAnimating()
            var request:URLRequest = URLRequest(url:Constants.Net.update_user_api_url! as URL)
            request.httpMethod = "POST"
            let bodyData = "user_id=" + Constants.Net.user_id + "&p=" + password + params
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                let success = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
                if (success == "1") {
                    DispatchQueue.main.async(execute: {
                        activityIndicatorView.stopAnimating()
                        Constants.Net.updated = true
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc: ProfileHomeViewController = storyboard.instantiateViewController(withIdentifier: "profile_home") as! ProfileHomeViewController
                        self.present(vc, animated: true, completion: nil)
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
