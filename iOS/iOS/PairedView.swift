////
////  PairedView.swift
////  sequoia
////
////  Created by Asteya Laxmanan on 7/14/24.
////
//
//import Foundation
//import SwiftUI
//
//@available(iOS 18.0, *)
//struct PairedView: View {
//    let accessorySessionManager: AccessorySessionManager
//    
//    @AppStorage("accessoryPaired") private var accessoryPaired = false
//    
//    @State var isConnected = false
//    
//    @State var isRelayOn = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Spacer()
//                
//                Text("Paired, \(isConnected ? "connected" : "not connected")")
//                Button {
//                    isConnected = accessorySessionManager.peripheralConnected
//                } label: {
//                    Text("Refresh whether connected")
//                }
//                
//                
//                List {
//                    Button {
//                        accessorySessionManager.connect()
//                    } label: {
//                        Text("Connect")
//                    }
//                    
////                    LabeledContent {
////                        Text(accessorySessionManager.distance?.formatted() ?? "nil")
////                    } label: {
////                        Text("Distance")
////                    }
//                    
////                    LabeledContent {
////                        Text(accessorySessionManager.orientation?.name.capitalized ?? "nil")
////                    } label: {
////                        Text("Orientation")
////                    }
//                    
////                    Toggle("Pump", isOn: $isRelayOn)
////                        .onChange(of: isRelayOn) {
////                            accessorySessionManager.setRelayState(isOn: isRelayOn)
////                        }
////                    
////                    NavigationLink {
////                        HomeView()
////                    } label: {
////                        Text("Orientation flow")
////                    }
//                }.scrollDisabled(true)
//                
//                Spacer()
//                Button {
//                    accessorySessionManager.removeAccessory()
//                    withAnimation {
//                        accessoryPaired = false
//                    }
//                } label: {
//                    Text("Reset app")
//                }.buttonStyle(.bordered)
//                .controlSize(.large)
//            }.padding()
//                .onAppear {
//                    Task {
//                        while !accessorySessionManager.peripheralConnected {
//                            accessorySessionManager.connect()
//                            try await Task.sleep(nanoseconds: 200000000)
//                        }
//                        
//                        isConnected = accessorySessionManager.peripheralConnected
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    if #available(iOS 18.0, *) {
//        PairedView(accessorySessionManager: AccessorySessionManager())
//    } else {
//        // Fallback on earlier versions
//    }
//}
