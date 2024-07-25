import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLogInSuccessful: Bool = true
    @State private var isFullScreen = false
    @State private var isPasswordVisible: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel

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

                Button {
                    // Handle forgot password
                } label: {
                    Text("Forgot Password?")
                }.padding(.bottom)
            }

            Button(action: {
                logIn()
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)

            if !isLogInSuccessful {
                Text("Email or password is incorrect")
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
    }

    private func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            isLogInSuccessful = false
            return
        }

        authViewModel.logIn(email: email, password: password)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLogInSuccessful = authViewModel.isAuthenticated
        }
    }
}

