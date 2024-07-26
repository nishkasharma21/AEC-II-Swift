import SwiftUI

struct ScrubView: View {
    @State var text: String
    
    var body: some View {
        let imageName = getImageNameAndColor(for: text)
        HStack{
            Image(systemName: imageName).foregroundColor(.white).font(.system(size: 30))
            VStack(alignment: .leading){
                Text(text).font(.system(size: 14)).fontWeight(.semibold)
            }
                .fontWeight(.semibold)
        }.padding().background(Color("StandardIconColor")).clipShape(RoundedRectangle(cornerRadius: 30))
    }
    private func getImageNameAndColor(for type: String) -> (String) {
        switch type {
        case "Unlocked Door":
            return ("door.left.hand.open")
        case "Fire":
            return ("flame.fill")
        case "Gun":
            return ("exclamationmark.shield.fill")
        case "Vandalism":
            return ("paintbrush.fill")
        default:
            return ("questionmark")
        }
    }
}

#Preview {
    ScrubView(text: "Fire")
}

