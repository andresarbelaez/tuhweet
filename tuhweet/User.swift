//
//  User.swift
//  tuhweet
//
//  Created by Andrés Arbeláez on 6/26/16.
//  Copyright © 2016 Andrés Arbeláez. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var tagline: String?
    var profileUrl: NSURL?
    var profileBannerUrl: NSURL?
    var followersCount: Int = 0
    var followingCount: Int = 0
    var tweetCount: Int = 0
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        
        //print(dictionary)
        
        followersCount = dictionary["followers_count"] as? Int ?? 0
        
        tweetCount = dictionary["statuses_count"] as? Int ?? 0
        
        followingCount = dictionary["friends_count"] as? Int ?? 0
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        
        
        print("HERE IS WHERE THE PROFILE BANNER URL STRING SHOULD BE")
        print(profileBannerUrlString)
        
        if let profileBannerUrlString = profileBannerUrlString {
            profileBannerUrl = NSURL(string: profileBannerUrlString)
            print("i dont relaly knwetopjawjrtwew")
        }
        
    }
    
    
    
    
    
    
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    print("yay the user was found!")
                _currentUser = User(dictionary: dictionary)
                    print(_currentUser)
                }
            }
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    
}
