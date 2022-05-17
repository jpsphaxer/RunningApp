import SwiftUI
import MapKit
import Foundation
import Firebase
//import FirebaseCore


struct ShowItemView: View {
    var idx: Int
    @EnvironmentObject private var sessionManager : SessionServiceManager
    @EnvironmentObject private var runList: RunList
    @EnvironmentObject private var DBstuff : DBRetrieveManager
    @EnvironmentObject var locationManager: LocationManager
    
    @State var isModal : Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if DBstuff.runs.indices.contains(idx) {
                let run = DBstuff.runs[idx]
                Text("Run #\(idx + 1)")
                Text("Date: " + run.dateStr)
                Text("Duration: \(run.timer.formatted(.number.precision(.significantDigits(3))))")
                    .foregroundColor(.black)
                Text("Distance: \(run.distance.formatted(.number.precision(.significantDigits(3))))")
                //SingleRunMapView(run: run)
                Spacer()
                
            }
        }.onTapGesture {
            isModal = true
        }.sheet(isPresented : $isModal, content: {
            StatsPerRunView(idx: idx).environmentObject(DBstuff)
        })
    }
}




struct ContentView: View {
    
    //this will retrieve the runs of the user?
    //hopefully this will work and add the runs to the list?
    @StateObject var DBstuff: DBRetrieveManager = DBRetrieveManager()
    @State private var date = Date()
    @EnvironmentObject var authModel: AuthenticationModel
    @EnvironmentObject private var runList: RunList
    @ObservedObject private var runManger : RunListManager = RunListManager()
    @ObservedObject private var timer : StopWatch = StopWatch()
    @State private var watch = StopWatch()
    @EnvironmentObject var locationManager: LocationManager
    @State private var distance : Double = 0.0
    @State var showText: Bool = false
//
//    init(){
//        DBstuff.getDataByUserId()
//    }
    
    
    var body: some View {
//        Group {
//            if authModel.userSession == nil {
//                LoginView()
//            } else {
            mainContent
//            }
        }
//    }
    
    
    var mainContent: some View {
        TabView{
            VStack{
                
                //MapView()
                //  .frame(width: 350, height: 250, alignment: .center)
                WatchView().environmentObject(runManger)
                
            }.tabItem{Label("Run", systemImage: "figure.walk")}
                .navigationBarHidden(true).environmentObject(timer)
           
            VStack{
           
                HStack{
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                        .onChange(of: date, perform: {value in date; retrieveD()})
                        .datePickerStyle(.graphical)
                        .background(Color.gray.opacity(0.2), in : RoundedRectangle(cornerRadius: 20))
                        //.frame(width:200,height:200)
                        .padding()
                    
                }
                GeometryReader { geometry in
                List(DBstuff.runs.startIndex..<DBstuff.runs.count,id:\.self){ i in
                    ShowItemView(idx: i).environmentObject(DBstuff)

                }
            }.frame(maxHeight: .infinity)
            }.onAppear(){retrieve()}
                
            .navigationBarHidden(true)
            
            .tabItem{Label("Calendar/Stats", systemImage: "calendar")}
            
            VStack{
                ProfileView(showText: $showText).onAppear(){showText = true}
            }.tabItem{Label("Profile", systemImage: "person.crop.square")}
            
        }.onAppear(){
            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().barTintColor = UIColor.gray//.opacity(0.2)
        }
    }
    
    func retrieveD(){
        

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM d, yyyy"
        dateFormater.timeZone = TimeZone(abbreviation: "EST+0:00")
        //print(date)
        
    
        let dates = dateFormater.string(from: date)
        //print(dates)
        var par = dateFormater.date(from: dates)
        //par = Calendar.current.date(bySetting: .minute, value: 0, of: par!)
        //print("date par")
        //print(par!)
        DBstuff.singleDateFilter(dateC: par!)
        //print(DBstuff.runs.count)
        
    }
    
    func retrieve(){
        DBstuff.getDataByUserId()
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

