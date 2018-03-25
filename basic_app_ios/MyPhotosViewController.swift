//
//  MyPhotosViewController.swift
//  basic_app_ios
//
//  Created by Development on 12/19/15.
//  Copyright © 2015 Development. All rights reserved.
//

import UIKit

class MyPhotosViewController: UIViewController {
    @IBOutlet weak var cancel_button: UIButton!
    @IBOutlet weak var profile_button: UIButton!
    @IBOutlet weak var trash_button: UIButton!
    
    struct MyPhotosConstants {
        static var selected_image = 0
        static var image_length = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        setupButtonBorders()
        super.viewDidLoad()
        let activityIndicatorView = ActivityIndicatorView(title: "Loading Images...", center: self.view.center)
        self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        var request:URLRequest = URLRequest(url:Constants.Net.my_photos_api_url! as URL)
        request.httpMethod = "POST"
        let bodyData = "user_id=" + Constants.Net.user_id
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            do {
                let screenSize: CGRect = UIScreen.main.bounds
                let targetScreenWidth:Int = Int(screenSize.width)
                let images_cnt:Int = (targetScreenWidth / MyPhotosConstants.image_length) - 1
                let original_width: Int = (targetScreenWidth % MyPhotosConstants.image_length) / 2
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                    var cur_height = 30
                    var cur_width = original_width
                    DispatchQueue.main.async(execute: {
                        activityIndicatorView.stopAnimating()
                        for image in (jsonResult as? [[String:Any]])! {
                            let tag_id : Int = image["id"] as! Int
                            if let data_string : String = image["data"] as? String {
                                if let decodedData = Data(base64Encoded: data_string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                                    if let decodedImage = UIImage(data: decodedData) {
                                        let imageView = UIImageView(image: decodedImage)
                                        imageView.frame = CGRect(x: cur_width, y: cur_height, width: MyPhotosConstants.image_length, height: MyPhotosConstants.image_length)
                                        imageView.layer.cornerRadius = 8
                                        imageView.clipsToBounds = true
                                        let tap = UITapGestureRecognizer(target: self, action: #selector(MyPhotosViewController.tappedImage(_:)))
                                        imageView.addGestureRecognizer(tap)
                                        imageView.isUserInteractionEnabled = true
                                        imageView.tag = tag_id
                                        self.view.addSubview(imageView)
                                        if (cur_width >= (MyPhotosConstants.image_length * images_cnt)) {
                                            cur_width = original_width
                                            cur_height = cur_height + MyPhotosConstants.image_length
                                        } else {
                                            cur_width = cur_width + MyPhotosConstants.image_length
                                        }
                                    }
                                }
                            }
                        
                        }
                    })
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }

        }) 
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Programmatically set hover/press color of border for buttons
    func setupButtonBorders() {
        self.cancel_button.layer.borderColor = UIColor.white.cgColor
        self.cancel_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.profile_button.layer.borderColor = UIColor.white.cgColor
        self.profile_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
        self.trash_button.layer.borderColor = UIColor.white.cgColor
        self.trash_button.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0), for: UIControlState.highlighted)
    }
    
    //Cancel
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
    
    //Set Profile Pic
    @IBAction func highlight_border_profile(_ sender: Any) {
        self.profile_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.profile_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_profile(_ sender: Any) {
        self.profile_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.profile_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_profile(_ sender: Any) {
        self.profile_button.layer.borderColor = UIColor.white.cgColor
        self.profile_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_profile(_ sender: Any) {
        self.profile_button.layer.borderColor = UIColor.white.cgColor
        self.profile_button.backgroundColor = UIColor.clear
    }
    
    //Trash
    @IBAction func highlight_border_trash(_ sender: Any) {
        self.trash_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.trash_button.backgroundColor = UIColor.white
    }
    @IBAction func highlight_drag_border_trash(_ sender: Any) {
        self.trash_button.layer.borderColor = UIColor(red: 224/255, green: 36/255, blue: 94/255, alpha: 1.0).cgColor
        self.trash_button.backgroundColor = UIColor.white
    }
    @IBAction func unhighlight_inside_border_trash(_ sender: Any) {
        self.trash_button.layer.borderColor = UIColor.white.cgColor
        self.trash_button.backgroundColor = UIColor.clear
    }
    @IBAction func unhighlight_border_trash(_ sender: Any) {
        self.trash_button.layer.borderColor = UIColor.white.cgColor
        self.trash_button.backgroundColor = UIColor.clear
    }
    
    
    //Action Buttons (Cancel/Set Profile Pic/Trash)
    @objc func tappedImage(_ sender: AnyObject) {
        let tappedImageView = sender.view!
        for view in self.view.subviews as [UIView] {
            if let img = view as? UIImageView {
                img.layer.borderWidth = 0
            }
        }
        tappedImageView.layer.borderWidth = 4
        tappedImageView.layer.borderColor = UIColor.red.cgColor
        MyPhotosConstants.selected_image = tappedImageView.tag
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ProfileHomeViewController = storyboard.instantiateViewController(withIdentifier: "profile_home") as! ProfileHomeViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func set_profile_image(_ sender: AnyObject) {
        if (MyPhotosConstants.selected_image != 0) {
            let activityIndicatorView = ActivityIndicatorView(title: "Updating Profile...", center: self.view.center)
            self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
            activityIndicatorView.startAnimating()
            var request:URLRequest = URLRequest(url:Constants.Net.my_info_api_url! as URL)
            request.httpMethod = "POST"
            let selectedImage = String(MyPhotosConstants.selected_image)
            let bodyData = "user_id=" + Constants.Net.user_id + "&profile_image_id=" + selectedImage
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let status : Int = jsonResult["status"] as! Int
                        DispatchQueue.main.async(execute: {
                            if (status == Constants.Net.success) {
                                activityIndicatorView.stopAnimating()
                                Constants.Net.updated = true
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc: ProfileHomeViewController = storyboard.instantiateViewController(withIdentifier: "profile_home") as! ProfileHomeViewController
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: nil, message: "Something went wrong.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }) 
            task.resume()
        } else {
            let alert = UIAlertController(title: nil, message: "You must select an image first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func trash_selected(_ sender: AnyObject) {
        if (MyPhotosConstants.selected_image != 0) {
            let activityIndicatorView = ActivityIndicatorView(title: "Deleting Image...", center: self.view.center)
            self.view.addSubview(activityIndicatorView.getViewActivityIndicator())
            activityIndicatorView.startAnimating()
            var request:URLRequest = URLRequest(url:Constants.Net.my_photo_api_url! as URL)
            request.httpMethod = "POST"
            let selectedImage = String(MyPhotosConstants.selected_image)
            let bodyData = "image_id=" + selectedImage + "&delete=1"
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        let status : Int = jsonResult["status"] as! Int
                        DispatchQueue.main.async(execute: {
                            if (status == Constants.Net.success) {
                                activityIndicatorView.stopAnimating()
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc: MyPhotosViewController = storyboard.instantiateViewController(withIdentifier: "my_photos") as! MyPhotosViewController
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: nil, message: "Image already deleted.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            })
            task.resume()
        } else {
            let alert = UIAlertController(title: nil, message: "You must select an image first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
