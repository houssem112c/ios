//
//  APIManager.swift
//  projectpmd
//
//  Created by Mac Mini 2 on 11/11/2023.
//

import Foundation
class APIManager {
    static let shared = APIManager()
    
    func signup(data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        // Replace the placeholder URL with your actual signup endpoint
        let url = URL(string: "http://localhost:5001/api/users/signup")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the API response
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
    
    
    
    
    
    //private let loginURL = URL(string: "http://localhost:9090/api/users/signin")!
    
    func login(data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "http://localhost:5001/api/users/signin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the API response
            if let error = error {
                completion(.failure(error))
            } else {
                
                completion(.success(data!))
            }
        }.resume()
    }
    
    func authenticateUserProfile(completion: @escaping (Result<User, Error>) -> Void) {
            guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
                return completion(.failure(APIError.tokenNotFound))
            }
            print("test")
            print(token)
            let apiUrl = URL(string: "http://localhost:5001/api/users/authenticate-profile")!

            var request = URLRequest(url: apiUrl)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }

                do {
                    print("test 5")
                    let user = try JSONDecoder().decode(User.self, from: data)
                    print(user.fullname)
                    self.saveUserInSession(user)
                    
                    
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    private func saveUserInSession(_ user: User) {
        // Save user information in UserDefaults or your preferred storage
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.id, forKey: "userID")
        userDefaults.set(user.fullname, forKey: "userFullname")
        userDefaults.set(user.email, forKey: "userEmail")
        userDefaults.set(user.dateofbirth, forKey: "userDateOfBirth") // Assuming dateofbirth is a Date property
        userDefaults.set(user.role.rawValue, forKey: "userRole") // Assuming role is an enum
        userDefaults.set(user.isActive, forKey: "userIsActive")
        userDefaults.set(user.isBanned, forKey: "userIsBanned")
        userDefaults.set(user.isVerified, forKey: "userIsVerified")
        userDefaults.synchronize() // Ensure the data is saved immediately
    }

    
}
    

enum APIError: Error {
    case tokenNotFound
    case noData
}
