//
//  UserProfile.swift
//  projectpmd
//
//  Created by Apple Esprit on 15/11/2023.
//
import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    
    @Published var fullName: String = ""
    @Published var role: String = ""
    @Published var location: String = ""
    @Published var isNavigationActive: Bool = false
    @Published var bio: String = ""
    private let apiManager = APIManager.shared
    func fillUserFromUserDefaults() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
                 }
            guard let userId = UserDefaults.standard.string(forKey: "userId") else {
                return print("Error getting user ID from UserDefaults")
            }

            self.role = UserDefaults.standard.string(forKey: "userRole") ?? ""
        self.location = UserDefaults.standard.string(forKey: "userlocation") ?? ""
            self.fullName = UserDefaults.standard.string(forKey: "userFullName") ?? ""
        self.bio = UserDefaults.standard.string(forKey: "userbio") ?? ""
        }
    init() {
        // ... (other setup)
        //fillUserFromUserDefaults()
        //authenticateUserProfile()
    }
    func authenticateUserProfile() {
        //isLoading = true
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            return print("error getting the token")
        }
        print("test")
        print(token)
        
        let apiUrl = URL(string: "http://localhost:5001/api/users/authenticate-profile")!
        do {
            
            
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(token, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        /*guard let userInfo = jsonResponse else {
                            // Handle the case where jsonResponse is nil
                            print("Failed to parse JSON response")
                            return
                        }*/
                        print(jsonResponse)
                      
                        guard let userInfo = jsonResponse else { return }
                       
                        let id = userInfo["id"] as? String
                        if let id = id {
                            print("ID: \(id)")
                            UserDefaults.standard.removeObject(forKey: "userId")
                            UserDefaults.standard.set(id, forKey: "userId")
                        } else {
                            print("Failed to retrieve ID from JSON response")
                        }

                        let fullname = userInfo["fullname"] as? String
                        if let fullname = fullname {
                            print("Fullname: \(fullname)")
                            UserDefaults.standard.removeObject(forKey: "userFullName")
                            UserDefaults.standard.set(fullname, forKey: "userFullName")
                        } else {
                            print("Failed to retrieve fullname from JSON response")
                        }

                        let email = userInfo["email"] as? String
                        if let email = email {
                            print("Email: \(email)")
                            UserDefaults.standard.removeObject(forKey: "userEmail")
                            UserDefaults.standard.set(email, forKey: "userEmail")
                        } else {
                            print("Failed to retrieve email from JSON response")
                        }

                        let dateofbirthString = userInfo["dateofbirth"] as? String
                        if let dateofbirthString = dateofbirthString {
                           
                            
                                print("Date of birth: \(dateofbirthString)")
                            UserDefaults.standard.removeObject(forKey: "userDateOfBirth")
                            UserDefaults.standard.set(dateofbirthString, forKey: "userDateOfBirth")
                           
                             
                            
                        } else {
                            print("Failed to retrieve date of birth from JSON response")
                        }

                        let roleString = userInfo["role"] as? String
                        if let roleString = roleString {
                            
                            print("Role: \(roleString)")
                            UserDefaults.standard.removeObject(forKey: "userRole")
                            UserDefaults.standard.set(roleString, forKey: "userRole")
                        } else {
                            print("Failed to retrieve role from JSON response")
                        }
                        
                        let location = userInfo["location"] as? String
                        if let location = location {
                            
                            print("Location: \(location)")
                            UserDefaults.standard.removeObject(forKey: "userlocation")
                            UserDefaults.standard.set(location, forKey: "userlocation")
                        } else {
                            print("Failed to retrieve role from JSON response")
                        }

                        let isVerified = userInfo["isVerified"] as? Bool
                        if let isVerified = isVerified {
                            UserDefaults.standard.removeObject(forKey: "isUserVerified")
                            UserDefaults.standard.set(isVerified, forKey: "isUserVerified")
                            print("Is verified: \(isVerified)")
                        } else {
                            print("Failed to retrieve isVerified flag from JSON response")
                        }

                        let isActive = userInfo["isActive"] as? Bool
                        if let isActive = isActive {
                            print("Is active: \(isActive)")
                            UserDefaults.standard.removeObject(forKey: "isUserActive")
                            UserDefaults.standard.set(isActive, forKey: "isUserActive")
                        } else {
                            print("Failed to retrieve isActive flag from JSON response")
                        }

                        let isBanned = userInfo["isBanned"] as? Bool
                        if let isBanned = isBanned {
                            print("Is banned: \(isBanned)")
                            UserDefaults.standard.removeObject(forKey: "isUserBanned")
                            UserDefaults.standard.set(isBanned, forKey: "isUserBanned")
                        } else {
                            print("Failed to retrieve isBanned flag from JSON response")
                        }
                        
                        
                        let fb = userInfo["facebooklink"] as? Bool
                        if let fb = fb {
                            print("Facebook: \(fb)")
                            UserDefaults.standard.removeObject(forKey: "userfb")
                            UserDefaults.standard.set(fb, forKey: "userfb")
                        } else {
                            print("Failed to retrieve fb flag from JSON response")
                        }
                        
                        let insta = userInfo["instagramlink"] as? Bool
                        if let insta = insta {
                            print("instagram: \(insta)")
                            UserDefaults.standard.removeObject(forKey: "userinsta")
                            UserDefaults.standard.set(fb, forKey: "userinsta")
                        } else {
                            print("Failed to retrieve insta flag from JSON response")
                        }
                        
                        let phone = userInfo["phonenumber"] as? Bool
                        if let phone = phone {
                            print("phone: \(phone)")
                            UserDefaults.standard.removeObject(forKey: "phoneNumber")
                            UserDefaults.standard.set(phone, forKey: "phoneNumber")
                        } else {
                            print("Failed to retrieve phone flag from JSON response")
                        }
                        
                        let bio = userInfo["profilebio"] as? String
                        if let bio = bio {
                            print("Bio: \(bio)")
                            UserDefaults.standard.removeObject(forKey: "userBio")
                            UserDefaults.standard.set(bio, forKey: "userbio")
                        } else {
                            print("Failed to retrieve bio flag from JSON response")
                        }
                        UserDefaults.standard.synchronize()
                        self.fillUserFromUserDefaults()
                       
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
}
