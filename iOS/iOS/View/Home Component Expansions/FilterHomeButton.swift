import SwiftUI

struct FilterHomeButton: View {
    @State var symbol: String
    @State var text: String
    @State var color: Color
    
    var body: some View {
        HStack{
            Image(systemName: symbol).foregroundColor(color).font(.system(size: 20))
            Text(text)
                .fontWeight(.semibold)
        }.padding().background(Color("TabViewColor")).clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    FilterHomeButton(symbol: "exclamationmark.shield.fill", text: "Gun", color: Color("GunDetection"))
}

