import SwiftUI
import WebKit
import AVKit

struct VideoPlayerUIView: UIViewControllerRepresentable {
    var videoURL: URL
    
    class Coordinator: NSObject {
        var player: AVPlayer?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        context.coordinator.player = AVPlayer(url: videoURL)
        playerViewController.player = context.coordinator.player
        context.coordinator.player?.play()
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        let currentAsset = uiViewController.player?.currentItem?.asset as? AVURLAsset
        if currentAsset?.url != videoURL {
            let newPlayerItem = AVPlayerItem(url: videoURL)
            context.coordinator.player?.replaceCurrentItem(with: newPlayerItem)
            context.coordinator.player?.play()
        }
    }
}

struct Home: View {
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var player = AVPlayer(url: URL(string: "https://archive.org/download/four_days_of_gemini_4/four_days_of_gemini_4_512kb.mp4")!)
    @State private var showSettings = false
    @State private var showMakeGroup = false
    @State private var showAddSense = false
    @State private var homeNotificationBaseColorBlue = "HomeNotificationBaseBlue"
    @State private var homeNotificationLineColorBlue = "HomeNotificationLineAndTextBlue"
    @State private var homeNotificationBaseColorRed = "HomeNotificationBaseRed"
    @State private var homeNotificationLineColorRed = "HomeNotificationLineAndTextRed"
    
    @State private var notificationMessage = "Nothing"
    @State private var isPartOfGroup: Bool = false // Track if the user is part of a group
    let launchViewModel: LaunchViewModel
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var events: [Event] = []
    @State private var scrub: [ScrubViewModel] = []
    @State private var groupName: String?

    init() {
        self.launchViewModel = LaunchViewModel()
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isPartOfGroup {
                HStack(alignment: .center) {
                    Text(groupName!)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    Spacer()
                    Button(action: {
                        showSettings = true // Show Settings view
                    }, label: {
                        Image(systemName: "gearshape.fill").font(.system(size: 20)).foregroundColor(.white).padding(.trailing)
                    }).padding(.trailing)
                    Button(action: {
                        showMakeGroup = true
                    }, label: {
                        Image(systemName: "person.fill.badge.plus").font(.system(size: 20)).foregroundColor(.white)
                    }).padding(.trailing)
                }.padding(.leading)
                
                VStack {
                    if notificationMessage == "Gun detected!" {
                        HStack {
                            Text("🔫").padding().foregroundColor(.white)
                                .background(Circle().fill(Color("StandardIconColor"))) // Change to desired color
                            VStack(alignment: .leading) {
                                Text("Gun Detected").fontWeight(.semibold).font(.system(size: 18))
                                Text("Yesterday at 10:50 AM").font(.system(size: 14))
                            }
                            Spacer()
                        }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                    } else if notificationMessage == "Fire detected!" {
                        HStack {
                            Text("🔥").padding().foregroundColor(.white)
                                .background(Circle().fill(Color("StandardIconColor"))) // Change to desired color
                            VStack(alignment: .leading) {
                                Text("Fire Detected").fontWeight(.semibold).font(.system(size: 18))
                                Text("Yesterday at 10:50 AM").font(.system(size: 14))
                            }
                            Spacer()
                            Text("5%").fontWeight(.bold).font(.system(size: 30))
                        }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                    }
                    
                    CustomWebView(url: URL(string: "http://192.168.1.95:8000/video_stream")!)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.horizontal, .top])
                    
                    VideoPlayerUIView(videoURL: URL(string: "http://192.168.1.95:8000/video_stream")!)
                        .edgesIgnoringSafeArea(.all)  // To make the video fullscreen
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        if scrub.isEmpty {
                            Text("No scrub times available")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(scrub) { scrubItem in
                                scrubItem.view
                            }
                        }
                    }.padding(.leading)
                    
                    HStack {
                        Text("Events")
                            .fontWeight(.bold).font(.system(size: 20))
                        
                        Spacer()
                        
                        Button(action: {
                            // Handle Event action
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle").font(.system(size: 20)).foregroundColor(.white)
                        })
                    }.padding()
                                
                    VStack {
                        
                        if events.isEmpty {
                            Text("No events yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(events) { event in
                                EventView(event: event)
                            }
                        }
                    }
                }
            } else {
                VStack{
                    HStack(alignment: .center) {
                        Text("Dorm Room")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                        Button(action: {
                            showSettings = true // Show Settings view
                        }, label: {
                            Image(systemName: "gearshape.fill").font(.system(size: 20)).foregroundColor(.white).padding(.trailing)
                        }).padding(.trailing)
                        Button(action: {
                            showMakeGroup = true
                        }, label: {
                            Image(systemName: "person.fill.badge.plus").font(.system(size: 20)).foregroundColor(.white)
                        }).padding(.trailing)
                    }.padding(.leading)
                    
                    Text("You are not part of any group.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .onAppear {
            audioPlayer.startStreaming()
            fetchGroupEvents()
            checkUserGroupStatus()
            fetchUserGroup()
        }
        .onAppear(perform: startListening)
        .sheet(isPresented: $showSettings) {
            Setting() // Present Settings view
        }
        .sheet(isPresented: $showMakeGroup) {
            GroupView() // Present Settings view
        }
    }
    
    private func checkUserGroupStatus() {
        guard let url = URL(string: "http://192.168.1.95:8000/check_user_group_status") else {
            
            return
        }
       
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add any required headers or authentication tokens here
        // request.setValue("Bearer <TOKEN>", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
           
                //
                if let error = error {
               
                    return
                }
                
                guard let data = data else {
            
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = jsonResponse["status"] as? Bool {
                        isPartOfGroup = status
                    } else {
                        
                    }
                } catch {
                   
                }
            }
        }.resume()
    }
    
    private func fetchGroupEvents() {
        guard let userId = authViewModel.userId else {
            print("No userId found")
            return
        }

        guard let url = URL(string: "http://192.168.1.95:8000/get_group_events?user_id=\(userId)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching group events: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let events = jsonResponse["events"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            // Process and update the state with events
                            self.events = events.map { eventDict in
                                Event(id: eventDict["id"] as? Int ?? 0,
                                      type: eventDict["type"] as? String ?? "",
                                      date: eventDict["date"] as? String ?? "",
                                      video: eventDict["video"] as? String ?? "")
                            }
                        }
                    } else {
                        print("Error parsing response JSON")
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func startListening() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            checkForNotification()
            fetchGroupEvents()
            checkUserGroupStatus()
        }
    }

    func checkForNotification() {
        guard let url = URL(string: "http://192.168.1.95:8000/notifications") else { return }

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
                        let now = Date()
                        let formatter = DateFormatter()
                        formatter.timeStyle = .medium
                        formatter.dateStyle = .medium
                        let currentTime = formatter.string(from: now)
                        if notificationMessage == "Gun detected!" {
                            createEvent(eventType: "Gun", eventDate: currentTime, eventVideo: "Video URL") // Adjust video URL if needed
                        }
                        launchViewModel.scheduleTimeBasedNotification()
                    }
                }
            }
        }.resume()
    }
    
    func createEvent(eventType: String, eventDate: String, eventVideo: String) {
        guard let url = URL(string: "http://192.168.1.95:8000/create_event") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "type": eventType,
            "date": eventDate,
            "video": eventVideo
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode request body: \(error.localizedDescription)")
            return
        }
        
        print("Sending request to \(url) with body: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error creating event: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        if let data = data {
                            do {
                                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                   let message = jsonResponse["message"] as? String {
                                    DispatchQueue.main.async {
                                        // Fetch events again to update the UI
                                        fetchGroupEvents()
                                        scrub.append(ScrubViewModel(view: ScrubView(text: eventType)))
                                    }
                                    print("Event created successfully: \(jsonResponse)")
                                } else {
                                    print("Invalid response format")
                                }
                            } catch {
                                print("Failed to decode response: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Error creating event, status code: \(httpResponse.statusCode)")
                    }
                } else {
                    print("No response from server")
                }
            }
        }.resume()
    }
    
    func fetchUserGroup() {
        guard let userId = authViewModel.userId,
              let url = URL(string: "http://192.168.1.95:8000/get_user_group?user_id=\(userId)") else {
            
            return
        }
        
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
               
                
                if let error = error {
                  
                    return
                }
                
                guard let data = data else {
                    
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let fetchedGroupName = jsonResponse["group_name"] as? String {
                        groupName = fetchedGroupName
                    } else {
                        
                    }
                } catch {
            
                }
            }
        }.resume()
    }


}

struct VideoPlayerView: View {
    var player: AVPlayer

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
    }
}

struct Event: Identifiable {
    var id: Int
    var type: String
    var date: String
    var video: String
}

struct ScrubViewModel: Identifiable {
    var id: UUID = UUID()
    var view: ScrubView
}

#Preview {
    Home()
}
