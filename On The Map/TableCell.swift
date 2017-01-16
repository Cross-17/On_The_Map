//
//  File.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/15.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import Foundation
import UIKit
class TableCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
    
    func getinfo(info: StudentInformation){
        name.text = info.lastName + " " + info.firstName
        url.text = info.mediaURL
    }
    
}
