import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct Home: View {
    @State private var showAddSense = false
    @State private var homeNotificationBaseColorBlue = "HomeNotificationBaseBlue"
    @State private var homeNotificationLineColorBlue = "HomeNotificationLineAndTextBlue"
    @State private var homeNotificationBaseColorRed = "HomeNotificationBaseRed"
    @State private var homeNotificationLineColorRed = "HomeNotificationLineAndTextRed"
    
    let playbackVideos: [PlaybackVideo] = [
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Unlocked Door"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Fire"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Gun"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Vandalism")
    ]
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            
            HStack{
                Spacer()
                
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "bell.fill").font(.system(size: 20))
                }).padding(.trailing)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "ellipsis.circle").font(.system(size: 20))
                })
            }.foregroundColor(.black).padding(.trailing)
            
            HStack{
                Text ("Dorm Room")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    FilterHomeButton(symbol: "exclamationmark.shield.fill", text: "Gun", color: Color("GunDetection"))
                    FilterHomeButton(symbol: "flame.fill", text: "Fire", color: Color("FireIcon"))
                    FilterHomeButton(symbol: "paintbrush.fill", text: "Vandalism", color: Color("VandalismIcon"))
                    FilterHomeButton(symbol: "door.left.hand.open", text: "Open Door", color: Color("OpenDoorIcon"))
                }
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
                
                WebView(url: URL(string: "http://172.20.10.2:8000/video_feed")!).edgesIgnoringSafeArea(.all)
                
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
                
                HStack{
                    Text("Playback")
                        .fontWeight(.bold).font(.system(size: 20))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle").font(.system(size: 20))
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
        }
    }
}

#Preview {
    Home()
}
