
import Foundation
import SwiftUI
import Firebase



struct ProfileView : View {
    
    @EnvironmentObject var viewModel: AuthenticationModel
    @Binding var showText: Bool
    var body : some View {
        
            VStack{
                if let user = viewModel.currentUser {
                    if showText {
                        Text("Full Name: \(user.fullname)\n\nUsername: \(user.username)\n\nEmail: \(user.email)\n\nHeight: \(user.height)\n\nWeight: \(user.weight)")
                            .multilineTextAlignment(.leading)
                            .padding()
                            .font(.title)
                            .fixedSize()
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration:6.0)))
                   }
                   if !showText {
                       Text("This is you").font(.title).fixedSize()
                           .transition(AnyTransition.opacity.animation(.easeInOut(duration:3.5)))
                   }
                   
                }
                
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Signout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:220,height:60)
                        .background(Color(.systemRed))
                        .cornerRadius(15.0)
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)

            }
    }
    
//    @EnvironmentObject private var sessionService : SessionServiceManager
//
//    @State var didSignOut : Bool = false
//    @Binding var showContentView : Bool
//
//    var body : some View {
//
//
//
//            VStack{
////
////
////                NavigationLink(destination: LoginView(),isActive: $didSignOut){
////                    EmptyView()
////                }
//
//                Image("anonymous")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(Circle())
//                    .frame(width: 200.0, height: 200.0, alignment: .center)
//                    .shadow(radius:25.0)
//                    .overlay(Circle().stroke(Color.gray.opacity(20.0),lineWidth: 10.0))
//                    //.border(.gray, width:10.0).clipShape(Circle())
//
//
//                Text("Anonymous")
//                    .font(.headline)
//                    .padding()
//
//                Text("Maybe User Email")
//                Text("UserId:")
//                Text("\(sessionService.UID)")
//                Text("We might Be able To user this info if we incoorporate HealthKit? (looking in this)")
//                    .font(.footnote)
//
//                Button(action:{sessionService.logout()}){
//                    Text("Log Out")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width:220,height:60)
//                        .background(.red)
//                        .cornerRadius(15.0)
//                }
//                Text("This Will Display User Profile Data")
//
//            }
        
        
        
    }


//    func signOutUser() {
//        //didSignOut = true
//        let firebaseAuth = Auth.auth()
//
//        do{
//            try firebaseAuth.signOut()
//            showContentView = false
//            didSignOut = true
//        } catch let signOutError as NSError{
//            print("Error Can't Leave Area 51: %@",signOutError)
//            didSignOut = false
//
//        }
//    }




//struct ProfileView_Preview : PreviewProvider{
//    
//    static var previews : some View{
//        Group{
//            ProfileView()
//        }
//    }
//}
