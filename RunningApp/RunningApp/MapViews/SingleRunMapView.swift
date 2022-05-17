//
//  SingleRunMapView.swift
//  RunningApp
//
//  Created by Josue Proano on 3/14/22.
//

import Foundation
import SwiftUI
import MapKit



struct SingleRunMapView: UIViewRepresentable {
  
    
    typealias UIViewType = MKMapView
    @State var run : Run
    
    
    func makeUIView(context: Context) -> MKMapView {
        let v = MKMapView(frame: .zero)
        let span = run.calculateSpan(latitudes: run.latitudes, longitudes: run.longitudes)
        let center = run.calculateCenter(latitudes: run.latitudes, longitudes: run.longitudes)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        
        v.setRegion(region, animated: false)
        v.isZoomEnabled = false
        v.isScrollEnabled = false 
        v.layer.cornerRadius = 20.0
        var locationsToRoute : [CLLocationCoordinate2D] = []
        
        for location in run.locations{
            
            if location != nil {
                locationsToRoute.append(location!.coordinate)
            }
        }
        
        let rout = MKPolyline(coordinates: locationsToRoute, count: locationsToRoute.count)
        v.addOverlay(rout)
        
        let startlocation = run.locations[0]!
        let start = MKPointAnnotation()
        start.title = "Start"
        start.coordinate = CLLocationCoordinate2D(latitude: (startlocation.coordinate.latitude), longitude: startlocation.coordinate.longitude)
        v.addAnnotation(start)
        
        let endlocation = run.locations[run.locations.count - 1]!
        let end = MKPointAnnotation()
        end.title = "Finish"
        
        end.coordinate = CLLocationCoordinate2D(latitude: endlocation.coordinate.latitude, longitude: endlocation.coordinate.longitude)
        v.addAnnotation(end)
        
        
        v.delegate = context.coordinator
        
        return v
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SingleRunMapView

        init(_ parent: SingleRunMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 10
            return renderer
          }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation : MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            switch annotation.title!!{
            case "Start":
                annotationView.markerTintColor = .orange
            case "Finish":
                annotationView.markerTintColor = .green
            default:
                annotationView.markerTintColor = UIColor.blue
            }
            
            return annotationView
        }
        
        
    }
    
    func makeCoordinator() -> SingleRunMapView.Coordinator {
        Coordinator(self)
    }
    

    

    
}

