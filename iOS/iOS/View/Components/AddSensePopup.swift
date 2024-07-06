import SwiftUI

struct AddSensePopup: View {
    @Binding var showAddSense: Bool
    var body: some View {
        VStack {
            NavigationView {
                // Your page content here
                Text("Hello, World!")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                self.showAddSense = false
                            }) {
                                Image(systemName: "x.circle.fill")
                                    .accentColor(Color("ClosePopup"))
                            }
                        }
                    }
            }
            
        }
    }
}
