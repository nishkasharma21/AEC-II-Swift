import SwiftUI

struct ServicesButton: View {
    
    @State private var isFullScreen = false
    @Binding var isAlreadyPurchased: Bool
    @Binding var title: String
    @Binding var purchaseTitle: String
    @Binding var description: String
    @Binding var image: String
    @Binding var backgroundColor: String
    @Binding var bottomTextColor: String
    @Binding var subtext1: String
    @Binding var subtext2: String
    @Binding var purchaseDescription: String
    
    init(title: String, description: String, image: String, purchaseTitle: String, bottomTextColor: String, backgroundColor: String, subtext1: String, subtext2: String, purchaseDescription: String, isAlreadyPurchased: Bool) {
        _title = .constant(title)
        _description = .constant(description)
        _image = .constant(image)
        _isAlreadyPurchased = .constant(isAlreadyPurchased)
        _purchaseTitle = .constant(purchaseTitle)
        _bottomTextColor = .constant(bottomTextColor)
        _backgroundColor = .constant(backgroundColor)
        _subtext1 = .constant(subtext1)
        _subtext2 = .constant(subtext2)
        _purchaseDescription = .constant(purchaseDescription)
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                isFullScreen.toggle()
            }
        }) {
            VStack{
                Image(image).padding(.top)
                
                VStack(alignment: .leading){
                    Text(title).multilineTextAlignment(.leading).bold().font(.system(size:30)).foregroundColor(.black)
                    Text(description).fontWeight(.medium).font(.system(size: 14)).foregroundColor(Color("ServicesDetailText")).multilineTextAlignment(.leading)
                }
                .padding()
            }
            .frame(width: 328)
            .padding()
            .background(Color("TabViewColor"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .fullScreenCover(isPresented: $isFullScreen) {
            PurchaseService(purchaseTitle: purchaseTitle, bottomTextColor: bottomTextColor, backgroundColor: backgroundColor, image: image, subtext1: subtext1, subtext2: subtext2, purchaseDescription: purchaseDescription, isFullScreen: $isFullScreen, isAlreadyPurchased: $isAlreadyPurchased)
        }
    }
}

//#Preview {
//    
//    ServicesButton(title: "Fire Detection", description: "Using AI algorithms and all the sensors Sense is equipped with, we will make sure to notify you and authorities in the case of a fire.", image: "FireDetection", purchaseTitle: "Notify authorities of a fire.", bottomTextColor: "TheftDetectionTect", backgroundColor: "TheftDetectionText", subtext1: "Your dorm.", subtext2: "Be notified of fires.", purchaseDescription: "Driven by machine learning algorithms, Sense  monitors your dorm for any signs of fire. It distinguishes between regular environmental fluctuations and potential fire hazards, promptly detecting smoke or abnormal heat levels. With its real-time alerts and authorities alerts, Sense keeps you both informed and in control.", isAlreadyPurchased: true)
//}
