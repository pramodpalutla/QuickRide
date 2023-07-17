//
//  RideRequestView.swift
//  QuickRide
//
//  Created by Sai Palutla on 6/11/23.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideType = .standard
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            // Trip Info View
            
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 2, height: 32)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                VStack {
                    HStack {
                        Text("Current Location")
                            .font(.system(size:16))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(homeViewModel.pickupTime ?? "")
                            .font(.system(size:14, weight: .semibold))
                            .foregroundColor(.gray)
                        
                    }
                    .padding(.bottom, 20)
                    
                    
                    HStack {
                        if let location = homeViewModel.selectedRideLocation {
                            Text(location.title)
                                .font(.system(size:16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text(homeViewModel.dropoffTime ?? "")
                            .font(.system(size:14, weight: .semibold))
                            .foregroundColor(.gray)
                        
                    }
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            // Ride type selection
            Text("RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) { type in
                        VStack(alignment: .leading) {
                            Text(type.description)
                                .font(.system(size:16, weight: .bold))
//                                .foregroundColor(.black)
                            Text(homeViewModel.computeRidePrice(forType: type).toCurrency())
                                .font(.system(size:16, weight: .bold))
//                                .foregroundColor(.black)
                        }
                        .frame(width: 112, height: 60)
                        .foregroundColor(type == selectedRideType ? Color(.white) : Color.theme.primaryTextColor)
                        .background(type == selectedRideType ? Color(.systemBlue) : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            // Payment
            
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 5689")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
        
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Request
            Button {
                homeViewModel.requestTrip()
            } label: {
                Text("REQUEST RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.top, 6)
            }
            
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(12)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
            .environmentObject(LocationSearchViewModel())
    }
}
