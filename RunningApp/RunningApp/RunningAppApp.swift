//
//  RunningAppApp.swift
//  RunningApp
//
//  Created by Josue Proano on 3/7/22.
//

import SwiftUI
import Firebase
//import FirebaseCore

@main
struct RunningAppApp: App {
    
    @StateObject var runList: RunList = RunList()
    @StateObject var sessionManager = SessionServiceManager()
    @StateObject var authModel = AuthenticationModel()
    
    init(){
        //FirebaseConfiguration.shared.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        //Database.database().isPersistenceEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView{
                if authModel.userSession == nil {
                    LoginView()
                } else {
                    ContentView()
                }
//                switch sessionManager.state {
//                case .loggedIn:
//                    ContentView()
//                        .environmentObject(sessionManager)
//                        .environmentObject(runList)
//                case .loggedOut:
//                    LoginView().environmentObject(runList)
//                }
            }
            .environmentObject(authModel)
            //LoginView().environmentObject(runList)
            //ContentView().environmentObject(runList)
        }
    }
}
