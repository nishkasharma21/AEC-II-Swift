import SwiftUI

struct Home: View {
    @State private var showAddSense = false
    @State private var homeNotificationBaseColorBlue = "HomeNotificationBaseBlue"
    @State private var homeNotificationLineColorBlue = "HomeNotificationLineAndTextBlue"
    @State private var homeNotificationBaseColorRed = "HomeNotificationBaseRed"
    @State private var homeNotificationLineColorRed = "HomeNotificationLineAndTextRed"
    var body: some View {

        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    VStack {
                        VStack{
                            HStack{
                                Text("Notifications")
                                    .font(.body.weight(.semibold))
                                Spacer()
                            }
                            HomeNotification(baseColor: $homeNotificationBaseColorBlue, lineColor: $homeNotificationLineColorBlue)
                                .padding(.bottom, 5)
                            HomeNotification(baseColor: $homeNotificationBaseColorRed, lineColor: $homeNotificationLineColorRed)
                        }
                        .padding()
                    }
                    .background(Color("TabViewColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Image("Camera View")
                        .resizable()
                        .padding(3)
                    
                    
                    ScrollView(.horizontal) {
                        LazyHStack{
                            NavigationLink(destination: PlaybackView()) {
                                PlaybackPreview()
                            }
                            NavigationLink(destination: StatisticsView()) {
                                StatisticsPreview()
                            }
                            NavigationLink(destination: ServicesView()                ) {
                                ServicesPreview()
                            }
                            NavigationLink(destination: EmergencyAlertHistoryView()) {
                                EmergencyAlertHistoryPreview()
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("1732 Lyons Ave")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        //change to variables of after dynamic pairing
                        Menu("Sense 1") {
                            Button("Sense 2") { }
                            Button("Sense 3") { }
                            Button("Sense 4") { }
                        }
                        .accentColor(.black)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack{
                            Button(action: {
                                showAddSense = true
                            }) {
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .padding()
                            }
                            .accentColor(.black)
                            .sheet(isPresented: $showAddSense) {
                                AddSensePopup(showAddSense: $showAddSense)
                            }
                            
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Home()
}
