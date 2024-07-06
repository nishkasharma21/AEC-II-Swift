import SwiftUI

struct HomeNotification: View {
    var body: some View {
        HStack (alignment: .center) {
            //fix height of rectangle to be dynamic
            Rectangle()
                .fill(.blue)
                    .frame(width: 7)
                    .frame(maxHeight: 70)
                    .cornerRadius(10)
            HStack{
                VStack (alignment: .leading){
                    Text("Unlocked Door").bold()
                    Text("Today at 8:29 AM")
                }
                Spacer()
                Image(systemName: "play.fill")
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }

    }
}

#Preview {
    HomeNotification()
}
