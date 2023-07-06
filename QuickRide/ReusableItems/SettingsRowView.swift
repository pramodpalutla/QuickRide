//
//  SettingsRowView.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/5/23.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(Color.theme.primaryTextColor)
            
            
        }
        .padding(4)
    }
    
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "house.circle.fill", title: "Home", tintColor: Color(.systemGray))
    }
}
