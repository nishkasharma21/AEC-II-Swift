import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLogInSuccessful: Bool = true
    @State private var isFullScreen = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("Log In")
                    .font(.largeTitle).bold()
                Spacer()
            }

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .padding(.bottom)
                .background(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                )
                .padding(.bottom)

            VStack (alignment: .leading){
                HStack (alignment: .center){
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .padding(.bottom)
                        
                    } else {
                        SecureField("Password", text: $password)
                            .padding(.bottom)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle() // Toggle password visibility
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill").foregroundColor(.black)
                    }
                }
                .background(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                )
                .padding(.bottom)
                
                
                Button {
                    // Handle forgot password
                } label: {
                    Text("Forgot Password?")
                }.padding(.bottom)
            }
            

            Button(action: {
                logIn()
            }) {
                Text("Log In") // Changed from "Sign Up" to "Log In"
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)

            if !isLogInSuccessful {
                Text("Email or password is incorrect") // Updated message for login
                    .foregroundColor(.red)
                    .padding()
            } 
            
            HStack {
                Text("Don't have an account?")
                Button {
                    withAnimation {
                        isFullScreen.toggle()
                    }
                } label: {
                    Text("Sign Up").foregroundColor(.blue)
                }.fullScreenCover(isPresented: $isFullScreen) {
                    SignUpView()
                }
            }
        }
        .padding()
        .padding()
    }

    private func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            isLogInSuccessful = false
            return
        }
        
        let url = URL(string: "http://172.20.10.2:8000/login")! // Updated URL for login
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    isLogInSuccessful = false
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    isLogInSuccessful = false
                }
                return
            }
            
            DispatchQueue.main.async {
                isLogInSuccessful = true
            }
        }
        
        task.resume()
    }

}

#Preview {
    LogInView() // Updated to show LogInView
}

