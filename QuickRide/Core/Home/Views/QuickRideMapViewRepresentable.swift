//
//  QuickRideMapViewRepresentable.swift
//  QuickRide
//
//  Created by Sai Palutla on 5/2/23.
//

import Foundation
import SwiftUI
import MapKit

struct QuickRideMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
//    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: MAP STATE IS \(mapState)")
        
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedRideLocation?.coordinate {
                print("DEBUG: Selected coordinate in mapview \(coordinate)")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        }
        
        //        if mapState == .noInput {
        //            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        //        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension QuickRideMapViewRepresentable {
    class MapCoordinator:NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        let parent: QuickRideMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        
        init(parent :QuickRideMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .purple
            polyline.lineWidth = 4.5
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(named: "car")
                let size = CGSize(width: 64, height: 64)
                view.frame = CGRect(origin: .zero, size: size)
                return view
            } else {
                return nil
            }
        }
        
        // MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
//            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userlocation = self.userLocationCoordinate else { return }
            self.parent.homeViewModel.getDestinationRoute(from: userlocation, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        

        
        func clearMapViewAndRecenterOnUserLocation () {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays (parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion (currentRegion, animated: true)
            }
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0)})
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
