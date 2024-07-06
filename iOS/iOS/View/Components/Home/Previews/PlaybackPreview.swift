import SwiftUI

struct PlaybackPreview: View {
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "video.fill")
                   .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color("Purple Dark"),Color("Purple Light")]), startPoint:.leading, endPoint:.trailing)
                           .mask(Image(systemName: "video.fill"))
                    )
                Text("Playback").font(.body.weight(.semibold))
                Spacer()
                Image("Arrow")
            }
            .frame(alignment: .leading)
            Image("PlaybackPreview")
        }
        .padding()
        .background(Color("TabViewColor"))
        .cornerRadius(10)
    }
}

#Preview {
    PlaybackPreview()
}
