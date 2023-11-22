//
//  Login.swift
//  projectpmd
//
//  Created by Mac Mini 2 on 11/11/2023.
//

import Foundation
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    
    @Published var isLoading: Bool = false
    @Published var isNavigationActive: Bool = false

    private let apiManager = APIManager.shared

    func login() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
                 }
        // Create a JSON body with the user's credentials
        let apiUrl = URL(string: "http://localhost:5001/api/users/signin")!

        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            var request = URLRequest(url: apiUrl)

                        // Set the request method to POST
                        request.httpMethod = "POST"

                        // Set the request body with the JSON data
                        request.httpBody = jsonData

                        // Set the request header to indicate JSON content
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    // Parse and handle the response data
                    // Note: You should handle this according to your API response format
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        //print("Response: \(jsonResponse)")
                        print(jsonResponse)
                        if let jsonDictionary = jsonResponse as? [String: Any], let token = jsonDictionary["token"] as? String {
                            print("Token: \(token)")
                            // Save the token to your session or any storage mechanism you prefer
                            // Example using UserDefaults:
                            UserDefaults.standard.set(token, forKey: "accessToken")
                           
                        }
                        // You can update your UI or perform other actions based on the response
                    } catch {
                        print("Error parsing JSON: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isNavigationActive = true
                }
            }.resume()
            
        } catch {
            print("error taa do")
        }
      
        
    }
    
    func extractToken(from json: String) -> String? {
        // Define a regular expression pattern to match the token
        let pattern = "\"token\":\\s*\"([^\"]+)\""

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(json.startIndex..<json.endIndex, in: json)

            if let match = regex.firstMatch(in: json, options: [], range: range) {
                let tokenRange = Range(match.range(at: 1), in: json)!
                let token = String(json[tokenRange])
                return token
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }

        return nil
    }

    // Example usage:
    
}
