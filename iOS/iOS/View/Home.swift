import SwiftUI

struct Home: View {
    @State private var showAddSense = false
    var body: some View {
        NavigationStack{
            VStack{
                VStack {
                    VStack{
                        HStack{
                            Text("Notifications")
                                .font(.body.weight(.semibold))
                            Spacer()
                        }
                        HomeNotification()
                        HomeNotification()
                    }
                    .padding()
                }
                .background(Color("TabViewColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text("Camera View").padding()
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        Text("Playback").padding()
                        Text("Statistics").padding()
                        Text("Notifications").padding()
                        Text("Serveces").padding()
                    }
                }
                .scrollIndicators(.hidden)
                
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

#Preview {
    Home()
}
