import SwiftUI

struct Setting: View {
    @State private var phoneNumber = "510 371 2161"
    @State private var language = "English"
    @State private var isPhoneNumberEditable = false
    @State private var isLanguageEditable = false
    @State private var isValid: Bool = false
    
    @State private var personServer: Bool = false
    @State private var serverName = "Nishka's Mac Mini"
    
    @State private var devices = ["Philips Smart LED Bulb", "Smart Lock", "Philips Smart LED Bulb"]
    
    @State private var selectedLanguage = "English"
    let languages = ["English", "Spanish", "French", "German", "Italian"]
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    let formatter: PhoneNumberFormatter = PhoneNumberFormatter()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // Your phone number validation logic here
        // For example:
        let phoneRegex = "^[0-9+]{1,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                VStack(alignment: .leading) {
                    Text("Personal Settings").multilineTextAlignment(.leading).bold()

                    HStack {
                        Image(systemName: "iphone.gen3").padding(.leading).font(.system(size: 20))

                        if isPhoneNumberEditable {
                            TextField("Phone Number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .onChange(of: phoneNumber) { newValue in
                                    phoneNumber = formatter.format(phoneNumber: newValue)
                                }
                        } else {
                            Text(phoneNumber)
                                .foregroundColor(.gray)
                                .padding()
                        }

                        Spacer()

                        Button(action: {
                            if isPhoneNumberEditable {
                                // Save the phone number to UserDefaults
                                UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                            }
                            isPhoneNumberEditable.toggle()
                        }) {
                            Text(isPhoneNumberEditable ? "Save" : "Edit")
                                .foregroundColor(Color("StandardIconColor")).bold().padding(.trailing)
                        }
                        .padding(.leading)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("TabViewColor"))
                    )
                    .clipped()
                    .onAppear {
                        if let savedPhoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") {
                            phoneNumber = savedPhoneNumber
                        }
                    }
                    
                    HStack {
                        Image(systemName: "globe").padding(.leading).font(.system(size: 20))

                        if isLanguageEditable {
                            Menu {
                                ForEach(languages, id: \.self) { language in
                                    Button(language) {
                                        selectedLanguage = language
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedLanguage)
                                        .foregroundColor(.gray)
                                        .padding()
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .padding(.trailing)
                                }
                            }
                            .padding(.leading)
                        } else {
                            Text(selectedLanguage)
                                .foregroundColor(.gray)
                                .padding()
                        }

                        Spacer()

                        Button(action: {
                            if isLanguageEditable {
                                // Save the language to UserDefaults
                                UserDefaults.standard.set(selectedLanguage, forKey: "language")
                            }
                            isLanguageEditable.toggle()
                        }) {
                            Text(isLanguageEditable ? "Save" : "Edit")
                                .foregroundColor(Color("StandardIconColor")).bold().padding(.trailing)
                        }
                        .padding(.leading)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("TabViewColor"))
                    )
                    .clipped()
                    .onAppear {
                        if let savedLanguage = UserDefaults.standard.string(forKey: "language") {
                            selectedLanguage = savedLanguage
                        }
                    }
                    
                }.padding()
                
                
                VStack(alignment: .leading){
                    Text("Personal Server").multilineTextAlignment(.leading).bold()
    
                    Toggle("Enable Personal Server", isOn: $personServer)
                        .padding()
                        .background(Color("TabViewColor"), in: RoundedRectangle(cornerRadius: 10))
                    HStack{
                        Menu {
                            VStack {
                                Button("Menu Item 1") {
                                    // Code to be executed when menu item 1 is tapped
                                }
                                Button("Menu Item 2") {
                                    // Code to be executed when menu item 2 is tapped
                                }
                                // Add more menu items as needed
                            }
                        } label: {
                            HStack {
                                Text(serverName).foregroundColor(.white)
                                Spacer()
                                Image("DarkArrow")
                            }
                            .padding()
                            .foregroundColor(.black)
                            .background(Color("TabViewColor"), in: RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Image("LightAdd")
                        
                    }
                    
                    
                }.padding()
                
                VStack(alignment: .leading){
                    Text("Roomates").multilineTextAlignment(.leading).bold().padding(.top).padding(.leading)
                    List(items, id: \.self) { item in
                        Text(item)
                    }.padding(.all, 0)

                }
                
                VStack {
                    Spacer() // Pushes the content to the center vertically
                    Button {
                        authViewModel.logOut()
                        authViewModel.isAuthenticated = false
                    } label: {
                        Text("Log out")
                            .bold()
                            .padding()
                            .background(Color("StandardIconColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10) // Optional: For rounded corners
                    }
                    Spacer() // Pushes the content to the center vertically
                }
                .frame(maxWidth: .infinity, maxHeight: 50) // Makes the VStack take the full screen
                 
            }.navigationTitle("Settings")
        }
    }
}

class PhoneNumberFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let phoneNumber = obj as? String else { return nil }
        let formattedPhoneNumber = format(phoneNumber: phoneNumber)
        return formattedPhoneNumber
    }

    func format(phoneNumber: String) -> String {
        let digits = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let phoneNumberLength = digits.count

        if phoneNumberLength < 4 {
            return digits
        }

        let areaCode = digits.prefix(3)
        let prefix = digits.dropFirst(3).prefix(3)
        let lineNumber = digits.dropFirst(6)

        return "(\(areaCode)) \(prefix)-\(lineNumber)"
    }
}
