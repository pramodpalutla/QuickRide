//
//  HomeView.swift
//  QuickRide
//
//  Created by Sai Palutla on 5/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showLocationSearchView = false
    var body: some View {
        ZStack(alignment: .top){
            QuickRideMapViewRepresentable()
                .ignoresSafeArea()
            
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            } else {
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                        
                    }

            }
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
