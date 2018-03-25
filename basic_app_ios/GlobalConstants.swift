//
//  GlobalConstants.swift
//  basic_app_ios
//
//  Created by Development on 12/13/15.
//  Copyright © 2015 Development. All rights reserved.
//

import Foundation

struct Constants {    
    struct Net {
        static let version_number = "1.0.3"
        static let host_url : String = "https://basic-app.herokuapp.com/"
        static let login_api_url = URL(string: host_url + "auth")
        static let register_api_url = URL(string: host_url + "create_user")
        static let my_info_api_url = URL(string: host_url + "my_info")
        static let update_user_api_url = URL(string: host_url + "update_user")
        static let my_photos_api_url = URL(string: host_url + "my_photos")
        static let my_photo_api_url = URL(string: host_url + "my_photo")
        static let create_photo_api_url = host_url + "create_user_image/"
        static let failure = "0"
        static let success = 1
        static var registered = false
        static var updated = false
        static var user_id = ""
    }
}

func is_authenticated() -> Bool {
    if (Constants.Net.user_id == "") {
        return false
    } else {
        return true
    }
}
