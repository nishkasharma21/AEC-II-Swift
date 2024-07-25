//
//  iOSApp.swift
//  iOS
//
//  Created by Nishka Sharma on 7/5/24.
//

import SwiftUI
import UserNotifications

@main
struct iOSApp: App {
    let launchViewModel: LaunchViewModel
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        self.launchViewModel = LaunchViewModel()
        launchViewModel.scheduleTimeBasedNotification()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
        }
    }
}

