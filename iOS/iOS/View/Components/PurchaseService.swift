import SwiftUI

struct PurchaseService: View {
    
    @Binding var isFullScreen: Bool
    @Binding var isAlreadyPurchased: Bool
    @Binding var purchaseTitle: String
    @Binding var image: String
    @Binding var backgroundColor: String
    @Binding var bottomTextColor: String
    @Binding var purchaseDescription: String
    @Binding var subtext1: String
    @Binding var subtext2: String
    
    init(purchaseTitle: String, bottomTextColor: String, backgroundColor: String, image: String, subtext1: String, subtext2: String, purchaseDescription: String, isFullScreen: Binding<Bool>, isAlreadyPurchased: Binding<Bool>) {
        _isFullScreen = isFullScreen
        _isAlreadyPurchased = isAlreadyPurchased
        _purchaseTitle = .constant(purchaseTitle)
        _bottomTextColor = .constant(bottomTextColor)
        _backgroundColor = .constant(backgroundColor)
        _image = .constant(image)
        _subtext1 = .constant(subtext1)
        _subtext2 = .constant(subtext2)
        _purchaseDescription = .constant(purchaseDescription)
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    withAnimation {
                        isFullScreen = false
                    }
                }) {
                    Image("CrossPage").padding(.trailing)
                }
            }
            VStack(alignment: .leading){
                Text("GETTING STARTED").font(.system(size: 12)).bold()
                GeometryReader { geometry in
                    Text(purchaseTitle).font(.title).bold()
                        .frame(maxWidth: geometry.size.width, alignment: .leading)
                }
                .frame(maxHeight: 50)
            }
            .padding()
            
            Image(image)
                .padding()
        }
        .background(Color(backgroundColor))
        
        VStack{
            Spacer()
            VStack (alignment: .leading) {
                Text(subtext1).fontWeight(.bold).foregroundColor(Color(bottomTextColor)).font(.system(size: 25))
                Text(subtext2).fontWeight(.bold).font(.system(size: 25)).padding(.bottom)
                Text(purchaseDescription).font(.system(size: 14)).foregroundColor(Color("ServicesDetailText"))
            }
            .padding()
            
            Spacer()
            
            if isAlreadyPurchased {
                Button(action: {
                    // Add your action here
                    withAnimation {
                        isFullScreen = false
                    }
                }) {
                    HStack (alignment:.center){
                        Spacer()
                        Text("Purchase").foregroundColor(.white).bold()
                        Spacer()
                    }
                   .padding()
                   .background(.blue)
                   .clipShape(RoundedRectangle(cornerRadius: 10))
                   .padding()
                }
            } else {
                Button(action: {
                    // Add your action here
                    withAnimation {
                        isFullScreen = false
                    }
                }) {
                    HStack (alignment:.center){
                        Spacer()
                        Text("Remove").foregroundColor(.white).bold()
                        Spacer()
                    }
                   .padding()
                   .background(Color("RemoveService"))
                   .clipShape(RoundedRectangle(cornerRadius: 10))
                   .padding()
                }
            }
            
            Spacer()
        }
    }
}


