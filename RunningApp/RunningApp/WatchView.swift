import SwiftUI
import CoreLocation

struct WatchView: View {
    
    @EnvironmentObject private var runList: RunList
    @EnvironmentObject private var timer : StopWatch
    @EnvironmentObject private var runManger : RunListManager
    @State private var start : Bool = true
    @State private var isTaped : Bool = false
    @State private var button : String = "Start"
    @State private var color : Color = .green
    @State private var list = RunList()
    @StateObject var locationManager = LocationManager.locationManager
    //private var locManager : LocationManager = LocationManager()
    
    
    private var startlocation : CLLocation!
    private var endLocation : CLLocation!
    
    
    
    var body : some View {
        
        VStack{
            
            MapView(started:$isTaped)
                .frame(maxWidth: .infinity, maxHeight: 350)
            
            //var v = locManager.currSpeed
            Text("Speed: \((locationManager.currSpeed < 0) ? "0.00" : String(locationManager.currSpeed))")
            Text("Distance: \(locationManager.totalDistance)")
            Text(self.timer.timeString).font(.system(size : 20)).padding().offset(y:10)

            HStack{
                
                if isTaped == false {
                    // if tapped once then disable tapping again
                }
                
                Button(action: {if start {
                    star()
                } else {
                    stop()
                }
                }){
                    ZStack{
                        Circle()
                            .fill(color)
                            .frame(width: 100, height: 100)
                        Text(button)
                            .foregroundColor(Color.white)
                    }.padding()
                }
            }
        }
        
    }
    

    
    
    func star(){
        if start {
            //speed = locManager.currSpeed
            button = "Stop"
            color = .red
        }
        self.timer.start()
        self.isTaped.toggle()
        self.start.toggle()
        
    }
    
    func stop()  {
        self.timer.stop()
        self.start.toggle()
        self.isTaped.toggle()
        
        //runList.addRun(run:Run(distance: 5.0, timer: timer.secs, locations: locManager.coords,region: locManager))
        button = "Start"
        color = .green 
    }
}

