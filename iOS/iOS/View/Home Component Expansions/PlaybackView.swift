import SwiftUI

struct PlaybackView: View {
    
    let playbackVideos: [PlaybackVideo] = [
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Open Door"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Fire"),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", type: "Open Door")
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack{
                HStack(alignment: .center){
                    Image(systemName: "video.fill")
                       .font(.system(size:25))
                       .overlay(
                            LinearGradient(gradient: Gradient(colors: [Color("Purple Dark"),Color("Purple Light")]), startPoint:.leading, endPoint:.trailing)
                                .mask(Image(systemName: "video.fill")).font(.system(size:25))
                       ).padding()
                    Text("Playback").font(.largeTitle).fontWeight(.bold)
                }
                .padding(.top, -40)
                Spacer()
            }
            VStack {
                ForEach(playbackVideos) { playbackVideo in
                    PlaybackVideos(playbackVideo: playbackVideo)
                }
            }
        }
        
    }
}

#Preview {
    PlaybackView()
}
