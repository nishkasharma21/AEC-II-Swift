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
    @State private var showAddSense = false
    @State private var homeNotificationBaseColorBlue = "HomeNotificationBaseBlue"
    @State private var homeNotificationLineColorBlue = "HomeNotificationLineAndTextBlue"
    @State private var homeNotificationBaseColorRed = "HomeNotificationBaseRed"
    @State private var homeNotificationLineColorRed = "HomeNotificationLineAndTextRed"

    
    let playbackVideos: [PlaybackVideo] = [
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door"),
        PlaybackVideo(title: "Fire", timeAndDate: "Today at 8:29 AM", type: "Fire"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door")
    ]
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            
            
            HStack{
                Text ("Dorm Room")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus").font(.system(size: 20)).foregroundColor(.white)
                }).padding(.trailing)
            }.padding(.leading)
            
            
            VStack{
//                    VStack {
//                        VStack{
//                            HStack{
//                                Text("Notifications")
//                                    .font(.body.weight(.semibold))
//                                Spacer()
//                            }
//                            HomeNotification(baseColor: $homeNotificationBaseColorBlue, lineColor: $homeNotificationLineColorBlue)
//                                .padding(.bottom, 5)
//                            HomeNotification(baseColor: $homeNotificationBaseColorRed, lineColor: $homeNotificationLineColorRed)
//                        }
//                        .padding()
//                    }
//                    .background(Color("TabViewColor"))
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
//                WebView(url: URL(string: "http://172.20.10.2:8000/video_feed")!).edgesIgnoringSafeArea(.all)
                
                
                
                HStack{
                    Image(systemName: "battery.25percent").padding().foregroundColor(.white)
                        .background(
                        Circle()
                            .fill(Color("StandardIconColor")) // Change to desired color
                    )
                    VStack(alignment: .leading){
                        Text("Low Battery")
                            .fontWeight(.semibold).font(.system(size: 18))
                        Text("Yesterday at 10:50 AM").font(.system(size: 14))
                    }
                    Spacer()
                    
                    Text("5%").fontWeight(.bold).font(.system(size: 30))
                    
                }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal)
                
                CustomWebView(url: URL(string: "http://192.168.1.95:8000/video_feed")!)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.horizontal, .top])
                
//                VideoPlayerView(player: player)
//                    .frame(height: 200)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .padding()
                
                VideoPlayerUIView(videoURL: URL(string: "http://192.168.1.95:8000/video_feed")!)
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
                        
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle").font(.system(size: 20)).foregroundColor(.white)
                    })
                }.padding()
                                
                VStack {
                    ForEach(playbackVideos) { playbackVideo in
                        PlaybackVideos(playbackVideo: playbackVideo)
                    }
                }
                
//                    ScrollView(.horizontal) {
//                        LazyHStack{
//                            NavigationLink(destination: PlaybackView()) {
//                                PlaybackPreview()
//                            }
//                            NavigationLink(destination: StatisticsView()) {
//                                StatisticsPreview()
//                            }
//                            NavigationLink(destination: ServicesView()                ) {
//                                ServicesPreview()
//                            }
//                            NavigationLink(destination: EmergencyAlertHistoryView()) {
//                                EmergencyAlertHistoryPreview()
//                            }
//                        }
//                    }
            }
        }.onAppear {
            audioPlayer.startStreaming()
        }
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
