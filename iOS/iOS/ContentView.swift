import SwiftUI

struct ContentView: View {
    
    let high: Int = 12
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

                .tag(0)
            Automation()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Automation")
                }
                .tag(1)
            Setting()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.black)
        
    }
}

#Preview {
    ContentView()
}
