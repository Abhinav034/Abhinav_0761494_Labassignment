//
//  Annotations.swift
//  Abhinav_0761494_Labassignment
//
//  Created by Abhinav Bhardwaj on 2020-01-14.
//  Copyright © 2020 Abhinav Bhardwaj. All rights reserved.
//

import Foundation
import MapKit

class Annotations: NSObject , MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var identifier:String
    
    init(coordinate:CLLocationCoordinate2D , identifier:String){
        
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
     
}







