//
//  ListeEvenement.swift
//  projectpmd
//
//  Created by MacOS on 22/11/2023.
//

import SwiftUI

class Liste_meseventViewModel: ObservableObject {
    @Published var likedEvents: [Event] = []
    func fetchAllLikedEvenements() {
            EventManager.shared.fetchAllLikedEvenements { result in
                switch result {
                case .success(let events):
                    DispatchQueue.main.async {
                        self.likedEvents = events
                    }

                case .failure(let error):
                    print("Error fetching all liked evenements: \(error)")
                }
            }
        }
}



struct ListeEvenement: View {
    @StateObject var viewModels = Liste_meseventViewModel()

    var body: some View {
        NavigationView {
            List(viewModels.likedEvents, id: \.id) { event in
                mesEventCellView(event: event)
                  
            }
            .navigationBarTitle("Liste mes evenement", displayMode: .inline)

            .onAppear {
                viewModels.fetchAllLikedEvenements()
            }
        }
    }
}
struct mesEventCellView: View {
    let event: Event
    
    var body: some View {

        HStack(alignment: .top, spacing: 16) {
            // Add an image to the left
            Image(systemName: "book")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 8) {
                Text(event.eventName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(event.eventDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 16))
        }
        .background(Color.green.opacity(0.4))
        .cornerRadius(20)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}



struct DetailmesEvenementView: View {
    let event: Event


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(event.eventName)
                .font(.title)
           
            Text("Date: \(event.eventDate)")
                .font(.headline)
                .padding(.horizontal)

            Text("Location: \(event.eventLocation)")
                .font(.headline)
                .padding(.horizontal)

            Text("Description: \(event.eventDescription)")
                .font(.body)
                .padding()
            
        }
        .padding()
    }
}



 



struct ListeEvenement_Previews: PreviewProvider {
    static var previews: some View {
        ListeEvenement()
    }
}
