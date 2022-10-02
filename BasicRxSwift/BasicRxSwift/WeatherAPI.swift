//
//  WeatherAPI.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 8/1/22.
//

import Foundation
import RxSwift

class WeatherAPI {

    static var shared = WeatherAPI()

    // private init
    private init() { }

    private let apiKey = ""
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!

    // MARK: - Private methods
    private func request(method: String = "GET", pathComponent: String, params: [(String, String)]) -> Observable<Data> {
        let url = baseURL.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "appid", value: apiKey)
        let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!

        if method == "GET" {
            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            queryItems.append(keyQueryItem)
            queryItems.append(unitsQueryItem)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = [keyQueryItem, unitsQueryItem]

            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }

        print("🔴 URL: \(urlComponents.url!.absoluteString)")

        request.url = urlComponents.url!
        request.httpMethod = method

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared

        return session.rx.data(request: request)
    }
}

struct Weather: Decodable {
    let cityName: String
    let temperature: Int
    let humidity: Int
}

public func iconNameToChar(icon: String) -> String {
    switch icon {
    case "01d":
        return "☀️"
    case "01n":
        return "🌙"
    case "02d":
        return "🌤"
    case "02n":
        return "🌤"
    case "03d", "03n":
        return "☁️"
    case "04d", "04n":
        return "☁️"
    case "09d", "09n":
        return "🌧"
    case "10d", "10n":
        return "🌦"
    case "11d", "11n":
        return "⛈"
    case "13d", "13n":
        return "❄️"
    case "50d", "50n":
        return "💨"
    default:
        return "E"
    }
}

extension WeatherAPI {

    func currentWeather(city: String) -> Observable<Weather> {
        return Observable<Weather>.just(
            Weather(cityName: "Thien Tam",
                temperature: 99,
                humidity: 99)
        )
    }
}
