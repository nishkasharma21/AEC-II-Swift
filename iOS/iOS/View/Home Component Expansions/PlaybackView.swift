import SwiftUI

struct PlaybackView: View {
    
    let playbackVideos: [PlaybackVideo] = [
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", alert: false),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", alert: true),
        PlaybackVideo(title: "Nishka Sharma unlocked door", timeAndDate: "Today at 8:29 AM", alert: false)
    ]
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(playbackVideos) { playbackVideo in
                        PlaybackVideos(playbackVideo: playbackVideo)
                    }
                }
            }
            .navigationTitle("Playback")
        }
        
    }
}
