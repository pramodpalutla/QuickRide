//
//  SavedLocation.swift
//  UberCloneSwiftUI
//
//  Created by Sudharshan S H on 03/03/22.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
