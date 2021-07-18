import Foundation

struct WeatherResponse: Codable {
    let location: SelectedLocation
    let current: CurrentWeather
    let forecast: Forecast
}
