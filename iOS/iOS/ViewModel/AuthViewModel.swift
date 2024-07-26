import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userId: Int?

    func logIn(email: String, password: String) {
        guard let url = URL(string: "http://192.168.1.95:8000/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let userId = json["user_id"] as? Int {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.userId = userId
                }
            }
        }.resume()
    }

    func logOut() {
        guard let url = URL(string: "http://192.168.1.95:8000/logout") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }

            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.userId = nil
            }
            print(self.isAuthenticated)
        }.resume()
    }
}
