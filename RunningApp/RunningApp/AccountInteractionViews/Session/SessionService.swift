//
//  SessionService.swift
//  RunningApp
//
//  Created by Josue Proano on 3/29/22.
//

import Foundation
import FirebaseAuth

enum SessionState {
    case loggedIn
    case loggedOut
}

//dont know if this is necessary but this will technically setup a way to handle
//user sessions
protocol SessionServices {
    var state : SessionState { get}
    func logout ()
}


//Session manager will handle if user is logged in and also logged out processes
final class SessionServiceManager: ObservableObject, SessionServices {
    
    @Published var state : SessionState = .loggedOut
    @Published var UID : String = ""
    
    private var handler : AuthStateDidChangeListenerHandle?
    
    
    init() {
        setupAuthManager()
    }
    
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    
}

private extension SessionServiceManager{
    
    func setupAuthManager(){
        
        //handles the communication to FB so we can get user is logged in?
        handler = Auth.auth().addStateDidChangeListener{[weak self] res, user in
            guard let self = self else {return}
            //will change the state if user is logged in or not based on if user is nil or not
            self.state = user == nil ? .loggedOut : .loggedIn
            
            
            //this part should handle something or a function to use when user is logged in so we can get user info?
            // maybe this works maybe not ? for now just printing userid
            if let uid = user?.uid {
                //do something here
                self.UID = uid
                print(uid)
            }
            
        }
        
        
        
        
    }
}
