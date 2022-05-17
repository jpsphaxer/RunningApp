import Foundation
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase
import SwiftUI

struct Run{ // maybe add Hashable protocol
    
    var date : Date = Date()
    private var dateFormat : DateFormatter = DateFormatter()
    var distance : Double
   // var start_time : Int
    var timer : Double
    var locations : [CLLocation?]
    var latitudes : [CLLocationDegrees] = []
    var longitudes : [CLLocationDegrees] = []
    
    
    var dateStr : String {
        print("run date")
        print(self.date)
        dateFormat.dateFormat = "MMM d, yyyy"
        dateFormat.timeZone = TimeZone(abbreviation: "EST+0:00")
        print(dateFormat.string(from:date))
        return dateFormat.string(from: date)
    }


    init(distance : Double, timer: Double, locations: [CLLocation?]){
        self.distance = distance
        self.timer = timer
        self.locations = locations
    }
    

    
}

extension Run{
    
    
    func runLocations(locations: [CLLocation?]) -> [[Double]] {
        
        var locs : [[Double]] = []
        
        for location in locations{
            
            if let loc = location {
                
                let cord = latlong(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude).toArray()
                locs.append(cord)
                
            }
            
        }
        
        return locs
        
    }
    
    
    
    mutating func get_lat_lon() {
        
        var latitudes: [CLLocationDegrees] = []
        var longitudes: [CLLocationDegrees] = []
        for location in self.locations {
            // Only include coordinates where neither latitude nor longitude is nil
            if let currentLatitude = location?.coordinate.latitude {
                if let currentLongitude = location?.coordinate.longitude {
                    latitudes.append(currentLatitude)
                    longitudes.append(currentLongitude)
                }
            }
        }
        self.longitudes = longitudes
        self.latitudes = latitudes
    }
    
    
    func setupCoordinates(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        var locationsCount = latitudes.count
        if (latitudes.count > longitudes.count) {
            locationsCount = longitudes.count
        }
        
        for index in 0..<locationsCount {
            coordinates.append(CLLocationCoordinate2DMake(latitudes[index], longitudes[index]))
        }
        
        return coordinates
    }
    
    func calculateCenter(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationCoordinate2D {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            let latitudeMidpoint = (maxLatitude + minLatitude)/2
            let longitudeMidpoint = (maxLongitude + minLongitude)/2
            return CLLocationCoordinate2D(latitude: latitudeMidpoint, longitude: longitudeMidpoint)
        }
        else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
    
    func calculateSpan(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationDegrees {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            // Add 10% extra so that there is some space around the map
            let latitudeSpan = (maxLatitude - minLatitude) * 1.1
            let longitudeSpan = (maxLongitude - minLongitude) * 1.1
            return latitudeSpan > longitudeSpan ? latitudeSpan : longitudeSpan
        }
        else {
            return 0.1
        }
    }
    
    
}

enum GroupMode {
    case byWeek
    case byMonth
    case byYear
}


class RunList: ObservableObject {
    
    @Published private var _runs: [Run]
    
    init() {
        _runs = []
    }
    
    func addRun(run : Run) {
        _runs.append(run)
    }
    
    func updateArr(runs : [Run]){
        
        _runs = runs
    }
    
    func runs() -> [Run] {
        return _runs
    }
    
    func quickSort(arr: [Run], l: Int, r: Int) -> [Run] {
        // copy the given list since it is a let variable
        var res: [Run] = Array()
        res.append(contentsOf: arr)
        
        if(l < r) {
            // partition
            let pivot = res[r].date
            var i = l - 1
            for j in l...r - 1 {
                if(res[j].date < pivot) {
                    i += 1
                    let temp = res[i]
                    res[i] = res[j]
                    res[j] = temp
                }
            }
            
            let p = i + 1
            let temp2 = res[p]
            res[p] = res[r]
            res[r] = temp2
            
            // recursion
            res = quickSort(arr: res, l: l, r: p - 1)
            res = quickSort(arr: res, l: p + 1, r: r)
        }
        
        return res
    }
    
    func sortByDate()  -> [Run]{
        // copy original list in res
        var res: [Run] = Array()
        var size = 0
        for r in _runs {
            res.append(r)
            size += 1
        }
        
        // quicksort
        return quickSort(arr: res, l: 0, r: size)
    }
    
    func group(mode: GroupMode) -> [[Run]] {
        let sortedRun = sortByDate()
        var res: [[Run]] = Array()
        
        switch mode {
        case .byWeek:
            var weekNum = 0
            
            for r in sortedRun{
                let df = DateFormatter()
                df.dateFormat = "EEEE"
                let dayOfTheWeek = df.string(from: r.date)
                
                if(dayOfTheWeek == "Monday") {
                    if(weekNum != 0) {
                        weekNum += 1
                    }
                    res[weekNum].append(r)
                }else {
                    res[weekNum].append(r)
                }
            }
            
            return res
        case .byMonth:
            var monthNum = 0
            
            for r in sortedRun{
                let calendar = Calendar.current
                let components = calendar.dateComponents([.month], from: r.date)
                let month = components.month
                
                if(monthNum == 0) {
                    res[0].append(r)
                }else if(month != calendar.dateComponents([.month], from: res[monthNum][0].date).month) {
                    monthNum += 1
                    res[monthNum].append(r)
                }else {
                    res[monthNum].append(r)
                }
            }
            
            return res
        case .byYear: return res
            var yearNum = 0
            
            for r in sortedRun{
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year], from: r.date)
                let year = components.year
                
                if(yearNum == 0) {
                    res[0].append(r)
                }else if(year != calendar.dateComponents([.year], from: res[yearNum][0].date).year) {
                    yearNum += 1
                    res[yearNum].append(r)
                }else {
                    res[yearNum].append(r)
                }
            }
            
            return res
        }
    }
    
}

