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
}
