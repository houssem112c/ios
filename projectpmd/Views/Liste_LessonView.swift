import SwiftUI




class Liste_meslessonViewModel: ObservableObject {
    @Published var likedLessons: [Lesson] = []

    func fetchAllLikedLessons() {
            NetworkingManager.shared.fetchAllLikedLessons { result in
                switch result {
                case .success(let lessons):
                    DispatchQueue.main.async {
                        self.likedLessons = lessons
                    }

                case .failure(let error):
                    print("Error fetching all liked lessons: \(error)")
                }
            }
        }
}


struct Liste_meslessonView: View {
    @StateObject var viewModel = Liste_meslessonViewModel()
    @State private var selectedLesson: Lesson?

    var body: some View {
        NavigationView {
            List(viewModel.likedLessons, id: \.id) { lesson in
                mesLessonCellView(lesson: lesson)
                    .onTapGesture {
                        selectedLesson = lesson
                    }
            }
            .navigationBarTitle("Liste des lessons", displayMode: .inline)

            .onAppear {
                viewModel.fetchAllLikedLessons()
            }
        }
    }
}


struct mesLessonCellView: View {
    let lesson: Lesson
    
    var body: some View {

        HStack(alignment: .top, spacing: 16) {
            // Add an image to the left
            Image(systemName: "book")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 8) {
                Text(lesson.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(lesson.description)
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



struct DetailmesLessonView: View {
    let lesson: Lesson
    @State private var isLiked = false
    @State private var isDisliked = false
    @State private var isShared = false
    @State private var isCommented = false
    @State private var showComments = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(lesson.name)
                .font(.title)
            
            Text("Description:")
                .font(.headline)
            Text(lesson.description)
                .foregroundColor(.gray)
            
        }
        .padding()
    }
}



 

struct mesActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}


struct Liste_meslessonView_Previews: PreviewProvider {
    static var previews: some View {
        Liste_meslessonView()
    }
}
