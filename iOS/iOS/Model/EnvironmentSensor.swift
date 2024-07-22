//import SwiftUI
//
//struct EnvironmentalData: Codable, Identifiable {
//    let id = UUID()
//    var aqi: Double
//    var temperature: Double
//    var tvoc: Double
//    var co: Double
//    var humidity: Double
//    var pressure: Double // in mmHg
//
//    enum CodingKeys: String, CodingKey {
//        case aqi
//        case temperature
//        case tvoc
//        case co
//        case humidity
//        case pressure
//    }
//}

struct EnvironmentalData: Codable {
    let aqi: Double
    let temperature: Double
    let tvoc: Double
    let co: Double
    let humidity: Double
    let pressure: Double
    // Add other properties as needed
}


