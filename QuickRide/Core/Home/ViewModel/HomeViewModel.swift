//
//  HomeViewModel.swift
//  QuickRide
//
//  Created by Sai Palutla on 7/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var drivers = [User]()
    private let service = UserService.shared
    private var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    // Location search properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedRideLocation: RideLocation?
    @Published var pickupTime: String?
    @Published var dropoffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        fetchUser()
        
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    // MARK: - Fetching User
    
   func fetchDrivers() {
       Firestore.firestore().collection("users")
           .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
           .getDocuments { snapshot, _ in
               guard let documents = snapshot?.documents else { return }
               let drivers =  documents.compactMap({ try? $0.data(as: User.self)})
               self.drivers = drivers
               
           }
       
    }
    
    func fetchUser() {
        service.$user
            .sink { user in
                self.currentUser = user
                guard let user = user else { return }
                guard user.accountType == .passenger else { return }
                self.fetchDrivers()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Passenger API

extension HomeViewModel {
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedRideLocation else { return }
        let dropoffGeopoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude,
                                      longitude: currentUser.coordinates.longitude)
        
        getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark = placemark else { return }
            
            let trip = Trip(id: NSUUID().uuidString,
                            passengerUid: currentUser.uid,
                            driverUid: driver.uid,
                            passengerName: currentUser.fullname,
                            driverName: driver.fullname,
                            passengerLocation: currentUser.coordinates,
                            driverLocation: driver.coordinates,
                            pickupLocationName: placemark.name ?? "Current Location",
                            dropoffLocationName: dropoffLocation.title,
                            pickupLocationAddress: "1 Campus Dr Allendale",
                            pickupLocation: currentUser.coordinates,
                            dropoffLocation: dropoffGeopoint,
                            tripCost: 50.0
            )
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("DEBUG: did upload trip to firestore")
            }
        }
        
    }
}


// MARK: - Driver API

extension HomeViewModel {
    
}

// MARK: - LocationSearchHelpers

extension HomeViewModel {
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedRideLocation = RideLocation(title: localSearch.title, coordinate: coordinate)
                print("DEBUG: Location coordinate \(coordinate)")
            case .saveLocation(let viewModel):
                print("DEBUG: Saved location coordinates are \(coordinate)")
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let savedLocation = SavedLocation(title: localSearch.title,
                                                  address: localSearch.subtitle,
                                                  coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey : encodedLocation
                ])
            }
        }
        
        
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = self.selectedRideLocation?.coordinate else { return 0.0 }
        guard let userLocation = self.userLocation else { return 0.0 }
        
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let tripDistanceInMeters = userLoc.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
        
    }
    
    
    func getDestinationRoute (from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark( coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
            
        }
        
    }
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropoffTime = formatter.string(from: Date() + expectedTravelTime)
    }
    
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
