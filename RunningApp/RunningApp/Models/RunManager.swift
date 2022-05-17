
import Foundation
import CoreLocation
import MapKit
import FirebaseDatabase
import FirebaseAuth



struct latlong : Codable {
    private var latitude: Double
    private var longitude: Double
    
    init ( latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toArray() -> [Double]{
        
        var subarr : [Double] = []
        
        subarr.append( self.latitude)
        subarr.append( self.longitude)
        
        return subarr
    }
    
    
}





struct RunDetails : Codable, Identifiable{
    var id : String?
    var uid: String
    var timer : Double
    var distance : Double = 0.0
    
    var date : (String){
        let dat = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dates = formatter.string(from: dat)
        return dates
        
    }
 
   
    

    
    init(id: String? = nil,uid: String,distance: Double, timer: Double){
        self.id = id
        self.uid = uid
        self.distance = distance
        self.timer = timer
        
        // self.coordinates = coordinates
        
    }
    
    
    var dict: NSDictionary? {
        if let idStr = id {
            //print(idStr)
            let d = NSDictionary(dictionary: ["id":idStr,"uid": uid ,"distance" : distance, "timer": timer, "date":date])
            return d
            
        }
        
        return nil
        
    }
    
    
    static func fromDict(_ d: NSDictionary) -> RunDetails? {
        //        guard let date = d["date"] as? Date else { return nil }
        guard let distance = d["distance"] as? Double else { return nil }
        guard let timer = d["timer"] as? Double else { return nil }
        guard let uid = d["uid"] as? String else {return nil}
        //guard let date = d["date"] as? Date else {return nil}
        //guard let coordA = d["coords"] as? NSArray else {return nil}
        return RunDetails(id: d["id"] as? String,uid: uid, distance: distance, timer: timer)
    }
    
    

    
}


class RunListManager: ObservableObject {
    @Published var entries: [String:RunDetails] = [:]
    
    private let user = Auth.auth().currentUser?.uid
    
    init() {
        let rootRef = Database.database().reference()
        rootRef.getData { err, snapshot in
            DispatchQueue.main.async {
                for child in snapshot.children {
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSDictionary,
                           let de = RunDetails.fromDict(val),
                           let id = de.id { self.entries[id] = de }
                    }
                }
            }
        }
        rootRef.observe(.childAdded) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = RunDetails.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
        rootRef.observe(.childRemoved) { snapshot in
            self.entries.removeValue(forKey: snapshot.key)
        }
        rootRef.observe(.childChanged) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let de = RunDetails.fromDict(v),
               let id = de.id { self.entries[id] = de }
        }
    }
    
    func addEntry(entry: inout RunDetails, locations: NSArray) {
        let rootRef = Database.database().reference().child("Runs")
        let childRef = rootRef.childByAutoId()
        entry.id = childRef.key
        //entry.dict!["coord"] = locations
        if let val = entry.dict {
            
            childRef.setValue(val)
            childRef.child("coords").setValue(locations)
        }
    }
    
    func delEntry(id: String) {
        entries.removeValue(forKey: id)
        let rootRef = Database.database().reference()
        rootRef.child(id).removeValue()
    }
    
    
    
}




