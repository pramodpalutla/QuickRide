//
//  HomeView.swift
//  QuickRide
//
//  Created by Sai Palutla on 5/2/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        QuickRideMapViewRepresentable()
            .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
