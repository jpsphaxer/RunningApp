//
//  StatsPerRunView.swift
//  RunningApp
//
//  Created by Josue Proano on 3/15/22.
//

import Foundation
import MapKit
import SwiftUI


struct StatsPerRunView: View {
    
    @State var idx : Int
    
    @EnvironmentObject private var runList: RunList
    @EnvironmentObject private var DBstuff : DBRetrieveManager
    
    
    
    var body : some View {
        
        

            
            if DBstuff.runs.indices.contains(idx){

                let run = DBstuff.runs[idx]
                Text("Index: \(idx)")
                Text("Duration: \(run.timer)")
                Text("Distance: \(run.distance)")

                SingleRunMapView(run: run)
                Spacer()
            }
               
        }
        
        
      
     
    


}


