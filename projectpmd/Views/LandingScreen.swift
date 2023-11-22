//
//  LandingScreen.swift
//  -
//
//  Created by Apple Esprit on 7/11/2023.
//

import SwiftUI

struct LandingScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive: Bool = false
    var body: some View {
        NavigationView {
            ZStack() {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 447, height: 404)
                
                    .background(
                        
                        Image(colorScheme == .dark ? "logo1" : "logo") // Use the image named "logo" from your assets
                            .resizable()
                            .frame(width: 404, height: 404)
                        
                    )
                    .offset(x: 0.50, y: -170)
                
                Text("Découvrez comment\nvous pouvez aider l'environnement")
                    .font(Font.custom("Aksara Bali Galang", size: 24))
                    .lineSpacing(5)
                    .multilineTextAlignment(.center) 
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color(red: 0.38, green: 0.69, blue: 0.35))
                    .offset(x: 0.50, y: 89)
                Text("Explorez les différentes façons dont vous pouvez \naide le monde à améliorer l'habitat environnemental.")
                    .font(Font.custom("Aksara Bali Galang", size: 16))
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .offset(x: 0, y: 226.50)
                
                Button(action: {
                    // Add the action you want the button to perform here
               
                }) {
                    NavigationLink(destination: LoginView(LoginViewModel: LoginViewModel())) {
                    Text("Login")
                        .font(Font.custom("Aksara Bali Galang", size: 20))
                        .foregroundColor(.white)
                    }
                }
                
                .zIndex(999)
                .frame(width: 147, height: 55)
                .background(Color(red: 0.36, green: 0.70, blue: 0.36))
                .cornerRadius(41)
                .offset(x: -102.50, y: 350)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 7, y: 4
                )
                
                
                Button(action: {
                    // Add the action you want the button to perform here
                }) {
                    NavigationLink(destination: RegisterView(signupviewModel: SignUp())) {
                    Text("Register")
                        .font(Font.custom("Aksara Bali Galang", size: 20))
                        .foregroundColor(.black)
                    }
                }
                .foregroundColor(.clear)
                .frame(width: 147, height: 55)
                .background(Color(red: 255, green: 255, blue: 255))
                .cornerRadius(41)
                .offset(x: 102, y: 350)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 7, y: 4
                )
            }
            .frame(width: 430, height: 932)
            .background(colorScheme == .dark ? Color(red: 0.25, green: 0.24, blue: 0.26) : Color(red: 0.98, green: 0.97, blue: 0.93))
            
        }
        
    }
        
        
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
    }
}
