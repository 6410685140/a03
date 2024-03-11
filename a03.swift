//
//  ContentView.swift
//  API_a03
//
//  Created by นายธนภัทร สาระธรรม on 6/3/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
                if let weather = weatherViewModel.weather {
                    Text("City: \(weather.name)")
                        .foregroundColor(.blue)
                    Text("Temperature: \(weather.main.temp - 273)°C")
                        .foregroundColor(.green)
                    Text("Description: \(weather.weather.first?.description ?? "")")
                        .foregroundColor(.orange)
                    Text("Humidity: \(weather.main.humidity)%")
                        .foregroundColor(.red)
                } else if let error = weatherViewModel.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    Text("Loading...")
                        .foregroundColor(.gray)
                }
            }
            .background(Color.white)
        .onAppear {
            weatherViewModel.fetchWeather(for: "Thailand")
        }
    }
}

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var error: Error?
    
    func fetchWeather(for city: String) {
        let apiKey = "e7a1945e99848a309c4a4484bd4fa231"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            self.weather = try JSONDecoder().decode(WeatherData.self, from: data)
                        } catch {
                            self.error = error
                        }
                    } else if let error = error {
                        self.error = error
                    }
                }
            }.resume()
        }
    }
}

struct WeatherData: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
