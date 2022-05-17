//
//  User.swift
//  RunningApp
//
//  Created by To Yin Yu on 3/31/22.
//

import Firebase
import FirebaseDatabase

struct User: Identifiable, Decodable {
    var id: String?
    let username: String
    let fullname: String
    let email: String
    let height: String
    let weight: String
    
    static func fromUser(_ d: [String:Any]) -> User? {
        guard let username = d["username"] as? String else { return nil }
        guard let fullname = d["fullname"] as? String else { return nil }
        guard let email = d["email"] as? String else { return nil }
        guard let height = d["height"] as? String else { return nil }
        guard let weight = d["weight"] as? String else { return nil }
        return User(id: d["uid"] as? String, username: username, fullname: fullname, email: email, height: height, weight: weight)
    }
}


struct UserService{
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        let ref = Database.database().reference(withPath: "Users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String:Any],
               let user = User.fromUser(userDict),
               let _ = user.id {
                completion(user)
            }
        })
    }
}
