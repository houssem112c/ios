//
//  SignUp.swift
//  projectpmd
//
//  Created by Mac Mini 2 on 11/11/2023.
//

import Foundation
import UIKit

class SignUp: ObservableObject {
    // Bindable properties for user input
    @Published var fullname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var role: String = "" // Add role property
    @Published var dateofbirth: Date = Date() // Use dateofbirth property
    @Published var passwordVerify: String = ""
    @Published var signupError: String = ""
    @Published var signedUp: Bool = false
    @Published var isLoading: Bool = false
    @Published var isNavigationActive: Bool = false
    // Function to send signup request
    func validate() -> Bool {
        var errors: [String] = []

        // Check if fullname is not empty and contains no numbers
        if fullname.isEmpty {
            errors.append("Full name cannot be empty.")
        } else if fullname.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            errors.append("Full name cannot contain numbers.")
        }

        // Check if email is not empty and has both '@' and '.'
        if email.isEmpty {
            errors.append("Email cannot be empty.")
        } else if !email.contains("@") || !email.contains(".") {
            errors.append("Invalid email format. Email must contain '@' and '.'.")
        }

        // Check if passwords are not empty, match, and have at least 8 characters
        if password.isEmpty || passwordVerify.isEmpty {
            errors.append("Passwords cannot be empty.")
        } else if password != passwordVerify {
            errors.append("Passwords do not match.")
        } else if password.count < 8 {
            errors.append("Password must be at least 8 characters long.")
        }

        // Check if role is either "Organisateur" or "Contributeur"
        if !["Organisateur", "Contributeur"].contains(role) {
            errors.append("Invalid role. Role must be either 'Organisateur' or 'Contributeur'.")
        }

        // Combine error messages and display them if any errors exist
        if !errors.isEmpty {
            signupError = errors.joined(separator: " ")
            //showAlert(title: "Validation Errors", message: errorMessage)
            return false
        } else {
            return true
        }
    }


    
    
    
    func signup() {
        
        if !validate() {
              return
            }
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
                 }
        // Create a JSON body
        let dateOfBirthJSON: String = dateofbirth.formatted(.iso8601)
        let requestBody: [String: Any] = [
            "fullname": fullname,
            "email": email,
            "password": password,
            "role": role, // Include role in the JSON body
            "dateofbirth": dateOfBirthJSON, // Use dateofbirth in the JSON body
            // ... include other properties
        ]

        // Convert the request body to Data
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
            // Perform the API request (you'll need to implement this)
            APIManager.shared.signup(data: jsonData) { result in
                // Handle the result (success or failure)
                switch result {
                case .success:
                    self.signedUp = true
                    // Handle successful signup
                    self.signupError = "Signup Success"
                    print("Signup successful")
                case .failure(let error):
                    // Handle signup failure
                    self.signupError = "Signup failed: \(error.localizedDescription)"
                    print("Signup failed: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isNavigationActive = true
                }
            }
        }
    }
}
