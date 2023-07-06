//
//  SideMenuOptionView.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/2/23.
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel
    var body: some View {
        HStack {
            Image(systemName: viewModel.imageName)
                .font(.title2)
                .imageScale(.medium)
            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))
            Spacer()
        }
        .foregroundColor(Color.theme.primaryTextColor)
    }
}

struct SideMenuOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(viewModel: .trips)
    }
}
