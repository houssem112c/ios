import SwiftUI

struct RegisterView: View {
    
    //@StateObject private var signupviewModel = SignUp()
    
    @State private var isImagePickerPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isEditing = false
    @State private var isDisabled: Bool = true
    @State private var pleasecheck = false
    @State private var iAgree: Bool = false
    /// for the sign up
    @ObservedObject var signupviewModel: SignUp
    @State private var isErrorShowing = false
    
    var body: some View {
        if self.signupviewModel.isLoading {
            ProgressView("Signing Up...")
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .foregroundColor(.green)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding()
        }
        else {
            ScrollView {
                VStack(spacing: 20) {
                    Text("S'inscrire")
                        .font(Font.custom("Aksara Bali Galang", size: 36))
                        .lineSpacing(100)
                        .foregroundColor(Color(red: 0.36, green: 0.70, blue: 0.36))
                    
                    Text("Créez un compte pour explorer les différentes façons de contribuer à un meilleur environnement.")
                        .font(Font.custom("Aksara Bali Galang", size: 16))
                        .lineSpacing(10)
                        .foregroundColor(colorScheme == .dark ? Color(.white) : Color(.black))
                        .multilineTextAlignment(.center)
                    
                    TextField("Email", text: $signupviewModel.email)
                    
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 50)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                    
                    SecureField("Password", text: $signupviewModel.password)
                    
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 50)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                    SecureField("Verify Password", text: $signupviewModel.passwordVerify)
                    
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 50)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                    TextField("Full Name", text: $signupviewModel.fullname)
                    
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 50)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                    
                    DatePicker("Date of Birth", selection: $signupviewModel.dateofbirth, displayedComponents: .date)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                        .frame(width: 402, height: 50)
                        //.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        //.padding(.horizontal)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .cornerRadius(19)
                    TextField("Organisateur ou Contributeur", text: $signupviewModel.role)
                    
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .frame(width: 402, height: 50)
                        .background(Color(red: 0.36, green: 0.70, blue: 0.36).opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(19)
                    
                    
                    Toggle(isOn: $iAgree) {
                        
                        Text("I agree to Terms and conditions")
                        
                    }
                    
                    .toggleStyle(iOSCheckboxToggleStyle())
                    
                    
                    /* Text("Choisir photo de profile")
                     .font(Font.custom("Aksara Bali Galang", size: 18))
                     .foregroundColor(colorScheme == .dark ? Color(.white) : Color(.black))
                     
                     HStack {
                     if let image = selectedImage {
                     image
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 120, height: 120)
                     } else {
                     Image(systemName: "photo.on.rectangle")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 30, height: 30)
                     }
                     
                     Button(action: {
                     isImagePickerPresented = true
                     }) {
                     Text("Choose Photo")
                     .font(Font.custom("Aksara Bali Galang", size: 18))
                     .foregroundColor(Color(red: 0.36, green: 0.70, blue: 0.36))
                     }
                     .sheet(isPresented: $isImagePickerPresented) {
                     ImagePicker(selectedImage: $selectedImage)
                     }
                     }*/
                    
                    
                    Button(action: {
                        if !iAgree {
                            pleasecheck = true
                        } else {
                            signupviewModel.signup()
                        }
                    }) {
                        Text("S'inscrire")
                            .font(Font.custom("Aksara Bali Galang", size: 24))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.06, green: 0.56, blue: 0.08))
                            .cornerRadius(19)
                            .frame(width: 402, height: 50)
                        if isErrorShowing {
                            Text(signupviewModel.signupError)
                                .foregroundColor(.red)
                                
                                
                        }
                        if signupviewModel.signedUp {
                            NavigationLink(destination: LoginView(LoginViewModel: LoginViewModel())) {
                            }
                        }
                    }
                    .alert("Please check the terms and conditions box", isPresented: $pleasecheck) {
                                Button("OK", role: .cancel) { }
                            }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                .padding(.vertical, 50)
                .padding(.horizontal, 20)
                .edgesIgnoringSafeArea(.all)
                .background(colorScheme == .dark ? Color(red: 0.25, green: 0.24, blue: 0.26) : Color(red: 0.98, green: 0.97, blue: 0.93))
                VStack() {
                    Text(signupviewModel.signupError)
                        .font(Font.custom("Aksara Bali Galang", size: 12))
                        
                        .foregroundColor(Color.red)
                        .offset(y: -50)
                        .padding(.horizontal)
                }
            }
            .background(colorScheme == .dark ? Color(red: 0.25, green: 0.24, blue: 0.26) : Color(red: 0.98, green: 0.97, blue: 0.93))
        }
        NavigationLink(
            destination: LoginView(LoginViewModel: LoginViewModel()), // Replace LogInPage with the actual destination
            isActive: $signupviewModel.isNavigationActive
        ) {
            EmptyView()
        }
        .hidden()
        
        
    }}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(signupviewModel: SignUp())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Image?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
enum SignupError: Identifiable {
    case apiError(String)
    
    var id: String {
        switch self {
        case .apiError(let message):
            return message
        }
    }
}


struct iOSCheckboxToggleStyle: ToggleStyle {
    @State private var showingAlert = false
    @State private var terms = "EcoLink Terms and Conditions\n"
    + "Introduction\n"
    + "Welcome to EcoLink, an application designed to help you connect with others who share your passion for environmental sustainability. By using EcoLink, you agree to these Terms and Conditions. Please read them carefully.\n"
    + "Definitions\n"
    + "In these Terms and Conditions, the following terms have the following meanings:\n"
    + "\"EcoLink\" means the EcoLink mobile application and website.\n"
    + "\"User\" means any individual who uses EcoLink.\n"
    + "\"Content\" means any text, images, audio, video, or other data that is posted, uploaded, or otherwise transmitted through EcoLink.\n"
    + "\"Intellectual Property Rights\" means all patent rights, copyright rights, trademark rights, trade secret rights, and other proprietary rights.\n"
    + "Acceptance of Terms\n"
    + "By using EcoLink, you agree to be bound by these Terms and Conditions. If you do not agree to these Terms and Conditions, you may not use EcoLink.\n"
    + "User Conduct\n"
    + "You agree to use EcoLink in a responsible and lawful manner. You agree not to use EcoLink to:\n"
    + "Post, upload, or transmit any Content that is unlawful, harmful, threatening, abusive, harassing, tortious, defamatory, vulgar, obscene, libelous, invasive of another\'s privacy, hateful, or racially, ethnically, or otherwise objectionable.\n"
    + "Harm or harass others, including by sending unsolicited email, spam, or chain letters.\n"
    + "Impersonate any person or entity, or falsely state or otherwise misrepresent your affiliation with a person or entity.\n"
    + "Forge headers or otherwise manipulate identifiers in order to disguise the origin of any Content transmitted through EcoLink.\n"
    + "Interfere with or disrupt EcoLink or servers or networks connected to EcoLink, or disobey any requirements, procedures, or policies of networks connected to EcoLink.\n"
    + "Violate any applicable laws or regulations.\n"
    + "Content Removal and Account Termination\n"
    + "EcoLink reserves the right to remove any Content that it deems to be in violation of these Terms and Conditions, or that it deems to be otherwise objectionable. EcoLink also reserves the right to terminate your account at any time, without notice or explanation.\n"
    + "Intellectual Property Rights\n"
    + "All Content posted, uploaded, or otherwise transmitted through EcoLink is the sole responsibility of the person who originally submitted the Content. You agree not to post, upload, or otherwise transmit any Content that you do not have the right to transmit.\n"
    + "You grant EcoLink a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, publish, distribute, and display any Content that you post, upload, or otherwise transmit through EcoLink. This license includes the right to adapt Content to fit different formats and devices, and to promote EcoLink and its services.\n"
    + "Disclaimers\n"
    + "ECOLINK IS PROVIDED ON AN \"AS IS\" AND \"AS AVAILABLE\" BASIS. ECOLINK MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. ECOLINK DOES NOT WARRANT THAT ECOLINK WILL BE UNINTERRUPTED OR ERROR-FREE.\n"
    + "Limitations of Liability\n"
    + "ECOLINK IS NOT LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES ARISING OUT OF YOUR USE OF ECOLINK, INCLUDING, BUT NOT LIMITED TO, DAMAGES FOR LOSS OF PROFITS, GOODWILL, DATA, OR USE; DAMAGES CAUSED BY DELAY; OR DAMAGES CAUSED BY A COMPUTER VIRUS OR OTHER MALICIOUS CODE.\n"
    + "Indemnification\n"
    + "You agree to indemnify and hold EcoLink harmless from any and all claims, liabilities, damages, costs, and expenses (including reasonable attorneys\' fees) arising out of your violation of these Terms and Conditions.\n"
    + "General Provisions\n"
    + "These Terms and Conditions constitute the entire agreement between you and EcoLink with respect to your use of EcoLink. These Terms and Conditions may be amended by EcoLink at any time without notice. You agree to be bound by any such amendments.\n"
    + "These Terms and Conditions shall be governed by and construed in accordance with the laws of the State of [State].\n"
    + "If any provision of these Terms and Conditions is held to be invalid or unenforceable, such provision shall be struck from these Terms and Conditions and the remaining provisions shall remain in full force and effect.\n"
    + "These Terms and Conditions may be assigned by EcoLink without your consent. You may not assign these Terms and Conditions without the prior written consent of EcoLink.\n"
    + "These Terms and Conditions shall inure to the benefit of EcoLink\'s successors and assigns.\n"
    + "Contact Us\n"
    + "If you have any questions about";
    func makeBody(configuration: Configuration) -> some View {
        //@State private var showingAlert = false
        // 1
        
        Button(action: {
            
            
            
            // 2
            
            configuration.isOn.toggle()
            
            showingAlert = true
            
        }, label: {
            
            HStack {
                
                // 3
                
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                
                
                
                configuration.label
                
            }
            .foregroundColor(.green)
            
        })
        .alert(terms, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
        
    }
    
}
