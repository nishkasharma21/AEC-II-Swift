import SwiftUI

struct ServicesView: View {
    
    @State var showSheet: Bool = false
    @State private var isAlreadyPurchased = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
      
            HStack(alignment: .center){
                HStack {
                    Text("Services").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                }
            }
            Spacer()
        
            Text("Explore what Sense can offer as your all in one mobile security system.")
                .fontWeight(.medium).foregroundColor(Color("ServicesDetailText")).multilineTextAlignment(.leading).border(.white)
            
            ServicesButton(title: "Theft Detection", description: "Using AI algorithms and face detection, place Sense in your dorm to make sure no unwanted visitors can enter while you’re gone.",image: "TheftDetection", purchaseTitle: "Get a thief-free dorm.", bottomTextColor: "TheftDetectionText", backgroundColor: "TheftDetection", subtext1: "Your dorm.", subtext2: "Security at your fingertips.", purchaseDescription: "Powered by machine learning algorithms, Sense continuously monitors your living space. It  discerns between routine activities and potential threats, ensuring that any unauthorized access or suspicious movements are swiftly detected. With real-time alerts, Sense keeps you informed and in control. Seamlessly designed for mobile placement and discreet operation, Sense redefines dorm room security.", isAlreadyPurchased: false)
            
            Spacer(minLength: 15)
            
            ServicesButton(title: "Fire Detection", description: "Using AI algorithms and all the sensors Sense is equipped with, we will make sure to notify you and authorities in the case of a fire.", image: "FireDetection", purchaseTitle: "Notify authorities of a fire.", bottomTextColor: "FireDetection", backgroundColor: "FireDetection", subtext1: "Your dorm.", subtext2: "Be notified of fires.", purchaseDescription: "Driven by machine learning algorithms, Sense  monitors your dorm for any signs of fire. It distinguishes between regular environmental fluctuations and potential fire hazards, promptly detecting smoke or abnormal heat levels. With its real-time alerts and authorities alerts, Sense keeps you both informed and in control.", isAlreadyPurchased: true)
            
            Spacer(minLength: 15)
            
            //modify purchaseDescription
            
            ServicesButton(title: "Dash Cam", description: "Place Sense in your car and you have a car equipped with AI safety features for safe driving and video footage of your flight.", image: "DashCam", purchaseTitle: "Keeping new drivers safe.", bottomTextColor: "DashCam", backgroundColor: "DashCam", subtext1: "Your dorm.", subtext2: "Stay safe on compus roads.", purchaseDescription: "Driven by machine learning algorithms, Sense  monitors your dorm for any signs of fire. It distinguishes between regular environmental fluctuations and potential fire hazards, promptly detecting smoke or abnormal heat levels. With its real-time alerts and authorities alerts, Sense keeps you both informed and in control.", isAlreadyPurchased: false)
            
            Spacer(minLength: 15)
            
            //modify purchaseDescription
            
            ServicesButton(title: "Physical Violence", description: "In any environment, Sense can find and report cases of physical violence to authorities and send notifications to the device owner.", image: "PhysicalViolence", purchaseTitle: "Keep safe from violence.", bottomTextColor: "PhysicalViolence", backgroundColor: "PhysicalViolence", subtext1: "Your dorm.", subtext2: "Alert authorities of instances of physical violence.", purchaseDescription: "Driven by machine learning algorithms, Sense  monitors your dorm for any signs of fire. It distinguishes between regular environmental fluctuations and potential fire hazards, promptly detecting smoke or abnormal heat levels. With its real-time alerts and authorities alerts, Sense keeps you both informed and in control.", isAlreadyPurchased: true)
            
        }
        .padding()
 
    }
}


#Preview {
    ServicesView()
}
