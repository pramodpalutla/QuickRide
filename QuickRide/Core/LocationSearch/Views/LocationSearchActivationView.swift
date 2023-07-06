//
//  LocationSearchActivationView.swift
//  QuickRide
//
//  Created by Sai Palutla on 5/15/23.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
                .padding(.horizontal)
            Text("What's your destination?")
                .foregroundColor(.black)
                Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black, radius: 6)
        )
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
