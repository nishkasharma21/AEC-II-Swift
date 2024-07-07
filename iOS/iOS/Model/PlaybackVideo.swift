import SwiftUI

struct PlaybackVideo: Identifiable {
    let id = UUID()
    var title: String
    var timeAndDate: String
    var alert: Bool
}
