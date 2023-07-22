//
//  DeveloperPreview.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/8/23.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockUser = User(
        fullname: "Sai Palutla",
        email: "test@gmail.com",
        uid: NSUUID().uuidString,
        coordinates: GeoPoint(latitude: 42.964656, longitude: -85.891873),
        accountType: .passenger,
        homeLocation: nil,
        workLocation: nil
    )
    
    let mockTrip = Trip(
        id: NSUUID().uuidString,
        passengerUid: NSUUID().uuidString,
        driverUid: NSUUID().uuidString,
        passengerName: "Sai Palutla",
        driverName: "John Doe",
        passengerLocation: .init(latitude: 37, longitude: -122),
        driverLocation: .init(latitude: 37, longitude: -122),
        pickupLocationName: "GVSU Allendale",
        dropoffLocationName: "Mad cap coffee 123 main st",
        pickupLocationAddress: "1 Campus Dr",
        pickupLocation: .init(latitude: 37, longitude: -122),
        dropoffLocation: .init(latitude: 37, longitude: -122),
        tripCost: 47.0,
        distanceToPassenger: 1000,
        travelTimeToPassenger: 24
    )
    
}
