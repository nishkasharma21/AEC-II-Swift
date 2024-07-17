import SwiftUI

struct StatisticsView: View {
    
    @StateObject private var viewModel = EnvironmentalDataViewModel()
    @State private var value: CGFloat = 0.0
    @State private var lastCoordinateValue: CGFloat = 0.0
    @State private var currentTime = Date()
    @State private var timer: Timer?
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    
    
    var body: some View {
        VStack {
            if let aqi = viewModel.aqi, let temperature = viewModel.temperature, let tvoc = viewModel.tvoc, let co = viewModel.co, let humidity = viewModel.humidity, let pressure = viewModel.pressure {
                
                var aqiCategory: String {
                    switch aqi {
                    case 0...50:
                        return "Good"
                    case 51...100:
                        return "Moderate"
                    case 101...150:
                        return "Unhealthy for Sensitive Groups"
                    case 151...200:
                        return "Unhealthy"
                    case 201...300:
                        return "Very Unhealthy"
                    case 301...500:
                        return "Hazardous"
                    default:
                        return "Unknown"
                    }
                }
                
                var tvocCategory: String {
                    switch tvoc {
                    case 0...300:
                        return "Good"
                    case 301...500:
                        return "Moderate"
                    case 501...1000:
                        return "Unhealthy for Sensitive Groups"
                    case 1001...3000:
                        return "Unhealthy"
                    case 3001...5000:
                        return "Very Unhealthy"
                    case 5001...:
                        return "Hazardous"
                    default:
                        return "Unknown"
                    }
                }
                
                var humidityCategory: String {
                    switch humidity {
                    case ..<30:
                        return "Low"
                    case 30...60:
                        return "Normal"
                    case 61...:
                        return "High"
                    default:
                        return "Unknown"
                    }
                }
            
                VStack{
                    
                    VStack {
                        let cursorSize = 7.0
                        let radius = 10.0
                        let minValue = 0.0
                        let maxValue = 353.0
                        let cursorPosition = (aqi/500)*maxValue
                        
                        VStack (alignment: .leading){
                            HStack{
                                Image(systemName: "aqi.medium")
                                Text("Air Quality")
                            }.font(.system(size: 14))
                                .foregroundColor(Color("Gray Text Color")).padding(.top).padding(.leading)
                            
                            Text(String(format: "%.1f", aqi))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Text(aqiCategory)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: radius)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color("Neon Green"), location: 0.0),  // Neon Green at the start
                                                .init(color: Color("Neon Yellow"), location: 0.16), // Neon Yellow at 25%
                                                .init(color: Color("Neon Orange"), location: 0.32),  // Neon Orange at 50%
                                                .init(color: Color("Neon Pink"), location: 0.50),   // Neon Pink at 75%
                                                .init(color: Color("Dark Red"), location: 0.68)      // Dark Red at the end
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 10)
                                
                                HStack {
                                    Circle().foregroundColor(Color.white).frame(width: cursorSize, height: cursorSize).offset(x: cursorPosition)
                                    Spacer()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.bottom)
                        }.background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TabViewColor"))
                        )
                        
                    }
                    
                    VStack {
                        let cursorSize = 7.0
                        let radius = 10.0
                        let minValue = 0.0
                        let maxValue = 353.0
                        let cursorPosition = (tvoc/3000)*maxValue
                        
                        VStack (alignment: .leading) {
                            HStack{
                                Image(systemName: "testtube.2").font(.system(size: 14))
                                Text("Total volatile organic compounds (TVOC)")
                                    .bold().font(.system(size: 14))
                            }
                            .foregroundColor(Color("Gray Text Color")).padding(.top).padding(.leading)
                            
                            Text(String(format: "%.1f", tvoc))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Text(tvocCategory)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: radius).foregroundColor(Color("Bright Blue")).frame(height: 10)
                                HStack {
                                    Circle().foregroundColor(Color.white).frame(width: cursorSize, height: cursorSize).offset(x: cursorPosition)
                                    Spacer()
                                }
                            }.padding(.leading)
                                .padding(.trailing)
                                .padding(.bottom)
                        }.background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TabViewColor")))
                        
                        
                    }
                    
                    VStack {
                        let cursorSize = 7.0
                        let radius = 10.0
                        let minValue = 0.0
                        let maxValue = 353.0
                        let cursorPosition = (humidity/500)*maxValue
                        
                        VStack (alignment: .leading) {
                            HStack{
                                Image(systemName: "humidity.fill").font(.system(size: 14))
                                Text("Relative Humidity (RH)")
                                    .bold().font(.system(size: 14))
                            }
                            .foregroundColor(Color("Gray Text Color")).padding(.top).padding(.leading)
                            
                            Text(String(format: "%.1f", humidity))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Text(humidityCategory)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.leading)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: radius).foregroundColor(Color("Bright Orange")).frame(height: 10)
                                HStack {
                                    Circle().foregroundColor(Color.white).frame(width: cursorSize, height: cursorSize).offset(x: cursorPosition)
                                    Spacer()
                                }
                            }.padding(.leading)
                                .padding(.trailing)
                                .padding(.bottom)
                        }.background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TabViewColor")))
                        
                    }
                
                    LazyVGrid(columns: columns) {
                        Text("  ")
                        ForEach(timeLabels(), id: \.self) { timeLabel in
                            Text(timeLabel).fontWeight(.semibold).padding(.bottom, -25).font(.system(size: 13))
                        }

                        Image("Carbon Monoxide")
                        Text("35")
                        Text("35")
                        Text("35")
                        Text(String(format: "%.1f", co))

                        Image("Temperature")
                        Text("35")
                        Text("35")
                        Text("35")
                        Text(String(format: "%.1f", temperature))

                        Image("Pressure")
                        Text("35")
                        Text("35")
                        Text("35")
                        Text(String(format: "%.1f", pressure))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("TabViewColor")))
                    .onAppear {
                        updateTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                    }

                    
                }
                
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("No data available")
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchEnvironmentalData()
        }
        .padding()
    }
    
    func timeLabels() -> [String] {
        let calendar = Calendar.current
        var labels = [String]()
        for hourOffset in (0...3).reversed() {
            let date = calendar.date(byAdding: .hour, value: -hourOffset, to: currentTime)!
            let formatter = DateFormatter()
            formatter.dateFormat = hourOffset == 0 ? "'Now'" : "ha"
            labels.append(formatter.string(from: date))
        }
        return labels
    }

    func updateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            currentTime = Date()
            viewModel.fetchEnvironmentalData()
        }
    }
    
}

#Preview {
    StatisticsView()
}
