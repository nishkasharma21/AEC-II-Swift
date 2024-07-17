import Foundation
import CoreData
import SwiftUI

class EnvironmentalDataService {
//    let baseURL = "http://172.20.10.2:8000"
    let baseURL = "http://localhost:8000"
    let sensorEndpoint = "/get_environmental-data"

    func fetchEnvironmentalData(completion: @escaping (Result<EnvironmentalData, Error>) -> Void) {
        guard let url = URL(string: baseURL + sensorEndpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
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
                case .success(let data):
                    self?.temperature = data.temperature
                    self?.humidity = data.humidity
                    self?.tvoc = data.tvoc
                    self?.aqi = data.aqi
                    self?.pressure = data.pressure
                    self?.co = data.co
                    print("Temperature: \(data.temperature), Humidity: \(data.humidity)")

                    // Save data to Core Data
                    //self?.saveSensorData(co: data.co, temperature: data.temperature, pressure: data.pressure)

                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }

    private func saveSensorData(co: Double, temperature: Double, pressure: Double) {
        let context = CoreDataStack.shared.context
        let now = Date()

        // Insert new data
        let newSensorData = NSEntityDescription.insertNewObject(forEntityName: "SensorData", into: context) as! SensorData
        newSensorData.timestamp = now
        newSensorData.co = co
        newSensorData.temperature = temperature
        newSensorData.pressure = pressure

        // Save context
        CoreDataStack.shared.saveContext()

        // Delete old data if there are more than 5 entries
        deleteOldSensorData()
    }

    private func deleteOldSensorData() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<SensorData> = SensorData.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let allData = try context.fetch(fetchRequest)
            if allData.count > 5 {
                if let oldestData = allData.first {
                    context.delete(oldestData)
                }
            }
            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to delete old sensor data: \(error)")
        }
    }
}
