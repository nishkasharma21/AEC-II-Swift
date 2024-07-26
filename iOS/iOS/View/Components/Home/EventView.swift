import SwiftUI

struct EventView: View {
    
    let event: Event
    
    var body: some View {
        let (imageName, backgroundColor, textColor) = getImageNameAndColor(for: event.type)
    
        VStack(spacing: 0){
            HStack{
                HStack(alignment: .center){
                    Image(systemName: imageName).font(.system(size: 25))
                    
                    VStack(alignment: .leading) {
                        Text(event.type).font(.system(size: 18).bold().weight(.semibold))
                        Text(event.date).font(.system(size: 18))
                    }
                    Spacer()
                    
                    if event.type == "Fire" || event.type == "Gun" || event.type == "Vandalism" {
                        // Assume videoURL is used for video preview
                        AsyncImage(url: URL(string: event.video)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 60)
                        } placeholder: {
                            ProgressView()
                        }
//                        Image("PlaybackVideos").resizable()
//                                .scaledToFit()
//                                .frame(width: 100, height: 60)
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
