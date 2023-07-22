//
//  GeoPoint.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/20/23.
//

import Firebase
import CoreLocation

extension GeoPoint{
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
