//
//  RideLocation.swift
//  QuickRide
//
//  Created by Sai Palutla on 6/19/23.
//

import CoreLocation

struct RideLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}


