import SwiftUI

struct HomeNotification: View {
    @Binding var baseColor: String
    @Binding var lineColor: String
    var body: some View {
        HStack (alignment: .center) {
            //fix height of rectangle to be dynamic
            Rectangle()
                .fill(Color(lineColor))
                .frame(width: 7)
                .cornerRadius(10)
            HStack{
                VStack (alignment: .leading){
                    Text("Unlocked Door").bold().foregroundColor(Color(lineColor))
                    Text("Today at 8:29 AM").foregroundColor(Color(lineColor))
                }
                Spacer()
                Image(systemName: "play.fill")
            }
            .padding()
            .background(Color(baseColor))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxHeight: 74)
    }
}

