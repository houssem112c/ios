import SwiftUI
import UIKit
import Alamofire



struct AddEventView: View {
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var textwhats = ""
    @State private var eventLocation = ""
    @State private var eventDescription = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var createdEvent: Event? // Ajoutez une propriété pour stocker l'événement créé
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $eventName)
                   
                    DatePicker("Event Date", selection: $eventDate, in:Date()...)
                    TextField("What's Happening", text: $textwhats)
                    TextField("Event Location", text: $eventLocation)
                    TextField("Event Description", text: $eventDescription)
                }
                
                Section(header: Text("Event Image")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            Image(systemName: "arrow.up.to.line.alt")
                                .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 50) // Ajuster la taille de l'icône selon vos besoins
                            .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36)) // Couleur de l'icône // Choisissez la couleur appropriée
                                .imageScale(.large) // Choisissez la taille de l'icône
                        }
                    }
                }

                
                Button(action: sendEventToServer) {
                    Text("Add Event")
                } .font(.headline)
                    .padding(20)

                                .background(Color(red: 0.36, green: 0.7, blue: 0.36))
                                .foregroundColor(.white)
                                .cornerRadius(10)
            }
            .navigationTitle("Add Event")
            
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $image, showImagePicker: $showImagePicker)
            }
        }
    }
    
    func sendEventToServer() {
        // Vérifiez si toutes les informations nécessaires sont présentes
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            print("Selected image is missing")
            return
        }

        // Créez l'URL du point de terminaison de votre serveur
        guard let url = URL(string: "https://your-server-endpoint.com/upload-event") else {
            print("Invalid URL")
            return
        }

        // Créez une instance de URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Créez un objet FormData pour stocker les données du formulaire
        let formData = MultipartFormData()

        // Ajoutez les champs de données au FormData
        AF.upload(multipartFormData: { multipartFormData in
                // Ajoutez les champs de données au MultipartFormData
                multipartFormData.append(eventName.data(using: .utf8) ?? Data(), withName: "eventName")
                multipartFormData.append(eventDate.description.data(using: .utf8) ?? Data(), withName: "eventDate")
                multipartFormData.append(textwhats.data(using: .utf8) ?? Data(), withName: "textwhats")
                multipartFormData.append(eventLocation.data(using: .utf8) ?? Data(), withName: "eventLocation")
                multipartFormData.append(eventDescription.data(using: .utf8) ?? Data(), withName: "eventDescription")
                if let imageData = image?.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                }
            }, to: "http://localhost:5001/api/evenement")
            .response { response in
                // Gérez la réponse du serveur ou les erreurs éventuelles ici
                if let error = response.error {
                    print("Error: \(error)")
                    return
                }

                if let data = response.data {
                    // Traitez les données de réponse si nécessaire
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response data: \(responseString ?? "")")
                }
            }
        }

    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Binding var showImagePicker: Bool
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.showImagePicker = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.showImagePicker = false
            }
        }
    }}
