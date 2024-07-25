import SwiftUI
import Combine

struct GroupView: View {
    @State private var selectedGroupId: Int?
    @State private var userEmail = ""
    @State private var usersInGroup: [User] = []
    @State private var allUsers: [User] = []
    @State private var isLoading = false
    @State private var alertMessage: AlertMessage?
    
    @State private var groupName: String = ""
    @State private var responseMessage: String = ""
    @State private var message: String = ""

    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack{
            VStack {
                Text("Groups Management")
                    .font(.largeTitle)
                    .padding()
                
                // Create Group Section
                TextField("Group Name", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Create Group") {
                    createGroup(groupName: groupName)
                    print("called")
                }
                .padding()
                .disabled(isLoading)
            }
            
            // Add User to Group Section
            TextField("User Email", text: $userEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add User to Group") {
                if let groupId = selectedGroupId {
                    addUserToGroup(groupId: groupId, userEmail: userEmail)
                }
            }
            .padding()
            .disabled(isLoading || userEmail.isEmpty)
        }
//
//            Button("Remove User from Group") {
//                if let groupId = selectedGroupId {
//                    removeUserFromGroup(groupId: groupId)
//                }
//            }
//            .padding()
//            .disabled(isLoading || userEmail.isEmpty)
//            
//            // List Users in Group
//            if let groupId = selectedGroupId {
//                List(usersInGroup) { user in
//                    Text(user.email)
//                }
//            }
//
//            // List Available Groups
//            VStack(alignment: .leading) {
//                Text("Available Groups")
//                    .font(.headline)
//                    .padding()
//                
//                List(allUsers) { user in
//                    Text(user.email)
//                        .onTapGesture {
//                            selectedGroupId = user.id
//                            fetchUsersInGroup(groupId: user.id)
//                        }
//                }
//            }
//            .padding()
//            
//            Spacer()
//        }
//        .alert(item: $alertMessage) { message in
//            Alert(title: Text(message.title), message: Text(message.message))
//        }
//        .onAppear(perform: loadGroups)
    }
    
    private func loadGroups() {
        guard let userId = authViewModel.userId else { return }

        isLoading = true
        let url = URL(string: "http://172.20.10.2:8000/groups?user_id=\(userId)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { self.isLoading = false } }

            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error fetching groups: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data,
                  let users = try? JSONDecoder().decode([User].self, from: data) else {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error decoding groups")
                }
                return
            }

            DispatchQueue.main.async {
                self.allUsers = users
            }
        }.resume()
    }

    private func createGroup(groupName: String) {
        guard let url = URL(string: "http://172.20.10.2:8000/create_group") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let json: [String: Any] = ["group_name": groupName]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpBody = jsonData

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        message = responseJSON["message"] as? String ?? "Unknown response"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    message = "Failed to create group"
                }
            }
        }.resume()
    }
    private func addUserToGroup(groupId: Int, userEmail: String) {
        guard let userId = authViewModel.userId else {
            print("No userId found")
            return
        }
        
        isLoading = true
        
        guard let url = URL(string: "http://172.20.10.2:8000/add_user_to_group") else {
            DispatchQueue.main.async {
                self.alertMessage = AlertMessage(title: "Error", message: "Invalid URL")
                self.isLoading = false
            }
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
                        self.fetchUsersInGroup(groupId: groupId)
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

    private func removeUserFromGroup(groupId: Int) {
        guard let userId = authViewModel.userId else { return }
        
        isLoading = true
        let url = URL(string: "http://172.20.10.2:8000/remove_user_from_group")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["group_id": groupId, "user_email": userEmail]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { isLoading = false }
            
            if let error = error {
                alertMessage = AlertMessage(title: "Error", message: "Error removing user from group: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                alertMessage = AlertMessage(title: "Error", message: "Error removing user from group")
                return
            }
            
            DispatchQueue.main.async {
                self.userEmail = ""
                self.fetchUsersInGroup(groupId: groupId)
            }
        }.resume()
    }
    
    private func fetchUsersInGroup(groupId: Int) {
        let url = URL(string: "http://172.20.10.2:8000/group_users?id=\(groupId)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error fetching users in group: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data,
                  let users = try? JSONDecoder().decode([User].self, from: data) else {
                DispatchQueue.main.async {
                    self.alertMessage = AlertMessage(title: "Error", message: "Error decoding users")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.usersInGroup = users
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


#Preview{
    GroupView()
}
