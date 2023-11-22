import Foundation

class UserModifyViewModel: ObservableObject {
    /*@Published var user: UserModifyModel
     @Published var isLoading = false
     @Published var error: Error?*/
    
    
    @Published var email: String = ""
    @Published var location: String = ""
    @Published var fullName: String = ""
    @Published var Bio: String = ""
    @Published var facebook: String = ""
    @Published var instagram: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedImage = ""
    
    
    @Published var isLoading: Bool = false
    @Published var isNavigationActive: Bool = false
    func fillUserFromUserDefaults() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return print("Error getting user ID from UserDefaults")
        }
        
        self.email = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        self.location = UserDefaults.standard.string(forKey: "userlocation") ?? ""
        self.fullName = UserDefaults.standard.string(forKey: "userFullName") ?? ""
        self.Bio = UserDefaults.standard.string(forKey: "userbio") ?? ""
        self.facebook = UserDefaults.standard.string(forKey: "userfb") ?? ""
        self.instagram = UserDefaults.standard.string(forKey: "userinsta") ?? ""
        self.phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
        
    }
    init() {
        // ... (other setup)
        fillUserFromUserDefaults()
    }
    func updateUser() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
        }
        //UserDefaults.standard.set(id, forKey: "userId")
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return print("Error getting user ID from UserDefaults")
        }
        print(userId)
        // Validate user input before sending the update request
        let apiUrl = URL(string: "http://localhost:5001/api/users/users/\(userId)")!
        //let dateOfBirthJSON: String = dateofbirth.formatted(.iso8601)
        let requestBody: [String: Any] = [
            "id": userId,
            "fullname": fullName,
            "email": email,// Include role in the JSON body
            "profilebio": Bio,
            "facebooklink": facebook,
            "instagram": instagram,
            "location": location,
            "phonenumber": phoneNumber,
        ]
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            var request = URLRequest(url: apiUrl)
            
            // Set the request method to POST
            request.httpMethod = "PUT"
            
            // Set the request body with the JSON data
            request.httpBody = jsonData
            
            // Set the request header to indicate JSON content
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data {
                    
                    do {
                        
                        print("Fullname: \(self.fullName)")
                        UserDefaults.standard.set(self.fullName, forKey: "userFullName")
                        
                        print("Email: \(self.email)")
                        UserDefaults.standard.set(self.email, forKey: "userEmail")
                        
                        print("Bio: \(self.Bio)")
                        UserDefaults.standard.set(self.Bio, forKey: "userbio")
                        
                        print("facebook: \(self.facebook)")
                        UserDefaults.standard.set(self.facebook, forKey: "userfb")
                        
                        print("instagram: \(self.instagram)")
                        UserDefaults.standard.set(self.instagram, forKey: "userinsta")
                        
                        print("location: \(self.location)")
                        UserDefaults.standard.set(self.location, forKey: "userlocation")
                        
                        print("phoneNumber: \(self.phoneNumber)")
                        UserDefaults.standard.set(self.phoneNumber, forKey: "phoneNumber")
                        
                        
                        
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
        
        // Simulate loading
        
        
        // Simulate backend call (replace this with actual logic)
        DispatchQueue.main.async {
            self.isLoading = false
            self.isNavigationActive = true
        }
        
        
        
        
        
    }
}

