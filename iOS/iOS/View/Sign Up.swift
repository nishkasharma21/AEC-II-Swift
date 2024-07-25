import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpSuccessful: Bool = false
    @State private var isFullScreen = false
    @State private var isPasswordVisible: Bool = false
    @State private var emailErrorMessage: String? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Sign Up")
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

            if let errorMessage = emailErrorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }

            HStack (alignment: .center) {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .padding(.bottom)
                } else {
                    SecureField("Password", text: $password)
                        .padding(.bottom)
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill").foregroundColor(.white)
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

            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)

            if isSignUpSuccessful {
                Text("Sign up successful!")
                    .foregroundColor(.green)
                    .padding()
            }

            HStack {
                Text("Have an account?")
                Button {
                    withAnimation {
                        isFullScreen.toggle()
                    }
                } label: {
                    Text("Login").foregroundColor(.blue)
                }
                .fullScreenCover(isPresented: $isFullScreen) {
                    LogInView()
                }
            }
        }
        .padding()
    }

    private func signUp() {
        emailErrorMessage = nil

        guard !email.isEmpty, !password.isEmpty else {
            isSignUpSuccessful = false
            emailErrorMessage = "Email and password are required"
            return
        }

        guard isValidEmail(email) else {
            isSignUpSuccessful = false
            emailErrorMessage = "Invalid email format"
            return
        }

        let url = URL(string: "http://172.20.10.2:8000/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    isSignUpSuccessful = false
                    emailErrorMessage = nil
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    isSignUpSuccessful = false
                    emailErrorMessage = nil
                }
                return
            }

            DispatchQueue.main.async {
                isSignUpSuccessful = true
                authViewModel.isAuthenticated = true
                emailErrorMessage = nil
            }
        }

        task.resume()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
