//
//  SideMenuView.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/1/23.
//

import SwiftUI

struct SideMenuView: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
            VStack(spacing: 48) {
                // header view
                VStack(alignment: .leading, spacing: 32) {
                    // User info
                    HStack {
                        Image("profile-photo")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullname)
                                .font(.system(size: 16, weight: .semibold))
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.7)
                        }
                    }
                    
                    // Become a driver
                    VStack (alignment: .leading, spacing: 16) {
                        Text("Do more with your account")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        HStack {
                            Image(systemName: "dollarsign.square")
                                .font(.title2)
                                .imageScale(.medium)
                            Text("Make Money Driving")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(6)
                            
                        }
                        
                    }
                    Rectangle()
                        .frame(width: 296, height: 0.75)
                        .opacity(0.7)
                        .foregroundColor(Color(.separator))
                        .shadow(color: .black.opacity(0.7), radius: 4)
                
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                
                // option view
                VStack {
                    ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                        NavigationLink(value: viewModel) {
                            SideMenuOptionView(viewModel: viewModel)
                                .padding()
                        }
                    }
                }
                .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                    switch viewModel {
                    case .trips:
                        Text("Trips")
                    case .wallet:
                        Text("Wallet")
                    case .settings:
                        SettingsView(user: self.user)
                    case .messages:
                        Text("Messages")
                    }
                }
                
                Spacer()
                
                
            }
            .padding(.top, 32)
        

    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView(user: User(fullname: "John Doe", email: "johndoe@gmail.com", uid: "", accountType: .driver))
        }
    }
}
