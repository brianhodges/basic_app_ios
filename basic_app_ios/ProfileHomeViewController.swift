//
//  ProfileHomeViewController.swift
//  basic_app_ios
//
//  Created by Development on 12/15/15.
//  Copyright © 2015 Development. All rights reserved.
//

import UIKit

class ProfileHomeViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var success_status: UILabel!
    @IBOutlet weak var my_profile_pic: UIImageView!
    @IBOutlet weak var upload_image_button: UIButton!
    @IBOutlet weak var my_photo: UIButton!
    @IBOutlet weak var edit_info_button: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (Constants.Net.updated == true) {
            let alert = UIAlertController(title: nil, message: "User Info updated.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            Constants.Net.updated = false
        }
    }
    
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
                                if let my_name: String = (jsonResult["first_name"] as? String) {
                                    if (my_name != "") {
                                        self.success_status.text = "Hi, " + my_name + "!"
                                    } else {
                                       self.success_status.text = jsonResult["email"] as? String
                                    }
                                } else {
                                   self.success_status.text = jsonResult["email"] as? String
                                }
                                if let data_string : String = jsonResult["profile_image_id"] as? String {
                                    if let decodedData = Data(base64Encoded: data_string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                                        if let decodedImage = UIImage(data: decodedData) {
                                            self.my_profile_pic.layer.cornerRadius = self.my_profile_pic.frame.height/2
                                            self.my_profile_pic.clipsToBounds = true
                                            self.my_profile_pic.image = decodedImage
                                        } else {
                                            print("display default pic")
                                        }
                                    }
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
        self.upload_image_button.layer.borderColor = UIColor.white.cgColor
        self.upload_image_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.my_photo.layer.borderColor = UIColor.white.cgColor
        self.my_photo.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.edit_info_button.layer.borderColor = UIColor.white.cgColor
        self.edit_info_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.logout.layer.borderColor = UIColor.white.cgColor
        self.logout.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
    }
    
    //upload image
    @IBAction func highlight_border_upload_image(_ sender: Any) {
        self.upload_image_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.upload_image_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_upload_image(_ sender: Any) {
        self.upload_image_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.upload_image_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_upload_image(_ sender: Any) {
        self.upload_image_button.layer.borderColor = UIColor.white.cgColor
        self.upload_image_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_upload_image(_ sender: Any) {
        self.upload_image_button.layer.borderColor = UIColor.white.cgColor
        self.upload_image_button.backgroundColor = UIColor.clear
    }
    
    //my photos
    @IBAction func highlight_border_my_photos(_ sender: Any) {
        self.my_photo.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.my_photo.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_my_photos(_ sender: Any) {
        self.my_photo.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.my_photo.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_my_photos(_ sender: Any) {
        self.my_photo.layer.borderColor = UIColor.white.cgColor
        self.my_photo.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_my_photos(_ sender: Any) {
        self.my_photo.layer.borderColor = UIColor.white.cgColor
        self.my_photo.backgroundColor = UIColor.clear
    }
    
    //edit info
    @IBAction func highlight_border_edit_info(_ sender: Any) {
        self.edit_info_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.edit_info_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_edit_info(_ sender: Any) {
        self.edit_info_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.edit_info_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_edit_info(_ sender: Any) {
        self.edit_info_button.layer.borderColor = UIColor.white.cgColor
        self.edit_info_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_edit_info(_ sender: Any) {
        self.edit_info_button.layer.borderColor = UIColor.white.cgColor
        self.edit_info_button.backgroundColor = UIColor.clear
    }
    
    //logout
    @IBAction func highlight_border_logout(_ sender: Any) {
        self.logout.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.logout.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_logout(_ sender: Any) {
        self.logout.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.logout.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_logout(_ sender: Any) {
        self.logout.layer.borderColor = UIColor.white.cgColor
        self.logout.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_logout(_ sender: Any) {
        self.logout.layer.borderColor = UIColor.white.cgColor
        self.logout.backgroundColor = UIColor.clear
    }
    
    
    //Action Buttons (Upload Image/My Photos/Edit Info/Logout)
    @IBAction func add_photo(_ sender: AnyObject) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        let activityIndicatorView = ActivityIndicatorView(title: "Saving Image...", center: self.view.center)
        self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        let upload_photo_api_url = URL(string: Constants.Net.create_photo_api_url + Constants.Net.user_id)
        var request:URLRequest = URLRequest(url:upload_photo_api_url!)
        request.httpMethod = "POST"
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        let imageData:Data = UIImageJPEGRepresentation(newImage, 1)!
        request.httpBody = imageData
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            let serv_resp = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
            if (serv_resp == "1") {
                DispatchQueue.main.async(execute: {
                    activityIndicatorView.stopAnimating()
                })
            }
        }) 
        task.resume()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func my_photos_lookup(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MyPhotosViewController = storyboard.instantiateViewController(withIdentifier: "my_photos") as! MyPhotosViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func edit_info(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EditProfileViewController = storyboard.instantiateViewController(withIdentifier: "edit_profile") as! EditProfileViewController
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func logout_user(_ sender: UIButton) {
        Constants.Net.user_id = ""
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
}
