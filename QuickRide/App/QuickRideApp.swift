//
//  QuickRideApp.swift
//  QuickRide
//
//  Created by Sai Palutla on 5/2/23.
//

import SwiftUI

@main
struct QuickRideApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
