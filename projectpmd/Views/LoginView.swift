//
//  LoginView.swift
//  projectpmd
//
//  Created by Apple Esprit on 7/11/2023.
//

import SwiftUI
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEditing = false
    @State private var isChecked: Bool = false
    
    
    ///for the login logic
    @ObservedObject var LoginViewModel: LoginViewModel
    ///
    

    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if self.LoginViewModel.isLoading {
            ProgressView("Logging in...")
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .foregroundColor(.green)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding()
        }
        else {
        NavigationView {
            
                ZStack() {
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 430, height: 932)
                        .background(colorScheme == .dark ? Color(red: 0.25, green: 0.24, blue: 0.26) : Color(red: 0.98, green: 0.97, blue: 0.93))
                        .offset(x: 0, y: 3)
                    Image(colorScheme == .dark ? "logo1" : "logo") // Use the image named "logo" from your assets
                        .resizable()
                        .frame(width: 404, height: 404)
                        .opacity(0.2)
                    
                    Text("Se connecter")
                        .font(Font.custom("Aksara Bali Galang", size: 36))
                        .lineSpacing(100)
                        .foregroundColor(Color(red: 0.36, green: 0.70, blue: 0.36))
                        .offset(x: -0.50, y: -296)
                    Text("Bienvenue ! \nVous nous avez manqué.")
                        .font(Font.custom("Aksara Bali Galang", size: 24))
                        .lineSpacing(25)
                        .foregroundColor(colorScheme == .dark ? Color(.white)  : Color(.black))
                        .multilineTextAlignment(.center)
                        .offset(x: -0.50, y: -196)
                    
                    
                    ZStack(alignment: .leading) {
                        TextField("", text: $LoginViewModel.email, onEditingChanged: { editing in
                            withAnimation {
                                self.isEditing = editing
                            }
                        })
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 66)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                        
                        .overlay(RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.06, green: 0.56, blue: 0.08), lineWidth: 4)
                                 
                            .opacity(isEditing && !email.isEmpty ? 1 : 0)
                        )
                        
                        if email.isEmpty {
                            Text("Email")
                                .foregroundColor(.white)
                                .padding(.horizontal, 19)
                                .scaleEffect(isEditing ? 0.8 : 1)
                                .background(Color.clear)
                                .offset(x: 16, y: -8)
                        }
                    }
                    .offset(x: 0, y: -80)
                    
                    ZStack(alignment: .leading) {
                        SecureField("", text: $LoginViewModel.password)
                        
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .frame(width: 402, height: 66)
                            .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(19)
                        
                            .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.06, green: 0.56, blue: 0.08), lineWidth: 4)
                                     
                                .opacity(password.isEmpty ? 0 : 1)
                            )
                        
                        if password.isEmpty {
                            Text("Password")
                                .foregroundColor(.white)
                                .padding(.horizontal, 19)
                            
                                .background(Color.clear)
                                .offset(x: 16, y: -8)
                        }
                    }
                    .offset(x: 0, y: 0)
                    
                    
                   
                    Button(action: {
                        LoginViewModel.login()
                    }) {
                        //NavigationLink(destination: UserProfileView()) {
                        Text("Se connecter")
                            .font(Font.custom("Aksara Bali Galang", size: 24))
                            .foregroundColor(.white)
                        //}
                    }
                    .frame(width: 402, height: 66)
                    .background(Color(red: 0.06, green: 0.56, blue: 0.08))
                    .cornerRadius(19)
                    .offset(x: 0, y: 200)
                    
                    
                    
                }
                .frame(width: 430, height: 932)
                .background(.white)
            }
            NavigationLink(
                                                    destination: Liste_lessonView(), // Replace LogInPage with the actual destination
                                                    isActive: $LoginViewModel.isNavigationActive
                                                ) {
                                                    EmptyView()
                                                }
                                                .hidden()
            
            
            NavigationLink(destination: RegisterView(signupviewModel: SignUp())) {
                Text("Créer un nouveau compte")
                    .font(Font.custom("Aksara Bali Galang", size: 20))
                    .lineSpacing(48.50)
                    .foregroundColor(Color(red: 0.90, green: 0.21, blue: 0.16))
                    .offset(x: 0, y: 282)
            }
            
        }
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(LoginViewModel: LoginViewModel())
    }
}
