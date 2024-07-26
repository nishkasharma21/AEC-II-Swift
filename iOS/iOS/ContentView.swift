import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TabView {
                    Home()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    StatisticsView()
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Statistics")
                        }
                        .tag(1)
                    ServicesView()
                        .tabItem {
                            Image(systemName: "star.fill")
                            Text("Discover")
                        }
                        .tag(2)
                }
                .accentColor(.white)
            } else {
                LogInView()
            }
        }
    }
}
