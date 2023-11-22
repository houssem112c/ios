//
//  EmailSent.swift
//  projectpmd
//
//  Created by Apple Esprit on 9/11/2023.
//

import SwiftUI

struct DeleteAccountConfirmationView: View {
    @ObservedObject var deleteModel: AccountDeleteViewModel
    
    @State private var email: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if self.deleteModel.isLoading {
            ProgressView("Deleting in...")
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .foregroundColor(.green)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding()
        }
        else {
            VStack(spacing: 20) {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 202, height: 202)
                    .background(
                        Image("Forgotpass2")
                            .resizable()
                            .frame(width: 202, height: 202)
                    )
                    .offset(x: 0, y:-120)
                Text("Confirm password")
                    .font(Font.custom("Aksara Bali Galang", size: 40))
                    .lineSpacing(53)
                    .foregroundColor(Color(red: 0.36, green: 0.70, blue: 0.36))
                    .offset(x: 0, y:-120)
                Text("Nous venons de vous envoyer un code pin pour veriier votre compte!")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Aksara Bali Galang", size: 16))
                    .lineSpacing(10)
                    .padding(.horizontal)
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.25, green: 0.24, blue: 0.26))
                    .offset(x: 0, y:-80)
                TextField("Password confirm", text: $deleteModel.PasswordConfirm)
                
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .frame(width: 402, height: 50)
                    .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(19)
                
                
                
                
                Button(action: {
                    deleteModel.checkpassword()
                }) {
                    //NavigationLink(destination: UserProfileView()) {
                        Text("Supprimer")
                            .font(Font.custom("Aksara Bali Galang", size: 24))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.06, green: 0.56, blue: 0.08))
                            .cornerRadius(19)
                            .frame(width: 402, height: 50)
                        
                    //}
                }
                .offset(x: 0, y:30)
            }
            .frame(width: 430, height: 932)
            .background(colorScheme == .dark ? Color(red: 0.25, green: 0.24, blue: 0.26) : Color(red: 0.98, green: 0.97, blue: 0.93))
        }
       NavigationLink(
            destination: LandingScreen(), // Replace LogInPage with the actual destination
            isActive: $deleteModel.isNavigationActive
        ) {
            EmptyView()
        }
        .hidden()
    }
    
}

struct DeleteAccountConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountConfirmationView(deleteModel: AccountDeleteViewModel())
    }
}

