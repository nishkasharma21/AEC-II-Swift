import SwiftUI

struct PlaybackVideos: View {
    
    let playbackVideo: PlaybackVideo
    
    var body: some View {
        let (imageName, backgroundColor, textColor) = getImageNameAndColor(for: playbackVideo.type)
    
        VStack(spacing: 0){
            HStack{
                HStack(alignment: .center){
                    Image(systemName: imageName).font(.system(size:25))
                    
                    VStack(alignment: .leading) {
                        Text(playbackVideo.title).font(.system(size: 18).bold().weight(.semibold))
                        Text(playbackVideo.timeAndDate).font(.system(size: 14))
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90))
                }
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
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
    private func getImageNameAndColor(for type: String) -> (String, Color, Color) {
        switch type {
        case "Unlocked Door":
            return ("door.left.hand.open", Color("TabViewColor"), .black)
        case "Fire":
            return ("flame.fill", Color("FireIcon"), .white)
        case "Gun":
            return ("exclamationmark.shield.fill", Color("GunDetection"), .white)
        case "Vandalism":
            return ("paintbrush.fill", Color("VandalismIcon"), .white)
        default:
            return ("questionmark", Color("TabViewColor"), .black)
        }
    }

}
