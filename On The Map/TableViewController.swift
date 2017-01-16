//
//  TableViewController.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/15.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let parse = ParseClient.sharedInstance()
    var student : [StudentInformation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        student = parse.data
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return student.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.getinfo(info: student[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentURL = student[indexPath.row].mediaURL
        
        // Check if it exists & proceed accordingly
        if let studentMediaURL = URL(string: studentURL), UIApplication.shared.canOpenURL(studentMediaURL) {
            UIApplication.shared.open(studentMediaURL)
        }}}
