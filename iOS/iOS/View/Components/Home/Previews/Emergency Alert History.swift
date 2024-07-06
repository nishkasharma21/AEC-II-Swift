import SwiftUI

struct EmergencyAlertHistoryPreview: View {
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "light.beacon.max")
                   .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color("Red Light"),Color("Red Dark")]), startPoint:.leading, endPoint:.trailing)
                           .mask(Image(systemName: "light.beacon.max"))
                    )
                Text("Emergency Alert History").font(.body.weight(.semibold))
                Spacer()
                Image("Arrow")
            }
            .frame(alignment: .leading)
            VStack{
                HStack{
                    VStack(alignment: .leading) {
                        Text("Theft Detected")
                            .bold().font(.system(size: 20))
                        Text("5 months ago").font(.system(size: 11))
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 11)
                .padding(.bottom, 11)
                .frame(alignment: .leading)
                .background(Color("Emergency Alert Red"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack{
                HStack{
                    VStack(alignment: .leading) {
                        Text("Theft Detected")
                            .bold().font(.system(size: 20))
                        Text("7 months ago").font(.system(size: 11))
                    }
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 11)
                .padding(.bottom, 11)
                .frame(alignment: .leading)
                .background(Color("Emergency Alert Red"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
        }
        .padding()
        .background(Color("TabViewColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    EmergencyAlertHistoryPreview()
}
