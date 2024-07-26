import SwiftUI
import Combine

struct GroupView: View {
    @State private var selectedGroupId: Int = 0
    @State private var userEmail = ""
    @State private var usersInGroup: [User] = []
    @State private var allUsers: [User] = []
    @State private var isLoading = false
    @State private var alertMessage: AlertMessage?
    
    @State private var groupName: String = ""
    @State private var responseMessage: String = ""
    @State private var message: String = ""
    @State private var emails: [String] = []
    
    @State private var adminGroups: [String] = []  // To track admin groups
    @State private var isAdminOfGroup: Bool = false  // To indicate if user is admin
    @State private var isGroupCreatedSuccessfully: Bool = false

    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Spacer()
                
                if isAdminOfGroup {
                    HStack{
                        VStack(alignment:.leading){
                            Text(adminGroups.first ?? "No Group")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                            Text("Add more people to your room.")
                                .font(.subheadline)
                                .padding(.horizontal)
                        }.padding(.leading)
                        Spacer()
                    }
                    
                    HStack {
                        TextField("Roomate email", text: $userEmail)
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
                            .padding()
                        Button {
                            addUserToGroup(groupId: selectedGroupId, userEmail: userEmail)
                        } label: {
                            Image(systemName: "plus").foregroundColor(.white)
                        }
                        .padding()
                        .disabled(isLoading || userEmail.isEmpty)
                        .background(Color("StandardIconColor"))
                        .disabled(isLoading)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }.padding(.horizontal,15)
                    
                } else {
                    VStack {
                        HStack{
                            VStack(alignment:.leading){
                                Text("Add Roommates")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding()
                                Text("Here you can add users to view your room's data.")
                                    .font(.subheadline)
                                    .padding(.horizontal)
                            }.padding(.leading)
                            Spacer()
                        }
                        HStack{
                            TextField("Group Name", text: $groupName)
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
                                .padding()
                            
                            Button("Create Group") {
                                createGroup(groupName: groupName)
                            }
                            .padding()
                            .background(Color("StandardIconColor"))
                            .foregroundColor(.white)
                            .disabled(isLoading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }.padding(.horizontal)
                        if isGroupCreatedSuccessfully {
                            HStack {
                                TextField("Roomate email", text: $userEmail)
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
                                    .padding()
                                Button {
                                    addUserToGroup(groupId: selectedGroupId, userEmail: userEmail)
                                } label: {
                                    Image(systemName: "plus").foregroundColor(.white)
                                }
                                .padding()
                                .disabled(isLoading || userEmail.isEmpty)
                                .background(Color("StandardIconColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                            }.padding(.horizontal, 15)
                        }
                    }
                }
                Spacer()
            }

            
            

            
            VStack{
                if !emails.isEmpty {
                    List(emails, id: \.self) { email in
                        HStack {
                            Text(email)
                            Spacer()
                            Button(action: {
                                removeUserFromGroup(groupId: selectedGroupId, email: email)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                    }
                    .padding()
                } else {
                    Text("No roomates in group")
                        .padding()
                }
            }

        }
        .alert(item: $alertMessage) { message in
            Alert(title: Text(message.title), message: Text(message.message))
        }
        .onAppear(perform: {
            checkAdminGroups { groupId in
                if let groupId = groupId {
                    fetchGroupEmails(groupId: groupId)
                } else {
                    self.isLoading = false // Stop loading if no admin group is found
                }
            }
        })
    }
    
    private func createGroup(groupName: String) {
        guard let url = URL(string: "http://192.168.1.95:8000/create_group") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = ["group_name": groupName]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Error serializing JSON")
            return
        }

        request.httpBody = jsonData

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    print("Network error: \(String(describing: error))")
                    self.isGroupCreatedSuccessfully = false
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            let message = responseJSON["message"] as? String ?? "Unknown response"
                            print(message)  // Update the UI or handle success
                            self.isGroupCreatedSuccessfully = true
                            if let groupId = responseJSON["group_id"] as? Int {
                                self.selectedGroupId = groupId
                                self.fetchGroupEmails(groupId: groupId)  // Fetch emails after creating group
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Error parsing response JSON")
                            self.isGroupCreatedSuccessfully = false
                        }
                    }
                case 401:
                    DispatchQueue.main.async {
                        print("Unauthorized: You need to log in.")
                        self.isGroupCreatedSuccessfully = false
                    }
                case 400:
                    if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let message = responseJSON["message"] as? String ?? "Bad request"
                        DispatchQueue.main.async {
                            print(message)
                            self.isGroupCreatedSuccessfully = false
                        }
                    }
                case 500:
                    DispatchQueue.main.async {
                        print("Internal server error")
                        self.isGroupCreatedSuccessfully = false
                    }
                default:
                    DispatchQueue.main.async {
                        print("Unexpected status code: \(httpResponse.statusCode)")
                        self.isGroupCreatedSuccessfully = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to create group")
                    self.isGroupCreatedSuccessfully = false
                }
            }
        }.resume()
    }

    
    private func addUserToGroup(groupId: Int, userEmail: String) {
        guard let userId = authViewModel.userId else {
            print("No userId found")
            return
        }
    
        guard let url = URL(string: "http://192.168.1.95:8000/add_user_to_group") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["group_id": groupId, "user_email": userEmail]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = AlertMessage(title: "Error", message: "Failed to encode request body: \(error.localizedDescription)")
                self.isLoading = false
            }
            return
        }
        
        print("Sending request to \(url) with body: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error adding user to group: \(error.localizedDescription)")
                }
                print("Error adding user to group: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.userEmail = ""
                        fetchGroupEmails(groupId: selectedGroupId)
                    }
                    print("User added to group successfully")
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = AlertMessage(title: "Error", message: "Error adding user to group, status code: \(httpResponse.statusCode)")
                    }
                    print("Error adding user to group, status code: \(httpResponse.statusCode)")
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "No response from server")
                }
                print("No response from server")
            }
            
        }.resume()
    }

    private func fetchGroupEmails(groupId: Int) {
        guard let url = URL(string: "http://192.168.1.95:8000/get_group_emails?group_id=\(groupId)") else {
            DispatchQueue.main.async {
              
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                   
                    self.isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                   
                    self.isLoading = false
                }
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let emails = jsonResponse["emails"] as? [String] {
                    DispatchQueue.main.async {
                        self.emails = emails
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        self.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
               
                    self.isLoading = false
                }
            }
        }.resume()
    }

    
    private func removeUserFromGroup(groupId: Int, email: String) {
        guard let url = URL(string: "http://192.168.1.95:8000/remove_user_from_group") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["group_id": groupId, "email": email]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = AlertMessage(title: "Error", message: "Failed to encode request body: \(error.localizedDescription)")
                self.isLoading = false
            }
            return
        }
        
        print("Sending request to \(url) with body: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error removing user from group: \(error.localizedDescription)")
                }
                print("Error removing user from group: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        // Remove user locally before fetching emails
                        self.emails.removeAll { $0 == email }
                        self.userEmail = ""
                        fetchGroupEmails(groupId: selectedGroupId)
                    }
                    print("User removed from group successfully")
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = AlertMessage(title: "Error", message: "Error removing user from group, status code: \(httpResponse.statusCode)")
                    }
                    print("Error removing user from group, status code: \(httpResponse.statusCode)")
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "No response from server")
                }
                print("No response from server")
            }
            
        }.resume()
    }
    
    // New function to check if the user is an admin of any group
    private func checkAdminGroups(completion: @escaping (Int?) -> Void) {
        guard let userId = authViewModel.userId else {
            print("No userId found")
            completion(nil)
            return
        }
        
        guard let url = URL(string: "http://192.168.1.95:8000/get_user_groups?user_id=\(userId)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error checking admin groups: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                }
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let groups = json["admin_groups"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.adminGroups = groups.compactMap { $0["name"] as? String }
                        self.isAdminOfGroup = !groups.isEmpty
                        // Pass the first group ID to the completion handler
                        let firstGroupId = groups.first?["id"] as? Int
                        completion(firstGroupId)
                    }
                } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let message = json["message"] as? String {
                    DispatchQueue.main.async {
                        print(message)
                    }
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print("JSON error: \(error.localizedDescription)")
                }
                completion(nil)
            }
        }.resume()
    }


    private func fetchGroupEmails(groupId: String) {
        guard let url = URL(string: "http://192.168.1.95:8000/get_group_emails?group_id=\(groupId)") else {
            DispatchQueue.main.async {
                
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    
                }
                return
            }

            do {
                // Use JSONSerialization to parse the JSON data
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let emails = jsonResponse["emails"] as? [String] {
                    DispatchQueue.main.async {
                        self.emails = emails
                    }
                } else {
                    DispatchQueue.main.async {
                        
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    
                }
            }
        }.resume()
    }
}

struct User: Identifiable, Codable {
    var id: Int
    var email: String
}

struct AlertMessage: Identifiable {
    var id = UUID()
    var title: String
    var message: String
}

struct GroupEmailsResponse: Codable {
    let emails: [String]
}


#Preview{
    GroupView()
}
