

import Foundation
import CoreLocation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
 
    @StateObject var DBstuff: DBRetrieveManager = DBRetrieveManager()
    
    @EnvironmentObject private var authModel : AuthenticationModel
    @EnvironmentObject private var sessionService : SessionServiceManager
    @EnvironmentObject private var timer : StopWatch
    @EnvironmentObject private var runList: RunList
    @EnvironmentObject private var runManger : RunListManager
    @StateObject var locationManager = LocationManager.locationManager
    typealias UIViewType = MKMapView
    @Binding var started : Bool
      
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
        
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    

    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        

        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(userLatitude)!, CLLocationDegrees(userLongitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center:location,span:span)
        
        uiView.setRegion(region, animated: true)
        
        
        if started {
            if (!startedRunning){
                startedRunning = true
                locationManager.startRun()
            }
        
        
            let locationsCount = locationManager.runLocations.count
            
            switch locationsCount {
            case _ where locationsCount < 2:
                break
            default:
                var locationsToRoute: [CLLocationCoordinate2D] = []
                for location in locationManager.runLocations{
                    if(location != nil){
                        locationsToRoute.append(location!.coordinate)
                    }
                }
                
                if(locationsToRoute.count > 1 && locationsToRoute.count <= locationManager.runLocations.count){
                    let route = MKPolyline(coordinates: locationsToRoute, count: locationsToRoute.count)
                    uiView.addOverlay(route)
                }
                
                
            }
            uiView.delegate = context.coordinator
        }else {
            if (startedRunning) {
                startedRunning = false
     
                let overlays = uiView.overlays
                uiView.removeOverlays(overlays)
                
                var run = Run(distance: locationManager.totalDistance, timer: timer.secs, locations: locationManager.runLocations)
                let locations = run.runLocations(locations: locationManager.runLocations)
                //print(locations)
                //print(sessionService.UID)
                if let user = authModel.currentUser {
                    var dbRun = RunDetails(id: user.id ,uid: user.id!, distance: locationManager.totalDistance, timer: timer.secs)
                    runManger.addEntry(entry: &dbRun, locations: locations as NSArray)
                }
                run.get_lat_lon()
                

                
                //retrieve runs from DB
                //DBstuff.getDataByUserId()
                //let runsFromDB = DBstuff.runs
                //print(runsFromDB)
                // this updates runLis using runsFromDatabase
                //runList.updateArr(runs: runsFromDB)
            }
        }
 
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
              renderer.strokeColor = .blue
              renderer.lineWidth = 10
              return renderer
          }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }

}


var startedRunning = false


