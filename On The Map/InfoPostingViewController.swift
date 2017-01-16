//
//  ViewController.swift
//  Test
//
//  Created by 政达 何 on 2017/1/8.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit
import CoreLocation
import  MapKit
class infoPostingViewController: UIViewController,MKMapViewDelegate,UITextViewDelegate{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var middleText: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var mapString: String?
    var mediaURL : String?
    var latitude : Double?
    var longitude: Double?
    let parseCleint = ParseClient.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        middleText.delegate = self
        topTextView.delegate = self
        mapView.delegate = self
        mapView.isHidden = true
        submitButton.isHidden = true
        activityIndicator.isHidden = true
    }
    
    @IBAction func experiment(_ sender: Any) {
        activityIndicator.isHidden = false
        let searchString = middleText.text
        let geo = CLGeocoder()
        geo.geocodeAddressString(searchString!){ (result,error) in
            if  error != nil{
                self.alertWithError("geocoding fails,please enter again","ERROR")
                self.activityIndicator.isHidden = true
            }else{
                self.mapString = searchString
                for item in result!{
                    print(item.location!.coordinate)
                    let cor = item.location?.coordinate
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = cor!
                    annotation.title = searchString
                    self.mapView.addAnnotation(annotation)
                    let region = MKCoordinateRegionMakeWithDistance(cor!, 100, 100);
                    self.mapView.setRegion(region, animated: true)
                    
                    self.latitude = cor?.latitude
                    self.longitude = cor?.longitude
                }
                
                self.bottomView.isHidden = true
                self.mapView.isHidden = false
                self.submitButton.isHidden = false
                self.topTextView.isUserInteractionEnabled = true
                self.topTextView.textColor = .white
                self.topTextView.backgroundColor = self.middleText.backgroundColor
                self.topTextView.tintColor = .white
                self.topTextView.text = "Enter a link to share here"
                self.middleText.isHidden = true
                self.activityIndicator.isHidden = true
            }}}
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func textViewDidBeginEditing(_ textField: UITextView) {
        if textField.text == "Enter a link to share here" || textField.text == "Enter Your Location Here"{
            textField.text = ""}
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n"{
            textView.resignFirstResponder()
            return false}
        return true
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        mediaURL = topTextView.text
        var param : [String:Any] = [:]
        param["mapString"] = mapString
        param["mediaURL"] = mediaURL
        param["latitude"] = latitude
        param["longitude"] = longitude
        parseCleint.postInfo(param){ sucess, error in
            performUIUpdatesOnMain{
                if let error = error {
                    self.alertWithError(error, "ERROR")
                }else{
                    print("posting sucess")
                            self.dismiss(animated: true, completion: nil)
                    self.parseCleint.getStudents(){ sucess, errorString in
                        performUIUpdatesOnMain{
                        if let errorString = errorString{
                            self.alertWithError(errorString, "ERROR")
                            }}}}}}}
    
    
    private func alertWithError(_ error: String,_ title: String) {
        let alertView = UIAlertController(title: title, message: error, preferredStyle: .alert)
               alertView.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

