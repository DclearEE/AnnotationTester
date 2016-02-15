//
//  ViewController.swift
//  AnnotationTester
//
//  Created by First User on 2/14/16.
//  Copyright © 2016 Daniel_Cleary. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    self.mapView.delegate = self
        
        //1
        
        var lat1:CLLocationDegrees = 40.748708
        var long1:CLLocationDegrees = -73.985643
        var latDelta1:CLLocationDegrees = 0.01
        var longDelta1:CLLocationDegrees = 0.01
        
        var span1:MKCoordinateSpan = MKCoordinateSpanMake(latDelta1, longDelta1)
        var location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat1, long1)
        var region1:MKCoordinateRegion = MKCoordinateRegionMake(location1, span1)
        
        mapView.setRegion(region1, animated: true)
        
        
        
        var info1 = CustomPointAnnotation()
        info1.coordinate = location1
        info1.title = "Info1"
        info1.subtitle = "Subtitle"
        info1.imageName = "Range.png"
        
        mapView.addAnnotation(info1)
        
        //2
        
        var lat2:CLLocationDegrees = 41.748708
        var long2:CLLocationDegrees = -72.985643
        var latDelta2:CLLocationDegrees = 0.01
        var longDelta2:CLLocationDegrees = 0.01
        
        var span2:MKCoordinateSpan = MKCoordinateSpanMake(latDelta2, longDelta2)
        var location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat2, long2)
        var region2:MKCoordinateRegion = MKCoordinateRegionMake(location2, span2)
        

        var info2 = CustomPointAnnotation()
        info2.coordinate = location2
        info2.title = "Info2"
        info2.subtitle = "Subtitle"
        info2.imageName = "Smiley_Face.png"
        
        mapView.addAnnotation(info1)
        mapView.addAnnotation(info2)
    }

    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            print("Disclosure Pressed! \(self.title)")
        }
    }

    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
   //         anView!.rightCalloutAccessoryView = UIButton.buttonWithType(.InfoDark) as UIButton
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }
}