//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/14.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import Foundation

class UdacityClient:Client{
    var accountKey :String?
    var first_name :String?
    var last_name :String?
    
    func loginFlow(_ userName:String,_ passWord:String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        loginWithCredential(userName,passWord){ sucess,sessionID,accountKey,error in
            if let error = error {
                completionHandlerForAuth(false,error)
            }else{
                if let accountKey = accountKey{
                    self.getUserProfile(accountKey){ sucess, error in
                        if let error = error {
                            completionHandlerForAuth(false,error)
                        }else{
                            completionHandlerForAuth(true,nil)
                        }}}}}}
    
    func loginWithCredential(_ userName:String,_ passWord:String,_ completionHandler: @escaping (_ success: Bool,_ sessionID: String?,_ accountKey: String?, _ errorString: String?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body = "{\"udacity\": {\"username\": \"xxxx@xxx.com\", \"password\": \"********\"}}"
        body = body.replacingOccurrences(of: "xxxx@xxx.com", with: userName).replacingOccurrences(of: "********", with: passWord)
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        
        let _  = requestWithUdacity(request: request as URLRequest,false){ (results,error) in
            if error != nil {
                if error?.code == 1{
                completionHandler(false,nil,nil, "Login Failed (Bad Internet Connection).")
                }else{
                completionHandler(false,nil,nil, "Login Failed (Incorrect Username or Password).")
                }
            } else {
                if let session = results?["session"] as? [String:Any], let account = results?["account"] as? [String:Any]{
                    completionHandler(true, session["id"] as! String?,account["key"] as! String?, nil)
                } else {
                    completionHandler(false,nil,nil, "Could not find sessionID or accountID in \(results)")
                }}}}
    
    func getUserProfile(_ accountKey:String,completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        let url = "https://www.udacity.com/api/users"+"/"+accountKey
        let request = NSMutableURLRequest(url: URL(string:url)!)
        let _ = requestWithUdacity(request: request as URLRequest,false){ (results,error) in
            if let error = error {
                print(error)
                completionHandler(false, "cound not get user profile")
            } else{
                if let profile = results?["user"] as? [String:Any]{
                    print(profile["last_name"]!)
                     self.accountKey = accountKey
                    self.last_name = profile["last_name"] as? String
                    self.first_name = profile["first_name"] as? String
                    completionHandler(true,nil)
                }}}}
    
    func logOut(completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let _ = requestWithUdacity(request: request as URLRequest, false){ (result,error) in
            if let error = error {
                print(error)
                completionHandler(false,"logout fail")
            }else{
                completionHandler(true,nil)
            }
        }
    }
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }}

