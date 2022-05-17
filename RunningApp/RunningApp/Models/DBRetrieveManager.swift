

import Foundation
import CoreLocation
import MapKit
import FirebaseDatabase
import FirebaseAuth



class DBRetrieveManager : ObservableObject {
    
    @Published var runs : [Run] = [Run]()
    private var ref : DatabaseReference! = Database.database().reference()
    private var user = Auth.auth().currentUser?.uid
    
    init() {
        if let check = Auth.auth().currentUser {
            user = check.uid
        }
    }
    
    func getDataByUserId(){
        
        self.runs = []
        let runsRef = ref.child("Runs")
        
        runsRef.observeSingleEvent(of: .value){
            (snapshot) in
            if snapshot.exists() {
                
                for child in snapshot.children{
                    
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String:AnyObject]
                    
                    if dict["uid"] as! String == self.user {
                        
                        let dist = dict["distance"] as! Double
                        let timer = dict["timer"] as! Double
                        let cords = dict["coords"] as! Array<Array<Double>>
                        let date = dict["date"] as! String
                        
                        //print(date)
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "MMM d, yyyy"
                        
                        let dates = dateFormater.date(from: date)
                        //print(dates)
                        
                        
                        var locs : [CLLocation?] = []
                        
                        for cord in cords {
                            
                            let point = CLLocation(latitude: cord[0], longitude: cord[1])
                            locs.append(point)
                            
                            
                        }
                        var run = Run(distance: dist, timer: timer, locations: locs)
                        run.get_lat_lon()
                        run.date = dates!
                        self.runs.append(run)
                        
                    }
                }
            }
        }
    }
    
    
    func singleDateFilter (dateC : Date){
        self.runs = []
        let runsRef = ref.child("Runs")
        
        runsRef.observeSingleEvent(of: .value){
            (snapshot) in
            if snapshot.exists() {
                
                for child in snapshot.children{
                    
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String:AnyObject]
                    
                    if dict["uid"] as! String == self.user {
                        
                        let dist = dict["distance"] as! Double
                        let timer = dict["timer"] as! Double
                        let cords = dict["coords"] as! Array<Array<Double>>
                        let date = dict["date"] as! String
                        
                        //print(date)
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "MMM d, yyyy"
                        dateFormater.timeZone = TimeZone(abbreviation: "EST+0:00")
                        let dates = dateFormater.date(from: date)
                        //print(dates!)
                        
                  
                        var locs : [CLLocation?] = []
                        
                        for cord in cords {
                            
                            let point = CLLocation(latitude: cord[0], longitude: cord[1])
                            locs.append(point)
                            
                            
                        }

                        if dates! == dateC{
                            //if calendarDate.day == calendarDate2.day{
                            
                            //print("dates \(dates!) dateC \(dateC)")
                            //print("helloooooo")
                            var run = Run(distance: dist, timer: timer, locations: locs)
                            run.get_lat_lon()
                            run.date = dates!
                            self.runs.append(run)
                        }
                    }
                }
            }
        }
        
    }
    
    
}

