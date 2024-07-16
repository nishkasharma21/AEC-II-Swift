import Foundation
import SwiftUI

class EnvironmentalDataService {
    let baseURL = "http://localhost:5001"
    let sensorEndpoint = "/get_environmental-data" // Updated to match the Flask endpoint

    func fetchEnvironmentalData(completion: @escaping (Result<EnvironmentalData, Error>) -> Void) {
        guard let url = URL(string: baseURL + sensorEndpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url, cachePolicy:.useProtocolCachePolicy)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Response is not HTTP"])))
                return
            }

            guard httpResponse.statusCode == 200 else {
                completion(.failure(URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server: \(httpResponse.statusCode)"])))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])))
                return
            }

            do {
                let environmentalData = try JSONDecoder().decode(EnvironmentalData.self, from: data)
                completion(.success(environmentalData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

class EnvironmentalDataViewModel: ObservableObject {
    @Published var aqi: Double?
    @Published var temperature: Double?
    @Published var tvoc: Double?
    @Published var co: Double?
    @Published var humidity: Double?
    @Published var pressure: Double?
    @Published var error: Error?
    @Published var isLoading = false
    
    var aqiBinding: Binding<Double> {
            Binding(
                get: { self.aqi ?? 0 },
                set: { self.aqi = $0 }
            )
        }

    private let dataService: EnvironmentalDataService

    init(dataService: EnvironmentalDataService = EnvironmentalDataService()) {
        self.dataService = dataService
    }

    func fetchEnvironmentalData() {
        isLoading = true
        dataService.fetchEnvironmentalData { [weak self] result in
            DispatchQueue.main.async { // Update UI on the main thread
                self?.isLoading = false
                switch result {
                case.success(let data):
                    self?.temperature = data.temperature
                    self?.humidity = data.humidity
                    self?.tvoc = data.tvoc
                    self?.aqi = data.aqi
                    self?.pressure = data.pressure
                    self?.co = data.co
                    print("Temperature: \(data.temperature), Humidity: \(data.humidity)")
                case.failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
