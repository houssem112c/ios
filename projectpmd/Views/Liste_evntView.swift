import SwiftUI



class Liste_lessonViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []

    func fetchLessons() {
        guard let url = URL(string: "http://localhost:5001/lessons") else {
            print("URL invalide")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Erreur lors de la récupération des lessons : \(error)")
                return
            }

            guard let data = data else {
                print("Aucune donnée trouvée")
                return
            }
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(ResponseModel.self, from: data)

                if json.message == "List of lessons" {
                    DispatchQueue.main.async {
                        // Check if the key isFavorite is present in the lesson JSON
                        // If not, set isFavorite to false for all lessons
                        self.lessons = json.list.map { lesson in
                            var updatedLesson = lesson
                            if updatedLesson.isFavorite == nil {
                                updatedLesson.isFavorite = false
                            }
                            return updatedLesson
                        }

                        print("Fetched lessons:")
                        print(self.lessons)
                    }
                } else {
                    print("Error: Invalid JSON structure or message.")
                }
            } catch {
                print("Error decoding JSON: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON received: \(jsonString)")
                } else {
                    print("Unable to convert JSON data to string")
                }

                return
            }
        }.resume()
    }


    func updateLesson(_ lesson: Lesson) {
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return
        }
        lessons[index] = lesson
    }

    func toggleFavoriteStatus(for lesson: Lesson) {
        guard let lessonId = lesson.id else {
            return
        }

        guard let url = URL(string: "http://localhost:5001/lessons/\(lessonId)/togglefavorite") else {
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
                    let updatedLesson = try JSONDecoder().decode(Lesson.self, from: data!)
                    DispatchQueue.main.async {
                        self.updateLesson(updatedLesson)
                    }
                } catch {
                    print("Error decoding lesson: \(error)")
                }
            } else {
                print("Error toggling favorite status: Unexpected HTTP status code")
            }
        }.resume()
    }


    func updateFavoriteState(for lesson: Lesson) {
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else {
            return
        }
        lessons[index].isFavorite = self.isLessonFavorite(lesson.id)
    }



    func isLessonFavorite(_ lessonId: String?) -> Bool {
        guard let unwrappedLessonId = lessonId else {
            // Handle the case where lessonId is nil
            return false
        }

        return lessons.first(where: { $0.id == unwrappedLessonId })?.isFavorite ?? false
    }



   }

struct Liste_lessonView: View {
    @StateObject var viewModel = Liste_lessonViewModel()
    @State private var selectedLesson: Lesson?

    var body: some View {
        TabView {
            // First Tab - List of Lessons
            NavigationView {
                if viewModel.lessons.isEmpty {
                    ProgressView("Fetching lessons...")
                } else {
                    List(viewModel.lessons, id: \.id) { lesson in
                        LessonCellView(lesson: lesson)
                            .onTapGesture {
                                selectedLesson = lesson
                            }
                    }
                    .navigationBarTitle("Liste des lessons", displayMode: .inline)
                    .navigationBarItems(trailing:
                                            NavigationLink(destination: Cree_lessonView()) {
                        Image(systemName: "plus.circle.fill")
                            .padding()
                    }
                    )
                    .sheet(item: $selectedLesson) { selected in
                        DetailLessonView(viewModel: viewModel, lesson: selected)
                    }
                }
            }
            .tabItem {
                Label("Lessons", systemImage: "list.bullet")
            }
            
            // Second Tab - User Profile
            NavigationView {
                UserProfileView(viewModel: UserProfileViewModel())
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            NavigationView {
                MyEventsView()
            }
            .tabItem {
                Label("events", systemImage: "list.circle.fill")            // Third Tab - Create Lesson
            }
            NavigationView {
                ProductListView()
            }
            .tabItem {
                Label("store", systemImage: "store.circle.fill")
            }
        }
        .onAppear {
            viewModel.fetchLessons()
        }
    }
}




struct LessonCellView: View {
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




struct DetailLessonView: View {
    @ObservedObject var viewModel = Liste_lessonViewModel()
    let lesson: Lesson
    @State private var isLiked = false
    @State private var isDisliked = false
    @State private var isShared = false
    @State private var isCommented = false
    @State private var showComments = false
    @State private var isFavorite = false
    @State private var showListeMesLessonView = false // Add this property

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
           

            Text(lesson.name)
                .font(.title)
            
            Text("Description:")
                .font(.headline)
            Text(lesson.description)
                .foregroundColor(.gray)
            
            HStack(spacing: 40) {
                Button(action: {
                    isLiked.toggle()
                    if isLiked {
                        isDisliked = false
                    }
                }) {
                    Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(isLiked ? Color.blue : Color.gray)
                    Text(isLiked ? "Like" : "")
                        .fontWeight(.semibold)
                        .foregroundColor(isLiked ? .blue : .gray)
                }
                
                Button(action: {
                    isDisliked.toggle()
                    if isDisliked {
                        isLiked = false
                    }
                }) {
                    Image(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(isDisliked ? Color.red : Color.gray)
                    Text(isDisliked ? "Dislike" : "")
                        .fontWeight(.semibold)
                        .foregroundColor(isDisliked ? .red : .gray)
                }
                
                Button(action: {
                    isShared.toggle()
                }) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(isShared ? Color.green : Color.gray)
                    Text(isShared ? "Share" : "")
                        .fontWeight(.semibold)
                        .foregroundColor(isShared ? .green : .gray)
                }
                .onTapGesture {
                    isShared.toggle()
                }
                .sheet(isPresented: $isShared, content: {
                    ActivityView(activityItems: [lesson.name, lesson.description])
                })
                
                Button(action: {
                    showComments.toggle()
                }) {
                    Image(systemName: "text.bubble.fill")
                        .foregroundColor(.green)
                        .font(.title)
                    Text("Comments")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .sheet(isPresented: $showComments) {
                    CommentView(lesson: lesson)
                }
            }
            
            Button(action: {
                isFavorite.toggle()
                viewModel.toggleFavoriteStatus(for: lesson)
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(isFavorite ? Color.yellow : Color.gray)
                Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .fontWeight(.semibold)
                    .foregroundColor(isFavorite ? .yellow : .gray)
            }
            .padding(.top, 16)
        }
        .padding()
        .onAppear {
            isFavorite = viewModel.isLessonFavorite(lesson.id)
        }
    }
}




struct CommentView: View {
    @State private var commentText: String = ""
       @State private var comments: [Comment] = []
       let lesson: Lesson

    var body: some View {
        VStack {

            ScrollView {
                           LazyVStack(alignment: .leading, spacing: 8) {
                               ForEach(comments, id: \.id) { comment in
                                   CommentCell(comment: comment, personName: "John Doe", personImage: "image2")
                               }
                           }
                           .background(
                               RoundedRectangle(cornerRadius: 10)
                                   .fill(Color.green.opacity(0.1))
                                   .padding(.horizontal)
                           )
                       }
           
                       .frame(maxHeight: 500)
            TextField("Write your comment...", text: $commentText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.1))
                        .padding(.horizontal)
                )




            Button("Post Comment") {
                postComment()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)


        }
              .padding()
              .onAppear {
                  fetchComments()
              }
          }



    func postComment() {
        guard let lessonId = lesson.id else {
            print("Lesson ID is nil")
            return
        }

        let commentData = [
            "lessonId": lessonId,
            "text": commentText
        ]

        NetworkingManager.shared.postComment(commentData) { result in
            switch result {
            case .success(let comment):

                comments.append(comment)
            case .failure(let error):
                print("Error posting comment: \(error)")
            }
        }


        commentText = ""
    }

    func fetchComments() {
        guard let lessonId = lesson.id else {
                 print("Lesson ID is nil")
                 return
             }
        NetworkingManager.shared.getCommentsByLessonId(lessonId) { result in
            switch result {
            case .success(let fetchedComments):
                comments = fetchedComments
            case .failure(let error):
                print("Error fetching comments: \(error)")
            }
        }
    }
}


struct CommentCell: View {
    let comment: Comment
    let personName: String
    let personImage: String

    init(comment: Comment, personName: String, personImage: String) {
        self.comment = comment
        self.personName = personName
        self.personImage = personImage
    }

    var body: some View {
        HStack {

            Image(personImage)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(personName)
                    .font(.headline)
                Text(comment.text)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
        }
        .padding(.horizontal)
    }
}

 


struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {

    }
}
struct FavoriteView: View {
    @ObservedObject var viewModel = Liste_lessonViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.lessons.filter { $0.isFavorite }) { lesson in
                NavigationLink(destination: DetailLessonView(lesson: lesson)) {
                    LessonCellView(lesson: lesson)
                }
            }
            .navigationBarTitle("Favorite Lessons", displayMode: .inline)
        }
    }
}


struct Liste_lessonView_Previews: PreviewProvider {
    static var previews: some View {

        Liste_lessonView()
    }
}
