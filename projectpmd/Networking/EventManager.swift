//
//  EventManager.swift
//  projectpmd
//
//  Created by MacOS on 22/11/2023.
//

import Foundation

class EventManager {
static let shared = EventManager()





var likedEvenements: [Event] = []

func likeEvenement(evenementId: String, completion: @escaping (Result<Void, Error>) -> Void) {

    guard let url = URL(string: "http://localhost:5001/likes/likeEvenement") else {

        print("Invalid URL for liking a evenement")

        completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for liking a evenement"])))

        return

    }



    var request = URLRequest(url: url)

    request.httpMethod = "POST"

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")



    let likeData: [String: Any] = [

        "evenementId": evenementId

    ]



    do {

        let jsonData = try JSONSerialization.data(withJSONObject: likeData)

        request.httpBody = jsonData



        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                completion(.failure(error))

                return

            }



            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {

                completion(.failure(NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)))

                return

            }



            // Assuming a successful response

            completion(.success(()))

        }.resume()

    } catch {

        completion(.failure(error))

    }

}



func fetchAllLikedEvenements(completion: @escaping (Result<[Event], Error>) -> Void) {

        guard let url = URL(string: "http://localhost:5001/evenements/allLikedEvenements") else {

            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)

            completion(.failure(error))

            return

        }



        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {

                completion(.failure(error))

                return

            }



            guard let data = data else {

                let error = NSError(domain: "No data received", code: 0, userInfo: nil)

                completion(.failure(error))

                return

            }



            do {

                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let list = json?["list"] as? [[String: Any]] {

                    // Parse the list of dictionaries into evenements

                    let evenements = try JSONDecoder().decode([Event].self, from: JSONSerialization.data(withJSONObject: list))

                    completion(.success(evenements))

                } else {

                    // Handle the case where the "list" key is missing or not an array

                    let error = NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)

                    completion(.failure(error))

                }

            } catch {

                completion(.failure(error))

            }

        }.resume()

    }



}
