import SwiftUI

struct PlaybackVideos: View {
    
    let playbackVideo: PlaybackVideo
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                HStack(alignment: .center){
                    VStack(alignment: .leading) {
                        Text(playbackVideo.title).font(.system(size: 18).bold().weight(.semibold))
                        Text(playbackVideo.timeAndDate).font(.system(size: 14))
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90))
                }
                .padding()
                .background(playbackVideo.alert ? Color("Emergency Alert Red") : Color("TabViewColor"))
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 10
                    )
                )
            }
            .padding(.leading)
            .padding(.trailing)
            
            
            Image("PlaybackVideos")
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 10,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 0
                    )
                )
        }
    }
}
