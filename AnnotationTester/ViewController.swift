//
//  ViewController.swift
//  AnnotationTester
//
//  Created by First User on 2/14/16.
//  Copyright © 2016 Daniel_Cleary. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBAction func ShowSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.HybridFlyover
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        

        
        //1 Annotation
        
        var lat1:CLLocationDegrees = 40.748708
        var long1:CLLocationDegrees = -73.985643
        var latDelta1:CLLocationDegrees = 0.01
        var longDelta1:CLLocationDegrees = 0.01
        
        var span1:MKCoordinateSpan = MKCoordinateSpanMake(latDelta1, longDelta1)
        var location1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat1, long1)
        var region1:MKCoordinateRegion = MKCoordinateRegionMake(location1, span1)
        
        mapView.setRegion(region1, animated: true)
        
        
        
        let info1 = CustomPointAnnotation()
        info1.coordinate = location1
        info1.title = "Empire State Building"
        info1.subtitle = "WOW!"
        info1.imageName = "Range"
        
        mapView.addAnnotation(info1)
        
        //2 Annotation
        
//        var lat2:CLLocationDegrees = 41.748708
//        var long2:CLLocationDegrees = -72.985643
//        var latDelta2:CLLocationDegrees = 0.01
//        var longDelta2:CLLocationDegrees = 0.01
//        
//        var span2:MKCoordinateSpan = MKCoordinateSpanMake(latDelta2, longDelta2)
//        var location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat2, long2)
//        var region2:MKCoordinateRegion = MKCoordinateRegionMake(location2, span2)
//        
//
//        var info2 = CustomPointAnnotation()
//        info2.coordinate = location2
//        info2.title = "Info2"
//        info2.subtitle = "Subtitle"
//        info2.imageName = "Smiley_Face.png"
//        
//        mapView.addAnnotation(info1)
//        mapView.addAnnotation(info2)
     }
    
    
    
    //  MARK: - Search Bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        //1: Once you click the keyboard search button, the app will dismiss the presented search controller you were presenting over the navigation bar. Then, the map view will look for any previously drawn annotation on the map and remove it since it will no longer be needed.
        
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
            self.mapView.removeAnnotation(info1)
        }
        
        //2: After that, the search process will be initiated asynchronously by transforming the search bar text into a natural language query, the ‘naturalLanguageQuery’ is very important in order to look up for -even an incomplete- addresses and POI (point of interests) like restaurants, Coffeehouse, etc.
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3 Mainly, If the search API returns a valid coordinates for the place, then the app will instantiate a 2D point and draw it on the map within a pin annotation view
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            
            
            
            let info1 = CustomPointAnnotation()
            info1.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            info1.title = "Solar!"
          //  info1.subtitle = "Subtitle"
            info1.imageName = "Range"
            
            self.mapView.addAnnotation(info1)
        }
    }
    
    
    
    
    
    
    

    //      MARK: - Location delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
  //      self.locationManager.stopUpdatingLocation()
        
        print("Yay")
    }


    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.draggable = true
            anView!.canShowCallout = true
//            anView!.rightCalloutAccessoryView = UIButton.buttonWithType(.InfoDark) as UIButton
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