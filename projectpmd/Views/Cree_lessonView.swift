import SwiftUI


struct Cree_lessonView: View {
    @State private var showConfirmationAlert = false
    @State private var showLessonForm = false
    
    @StateObject var viewModel = Cree_lessonViewModel()
    @State private var lesson = Lesson(name: "",description: "", isFavorite: false
)
    @State private var showMessage = false
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Lesson Name", text: $lesson.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Lesson description", text: $lesson.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Add logic here to load or select an image
            
            Button("Create Lesson") {
                viewModel.createLesson(lesson: lesson)
            }
            .font(.headline)
            .padding(20)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cyan) // Dark blue with transparency
                    .shadow(radius: 5) // Add a subtle shadow
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2)) // Light gray background with transparency
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarTitle("Create Lesson", displayMode: .inline)
    }
    
}
class Cree_lessonViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    @Published var lesson = Lesson(name: "", description: "", isFavorite: false)
    func createLesson(lesson: Lesson) {

        guard let url = URL(string: "http://localhost:5001/lesson") else {
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(lesson) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Gérer la réponse de l'API ici
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Response: \(responseJSON ?? "")")
                // Traitez la réponse de l'API en conséquence
            }
        }.resume()
    }
    func resetForm() {
        DispatchQueue.main.async {
            self.lessons.append(self.lesson)
            self.lesson.name = ""
            self.lesson.description = ""
            self.objectWillChange.send() // Force update
        }
    }


    struct Cree_lessonView_Previews: PreviewProvider {
        static var previews: some View {
            Cree_lessonView()
        }
    }
}


