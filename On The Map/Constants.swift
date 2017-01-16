//
//  Constant.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/14.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import Foundation
struct StudentInformation{
    let lastName: String
    let firstName:String
    let objectId:String
    let uniqueKey:String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL:String
    init(_ dict: [String:Any]){
        lastName = dict["lastName"] as? String ?? ""
        firstName = dict["firstName"] as? String ?? ""
        latitude = dict["latitude"] as? Double ?? 0.0
        longitude = dict["longitude"] as? Double ?? 0.0
        mapString = dict["mapString"] as? String ?? ""
        mediaURL = dict["mediaURL"] as? String ?? ""
        objectId = dict["objectId"] as? String ?? ""
        uniqueKey = dict["uniqueKey"] as? String ?? ""
}
}
