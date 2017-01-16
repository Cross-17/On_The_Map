//
//  TabBarController.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/14.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOut(_ sender: Any) {
        UdacityClient.sharedInstance().logOut(){ sucess,error in
            performUIUpdatesOnMain{
                if let error = error{
                    print(error)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }}}}
}
