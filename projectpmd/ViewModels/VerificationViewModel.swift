
import Foundation

class VerificationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isVerificationSent: Bool = false
    @Published var errorMessage: String = ""
    @Published var Pin: String = ""
    @Published var isNavigationActive: Bool = false
    private let apiManager = APIManager.shared

    func generateVerificationToken() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
                 }
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            errorMessage = "User ID not found in UserDefaults"
            return
        }

        
        let apiUrl = URL(string: "http://localhost:5001/api/verify/generate/\(userId)")!

        do {
           
            var request = URLRequest(url: apiUrl)

                        // Set the request method to POST
                        request.httpMethod = "POST"

                        // Set the request body with the JSON data
                       

                        // Set the request header to indicate JSON content
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    self.errorMessage = "Couldn't generate nor send the token"
                } else if let data = data {
                    // Parse and handle the response data
                    // Note: You should handle this according to your API response format
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        //print("Response: \(jsonResponse)")
                        print(jsonResponse)
                        if let jsonDictionary = jsonResponse as? [String: Any], let message = jsonDictionary["message"] as? String {
                            print("Message: \(message)")
                            // Save the token to your session or any storage mechanism you prefer
                            // Example using UserDefaults:
                            
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
    
    func Verify() {
        DispatchQueue.main.async {
            self.isLoading = true // Show loading view
                 }
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            errorMessage = "User ID not found in UserDefaults"
            return
        }

        
        let apiUrl = URL(string: "http://localhost:5001/api/verify/verify/\(userId)/\(Pin)")!
        do {
           
            var request = URLRequest(url: apiUrl)

                        // Set the request method to POST
                        request.httpMethod = "POST"

                        // Set the request body with the JSON data
                       

                        // Set the request header to indicate JSON content
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response and error here
                if let error = error {
                    self.errorMessage = "Couldn't generate nor send the token"
                } else if let data = data {
                    // Parse and handle the response data
                    // Note: You should handle this according to your API response format
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        //print("Response: \(jsonResponse)")
                        print(jsonResponse)
                        if let jsonDictionary = jsonResponse as? [String: Any], let message = jsonDictionary["message"] as? String {
                            print("Message: \(message)")
                            // Save the token to your session or any storage mechanism you prefer
                            // Example using UserDefaults:
                            
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
    
}
