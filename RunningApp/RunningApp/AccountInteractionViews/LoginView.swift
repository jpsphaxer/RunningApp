
import Foundation
import SwiftUI
import Firebase

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    @EnvironmentObject var authModel: AuthenticationModel
    
    //temporary to check if user is still logged in so we bypass login screen if user is in
//    var handdleL: AuthStateDidChangeListenerHandle?
    
//    @State var signInErrorMessage : String = ""
//    @State var showContentView : Bool = false
//    @State var showRegisterView : Bool = false
//    @State var showLoginView : Bool = true
//    @State var signInProcessing : Bool = true
//    @Binding var showRegisterView : Bool = false
    
    var body : some View {
            VStack{
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                VStack(spacing: 40) {
                    AuthTextField(image: "envelope",
                                     placeholderText: "Email",
                                     text: $email)
                    
                    AuthTextField(image: "lock",
                                     placeholderText: "Password",
                                     isSecureField: true,
                                     text: $password)
                }
                .padding(.horizontal, 32)
                .padding(.top, 44)
                
                Button(action: {
//                    signInUser(userEmail: username, userPassword: password)
                    authModel.login(withEmail: email, password: password)
                }){
                    // NavigationLink(destination: ContentView(), label: Text("label"))
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:220,height:60)
                        .background(Color(.systemGreen))
                        .cornerRadius(15.0)
                }.onLoad {
                    // Here is where we decide when to push the local notification
                    let reminderManager = ReminderManager(timeHr: 15, timeMinute: 0)
                    
                    // Ask for permission of notifications
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                        if(granted) {
                            reminderManager.triggerLocalNotification(title: "Running App", body: "It's time to run!")
                        }
                    }
                }.padding()
                
//                if showRegisterView{
//                    NavigationLink(destination: RegisterView(showRegisterView: $showRegisterView), isActive: $showRegisterView) { EmptyView() }
//                    //            RegisterView(showRegisterView: $showRegisterView)
//                }
                Text("New User? Click to Register")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.top,20)
                NavigationLink {
                    RegisterView()
                        .navigationBarHidden(true)
                } label: {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(.systemBlue))
                        .cornerRadius(15.0)
                }
                .padding(.bottom, 32)
                .foregroundColor(Color(.systemBlue))
//                Text("New User? Register Below")
//                    .font(.footnote)
//                    .foregroundColor(.black.opacity(0.50))
//                    .padding(.top,20)
//                Button(action: goToRegis){
//                    Text("Register")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 220, height: 60)
//                        .background(Color.red)
//                        .cornerRadius(15.0)
//
//                }.disabled(!username.isEmpty && !password.isEmpty ? false : true)
//
//                    .padding()
                
                
            }
            .navigationBarHidden(true)
            
//        }.navigationBarBackButtonHidden(true)
    }
        
    
    
//    func goToMain(){
//        username = ""
//        password = ""
//        showContentView = true
//    }
//
//    func goToRegis(){
//        username = ""
//        password = ""
//        showRegisterView = true
//    }
    
    
   
    
}






struct LoginView_Preview : PreviewProvider{
    
    static var previews : some View{
        Group{
            LoginView()
        }
    }
}
