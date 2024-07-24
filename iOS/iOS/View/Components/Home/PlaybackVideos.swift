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
                        Text(playbackVideo.timeAndDate).font(.system(size: 18))
                    }
                    Spacer()
                    
                    if (playbackVideo.type == "Fire" || playbackVideo.type == "Gun" || playbackVideo.type == "Vandalism"){
                        Image("PlaybackPreview")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 60)

                    } else {
                        Image("Arrow")
                    }
                }
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.leading)
            .padding(.trailing)
            

        }
    }
    private func getImageNameAndColor(for type: String) -> (String, Color, Color) {
        switch type {
        case "Unlocked Door":
            return ("door.left.hand.open", Color("TabViewColor"), .white)
        case "Fire":
            return ("flame.fill", Color("StandardIconColor"), .white)
        case "Gun":
            return ("exclamationmark.shield.fill", Color("StandardIconColor"), .white)
        case "Vandalism":
            return ("paintbrush.fill", Color("StandardIconColor"), .white)
        default:
            return ("questionmark", Color("TabViewColor"), .white)
        }
    }

}


