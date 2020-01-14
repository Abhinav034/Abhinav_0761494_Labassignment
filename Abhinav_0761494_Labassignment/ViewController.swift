//
//  ViewController.swift
//  Abhinav_0761494_Labassignment
//
//  Created by Abhinav Bhardwaj on 2020-01-14.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController , UIGestureRecognizerDelegate {

    @IBOutlet weak var automobileButton: UIButton!
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var authorisationStatus = CLLocationManager.authorizationStatus()
    var radius:Double = 1000
    var type:Bool?
    var cooArr = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        configureLocation()
        userLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        doubleTap()
        tripleTap()
        
        
        
    }
    
    func tripleTap(){
        
        let tripleTap = UILongPressGestureRecognizer(target: self, action: #selector(userTripletapped))
      
        
        tripleTap.delegate = self
        
        mapView.addGestureRecognizer(tripleTap)
        
        
        
        
    }
    
    @objc func userTripletapped(){
        
        
       // let latitude = mapView.userLocation.coordinate.latitude
       // let longitude = mapView.userLocation.coordinate.longitude
    
        
        let coordinates = mapView.userLocation.coordinate
        
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 100000*2, longitudinalMeters: 100000*2)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    func doubleTap(){
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(userTapped(sender:)))
        
        doubleTap.numberOfTapsRequired = 2
        
       
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
    @objc func userTapped(sender:UITapGestureRecognizer){
        
        removeAnnotation()
        let touchPoint = sender.location(in: mapView)
        
        
        
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        cooArr.append(coordinates)
        
        let annotation = Annotations(coordinate: coordinates, identifier: "pin")
        
        
        
        mapView.addAnnotation(annotation)
        mapView.removeOverlays(mapView.overlays)
        
        
    }
    
    func getDirection(destination:CLLocationCoordinate2D ){
        
        
        let destinationRequest = MKDirections.Request()
        
        let sourceCoordinates = mapView.userLocation.coordinate
       
      
        
        
        let source = CLLocationCoordinate2DMake((sourceCoordinates.latitude), (sourceCoordinates.longitude))
        let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
        
        print(source)
        print(destination)
        
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        
        let finalSource = MKMapItem(placemark: sourcePlacemark)
        let finalDestination = MKMapItem(placemark: destinationPlacemark)
        
       
        destinationRequest.source = finalSource
        destinationRequest.destination = finalDestination
        if type == true{
          destinationRequest.transportType = .walking
        }
        if type == false{
            
            destinationRequest.transportType = .automobile
        }
        
        
        let direction = MKDirections(request: destinationRequest)
        
        
        direction.calculate { (responce, error) in
            
            guard let responce = responce else {
                
                if let error = error {
                    print(error)
                    
                }
                return
            }
            let route = responce.routes[0]
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            
        }
        
        
    }
    

    @IBAction func navigationButtonPressed(_ sender: UIButton) {
        
        if mapView.annotations.count > 1{
            getDirection(destination:cooArr.last!)
        }
       
    }
    
    
    
    @IBAction func carButtonPressed(_ sender: UIButton) {
        
      
        
//        if type == false {
//            
//            automobileButton.setTitle("Car", for: .normal)
//            type = true
//        }
//        
//        else if type == true{
//            
//             automobileButton.setTitle("Walk", for: .normal)
//            
//            type = false
//        }
        
        
        
        
        
        
    }
    
    
}

extension ViewController: MKMapViewDelegate{
    
    
    func removeAnnotation(){
       
        for annotations in mapView.annotations{
            
            mapView.removeAnnotation(annotations)
            
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation{
                    
           return nil
        
        }
        
      let annotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        return annotation
        
        
    }
    
    
    
    func userLocation (){
        
        if authorisationStatus == .authorizedAlways || authorisationStatus == .authorizedWhenInUse{
            
            let coordinate = locationManager.location?.coordinate
            let coordinateRegion = MKCoordinateRegion(center: coordinate!, latitudinalMeters: radius*2, longitudinalMeters: radius*2)
            
            
            mapView.setRegion(coordinateRegion, animated: true)
            
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {

            let render = MKPolylineRenderer(overlay: overlay)

            render.strokeColor = UIColor.blue

            render.lineWidth = 4

            return render


        }

        return MKOverlayRenderer()
    }
    
    
    
    
    
   
}

extension ViewController: CLLocationManagerDelegate{
    
    func configureLocation(){
        
        locationManager.requestAlwaysAuthorization()
        
    }
    
    
    
}


