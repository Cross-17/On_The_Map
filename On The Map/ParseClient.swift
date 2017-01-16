//
//  ParseClient.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/14.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import Foundation
class ParseClient:Client{
    
    func getStudents(completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void){
       let request =  getParseRequestUrl("https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")
       let _ =  requestWithUdacity(request: request as URLRequest,true){ (result,error) in
            if let error = error{
                completionHandler(false,String(describing: error))
            }else{
                if let result = result as? [String:[[String:Any]]]{
                    for record in result["results"]!{
                        let temp = StudentInformation(record)
                        studentData.data.append(temp)
                }
                    completionHandler(true,nil)
                }}}}
    
    func postInfo(_ param:[String:Any],completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        let udacityClient = UdacityClient.sharedInstance()
        var parameter = param
        parameter["uniqueKey"] = udacityClient.accountKey
        parameter["firstName"] = udacityClient.first_name
        parameter["lastName"] = udacityClient.last_name
        let request =  getParseRequestUrl("https://parse.udacity.com/parse/classes/StudentLocation",parameter,true)
        let _ = requestWithUdacity(request: request, true){ (result,error) in
            if error != nil{
                completionHandler(false,"Posting Fail")
            }else{
                completionHandler(true,nil)
            }}}
    
    private func getParseRequestUrl(_ url:String, _ param:[String:Any] = [:],_ post:Bool = false) -> URLRequest{
        let request = NSMutableURLRequest(url:URL(string:url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let body = httpbody(param as [String : Any])
        print(body)
        request.httpBody = body.data(using: String.Encoding.utf8)
        if post{
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request as URLRequest
    }
    
    private func httpbody(_ parameters: [String:Any]) -> String {
        return String(describing: parameters).replacingOccurrences(of: "[", with: "{").replacingOccurrences(of: "]", with: "}")
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
