//
//  LocationManager.swift
//  RunningApp
//
//  Created by Josue Proano on 3/8/22.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject {

    
    static let locationManager = LocationManager()
    private let locationManager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    @Published var runLocations: [CLLocation?] = []
    @Published var runDistances : [CLLocationDistance?] = []
    @Published var totalDistance: CLLocationDistance = 0.0
    @Published var currSpeed : CLLocationSpeed = 0.0

    override init() {
        //initializer of parent
        super.init()
        //delegate set to ourself. when location manager looking for other services comes back to us
        locationManager.delegate = self
        // sets accuracy for location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //request authorization when app in use only when app runs
        locationManager.requestWhenInUseAuthorization()
       //set activity type
        locationManager.activityType = .fitness
        locationManager.startUpdatingLocation()
        
    }
    
    
    func startRun() {
        
        let locationsCount = runLocations.count
        
        if (locationsCount > 1){
            let locToKeep = runLocations[locationsCount - 1]
            runLocations.removeAll()
            runLocations.append(locToKeep)
        }
        
        runDistances.removeAll()
        totalDistance = 0.0
    }

}

//extends to implement the delegate
extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        lastLocation = location
        runLocations.append(lastLocation)
        
        //print(currSpeed!)
        let locationsCount = runLocations.count
        if (locationsCount > 1){
            
            self.currSpeed = location.speed
            //print(currSpeed)
//            if let lastLocation = runLocations.last {
//                let delta = location.distance(from: lastLocation!)
//                totalDistance = totalDistance + delta
//            }
            let newDist = lastLocation?.distance(from:( runLocations[locationsCount - 2] ?? lastLocation)!)
            runDistances.append(newDist)
            totalDistance += newDist ?? 0.0
                    
        }
        //adding distance stuff later.        
    }
    
}









//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if startLocation == nil {
//            startLocation = locations.first
//        } else if let location = locations.last {
//            runDistance += endLocation.distance(from: location)
//
//            let newLocation = Locations(lat: Double(endLocation.coordinate.latitude), long: Double(endLocation.coordinate.longitude))
//            //coordLocations.insert(newLocation, at: 0)
//            coordLocations.append(newLocation)
//            print(coordLocations)
//
//            //self.distanceLabel.text = self.runDistance.meterToMiles().toString(places: 2)
//
//            //if timeElapsed > 0 && runDistance > 0 {
//                //paceLabel.text = computePace(time: timeElapsed, miles: runDistance.meterToMiles())
//           // }
//
//        }
//        endLocation = locations.last
//    }
//}
