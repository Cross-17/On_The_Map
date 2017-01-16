//
//  MapViewController.swift
//  On The Map
//
//  Created by 政达 何 on 2017/1/14.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let parse = ParseClient.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        parse.getStudents(){ result,error in
            performUIUpdatesOnMain{
            if error != nil{
                self.studentLocationsPinnedDownError()
            }else{
                self.addAnnotation()
            }
            }}}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotation()
    }
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
                  if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!)
            }
        }
    }
    private func alertWithError(error: String, title: String) {
        let alertView = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func studentLocationsPinnedDownError() {
        alertWithError(error: "student data download fails", title: "ERROR")
    }
    private func addAnnotation(){
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for student in studentData.data {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }

}
