import SwiftUI

struct GroupUserManagementView: View {
    @State var groupId: Int // The ID of the group managed by the admin
    @State var adminId: Int // The ID of the admin user
    @State var users: [User] = [] // List of all users
    @State var groupMembers: [User] = [] // List of users in the group
    @State var emailToAdd: String = "" // Email of the user to be added
    @State var errorMessage: String? = nil
    @State var showAddUserFields: Bool = false // Control visibility of add user fields

    var body: some View {
        VStack {
            Text("Manage Group")
                .font(.largeTitle)
                .padding()

            List(groupMembers) { user in
                HStack {
                    Text(user.email)
                    Spacer()
                    Button(action: {
                        removeUserFromGroup(user: user)
                    }) {
                        Text("Remove")
                            .foregroundColor(.red)
                    }
                }
            }
            
            if showAddUserFields {
                VStack {
                    TextField("Enter email to add", text: $emailToAdd)
                        .textInputAutocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.bottom)
                    
                    Button(action: {
                        addUserByEmail(email: emailToAdd)
                    }) {
                        Text("Add User")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }

            Button(action: {
                showAddUserFields.toggle() // Toggle the visibility of the add user fields
            }) {
                Label("Add User", systemImage: "plus")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            fetchUsers()
            fetchGroupMembers()
        }
    }

    private func fetchUsers() {
        // Fetch all users from the server
        let url = URL(string: "http://172.20.10.2:8000/users")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let fetchedUsers = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                }
            } catch {
                print("Error decoding users: \(error)")
            }
        }
        task.resume()
    }

    private func fetchGroupMembers() {
        // Fetch group members from the server
        let url = URL(string: "http://172.20.10.2:8000/groups/\(groupId)/members")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let fetchedMembers = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.groupMembers = fetchedMembers
                }
            } catch {
                print("Error decoding group members: \(error)")
            }
        }
        task.resume()
    }

    private func addUserByEmail(email: String) {
        // Find user by email
        guard !email.isEmpty else {
            self.errorMessage = "Email cannot be empty"
            return
        }
        
        guard let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            self.errorMessage = "User with this email does not exist"
            return
        }
        
        // Add user to the group
        let url = URL(string: "http://172.20.10.2:8000/add_user_to_group")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "admin_id": adminId,
            "user_id": user.id,
            "group_id": groupId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to add user to group"
                }
                return
            }

            DispatchQueue.main.async {
                self.fetchGroupMembers() // Refresh the list
                self.emailToAdd = "" // Clear email field
                self.showAddUserFields = false // Hide the fields after adding
            }
        }
        task.resume()
    }

    private func removeUserFromGroup(user: User) {
        // Remove user from the group
        let url = URL(string: "http://172.20.10.2:8000/remove_user_from_group")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "admin_id": adminId,
            "user_id": user.id,
            "group_id": groupId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to remove user from group"
                }
                return
            }

            DispatchQueue.main.async {
                self.fetchGroupMembers() // Refresh the list
            }
        }
        task.resume()
    }
}

struct User: Identifiable, Decodable {
    var id: Int
    var email: String
}

#Preview {
    GroupUserManagementView(groupId: 1, adminId: 1) // Provide test values for preview
}
