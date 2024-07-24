import SwiftUI

struct FilterHomeButton: View {
    @State var symbol: String
    @State var text: String
    @State var subtext: String
    @State var color: Color
    
    var body: some View {
        HStack{
            Image(systemName: symbol).foregroundColor(color).font(.system(size: 30))
            VStack(alignment: .leading){
                Text(text).font(.system(size: 14)).fontWeight(.semibold)
                Text(subtext).font(.system(size: 14))
            }
                .fontWeight(.semibold)
        }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    FilterHomeButton(symbol: "exclamationmark.shield.fill", text: "Fire", subtext: "49 minutes ago", color: Color("GunDetection"))
}

