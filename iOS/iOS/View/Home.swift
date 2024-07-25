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
    @State private var showAddSense = false
    @State private var homeNotificationBaseColorBlue = "HomeNotificationBaseBlue"
    @State private var homeNotificationLineColorBlue = "HomeNotificationLineAndTextBlue"
    @State private var homeNotificationBaseColorRed = "HomeNotificationBaseRed"
    @State private var homeNotificationLineColorRed = "HomeNotificationLineAndTextRed"
    
    @State private var notificationMessage = "Nothing"
    let launchViewModel: LaunchViewModel
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {
        self.launchViewModel = LaunchViewModel()
    }

    @State private var playbackVideos: [PlaybackVideo] = [
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door"),
        PlaybackVideo(title: "Fire", timeAndDate: "Today at 8:29 AM", type: "Fire"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door")
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .center){
                Text ("Dorm Room")
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
                    // Handle Add Sense action
                }, label: {
                    Image(systemName: "person.fill.badge.plus").font(.system(size: 20)).foregroundColor(.white)
                }).padding(.trailing)
            }.padding(.leading)
            
            VStack{
                if (notificationMessage == "Gun detected!"){
                    HStack{
                        Text("🔫").padding().foregroundColor(.white)
                            .background(
                            Circle()
                                .fill(Color("StandardIconColor")) // Change to desired color
                        )
                        VStack(alignment: .leading){
                            Text("Gun Detected")
                                .fontWeight(.semibold).font(.system(size: 18))
                            Text("Yesterday at 10:50 AM").font(.system(size: 14))
                        }
                        Spacer()
                        
                        
                        
                    }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                } else if (notificationMessage == "Fire detected!") {
                    HStack{
                        
                        Text("🔫").padding().foregroundColor(.white)
                            .background(
                            Circle()
                                .fill(Color("StandardIconColor")) // Change to desired color
                        )
                        VStack(alignment: .leading){
                            Text("Gun Detected")
                                .fontWeight(.semibold).font(.system(size: 18))
                            Text("Yesterday at 10:50 AM").font(.system(size: 14))
                        }
                        Spacer()
                        
                        Text("5%").fontWeight(.bold).font(.system(size: 30))
                        
                    }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                        .onAppear(perform: addItem)
                }
                
                CustomWebView(url: URL(string: "http://172.20.10.2:8000/video_stream")!)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding([.horizontal, .top])
                
                VideoPlayerUIView(videoURL: URL(string: "http://172.20.10.2:8000/video_stream")!)
                    .edgesIgnoringSafeArea(.all)  // To make the video fullscreen
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        FilterHomeButton(symbol: "exclamationmark.shield.fill", text: "Gun", subtext: "49 minutes ago", color: Color("GunDetection"))
                        FilterHomeButton(symbol: "flame.fill", text: "Fire", subtext: "49 minutes ago", color: Color("FireIcon"))
                        FilterHomeButton(symbol: "paintbrush.fill", text: "Vandalism", subtext: "49 minutes ago", color: Color("VandalismIcon"))
                        FilterHomeButton(symbol: "door.left.hand.open", text: "Open Door", subtext: "49 minutes ago", color: Color("OpenDoorIcon"))
                    }
                }.padding(.leading)
                
                HStack{
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
                    ForEach(playbackVideos) { playbackVideo in
                        PlaybackVideos(playbackVideo: playbackVideo)
                    }
                }
            }
        }
        .onAppear {
            audioPlayer.startStreaming()
        }
        .onAppear(perform: startListening)
        .sheet(isPresented: $showSettings) {
            Setting() // Present Settings view
        }
        
    }
    
    func addItem() {
        let newEvent = PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door")
        playbackVideos.append(newEvent)
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
                        print("notification received")
                        launchViewModel.scheduleTimeBasedNotification()
                    }
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

#Preview {
    Home()
}
