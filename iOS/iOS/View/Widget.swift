//import SwiftUI
//import WidgetKit
//import ActivityKit
//
//struct StatsWidget: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: StatisticsAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            // ⚠️ Lock layout should be equal to expanded layout
//        } dynamicIsland: { context in
//            DynamicIsland { // ⚠️ On Device that don't have Dynamic Island, a brief notification is shown
//                DynamicIslandExpandedRegion(.leading) {
//                    // Expanded leading UI goes here
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    // Expanded trailing UI goes here
//                }
//                DynamicIslandExpandedRegion(.center) {
//                    // Expanded center UI goes here
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    // Expanded bottom UI goes here
//                }
//            } compactLeading: {
//                // Compact leading UI goes here
//            } compactTrailing: {
//                // Compact trailing UI goes here
//            } minimal: {
//                // Minimal UI goes here
//            }
//        }
//    }
//}
//
//struct StatisticsAttributes: ActivityAttributes {
//    typealias ContentState = Int
//    
//    var aqi: Int
//    var co: Int
//    var temp: Int
//    var rh: Int
//    var tvoc: Int
//}
