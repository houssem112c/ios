import SwiftUI
class Liste_evenementViewModel: ObservableObject {
    @Published var events: [Event] = []

    func updateEvent(_ event: Event) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else {
            return
        }
        events[index] = event
    }
    func toggleFavoriteStatus(for evenement: Event) {
        guard let evenementId = evenement.id else {
            return
        }

        guard let url = URL(string: "http://localhost:5001/api/evenement/\(evenementId)/togglefavorites") else {
            print("Invalid URL for toggling favorite status")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error toggling favorite status: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error toggling favorite status: Invalid HTTP response (not an HTTPURLResponse)")
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")

            if let data = data {
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
            }

            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let updatedEvenement = try JSONDecoder().decode(Event.self, from: data!)
                    DispatchQueue.main.async {
                        self.updateEvent(updatedEvenement)
                    }
                } catch {
                    print("Error decoding evenement: \(error)")
                }
            } else {
                print("Error toggling favorite status: Unexpected HTTP status code")
            }
        }.resume()
    }


    func updateFavoriteState(for evenement: Event) {
        guard let index = events.firstIndex(where: { $0.id == evenement.id }) else {
            return
        }
        events[index].isFavorites = self.isEvenementFavorite(evenement.id)
    }



    func isEvenementFavorite(_ evenementId: String?) -> Bool {
        guard let unwrappedEvenementId = evenementId else {
            // Handle the case where evenementId is nil
            return false
        }

        return events.first(where: { $0.id == unwrappedEvenementId })?.isFavorites ?? false
    }



   }
struct MyEventsView: View {
    @State var events: [Event] = [] // Assurez-vous d'avoir une structure Event similaire à celle que vous avez utilisée précédemment
    @State private var isAddingEvent = false // Utilisé pour présenter la vue d'ajout d'événement

    @State private var selectedEvent: Event?
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            // Utilisez une carte d'événement avec une image en vedette
                            EventCardView(event: event)
                                .onTapGesture {
                                    selectedEvent = event // Sélectionnez l'événement lorsqu'il est tapé
                                }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
            }
            
            .navigationBarTitle("Événements")
            .onAppear {
                fetchEvents()
            }
            
            .sheet(item: $selectedEvent) { event in
                // Affiche les détails de l'événement sélectionné dans une vue dédiée (Sheet)
                EventDetailView(event: event)
            }
            .sheet(isPresented: $isAddingEvent) {
                            AddEventView() // Ouvrir AddEventView quand isAddingEvent est vrai
                        }
            Spacer()
            
        }
        .overlay(
               VStack {
                   Spacer()
                   Button(action: {
                       isAddingEvent = true // Activer l'ajout d'événement
                   }) {
                       Image(systemName: "plus.circle.fill")
                           .font(.title)
                           .padding()
                           .frame(width: 20, height: 20) // Ajuster la taille de l'icône selon vos besoins
                           .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36)) // Couleur de l'icône // Choisissez la couleur appropriée
                               .imageScale(.large) // Choisissez la
                   }
               }
           )
       
        
    }
    struct EventCardView: View {
        let event: Event

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImageView(url: event.imageURL)
                    .frame(height: 200) // Taille de l'image en vedette

                Text(event.eventName)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Date: \(event.eventDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Location: \(event.eventLocation)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Description: \(event.eventDescription)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
    
struct EventDetailView: View {
        let event: Event // Assurez-vous que cet événement correspond à votre modèle d'événement
    @ObservedObject var viewModels = Liste_evenementViewModel()
           @State private var isFavorites: Bool = false
        

        var body: some View {
            VStack {
                Text(event.eventName)
                    .font(.title)
                    .padding()
                
                AsyncImageView(url: event.imageURL)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
                    .shadow(radius: 4)
                HStack {
                    Button(action: {
                        isFavorites.toggle()
                        viewModels.toggleFavoriteStatus(for: event)
                    }) {
                        Image(systemName: isFavorites ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(isFavorites ? Color.yellow : Color.gray)
                        Text(isFavorites ? "Remove from Favorites" : "Add to Favorites")
                            .fontWeight(.semibold)
                            .foregroundColor(isFavorites ? .yellow : .gray)
                    }
                    .padding(.top, 16)
                
                .padding()
                .onAppear {
                    isFavorites = viewModels.isEvenementFavorite(event.id)
                }
            

                    Button(action: {
                      
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            
                            .foregroundColor(.white)
                    })
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }




                Text("Date: \(event.eventDate)")
                    .font(.headline)
                    .padding(.horizontal)

                Text("Location: \(event.eventLocation)")
                    .font(.headline)
                    .padding(.horizontal)

                Text("Description: \(event.eventDescription)")
                    .font(.body)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitle(Text("Event Details"), displayMode: .inline)
        }
        
    }



    
    
    
    
    
    func fetchEvents() {
        guard let url = URL(string: "http://localhost:5001/api/evenements") else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Erreur lors de la récupération des événements : \(error)")
                return
            }

            guard let data = data else {
                print("Aucune donnée trouvée")
                return
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDictionary = json as? [String: Any], let eventList = jsonDictionary["list"] as? [[String: Any]] {
                    let jsonData = try JSONSerialization.data(withJSONObject: eventList)
                    let fetchedEvents = try decoder.decode([Event].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.events = fetchedEvents
                    }
                    
                } else {
                    print("La structure JSON ne correspond pas")
                }
            } catch {
                print("Erreur de décodage JSON : \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON reçu : \(jsonString)")
                } else {
                    print("Impossible de convertir les données JSON en chaîne")
                }
            }
        
        }.resume()
    }
}


struct AsyncImageView: View {
    @StateObject private var imageLoader: ImageLoader
    
    init(url: String) {
        let urlString = "http://localhost:5001/" + url // Assurez-vous que l'URL est correctement formée ici
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: urlString))
    }
    
    var body: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            // Placeholder image ou indicateur de chargement
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    init(url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView()
    }
}
