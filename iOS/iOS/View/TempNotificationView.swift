import SwiftUI

struct NotificationView: View {
    @State private var notificationMessage = "No notifications"
    let launchViewModel: LaunchViewModel
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        self.launchViewModel = LaunchViewModel()
        
    }

    var body: some View {
        VStack {
            Text("Live Notifications")
                .font(.largeTitle)
                .padding()

            Text(notificationMessage)
                .font(.title)
                .padding()

            Spacer()
        }
        .onAppear(perform: startListening)
    }

    func startListening() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            checkForNotification()
        }
    }

    func checkForNotification() {
        guard let url = URL(string: "http://172.20.10.2:8000/notifications") else { return }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let dictionary = json as? [String: Any],
                   let message = dictionary["message"] as? String {
                    DispatchQueue.main.async {
                        notificationMessage = message
                        launchViewModel.scheduleTimeBasedNotification()
                    }
                }
            }
        }.resume()
    }
}

#Preview{
    NotificationView()
}
