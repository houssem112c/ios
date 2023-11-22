import SwiftUI
import PassKit

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageURL: String
}

struct ProductListView: View {
    @State private var products: [Product] = [
            Product(name: "Product 1", description: "20% to ...", price: 83, imageURL: "images-2"),
            Product(name: "Product 2", description: "Another great product", price: 83, imageURL: "images-3"),
            Product(name: "Product 3", description: "A third great product", price: 83, imageURL: "images-3"),
            Product(name: "Product 4", description: "Another great product", price: 83, imageURL: "images-4"),
            Product(name: "Product 5", description: "A third great product", price: 83, imageURL: "images-5"),
            Product(name: "Product 6", description: "Another great product", price: 83, imageURL: "images-6"),
            Product(name: "Product 7", description: "A third great product", price: 83, imageURL: "images-10"),
            Product(name: "Product 8", description: "Another great product", price: 83, imageURL: "images-8"),
            Product(name: "Product 9", description: "A third great product", price: 83, imageURL: "images-9"),
            Product(name: "Product 10", description: "Another great product", price: 83, imageURL: "images-11"),
    ]

    var body: some View {
        NavigationView {
            List(products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        Image(product.imageURL)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())

                        Text(product.name)
                            .font(.title2)
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                    .frame(width: 280, height: 100)
                                    .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(30)
                                    
                                    .overlay(RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color(red: 0.06, green: 0.56, blue: 0.08), lineWidth: 4)
                                    
                                    )
                }
            }
            .navigationBarTitle("Products")
        

            .navigationBarItems(trailing:
                NavigationLink(destination: ProductFormView()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .font(.system(size: 40))
                        .frame(width: 50, height: 50)
                }
                .padding()
                .foregroundColor(.green)
                .cornerRadius(15)
            )
               }

        

        .background(Color.green.opacity(0.5))

            
        }

            
    }

struct AddProductView: View {
    @State private var productName: String = ""
    @State private var productDescription: String = "" // Declare productDescription
    @State private var productPrice: Double = 0.0
    @State private var productImageURL: String = ""

    var body: some View {
        Form {
            Section("Product Information") {
                TextField("Product Name", text: $productName)
                TextField("Product Description", text: $productDescription) // Use productDescription
                TextField("Product Price", value: $productPrice, formatter: NumberFormatter())
                TextField("Product Image URL", text: $productImageURL)
            }
        }
        .padding()

        // Move the navigationBarItems outside the Form
        .navigationBarItems(trailing:
            NavigationLink(destination: ProductDetailView(product: Product(name: productName, description: productDescription, price: productPrice, imageURL: productImageURL))) {
                Button("Add") {
                    // Add product action
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
            }
        )
    }
}






import SwiftUI

struct donation: Identifiable {
    var id = UUID()
    var name : String
    var price : Double
}

struct ProductDetailView: View {
    private var product: Product
    @State private var isPaymentFormPresented = false

    var body: some View {
        let donations = [donation(name: "fees", price: 3.0), donation(name: "amount", price: 80.0)]

        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 0.36, green: 0.70, blue: 0.36, opacity: 0.5)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Image(product.imageURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)

                        Text(product.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .foregroundColor(.white)

                        Text("Price: $\(product.price)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .foregroundColor(.white)

                        Text(product.description)
                            .lineLimit(5)
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        PaymentButton(donations: donations)
                                           .frame(minWidth: 100, maxWidth: .infinity, maxHeight: 45)
                                           .padding()
                        // NavigationLink to PaymentFormView
                      
                    }
                    .padding()
                }
                

                // Add a gradient overlay to the top of the view
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 200)
                    .ignoresSafeArea()
            }
            .navigationBarTitle(product.name)
        }
    }
    struct PaymentButton: UIViewRepresentable {
        
        var donations: [donation]
        
        func makeCoordinator() -> PaymentManager {
            PaymentManager(donations: donations)
        }
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.donations = donations
        }
        
    }
    class PaymentManager: NSObject,PKPaymentAuthorizationControllerDelegate {

        
        
        var donations : [donation]
        
        var button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .automatic)
        
        init(donations: [donation]) {
            self.donations = donations
            super.init()
            button.addTarget(self, action: #selector(callBack(_:)), for: .touchUpInside)
        }
        
        @objc func callBack(_ sender: Any) {
            startPayment(donations: donations )
        }
        func startPayment(donations: [donation]) {
            var paymentController: PKPaymentAuthorizationController?
            
            var paymentSummaryItems = [PKPaymentSummaryItem]()
            
            var totalPrice: Double = 0
            donations.forEach { donation in
                let item = PKPaymentSummaryItem(label: donation.name, amount: NSDecimalNumber(string: "\(donation.price.rounded())"),type: .final)
                totalPrice += donation.price.rounded()
                paymentSummaryItems.append(item)
            }
            
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(totalPrice)"),type: .final)
            paymentSummaryItems.append(total)
            
            
            let paymentRequest = PKPaymentRequest()
            
            paymentRequest.paymentSummaryItems = paymentSummaryItems
            paymentRequest.countryCode = "SA"
            paymentRequest.currencyCode = "SAR"
            paymentRequest.supportedNetworks = [.visa,.mada,.masterCard]
            paymentRequest.shippingType = .delivery
            paymentRequest.merchantIdentifier = "merchant.ApplePayButtonSession"
            paymentRequest.merchantCapabilities = .capability3DS
          
            paymentRequest.requiredShippingContactFields = [.name,.phoneNumber]
            
            paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
            
            paymentController?.delegate = self
            paymentController?.present()
            
            
            
        }
        
        func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment) async -> PKPaymentAuthorizationResult {
            .init(status: .success, errors: nil)
        }
        func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
            controller.dismiss()
        }
    }

    public init(product: Product) {
        self.product = product
    }
}




    
    
     struct StoreApp: App {
        var body: some Scene {
            WindowGroup {
                ProductListView()
            }
        }
    }
    
    struct StoreApp_Previews: PreviewProvider {
        static var previews: some View {
            ProductListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }
    

