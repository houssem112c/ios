import SwiftUI

struct ProductFormView: View {
    @State private var productName: String = ""
    @State private var productDescription: String = ""
    @State private var productPrice: String = ""
    @State private var productImage: UIImage?
    @State private var isImagePickerPresented: Bool = false

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.productImage = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Product Information")) {
                        TextField("Product Name", text: $productName)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)

                        TextField("Product Description", text: $productDescription)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)

                        TextField("Product Price", text: $productPrice)
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)

                        Button("Choose Image") {
                            self.isImagePickerPresented.toggle()
                        }
                    }
                }
                .padding()

                if let image = productImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding()
                }

                Button("Add Product") {
                    addProduct()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.green]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .padding()
            }
            .navigationBarTitle("Add Product", displayMode: .inline)
            .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(1))
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerView(imagePickerController: UIImagePickerController(), onImagePicked: imagePickerController)
            }
        }
    }

    func addProduct() {
        guard let price = Double(productPrice) else {
            // Handle invalid price input
            return
        }

        // Upload the selected image to your server or storage.
        // ...

        // Create a new product with the entered information and image URL.
        let newProduct = Product(
            name: productName,
            description: productDescription,
            price: price,
            imageURL: "https://example.com/image.jpg" // Replace with actual image URL
        )

        // Add your logic to store the new product, e.g., appending to an array or saving to a database.
        // For demonstration purposes, I'll print the new product.
        print("New Product Added: \(newProduct)")
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    var imagePickerController: UIImagePickerController
    var onImagePicked: (UIImagePickerController, [UIImagePickerController.InfoKey: Any]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView

        init(parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.onImagePicked(picker, info)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
