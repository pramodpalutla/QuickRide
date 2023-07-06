//
//  RideType.swift
//  QuickRide
//
//  Created by Sai Palutla on 6/18/23.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    
case standard
case premium
case comfort
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .standard: return "Standard"
        case .premium: return "Premium"
        case .comfort: return "Comfort"
            
        }
        
    }
    
    var imageName: String {
        switch self {
        case .standard: return "standard"
        case .premium: return "premium"
        case .comfort: return "comfort"
            
        }
    }
    
    var baseFare: Double {
        switch self {
        case .standard: return 5
        case .premium: return 20
        case .comfort: return 10
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .standard: return distanceInMiles * 1.5 + baseFare
        case .premium: return distanceInMiles * 2.0 + baseFare
        case .comfort: return distanceInMiles * 1.75 + baseFare
        }
    }
    
    
}
