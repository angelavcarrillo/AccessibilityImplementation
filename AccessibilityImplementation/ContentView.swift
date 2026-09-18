//
//  ContentView.swift
//  AccessibilityImplementation
//
//  Created by Angela on 7/30/26.
//

import SwiftUI
import MapKit
import CoreLocation

@Observable
class WiFiFinderManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    var region: MKCoordinateRegion = MKCoordinateRegion()
    var wifiSpots: [MKMapItem] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        
       
        let center = userLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        self.region = MKCoordinateRegion(center: center, span: span)
        
        searchForWiFi(near: center)
        
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    private func searchForWiFi(near coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "wifi"
        request.naturalLanguageQuery = "Wifi"
        request.naturalLanguageQuery = "Wi-Fi"
     
      
        request.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response else {
                print("Error searching for Wi-Fi: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
        
            DispatchQueue.main.async {
                self?.wifiSpots = response.mapItems
            }
        }
    }
}
struct ContentView: View {
    @State private var task = ["Buy groceries", "Call mom"]
    @State private var finderManager = WiFiFinderManager()
        
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
  
    @State private var newTask: String = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                
                HStack{
                    
                    TextField("Enter a new task",text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accessibilityValue(newTask)
                    
                    Button("add"){
                        if !newTask.isEmpty{
                            task.append(newTask)
                            UIAccessibility.post(notification: .announcement, argument: "Task added \(newTask)")
                            newTask = ""
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .accessibilityLabel(Text("Add new Task"))
                    
                    
                    
                    
                }
                .padding()
                //Spacer()
                Map(position: $cameraPosition) {
                                UserAnnotation()
                                
                                //FROP DA PINS
                                ForEach(finderManager.wifiSpots, id: \.self) { spot in
                                    Annotation(spot.name ?? "Wi-Fi Hotspot", coordinate: spot.placemark.coordinate) {
                                        Image(systemName: "wifi")
                                            .font(.system(size: 14, weight: .bold))
                                            .padding(8)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 3)
                                    }
                                }
                            }
                            .frame(height:200)
                            .mapControls {
                                MapUserLocationButton()
                                MapCompass()
                            }
                            
                
                List(finderManager.wifiSpots, id: \.self) { spot in
                               VStack(alignment: .leading) {
                                   Text(spot.name ?? "Unknown Wi-Fi")
                                       .font(.headline)
                                   Text(spot.placemark.title ?? "")
                                       .font(.subheadline)
                                       .foregroundColor(.gray)
                               }
                           }
                           .frame(height: 100)
                
                
                List{
                    ForEach(task, id:\.self){
                    
                    task in
                        Text(task)
                            .font(.body)
                            .accessibilityHint(Text("Swipe left to delete"))
                }
                    .onDelete{
                        indexSet in
                        task.remove(atOffsets: indexSet)
                    }
                }
                
                       }
                       .onAppear {
                           finderManager.requestLocationPermission()
                       }
                       .navigationTitle(Text("My Tasks"))
                       
            
            
            
            
                    }
                    
               
            }
            
            
        }
    


#Preview {
    ContentView()
}
