import Foundation
import SwiftUI
import Firebase

//let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct RegisterView: View {
    
    @State private var email:String = ""
    @State private var username:String = ""
    @State private var fullname:String = ""
    @State private var password:String = ""
    @State private var height:String = ""
    @State private var weight:String = ""
//    @State var action : Bool = false
    @EnvironmentObject var authModel: AuthenticationModel
    
    var body : some View {
        VStack{
            
            NavigationLink(destination: LoginView(),
                           isActive: $authModel.didAuthenticateUser,
                           label: { })
            
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            VStack(spacing: 40) {
                AuthTextField(image: "envelope",
                                 placeholderText: "Email",
                                 text: $email)
                
                AuthTextField(image: "person",
                                 placeholderText: "Username",
                                 text: $username)
                
                AuthTextField(image: "heart",
                                 placeholderText: "Height",
                                 text: $height)
                
                AuthTextField(image: "heart",
                                 placeholderText: "Weight",
                                 text: $weight)
                
                AuthTextField(image: "person",
                                 placeholderText: "Full name",
                                 text: $fullname)
                
                AuthTextField(image: "lock",
                                 placeholderText: "Password",
                                 isSecureField: true,
                                 text: $password)
            }.padding()
            
            Button(action: {
                authModel.register(withEmail: email,
                                   password: password,
                                   fullname: fullname,
                                   username: username,
                                   height: height,
                                   weight: weight)
            }){
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width:220,height:60)
                    .background(Color(.systemGreen))
                    .cornerRadius(15.0)
            }
            
            
            Text("Already have an account?")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.top,20)
            NavigationLink {
                LoginView()
                    .navigationBarHidden(true)
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color(.systemBlue))
                    .cornerRadius(15.0)
            }
            .padding(.bottom, 32)
            .foregroundColor(Color(.systemBlue))
            
        }
        .ignoresSafeArea()
    }
}
    
    
    
//    func signUpUser(userEmail: String, userPassword: String){
//        Auth.auth().createUser(withEmail: userEmail, password: userPassword){
//            authResult, error in
//            guard error == nil else {
//                signUpProcessing = false
//                return
//            }
//            switch authResult{
//            case .none:
//                print("could not create acc")
//                signUpProcessing = false
//            case .some(_):
//                print("User Created")
//
//                signUpProcessing = true
//            }
//        }
//        signUpProcessing = true
//
//    }
//
//
//    func goToMain(){
//        showRegisterView = false
//    }
    



//struct Register_Preview : PreviewProvider{
//    
//    static var previews : some View{
//        Group{
//            RegisterView()
//        }
//    }
//}
