//
//  EmailSent.swift
//  projectpmd
//
//  Created by Apple Esprit on 9/11/2023.
//

import SwiftUI

struct EmailSent: View {
    @ObservedObject var verifyModel: VerificationViewModel
    //@State private var pin = ""
    @State private var email: String = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if self.verifyModel.isLoading {
            ProgressView("Logging in...")
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .foregroundColor(.green)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding()
        }
        else {
            VStack(spacing: 20) {
                Text("Verifier votre compte")
                    .font(Font.custom("Aksara Bali Galang", size: 24))
                    .lineSpacing(100)
                    .foregroundColor(Color(red: 0.36, green: 0.70, blue: 0.36))
                    .offset(x: 0, y:-150)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 202, height: 202)
                    .background(
                        Image("Forgotpass1")
                            .resizable()
                            .frame(width: 202, height: 202)
                    )
                    .offset(x: 0, y:-120)
                Text("Check your email!")
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
                TextField("Pin", text: $verifyModel.Pin)
                
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .frame(width: 402, height: 50)
                    .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(19)
                
                
                
                
                Button(action: {
                    verifyModel.Verify()
                }) {
                    //NavigationLink(destination: UserProfileView()) {
                        Text("Verifier")
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
            destination: UserProfileView(), // Replace LogInPage with the actual destination
            isActive: $verifyModel.isNavigationActive
        ) {
            EmptyView()
        }
        .hidden()
    }
    
}

struct EmailSent_Previews: PreviewProvider {
    static var previews: some View {
        EmailSent(verifyModel: VerificationViewModel())
    }
}

